import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

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
  int currentIndex = 0;
  double _dragOffset = 0.0;
  bool _isDeleting = false;
  bool _isLoading = false;
  late AnimationController _animationController;
  final Map<String, Future<Uint8List?>> _imageCache = {};

  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    _isDisposed = true; // 👈 mark disposed early
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _deletePhoto() async {
    final asset = widget.images[currentIndex];
    if (_isDisposed) return;

    setState(() => _isLoading = true);
    final deletedIds = await PhotoManager.editor.deleteWithIds([asset.id]);
    final success = deletedIds.contains(asset.id);

    if (_isDisposed) return; // 👈 check again after async

    if (success) {
      await PhotoManager.clearFileCache();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Photo deleted"),
          behavior: SnackBarBehavior.floating,
          duration: Duration(milliseconds: 800),
        ),
      );

      setState(() {
        widget.images.removeAt(currentIndex);
        _imageCache.remove(asset.id);
      });

      if (widget.images.isEmpty) {
        _safePop();
        return;
      }

      if (currentIndex >= widget.images.length) {
        currentIndex = widget.images.length - 1;
      }

      if (!_isDisposed && _pageController.hasClients) {
        _pageController.jumpToPage(currentIndex);
      }
    } else {
      if (!_isDisposed) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to delete photo")));
      }
    }

    if (!_isDisposed) {
      setState(() => _isLoading = false);
    }
  }

  void _safePop() {
    if (Navigator.canPop(context) && !_isDisposed) {
      Navigator.of(context).pop(widget.images);
    }
  }

  Future<Uint8List?> _getImageBytes(AssetEntity asset) {
    return _imageCache.putIfAbsent(asset.id, () => asset.originBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onVerticalDragUpdate: (details) {
              if (_isDisposed) return;
              setState(() {
                _dragOffset += details.primaryDelta!;
              });
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
                if (!_isDisposed) {
                  setState(() => currentIndex = index);
                }
              },
              itemCount: widget.images.length,
              itemBuilder: (context, index) {
                final asset = widget.images[index];
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

          // top bar
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
                  "${currentIndex + 1}/${widget.images.length}",
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

          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.35),
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
