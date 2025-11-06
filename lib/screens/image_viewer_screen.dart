import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:video_player/video_player.dart';
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
  bool _hasPopped = false;
  final Map<String, VideoPlayerController> _videoControllers = {};
  String? _activeVideoId;
  bool _isOpeningVideo = false;

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
    for (final c in _videoControllers.values) {
      c.dispose();
    }
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

  Future<void> _openVideo(AssetEntity asset) async {
    if (_isDisposed || _isOpeningVideo) return;
    _isOpeningVideo = true;
    try {
      if (_videoControllers[asset.id] == null) {
        File? file = await asset.originFile;
        file ??= await asset.file;
        VideoPlayerController controller;
        if (file != null) {
          controller = VideoPlayerController.file(file);
        } else {
          final url = await asset.getMediaUrl();
          if (url == null) {
            throw Exception("Media source not available");
          }
          controller = VideoPlayerController.networkUrl(Uri.parse(url));
        }

        await controller.initialize();
        controller.setLooping(true);
        await controller.play();
        _videoControllers[asset.id] = controller;
      } else {
        final controller = _videoControllers[asset.id]!;
        if (!controller.value.isInitialized) {
          await controller.initialize();
        }
        await controller.play();
      }
      if (!_isDisposed && mounted) {
        setState(() => _activeVideoId = asset.id);
      }
    } catch (e) {
      debugPrint("Error opening video: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Unable to play video: $e"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      _isOpeningVideo = false;
    }
  }

  void _closeVideo() {
    if (_activeVideoId == null) return;
    final controller = _videoControllers[_activeVideoId!];
    controller?.pause();
    if (!_isDisposed && mounted) {
      setState(() => _activeVideoId = null);
    }
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
                    future: _getThumbnailBytes(asset),
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
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Hero(
                                    tag: asset.id,
                                    child: Image.memory(
                                      snapshot.data!,
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                      height: double.infinity,
                                    ),
                                  ),
                                  // Video play button overlay
                                  if (asset.type == AssetType.video)
                                    GestureDetector(
                                      onTap: () => _openVideo(asset),
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 48,
                                        ),
                                      ),
                                    ),
                                ],
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
                  Column(
                    children: [
                      Text(
                        "${currentIndex + 1}/${_service.images.length}",
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Show media type indicator
                      if (_service.images[currentIndex].type == AssetType.video)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "VIDEO",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
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

            // Video overlay when playing current video
            Builder(
              builder: (context) {
                if (_activeVideoId == null) return const SizedBox.shrink();
                final currentAsset = _service.images[currentIndex];
                if (currentAsset.type != AssetType.video ||
                    currentAsset.id != _activeVideoId) {
                  return const SizedBox.shrink();
                }
                final controller = _videoControllers[_activeVideoId!];
                if (controller == null || !controller.value.isInitialized) {
                  return const SizedBox.shrink();
                }
                return Positioned.fill(
                  child: Container(
                    color: Colors.black,
                    child: Stack(
                      children: [
                        Center(
                          child: controller.value.isInitialized
                              ? AspectRatio(
                                  aspectRatio: controller.value.aspectRatio == 0
                                      ? 16 / 9
                                      : controller.value.aspectRatio,
                                  child: GestureDetector(
                                    onTap: () {
                                      if (controller.value.isPlaying) {
                                        controller.pause();
                                      } else {
                                        controller.play();
                                      }
                                      setState(() {});
                                    },
                                    child: VideoPlayer(controller),
                                  ),
                                )
                              : const SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 8,
                          left: 8,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: _closeVideo,
                          ),
                        ),
                        Positioned(
                          bottom: 24,
                          left: 16,
                          right: 16,
                          child: VideoProgressIndicator(
                            controller,
                            allowScrubbing: true,
                            colors: const VideoProgressColors(
                              playedColor: Colors.white,
                              bufferedColor: Colors.white38,
                              backgroundColor: Colors.white24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
