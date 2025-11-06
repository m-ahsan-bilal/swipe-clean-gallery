import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:swipe_clean_gallery/screens/image_viewer_screen.dart';
import 'package:swipe_clean_gallery/services/ad_helper.dart';
import 'package:swipe_clean_gallery/services/app_colors.dart';
import 'package:swipe_clean_gallery/services/gallery_service.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final ScrollController _scrollController = ScrollController();
  final GalleryService _galleryService = GalleryService();

  int deletedCount = 0;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initGallery();
    _scrollController.addListener(_scrollListener);
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      // adUnitId: AdHelper.bannerAdUnitId,
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),

      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() => _isBannerAdLoaded = true);
          }
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("Ad failed: ${error.message}");
          ad.dispose();
        },
      ),
    )..load();
  }

  Future<void> _initGallery() async {
    try {
      setState(() => _isInitializing = true);

      await _galleryService.initGallery();

      if (mounted) {
        setState(() => _isInitializing = false);
      }
    } catch (e) {
      debugPrint("Gallery init error: $e");
      if (mounted) {
        setState(() => _isInitializing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error loading gallery: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadMore() async {
    await _galleryService.loadMoreImages();
    if (mounted) setState(() {});
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >
        _scrollController.position.maxScrollExtent - 400) {
      _loadMore();
    }
  }

  Future<bool> _onWillPop() async {
    if (deletedCount == 0) {
      final result = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.dialogBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Exit Gallery",
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Image.asset(
                  'assets/images/sad.png',
                  height: 120,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.mood_bad,
                    color: Colors.white54,
                    size: 80,
                  ),
                ),
              ),
              const Text(
                "You're leaving without cleaning. Come back soon!",
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Exit", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      return result ?? false;
    }

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.dialogBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.brandPrimary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.brandPrimary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                children: [
                  Text(
                    "$deletedCount file${deletedCount > 1 ? 's' : ''} successfully deleted",
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 20,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  // const SizedBox(width: 6),
                  // const Text(
                  //   "successfully deleted",
                  //   style: TextStyle(color: Colors.white70, fontSize: 20),
                  // ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Image.asset(
                  'assets/images/happy.png',
                  height: 140,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.celebration,
                    color: AppColors.brandPrimary,
                    size: 80,
                  ),
                ),
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.green.withOpacity(0.1),
            //     borderRadius: BorderRadius.circular(12),
            //     border: Border.all(color: Colors.green.withOpacity(0.3)),
            //   ),
            //   child: Row(
            //     children: [
            //       const Icon(Icons.delete_sweep, color: Colors.green, size: 28),
            //       const SizedBox(width: 12),
            //       Expanded(
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(
            //               "$deletedCount image${deletedCount > 1 ? 's' : ''}",
            //               style: const TextStyle(
            //                 color: Colors.white,
            //                 fontSize: 24,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //             const Text(
            //               "successfully deleted",
            //               style: TextStyle(color: Colors.white70, fontSize: 14),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 16),
            const Text(
              "You've freed up space! Continue or exit?",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              "Keep Cleaning",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Exit"),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundPrimary,
          elevation: 0,
          title: const Text(
            "Your Photos",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_sweep,
                      color: AppColors.brandPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "$deletedCount",
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.brandPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _isBannerAdLoaded && _bannerAd != null
            ? Container(
                color: AppColors.backgroundPrimary,
                height: _bannerAd!.size.height.toDouble(),
                width: double.infinity,
                child: AdWidget(ad: _bannerAd!),
              )
            : null,
        body: _isInitializing
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      "Loading your photos...",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              )
            : _buildGalleryContent(),
      ),
    );
  }

  Widget _buildGalleryContent() {
    final groupedImages = _galleryService.groupedImages;

    if (groupedImages.isEmpty) {
      return const Center(
        child: Text("No photos found", style: TextStyle(color: Colors.white70)),
      );
    }

    final sectionKeys = groupedImages.keys.toList();

    return ListView.builder(
      controller: _scrollController,
      itemCount: sectionKeys.length + (_galleryService.isLoading ? 1 : 0),
      itemBuilder: (context, sectionIndex) {
        if (sectionIndex >= sectionKeys.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
          );
        }

        final label = sectionKeys[sectionIndex];
        final photos = groupedImages[label]!;

        return StickyHeader(
          header: Container(
            color: AppColors.backgroundPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          content: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
            ),
            itemCount: photos.length,
            itemBuilder: (_, index) {
              final asset = photos[index];
              final allImages = _galleryService.allImages;
              final globalIndex = allImages.indexOf(asset);

              return GestureDetector(
                onTap: () async {
                  final imagesCopy = List<AssetEntity>.from(allImages);
                  final deleted = await Navigator.push<int>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImageViewerScreen(
                        images: imagesCopy,
                        initialIndex: globalIndex,
                      ),
                    ),
                  );

                  if (deleted != null && deleted > 0) {
                    setState(() => deletedCount += deleted);
                    debugPrint("✅ Total deleted: $deletedCount");
                  }

                  await _initGallery();
                },
                child: Hero(
                  tag: asset.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AssetEntityImage(
                          asset,
                          isOriginal: false,
                          thumbnailSize: const ThumbnailSize.square(150),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        // Video indicator
                        if (asset.type == AssetType.video)
                          Positioned(
                            bottom: 4,
                            right: 4,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }
}
