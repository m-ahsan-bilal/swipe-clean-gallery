import 'dart:async';
import 'package:flutter/material.dart';
import 'package:swipe_clean_gallery/l10n/app_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:swipe_clean_gallery/screens/image_viewer_screen.dart';
import 'package:swipe_clean_gallery/screens/permission_screen.dart';
import 'package:swipe_clean_gallery/screens/recently_deleted_screen.dart';
import 'package:swipe_clean_gallery/screens/settings_screen.dart';
import 'package:swipe_clean_gallery/services/app_colors.dart';
import 'package:swipe_clean_gallery/services/gallery_service.dart';
import 'package:swipe_clean_gallery/services/recently_deleted_service.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with WidgetsBindingObserver {
  final ScrollController _scrollController = ScrollController();
  late GalleryService _galleryService;
  late RecentlyDeletedService _deletedService;

  int deletedCount = 0;
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  bool _isInitializing = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _deletedService = RecentlyDeletedService(
      onUpdate: () {
        if (mounted) {
          // Just rebuild UI, don't reinitialize gallery
          setState(() {});
        }
      },
    );
    _galleryService = GalleryService(_deletedService);
    _initService();
    _scrollController.addListener(_scrollListener);
    _loadBannerAd();
  }

  Future<void> _initService() async {
    await _deletedService.init();
    await _initGallery();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Check permissions when app resumes
    if (state == AppLifecycleState.resumed) {
      _checkPermissionsOnResume();
    }
  }

  Future<void> _checkPermissionsOnResume() async {
    // Import the permission service at the top of the file
    final hasPermission = await _hasAllPermissions();
    if (!mounted) return;

    if (!hasPermission) {
      // Navigate back to permission screen if permissions were revoked
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PermissionScreen()),
      );
    }
  }

  Future<bool> _hasAllPermissions() async {
    final PermissionState photoState = await PhotoManager.getPermissionState(
      requestOption: const PermissionRequestOption(),
    );
    return photoState.isAuth;
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
    // Prevent multiple simultaneous calls
    if (_isRefreshing) {
      debugPrint("⏭️ Already refreshing, skipping...");
      return;
    }

    try {
      _isRefreshing = true;
      setState(() => _isInitializing = true);

      await _galleryService.initGallery();

      if (mounted) {
        setState(() => _isInitializing = false);
      }
    } catch (e) {
      debugPrint("Gallery init error: $e");
      if (mounted) {
        setState(() => _isInitializing = false);
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorLoadingGallery(e.toString())),
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
    final l10n = AppLocalizations.of(context)!;

    if (deletedCount == 0) {
      final result = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: AppColors.dialogBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            l10n.exitGallery,
            style: const TextStyle(color: Colors.white),
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
              Text(
                l10n.exitWithoutCleaningMessage,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.exit, style: const TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      return result ?? false;
    }

    final plural = deletedCount > 1 ? 's' : '';
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
            Flexible(
              child: Text(
                l10n.filesDeleted(deletedCount, plural),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                ),
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
            const SizedBox(height: 16),
            Text(
              l10n.freedUpSpace,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.keepCleaning,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.exit),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    // Update gallery grouping with localized date labels
    if (_galleryService.allImages.isNotEmpty) {
      _galleryService.updateGroupingWithContext(context);
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundPrimary,
          elevation: 0,
          title: Text(
            l10n.yourPhotos,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            // Settings icon
            IconButton(
              icon: const Icon(
                Icons.settings_outlined,
                color: AppColors.textSecondary,
                size: 26,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ),
            // Recently deleted icon
            IconButton(
              icon: const Icon(
                Icons.delete_outline,
                color: AppColors.brandPrimary,
                size: 28,
              ),
              onPressed: () async {
                final changed = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RecentlyDeletedScreen(),
                  ),
                );
                // Refresh gallery if items were restored or permanently deleted
                if (changed == true && mounted) {
                  debugPrint(
                    '🔄 Refreshing gallery after recently deleted changes',
                  );
                  await _initGallery();
                }
              },
            ),
            // Delete count
            // Center(
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 10),
            //     child: Row(
            //       children: [
            //         const Icon(
            //           Icons.delete_sweep,
            //           color: AppColors.brandPrimary,
            //           size: 20,
            //         ),
            //         const SizedBox(width: 6),
            //         Text(
            //           "$deletedCount",
            //           style: const TextStyle(
            //             fontSize: 16,
            //             color: AppColors.brandPrimary,
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
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
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      l10n.loadingPhotos,
                      style: const TextStyle(color: Colors.white70),
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
    final l10n = AppLocalizations.of(context)!;

    if (groupedImages.isEmpty) {
      return RefreshIndicator(
        onRefresh: _refreshGallery,
        color: AppColors.brandPrimary,
        backgroundColor: AppColors.backgroundSurface,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 200),
            Center(
              child: Text(
                l10n.noPhotosFound,
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      );
    }

    final sectionKeys = groupedImages.keys.toList();

    return RefreshIndicator(
      onRefresh: _refreshGallery,
      color: AppColors.brandPrimary,
      backgroundColor: AppColors.backgroundSurface,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
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
                      // Rebuild gallery to show filtered results
                      await _initGallery();
                    } else {
                      // Just rebuild UI if no changes
                      setState(() {});
                    }
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
      ),
    );
  }

  Future<void> _refreshGallery() async {
    await _initGallery();
    if (mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.galleryRefreshed),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _bannerAd?.dispose();
    super.dispose();
  }
}
