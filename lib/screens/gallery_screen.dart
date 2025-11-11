import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:swipe_clean_gallery/l10n/app_localizations.dart';
import 'package:swipe_clean_gallery/screens/permission_screen.dart';
import 'package:swipe_clean_gallery/screens/settings_screen.dart';
import 'package:swipe_clean_gallery/services/app_colors.dart';
import 'package:swipe_clean_gallery/services/gallery_service.dart';
import 'package:swipe_clean_gallery/services/recently_deleted_service.dart';

enum _SwipeDirection { left, right, up }

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late GalleryService _galleryService;
  late RecentlyDeletedService _deletedService;

  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  bool _isInitializing = true;
  bool _isRefreshing = false;
  bool _hasPlayedIntro = false;

  late AnimationController _introController;

  final List<AssetEntity> _pendingDeletionQueue = [];
  List<AssetEntity> _cardAssets = [];
  int _topCardIndex = 0;
  Offset _cardOffset = Offset.zero;
  double _cardRotation = 0.0;
  int _recentlyDeletedCount = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _introController =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 2000),
          )
          ..addListener(() {
            if (mounted) {
              setState(() {});
            }
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                _hasPlayedIntro = true;
              });
            }
          });
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
        _pendingDeletionQueue.clear();
        _cardOffset = Offset.zero;
        _cardRotation = 0.0;
        _hasPlayedIntro = false;
        setState(() => _isInitializing = false);
        _syncCardAssets(resetIndex: true);
        if (_cardAssets.isNotEmpty) {
          if (_introController.isAnimating) {
            _introController.stop();
          }
          _introController.forward(from: 0);
        }
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
    if (_galleryService.isLoading) return;
    await _galleryService.loadMoreImages();
    if (!mounted) return;
    _syncCardAssets(resetIndex: false);
  }

  void _syncCardAssets({required bool resetIndex}) {
    final pendingIds = _pendingDeletionQueue.map((asset) => asset.id).toSet();
    final sorted = List<AssetEntity>.from(_galleryService.allImages)
      ..sort((a, b) => b.createDateTime.compareTo(a.createDateTime));
    final filtered = sorted
        .where((asset) => !pendingIds.contains(asset.id))
        .toList();

    setState(() {
      _cardAssets = filtered;
      if (_cardAssets.isEmpty) {
        _topCardIndex = 0;
        _cardOffset = Offset.zero;
        _cardRotation = 0;
        return;
      }

      if (resetIndex || _topCardIndex >= _cardAssets.length) {
        _topCardIndex = 0;
      } else {
        final currentId = _cardAssets[_topCardIndex].id;
        final newIndex = _cardAssets.indexWhere(
          (asset) => asset.id == currentId,
        );
        if (newIndex == -1) {
          _topCardIndex = 0;
        } else {
          _topCardIndex = newIndex;
        }
      }
    });
  }

  void _maybeLoadMore() {
    if (_cardAssets.isEmpty) return;
    if (_topCardIndex >= _cardAssets.length - 3) {
      _loadMore();
    }
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
            : _buildGalleryOverlay(l10n),
      ),
    );
  }

  Widget _buildGalleryBackground() {
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

                return ClipRRect(
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
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildGalleryOverlay(AppLocalizations l10n) {
    return Stack(
      children: [
        IgnorePointer(child: _buildGalleryBackground()),
        Positioned.fill(child: _buildBlurOverlay()),
        _buildCardStackArea(l10n),
      ],
    );
  }

  Future<bool> _onWillPop() async {
    final l10n = AppLocalizations.of(context)!;

    if (_recentlyDeletedCount == 0) {
      final shouldExit = await showDialog<bool>(
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
      return shouldExit ?? false;
    }

    final plural = _recentlyDeletedCount > 1 ? 's' : '';
    final shouldExit = await showDialog<bool>(
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
                l10n.filesDeleted(_recentlyDeletedCount, plural),
                style: const TextStyle(color: Colors.white70, fontSize: 16),
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
    return shouldExit ?? false;
  }

  Widget _buildBlurOverlay() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
        child: Container(color: Colors.black.withOpacity(0.35)),
      ),
    );
  }

  Widget _buildCardStackArea(AppLocalizations l10n) {
    final size = MediaQuery.of(context).size;
    final stackWidth = math.min(460.0, size.width * 0.92);
    final stackHeight = math.min(size.height * 0.72, stackWidth * 1.25);

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: stackWidth,
        height: stackHeight + 120,
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(top: 0, child: _buildBinButton(l10n)),
            Positioned(
              top: 88,
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildCardDeck(l10n, stackWidth, stackHeight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBinButton(AppLocalizations l10n) {
    final pendingCount = _pendingDeletionQueue.length;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.brandPrimary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brandPrimary.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: IconButton(
                iconSize: 28,
                onPressed: _onBinPressed,
                icon: const Icon(Icons.delete_outline, color: Colors.white),
              ),
            ),
            if (pendingCount > 0)
              Positioned(
                top: -6,
                right: -6,
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.redAccent,
                  child: Text(
                    pendingCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (pendingCount > 0)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '$pendingCount ${l10n.selectedCount}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildCardDeck(AppLocalizations l10n, double width, double height) {
    if (_cardAssets.isEmpty) {
      if (_pendingDeletionQueue.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_pendingDeletionQueue.length} ${l10n.selectedCount}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.deleteSelected,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
        );
      }

      return Center(
        child: Text(
          l10n.noPhotosFound,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    final depth = 3;
    final widgets = <Widget>[];
    final maxDepth = math.min(depth, _cardAssets.length - _topCardIndex);

    for (int i = maxDepth - 1; i >= 0; i--) {
      final cardIndex = _topCardIndex + i;
      if (cardIndex >= _cardAssets.length) continue;
      final asset = _cardAssets[cardIndex];
      final depthIndex = i;
      final isTop = depthIndex == 0;
      final offsetY = depthIndex * 26.0;
      final scale = 1 - depthIndex * 0.07;
      final opacity = 1 - depthIndex * 0.14;

      widgets.add(
        Positioned.fill(
          top: offsetY,
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.topCenter,
            child: Opacity(
              opacity: opacity,
              child: isTop
                  ? _buildInteractiveCard(asset, width, height)
                  : ImageFiltered(
                      imageFilter: ImageFilter.blur(
                        sigmaX: depthIndex * 1.5,
                        sigmaY: depthIndex * 1.5,
                      ),
                      child: _buildStaticCard(asset, width, height),
                    ),
            ),
          ),
        ),
      );
    }

    return Stack(children: widgets);
  }

  Widget _buildInteractiveCard(AssetEntity asset, double width, double height) {
    final introRaw = _hasPlayedIntro ? 1.0 : _introController.value;
    final introProgress = _hasPlayedIntro
        ? 1.0
        : Curves.easeOutCubic.transform(introRaw);

    final initialOffset = Offset(-width * 0.32, -height * 0.55);

    final offset =
        _cardOffset +
        Offset(
          initialOffset.dx * (1 - introProgress),
          initialOffset.dy * (1 - introProgress),
        );
    final introScale = _hasPlayedIntro ? 1.0 : (0.65 + introProgress * 0.35);
    final introRotation = _hasPlayedIntro ? 0.0 : (1 - introProgress) * -0.08;

    return AbsorbPointer(
      absorbing: !_hasPlayedIntro,
      child: GestureDetector(
        onPanUpdate: _onCardPanUpdate,
        onPanEnd: _onCardPanEnd,
        child: Transform.translate(
          offset: offset,
          child: Transform.rotate(
            angle: _cardRotation + introRotation,
            child: Transform.scale(
              scale: introScale,
              child: _buildCardSurface(asset),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStaticCard(AssetEntity asset, double width, double height) {
    return _buildCardSurface(asset);
  }

  Widget _buildCardSurface(AssetEntity asset) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 28,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AssetEntityImage(
              asset,
              isOriginal: false,
              thumbnailSize: const ThumbnailSize.square(1600),
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: Colors.grey[850],
                alignment: Alignment.center,
                child: const Icon(
                  Icons.broken_image_outlined,
                  color: Colors.grey,
                  size: 48,
                ),
              ),
            ),
            if (asset.type == AssetType.video)
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onCardPanUpdate(DragUpdateDetails details) {
    setState(() {
      _cardOffset += details.delta;
      final width = MediaQuery.of(context).size.width;
      _cardRotation = (_cardOffset.dx / width) * 0.4;
    });
  }

  void _onCardPanEnd(DragEndDetails details) {
    const horizontalThreshold = 120;
    const verticalThreshold = 120;
    final dx = _cardOffset.dx;
    final dy = _cardOffset.dy;

    if (dy < -verticalThreshold) {
      _handleSwipe(_SwipeDirection.up);
    } else if (dx > horizontalThreshold) {
      _handleSwipe(_SwipeDirection.right);
    } else if (dx < -horizontalThreshold) {
      _handleSwipe(_SwipeDirection.left);
    } else {
      _resetCardPosition();
    }
  }

  void _handleSwipe(_SwipeDirection direction) {
    if (_cardAssets.isEmpty) {
      _resetCardPosition();
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    switch (direction) {
      case _SwipeDirection.left:
        if (_topCardIndex < _cardAssets.length - 1) {
          setState(() {
            _topCardIndex++;
            _cardOffset = Offset.zero;
            _cardRotation = 0.0;
          });
          _maybeLoadMore();
        } else {
          _showSnack(l10n.noMoreCards);
          _resetCardPosition();
        }
        break;
      case _SwipeDirection.right:
        if (_topCardIndex > 0) {
          setState(() {
            _topCardIndex--;
            _cardOffset = Offset.zero;
            _cardRotation = 0.0;
          });
        } else {
          _showSnack(l10n.noMoreCards);
          _resetCardPosition();
        }
        break;
      case _SwipeDirection.up:
        final asset = _cardAssets[_topCardIndex];
        if (!_pendingDeletionQueue.any((item) => item.id == asset.id)) {
          _pendingDeletionQueue.add(asset);
        }
        setState(() {
          _cardAssets.removeAt(_topCardIndex);
          if (_topCardIndex >= _cardAssets.length && _cardAssets.isNotEmpty) {
            _topCardIndex = _cardAssets.length - 1;
          }
          _cardOffset = Offset.zero;
          _cardRotation = 0.0;
        });
        _maybeLoadMore();
        break;
    }
  }

  void _resetCardPosition() {
    setState(() {
      _cardOffset = Offset.zero;
      _cardRotation = 0.0;
    });
  }

  Future<void> _onBinPressed() async {
    final l10n = AppLocalizations.of(context)!;
    if (_pendingDeletionQueue.isEmpty) {
      _showSnack(l10n.queueEmpty);
      return;
    }

    final count = _pendingDeletionQueue.length;
    final plural = count > 1 ? 's' : '';

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.dialogBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.confirmDelete(count, plural),
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          l10n.permanentDeleteConfirmation,
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    await _deleteQueuedAssets();
  }

  Future<void> _deleteQueuedAssets() async {
    if (_pendingDeletionQueue.isEmpty) return;
    final ids = _pendingDeletionQueue.map((asset) => asset.id).toList();
    try {
      await PhotoManager.editor.deleteWithIds(ids);
      await PhotoManager.clearFileCache();
    } catch (e) {
      debugPrint('Error deleting assets: $e');
    }

    _pendingDeletionQueue.clear();
    await _initGallery();
    if (!mounted) return;
    await _showFireworksOverlay();
    setState(() {
      _recentlyDeletedCount += ids.length;
    });
  }

  Future<void> _showFireworksOverlay() async {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'fireworks',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        // Use a simple scale/opacity animation to avoid network-dependent errors.
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            final scale = Curves.easeOutBack.transform(animation.value);
            final opacity = Curves.easeIn.transform(animation.value);
            return Opacity(
              opacity: opacity,
              child: Transform.scale(scale: scale, child: child),
            );
          },
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0x55FFFFFF), Colors.transparent],
              ),
            ),
            child: const _FireworksCelebration(),
          ),
        );
      },
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: const Duration(milliseconds: 1200),
          behavior: SnackBarBehavior.floating,
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
    _bannerAd?.dispose();
    _introController.dispose();
    super.dispose();
  }
}

class _FireworksCelebration extends StatefulWidget {
  const _FireworksCelebration();

  @override
  State<_FireworksCelebration> createState() => _FireworksCelebrationState();
}

class _FireworksCelebrationState extends State<_FireworksCelebration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();

    Future.delayed(const Duration(milliseconds: 1700), () {
      if (mounted) {
        Navigator.of(context).maybePop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      height: 280,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _FireworksPainter(progress: _controller.value),
          );
        },
      ),
    );
  }
}

class _FireworksPainter extends CustomPainter {
  final double progress;

  _FireworksPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
      final centerX = size.width * (0.2 + i * 0.15);
      final centerY = size.height * (0.3 + (i % 2) * 0.2);
      _drawFirework(canvas, Offset(centerX, centerY), progress, paint, i);
    }
  }

  void _drawFirework(
    Canvas canvas,
    Offset center,
    double progress,
    Paint paint,
    int seed,
  ) {
    final random = math.Random(seed);
    final particleCount = 20 + random.nextInt(10);

    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * math.pi;
      final velocity = 50 + random.nextDouble() * 100;

      final distance = velocity * progress * (2 - progress);
      final x = center.dx + math.cos(angle) * distance;
      final y =
          center.dy + math.sin(angle) * distance + (progress * progress * 40);

      final opacity = (1 - progress).clamp(0.0, 1.0);
      final colors = [
        Colors.red,
        Colors.blue,
        Colors.yellow,
        Colors.green,
        Colors.purple,
        Colors.orange,
        Colors.pink,
      ];
      paint.color = colors[random.nextInt(colors.length)].withOpacity(opacity);

      final particleSize = (3 + random.nextDouble() * 3) * (1 - progress * 0.5);
      canvas.drawCircle(Offset(x, y), particleSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _FireworksPainter oldDelegate) => true;
}
