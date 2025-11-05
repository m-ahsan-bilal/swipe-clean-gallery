import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:swipe_clean_gallery/services/image_viewer_service.dart';

class ImageViewerScreen extends StatefulWidget {
  final List<AssetEntity> images;
  final int initialIndex;

  const ImageViewerScreen({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late ImageViewerService _service;
  late AnimationController _animationController;

  int currentIndex = 0;
  double _dragOffset = 0.0;
  bool _isDeleting = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);

    _service = ImageViewerService(
      widget.images,
      onUpdate: () {
        if (!_isDisposed && mounted) setState(() {});
      },
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _deletePhoto() async {
    if (_isDisposed) return;

    final success = await _service.deletePhoto(context, currentIndex);

    if (_isDisposed) return;

    if (success) {
      if (_service.images.isEmpty) {
        // All images deleted, return count and exit
        Navigator.of(context).pop(_service.getDeletedCount());
        return;
      }

      if (currentIndex >= _service.images.length) {
        currentIndex = _service.images.length - 1;
      }

      if (!_isDisposed && _pageController.hasClients) {
        _pageController.jumpToPage(currentIndex);
      }
    }
  }

  /// Exit screen safely with deleted count
  void _safePop() {
    if (!_isDisposed && Navigator.canPop(context)) {
      final count = _service.getDeletedCount();
      debugPrint("🔙 Exiting viewer with deleted count: $count");
      Navigator.of(context).pop(count);
    }
  }

  Future<Uint8List?> _getImageBytes(AssetEntity asset) {
    return _service.getImageBytes(asset);
  }

  @override
  Widget build(BuildContext context) {
    if (_service.images.isEmpty) {
      // All images deleted
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed && mounted) {
          Navigator.of(context).pop(_service.getDeletedCount());
        }
      });
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (_isDisposed) return;
              setState(() => _dragOffset += details.primaryDelta!);
            },
            onVerticalDragEnd: (details) async {
              if (_isDisposed) return;

              if (_dragOffset < -120 && !_isDeleting) {
                setState(() => _isDeleting = true);
                await _animationController.forward();
                await _deletePhoto();
                if (!_isDisposed) {
                  _animationController.reset();
                  setState(() {
                    _isDeleting = false;
                    _dragOffset = 0;
                  });
                }
              } else if (_dragOffset > 100) {
                _safePop();
              } else {
                setState(() => _dragOffset = 0);
              }
            },
            child: PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                if (!_isDisposed) setState(() => currentIndex = index);
              },
              itemCount: _service.images.length,
              itemBuilder: (context, index) {
                final asset = _service.images[index];

                return FutureBuilder<Uint8List?>(
                  future: _getImageBytes(asset),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    final opacity =
                        1.0 - (_dragOffset.abs() / 300).clamp(0.0, 1.0);
                    final translateY = _dragOffset.clamp(-200, 200);

                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        final animationY = -200 * _animationController.value;
                        final animationOpacity =
                            1.0 - _animationController.value;

                        return Opacity(
                          opacity: _isDeleting ? animationOpacity : opacity,
                          child: Transform.translate(
                            offset: Offset(
                              0,
                              (_isDeleting ? animationY : translateY)
                                  .toDouble(),
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: Hero(
                                key: ValueKey(asset.id),
                                tag: asset.id,
                                child: Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.contain,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),

          // Top bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 26,
                  ),
                  onPressed: _safePop,
                ),
                Text(
                  "${currentIndex + 1}/${_service.images.length}",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),

          // Swipe hint
          if (_dragOffset.abs() > 30)
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _dragOffset < 0
                        ? Colors.red.withOpacity(0.8)
                        : Colors.blue.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _dragOffset < 0 ? Icons.delete : Icons.arrow_back,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _dragOffset < 0 ? "Swipe to Delete" : "Swipe to Exit",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
