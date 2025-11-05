// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
// import 'package:sticky_headers/sticky_headers/widget.dart';
// import 'package:swipe_clean_gallery/screens/image_viewer_screen.dart';
// import 'package:swipe_clean_gallery/services/ad_helper.dart';
// import 'package:swipe_clean_gallery/services/app_colors.dart';
// import 'package:swipe_clean_gallery/services/gallery_service.dart';

// class GalleryScreen extends StatefulWidget {
//   const GalleryScreen({super.key});

//   @override
//   State<GalleryScreen> createState() => _GalleryScreenState();
// }

// class _GalleryScreenState extends State<GalleryScreen> {
//   final ScrollController _scrollController = ScrollController();
//   final GalleryService _galleryService = GalleryService();

//   int deletedCount = 0;
//   BannerAd? _bannerAd;
//   bool _isBannerAdLoaded = false;
//   bool _isRefreshing = false;

//   @override
//   void initState() {
//     super.initState();
//     _initGallery();
//     _scrollController.addListener(_scrollListener);
//     _loadBannerAd();
//   }

//   /// Initialize Banner Ad
//   void _loadBannerAd() {
//     debugPrint("🔵 Starting to load banner ad...");

//     _bannerAd = BannerAd(
//       adUnitId: AdHelper.bannerAdUnitId,
//       size: AdSize.banner,
//       request: const AdRequest(),
//       listener: BannerAdListener(
//         onAdLoaded: (ad) {
//           debugPrint("✅ BannerAd loaded successfully");
//           if (mounted) {
//             setState(() {
//               _isBannerAdLoaded = true;
//             });
//           }
//         },
//         onAdFailedToLoad: (ad, error) {
//           debugPrint(
//             "❌ BannerAd failed to load: ${error.code} - ${error.message}",
//           );
//           ad.dispose();
//           setState(() {
//             _isBannerAdLoaded = false;
//           });
//         },
//         onAdOpened: (ad) => debugPrint("📖 BannerAd opened"),
//         onAdClosed: (ad) => debugPrint("📕 BannerAd closed"),
//       ),
//     );

//     _bannerAd!.load();
//   }

//   Future<void> _initGallery() async {
//     if (_isRefreshing) {
//       debugPrint("⏳ Already refreshing, skipping...");
//       return;
//     }

//     try {
//       _isRefreshing = true;
//       debugPrint("🔄 Starting gallery initialization...");

//       await _galleryService.initGallery().timeout(
//         const Duration(seconds: 10),
//         onTimeout: () {
//           debugPrint("⏰ Gallery init timed out");
//           throw TimeoutException("Failed to load gallery");
//         },
//       );

//       debugPrint(
//         "✅ Gallery init complete. Images: ${_galleryService.allImages.length}",
//       );

//       if (mounted) {
//         setState(() {});
//       }
//     } catch (e, stackTrace) {
//       debugPrint("❌ Error in _initGallery: $e");
//       debugPrint("Stack trace: $stackTrace");

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Error loading gallery: $e"),
//             backgroundColor: Colors.red,
//             duration: const Duration(seconds: 3),
//           ),
//         );
//       }
//     } finally {
//       _isRefreshing = false;
//     }
//   }

//   Future<void> _loadMore() async {
//     await _galleryService.loadMoreImages();
//     if (mounted) setState(() {});
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels >
//         _scrollController.position.maxScrollExtent - 400) {
//       _loadMore();
//     }
//   }

//   Future<bool> _onWillPop() async {
//     if (deletedCount == 0) {
//       // No deletions, just confirm exit
//       final result = await showDialog<bool>(
//         context: context,
//         builder: (context) => AlertDialog(
//           backgroundColor: const Color(0xFF1A1F24),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: const Text(
//             "Exit Gallery",
//             style: TextStyle(color: Colors.white),
//           ),
//           content: const Text(
//             "Do you want to exit?",
//             style: TextStyle(color: Colors.white70),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               child: const Text("Exit", style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         ),
//       );
//       return result ?? false;
//     }

//     // Show styled dialog with deleted count
//     final result = await showDialog<bool>(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF1A1F24),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.green.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(
//                 Icons.check_circle_outline,
//                 color: Colors.green,
//                 size: 24,
//               ),
//             ),
//             const SizedBox(width: 12),
//             const Expanded(
//               child: Text(
//                 "Great Job!",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.green.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: Colors.green.withOpacity(0.3),
//                   width: 1,
//                 ),
//               ),
//               child: Row(
//                 children: [
//                   const Icon(Icons.delete_sweep, color: Colors.green, size: 28),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           "$deletedCount image${deletedCount > 1 ? 's' : ''}",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         const Text(
//                           "successfully deleted",
//                           style: TextStyle(color: Colors.white70, fontSize: 14),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               "You've freed up some space! Do you want to continue cleaning or exit?",
//               style: TextStyle(color: Colors.white70, fontSize: 14),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, false),
//             style: TextButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//             ),
//             child: const Text(
//               "Keep Cleaning",
//               style: TextStyle(color: Colors.white70, fontSize: 16),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () => Navigator.pop(context, true),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//             ),
//             child: const Text(
//               "Exit",
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );

//     return result ?? false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final groupedImages = _galleryService.groupedImages;
//     final sectionKeys = groupedImages.keys.toList();

//     return WillPopScope(
//       onWillPop: _onWillPop,
//       child: Scaffold(
//         backgroundColor: const Color(0xFF0F1417),
//         appBar: AppBar(
//           backgroundColor: const Color(0xFF0F1417),
//           elevation: 0,
//           title: const Text(
//             "Your Photos",
//             style: TextStyle(
//               color: AppColors.textPrimary,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           actions: [
//             if (deletedCount > 0)
//               Center(
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 16),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.green.withOpacity(0.2),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: Colors.green.withOpacity(0.5)),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(
//                           Icons.delete_sweep,
//                           color: Colors.green,
//                           size: 16,
//                         ),
//                         const SizedBox(width: 6),
//                         Text(
//                           "$deletedCount",
//                           style: const TextStyle(
//                             color: Colors.green,
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//         bottomNavigationBar: _isBannerAdLoaded && _bannerAd != null
//             ? Container(
//                 color: const Color(0xFF0F1417),
//                 height: _bannerAd!.size.height.toDouble(),
//                 width: double.infinity,
//                 child: AdWidget(ad: _bannerAd!),
//               )
//             : null,
//         body: groupedImages.isEmpty
//             ? const Center(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(color: Colors.white),
//                     SizedBox(height: 16),
//                     Text(
//                       "Loading your photos...",
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                   ],
//                 ),
//               )
//             : ListView.builder(
//                 controller: _scrollController,
//                 itemCount:
//                     sectionKeys.length + (_galleryService.isLoading ? 1 : 0),
//                 itemBuilder: (context, sectionIndex) {
//                   if (sectionIndex >= sectionKeys.length) {
//                     return const Padding(
//                       padding: EdgeInsets.all(16),
//                       child: Center(
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2,
//                           color: Colors.white,
//                         ),
//                       ),
//                     );
//                   }

//                   final label = sectionKeys[sectionIndex];
//                   final photos = groupedImages[label]!;

//                   return StickyHeader(
//                     header: Container(
//                       width: double.infinity,
//                       color: const Color(0xFF0F1417),
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 16,
//                         vertical: 12,
//                       ),
//                       child: Row(
//                         children: [
//                           Text(
//                             label,
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     content: GridView.builder(
//                       padding: const EdgeInsets.symmetric(horizontal: 8),
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 4,
//                             crossAxisSpacing: 4,
//                             mainAxisSpacing: 4,
//                           ),
//                       itemCount: photos.length,
//                       itemBuilder: (context, index) {
//                         final asset = photos[index];
//                         final allImages = _galleryService.allImages;
//                         final globalIndex = allImages.indexOf(asset);

//                         return GestureDetector(
//                           onTap: () async {
//                             try {
//                               // Create a COPY of the images list
//                               final imagesCopy = List<AssetEntity>.from(
//                                 allImages,
//                               );

//                               debugPrint(
//                                 "📸 Opening viewer at index $globalIndex",
//                               );

//                               // Navigate to viewer with the copy
//                               final int? deletedFromViewer =
//                                   await Navigator.push<int>(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => ImageViewerScreen(
//                                         images: imagesCopy,
//                                         initialIndex: globalIndex,
//                                       ),
//                                     ),
//                                   );

//                               debugPrint(
//                                 "🔙 Returned from viewer: $deletedFromViewer deleted",
//                               );

//                               // Update total deleted count
//                               if (deletedFromViewer != null &&
//                                   deletedFromViewer > 0) {
//                                 setState(() {
//                                   deletedCount += deletedFromViewer;
//                                 });
//                                 debugPrint(
//                                   "✅ Total deleted count: $deletedCount",
//                                 );
//                               }

//                               // Refresh gallery - this reloads from PhotoManager
//                               if (mounted) {
//                                 debugPrint("🔄 Refreshing gallery...");
//                                 await _initGallery();
//                                 debugPrint("✅ Gallery refreshed");
//                               }
//                             } catch (e, stackTrace) {
//                               debugPrint("❌ Error in image viewer flow: $e");
//                               debugPrint("Stack trace: $stackTrace");

//                               if (mounted) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                     content: Text("Error: $e"),
//                                     backgroundColor: Colors.red,
//                                   ),
//                                 );
//                               }
//                             }
//                           },
//                           child: Hero(
//                             tag: asset.id,
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(4),
//                               child: AssetEntityImage(
//                                 asset,
//                                 isOriginal: false,
//                                 thumbnailSize: const ThumbnailSize.square(150),
//                                 fit: BoxFit.cover,
//                                 errorBuilder: (context, error, stackTrace) {
//                                   return Container(
//                                     color: Colors.grey[800],
//                                     child: const Icon(
//                                       Icons.broken_image,
//                                       color: Colors.grey,
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   );
//                 },
//               ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _bannerAd?.dispose();
//     super.dispose();
//   }
// }
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
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _initGallery();
    _scrollController.addListener(_scrollListener);
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() => _isBannerAdLoaded = true);
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    )..load();
  }

  Future<void> _initGallery() async {
    if (_isRefreshing) return;
    try {
      _isRefreshing = true;
      await _galleryService.initGallery().timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw TimeoutException("Gallery load timeout"),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error loading gallery: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      _isRefreshing = false;
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
    if (deletedCount == 0) return _confirmExit();
    return _postDeleteExitDialog();
  }

  Future<bool> _confirmExit() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Exit Gallery",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Do you want to exit?",
          style: TextStyle(color: Colors.white70),
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

  Future<bool> _postDeleteExitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                "Great Job!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.delete_sweep, color: Colors.green, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$deletedCount image${deletedCount > 1 ? 's' : ''}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "successfully deleted",
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Exit", style: TextStyle(color: Colors.white)),
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
        backgroundColor: const Color(0xFF0F1417),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0F1417),
          elevation: 0,
          title: const Text(
            "Your Photos",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            if (deletedCount > 0)
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.withOpacity(0.5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.delete_sweep,
                          color: Colors.green,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "$deletedCount",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),

        bottomNavigationBar: _isBannerAdLoaded && _bannerAd != null
            ? Container(
                color: const Color(0xFF0F1417),
                height: _bannerAd!.size.height.toDouble(),
                width: double.infinity,
                child: AdWidget(ad: _bannerAd!),
              )
            : null,
        body: ValueListenableBuilder<bool>(
          valueListenable: _galleryService.isGalleryReady,
          builder: (context, ready, _) {
            if (!ready) {
              return const Center(
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
              );
            }

            final groupedImages = _galleryService.groupedImages;

            if (groupedImages.isEmpty) {
              return const Center(
                child: Text(
                  "No photos found",
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }
            // final groupedImages = _galleryService.groupedImages;
            final sectionKeys = groupedImages.keys.toList();

            return ListView.builder(
              controller: _scrollController,
              itemCount:
                  sectionKeys.length + (_galleryService.isLoading ? 1 : 0),
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
                    color: const Color(0xFF0F1417),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  content: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                          }

                          await _initGallery();
                        },
                        child: Hero(
                          tag: asset.id,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: AssetEntityImage(
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
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }
}
