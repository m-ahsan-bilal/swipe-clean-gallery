// ignore_for_file: deprecated_member_use, use_build_context_synchronously

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
    with TickerProviderStateMixin {
  late PageController _pageController;
  late ImageViewerService _service;
  late AnimationController _animationController;
  late AnimationController _uiController;

  int currentIndex = 0;
  double _dragOffset = 0.0;
  bool _isDeleting = false;
  bool _isDisposed = false;
  bool _hasPopped = false;
  bool _isDraggingHorizontal = false;

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
      duration: const Duration(milliseconds: 300),
    );

    _uiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    _pageController.dispose();
    _animationController.dispose();
    _uiController.dispose();
    super.dispose();
  }

  Future<void> _deletePhoto() async {
    if (_isDisposed) return;

    final success = await _service.deletePhoto(context, currentIndex);

    if (_isDisposed) return;

    if (success) {
      if (_service.images.isEmpty) {
        if (!_hasPopped && Navigator.canPop(context)) {
          _hasPopped = true;
          Navigator.of(context).pop(_service.getDeletedCount());
        }
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

  void _safePop() {
    if (!_isDisposed && !_hasPopped && Navigator.canPop(context)) {
      final count = _service.getDeletedCount();
      debugPrint("Exiting viewer with deleted count: $count");
      _hasPopped = true;
      Navigator.of(context).pop(count);
    }
  }

  Future<Uint8List?> _getThumbnailBytes(AssetEntity asset) {
    return _service.getThumbnailBytes(asset);
  }

  @override
  Widget build(BuildContext context) {
    if (_service.images.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_isDisposed &&
            mounted &&
            !_hasPopped &&
            Navigator.canPop(context)) {
          _hasPopped = true;
          Navigator.of(context).pop(_service.getDeletedCount());
        }
      });
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        _safePop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            GestureDetector(
              onVerticalDragUpdate: (details) {
                if (_isDisposed || _isDraggingHorizontal) return;
                setState(() => _dragOffset += details.primaryDelta!);
              },
              onVerticalDragEnd: (details) async {
                if (_isDisposed || _isDraggingHorizontal) return;

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
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  // Track horizontal scrolling
                  if (notification is ScrollStartNotification) {
                    setState(() => _isDraggingHorizontal = true);
                  } else if (notification is ScrollEndNotification) {
                    setState(() => _isDraggingHorizontal = false);
                  }
                  return false;
                },
                child: Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 70,
                    bottom: 20,
                  ),
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const ClampingScrollPhysics(),
                    onPageChanged: (index) {
                      if (!_isDisposed) {
                        setState(() => currentIndex = index);
                      }
                    },
                    itemCount: _service.images.length,
                    itemBuilder: (context, index) {
                      final asset = _service.images[index];

                      return FutureBuilder<Uint8List?>(
                        future: _getThumbnailBytes(asset),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }

                          final opacity =
                              1.0 - (_dragOffset.abs() / 300).clamp(0.0, 1.0);
                          final translateY = _dragOffset.clamp(-200, 200);

                          return AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              final animationY =
                                  -200 * _animationController.value;
                              final animationOpacity =
                                  1.0 - _animationController.value;

                              return Opacity(
                                opacity: _isDeleting
                                    ? animationOpacity
                                    : opacity,
                                child: Transform.translate(
                                  offset: Offset(
                                    0,
                                    (_isDeleting ? animationY : translateY)
                                        .toDouble(),
                                  ),
                                  child: Hero(
                                    tag: asset.id,
                                    child: Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                      height: double.infinity,
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
              ),
            ),

            // Top bar - always visible
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  right: 8,
                  bottom: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: _safePop,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${currentIndex + 1}/${_service.images.length}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),

            // Swipe hint - only show during vertical drag
            if (_dragOffset.abs() > 30 && !_isDraggingHorizontal)
              Positioned(
                top: MediaQuery.of(context).padding.top + 100,
                left: 0,
                right: 0,
                child: Center(
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 200),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: 0.8 + (value * 0.2),
                        child: Opacity(
                          opacity: value,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: _dragOffset < 0
                                  ? Colors.red.withOpacity(0.9)
                                  : Colors.blue.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (_dragOffset < 0
                                              ? Colors.red
                                              : Colors.blue)
                                          .withOpacity(0.4),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _dragOffset < 0
                                      ? Icons.delete_rounded
                                      : Icons.close,
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _dragOffset < 0
                                      ? "Release to Delete"
                                      : "Release to Exit",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
