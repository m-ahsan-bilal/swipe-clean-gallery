// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:swipe_clean_gallery/viewmodels/gallery_viewmodel.dart';
import 'package:swipe_clean_gallery/l10n/app_localizations.dart';
import 'package:swipe_clean_gallery/screens/about_us_screen.dart';
import 'package:swipe_clean_gallery/screens/permission_screen.dart';
import 'package:swipe_clean_gallery/screens/settings_screen.dart';
import 'package:swipe_clean_gallery/services/app_colors.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  late GalleryViewModel _viewModel;

  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  late AnimationController _introController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _viewModel = GalleryViewModel();
    _introController =
        AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 2000),
          )
          ..addListener(() {
            if (mounted) setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _viewModel.setHasPlayedIntro(true);
            }
          });

    _initGallery();
    _loadBannerAd();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissionsOnResume();
    }
  }

  Future<void> _checkPermissionsOnResume() async {
    final hasPermission = await _hasAllPermissions();
    if (!mounted) return;

    if (!hasPermission) {
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
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) setState(() => _isBannerAdLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("Ad failed: ${error.message}");
          ad.dispose();
        },
      ),
    )..load();
  }

  Future<void> _initGallery({bool playIntro = true}) async {
    try {
      await _viewModel.initGallery(playIntro: playIntro);

      if (mounted && _viewModel.cardAssets.isNotEmpty && playIntro) {
        if (_introController.isAnimating) _introController.stop();
        _introController.forward(from: 0);
      }
    } catch (e) {
      debugPrint("Gallery init error: $e");
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.errorLoadingGallery(e.toString())),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (_viewModel.galleryService.allImages.isNotEmpty) {
      _viewModel.updateGroupingWithContext(context);
    }

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        return WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            backgroundColor: AppColors.backgroundPrimary,
            appBar: AppBar(
              backgroundColor: AppColors.backgroundPrimary,
              elevation: 0,
              title: Text(
                l10n.yourPhotos,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),

              actions: [
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    color: AppColors.textSecondary,
                    size: 26,
                  ),
                  offset: const Offset(0, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem<String>(
                      value: 'settings',
                      child: Row(
                        children: [
                          Icon(
                            Icons.settings_outlined,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.settings,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem<String>(
                      value: 'about',
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            l10n.about,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (String value) {
                    switch (value) {
                      case 'settings':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SettingsScreen(),
                          ),
                        );
                        break;
                      case 'about':
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AboutUsScreen(),
                          ),
                        );
                        break;
                    }
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
            body: _viewModel.isInitializing
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.loadingPhotos,
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : _buildGalleryOverlay(l10n),
          ),
        );
      },
    );
  }

  Widget _buildGalleryBackground() {
    final groupedImages = _viewModel.galleryService.groupedImages;
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
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
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
        itemCount:
            sectionKeys.length + (_viewModel.galleryService.isLoading ? 1 : 0),
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
    final hasDeletedImages = _viewModel.totalDeletedCount > 0;

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.exitGallery),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              hasDeletedImages
                  ? 'assets/images/happy.png'
                  : 'assets/images/sad.png',
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(
                hasDeletedImages ? Icons.celebration : Icons.mood_bad,
                size: 80,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              hasDeletedImages
                  ? l10n.freedUpSpace
                  : l10n.exitWithoutCleaningMessage,
              textAlign: TextAlign.center,
            ),
            if (hasDeletedImages)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  l10n.filesDeleted(
                    _viewModel.totalDeletedCount,
                    _viewModel.totalDeletedCount > 1 ? 's' : '',
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
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

    if (shouldExit == true) {
      Future.delayed(const Duration(milliseconds: 200), () {
        Navigator.pop(context);
      });
      return true;
    }

    return false;
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
    final stackWidth = math.min(350.0, size.width * 0.78);
    final stackHeight = math.min(size.height * .92, stackWidth * 1.3);

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: stackWidth,
        height: stackHeight + 280,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(top: 20, child: _buildBinButton(l10n)),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 68,
              child: _buildCardDeck(l10n, stackWidth, stackHeight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBinButton(AppLocalizations l10n) {
    final pendingCount = _viewModel.pendingCount;
    final isEmpty = pendingCount == 0;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: isEmpty
                    ? AppColors.brandPrimary.withOpacity(0.7)
                    : AppColors.brandPrimary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brandPrimary.withOpacity(
                      isEmpty ? 0.2 : 0.4,
                    ),
                    blurRadius: isEmpty ? 12 : 16,
                    offset: Offset(0, isEmpty ? 6 : 8),
                  ),
                ],
              ),
              child: IconButton(
                iconSize: 28,
                onPressed: _onBinPressed,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Icon(
                    isEmpty ? Icons.delete_outline : Icons.delete,
                    key: ValueKey<bool>(isEmpty),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            if (pendingCount > 0)
              Positioned(
                top: -6,
                right: -6,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.elasticOut,
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  builder: (context, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
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
              ),
          ],
        ),
        if (pendingCount > 0)
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            tween: Tween<double>(begin: 0.0, end: 1.0),
            builder: (context, opacity, child) {
              return Opacity(
                opacity: opacity,
                child: Transform.translate(
                  offset: Offset(0, 10 * (1 - opacity)),
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '$pendingCount ${l10n.selectedCount}',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCardDeck(AppLocalizations l10n, double width, double height) {
    final cardAssets = _viewModel.cardAssets;
    final topCardIndex = _viewModel.topCardIndex;

    if (cardAssets.isEmpty) {
      if (_viewModel.pendingCount > 0) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${_viewModel.pendingCount} ${l10n.selectedCount}',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.deleteSelected,
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }

      return Center(
        child: Text(
          l10n.noPhotosFound,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            fontSize: 16,
          ),
        ),
      );
    }

    const depth = 3;
    final widgets = <Widget>[];
    final maxDepth = math.min(depth, cardAssets.length - topCardIndex);

    for (int i = 0; i < maxDepth; i++) {
      final cardIndex = topCardIndex + i;
      if (cardIndex >= cardAssets.length) continue;

      final asset = cardAssets[cardIndex];
      final depthIndex = i;
      // Top card is the first one (at topCardIndex), not the last
      final isTop = depthIndex == 0;

      // Reverse the order: top card (depthIndex=0) should be on top visually
      final verticalOffset = (maxDepth - 1 - depthIndex) * 20.0;
      final scale = 1 - depthIndex * 0.04;
      final horizontalPadding = depthIndex * 4.0;

      widgets.add(
        Positioned(
          left: horizontalPadding,
          right: horizontalPadding,
          bottom: verticalOffset,
          child: Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: Container(
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15 + (depthIndex * 5),
                    spreadRadius: 1,
                    offset: Offset(0, 4 + depthIndex * 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: isTop
                    ? _buildInteractiveCard(asset, width, height)
                    : _buildStaticCard(asset),
              ),
            ),
          ),
        ),
      );
    }

    // Reverse widgets so the top card (at topCardIndex) is drawn last and appears on top
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: widgets.reversed.toList(),
    );
  }

  Widget _buildInteractiveCard(AssetEntity asset, double width, double height) {
    final introRaw = _viewModel.hasPlayedIntro ? 1.0 : _introController.value;
    final introProgress = _viewModel.hasPlayedIntro
        ? 1.0
        : Curves.easeOutCubic.transform(introRaw);

    final initialOffset = Offset(-width * 0.32, -height * 0.55);

    final offset =
        _viewModel.cardOffset +
        Offset(
          initialOffset.dx * (1 - introProgress),
          initialOffset.dy * (1 - introProgress),
        );
    final introScale = _viewModel.hasPlayedIntro
        ? 1.0
        : (0.65 + introProgress * 0.35);
    final introRotation = _viewModel.hasPlayedIntro
        ? 0.0
        : (1 - introProgress) * -0.08;

    return AbsorbPointer(
      absorbing: !_viewModel.hasPlayedIntro,
      child: GestureDetector(
        onPanUpdate: (details) => _viewModel.onCardPanUpdate(
          details,
          MediaQuery.of(context).size.width,
        ),
        onPanEnd: (details) {
          final message = _viewModel.onCardPanEnd(details);
          if (message != null) {
            final l10n = AppLocalizations.of(context)!;
            String snackMessage;

            switch (message) {
              case 'noMoreCards':
                snackMessage = l10n.noMoreCards;
                break;
              case 'alreadyAtMostRecent':
                snackMessage = 'Already at most recent photo';
                break;
              default:
                snackMessage = message;
            }

            _showSnack(snackMessage);
          }
        },
        child: Transform.translate(
          offset: offset,
          child: Transform.rotate(
            angle: _viewModel.cardRotation + introRotation,
            child: Transform.scale(
              scale: introScale,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: _buildCardSurface(asset),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStaticCard(AssetEntity asset) {
    return _buildCardSurface(asset);
  }

  Widget _buildCardSurface(AssetEntity asset) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: AssetEntityImage(
              asset,
              isOriginal: false,
              thumbnailSize: const ThumbnailSize.square(1200),
              fit: BoxFit.contain,
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
          ),
          if (asset.type == AssetType.video)
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
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
    );
  }

  Future<void> _onBinPressed() async {
    if (!mounted) return;

    final l10n = AppLocalizations.of(context)!;

    if (_viewModel.pendingCount == 0) {
      _showSnack(l10n.queueEmpty);
      return;
    }

    // Create a safe copy of the queue before showing dialog
    final queueCopy = List<AssetEntity>.from(_viewModel.pendingDeletionQueue);
    final count = queueCopy.length;
    final plural = count > 1 ? 's' : '';

    // Show simplified confirmation dialog to avoid viewport rendering issues
    bool? confirmed;
    try {
      confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(l10n.confirmDelete(count, plural)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.permanentDeleteConfirmation),
                  const SizedBox(height: 12),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(l10n.confirm),
              ),
            ],
          );
        },
      );
    } catch (e, stackTrace) {
      debugPrint('Error showing delete confirmation dialog: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        _showSnack('Error: Could not show confirmation dialog');
      }
      return;
    }

    if (confirmed != true || !mounted) return;

    // Small delay to ensure dialog is fully closed and UI is stable
    await Future.delayed(const Duration(milliseconds: 100));

    if (!mounted) return;

    // Perform deletion
    await _deleteQueuedAssets();
  }

  Future<void> _deleteQueuedAssets() async {
    if (!mounted) return;

    // Show loading indicator with proper constraints
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => Material(
          type: MaterialType.transparency,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    } catch (e) {
      debugPrint('Error showing loading dialog: $e');
      // Continue with deletion even if loading dialog fails
    }

    try {
      // Small delay to ensure loading dialog is shown and UI is stable
      await Future.delayed(const Duration(milliseconds: 100));

      if (!mounted) {
        try {
          Navigator.of(context).pop(); // Close loading dialog
        } catch (e) {
          debugPrint('Error closing loading dialog: $e');
        }
        return;
      }

      final result = await _viewModel.deleteQueuedAssets();

      // Close loading indicator safely
      if (mounted) {
        try {
          Navigator.of(context).pop();
        } catch (e) {
          debugPrint('Error closing loading dialog after deletion: $e');
        }
      }

      if (!mounted) return;

      if (!result['success']) {
        final message = result['message'];
        String snackMessage;

        if (message == 'queueEmpty') {
          snackMessage = AppLocalizations.of(context)!.queueEmpty;
        } else if (message == 'deletionCancelled') {
          snackMessage = 'Deletion cancelled or failed';
        } else {
          snackMessage = 'Error: ${result['error'] ?? 'Unknown error'}';
        }

        _showSnack(snackMessage);
        return;
      }

      // Show success message briefly
      final deletedCount = result['deleted'] ?? 0;
      if (result['partial'] == true) {
        _showSnack('Deleted ${result['deleted']} of ${result['total']} files');
      } else if (deletedCount > 0) {
        _showSnack(
          'Successfully deleted $deletedCount file${deletedCount > 1 ? 's' : ''}',
        );
      }

      // Show fireworks animation after successful deletion
      if (result['success'] == true && mounted) {
        // Small delay to let the UI update
        await Future.delayed(const Duration(milliseconds: 300));

        if (mounted) {
          try {
            await _showFireworksOverlay();
          } catch (e) {
            debugPrint('Error showing fireworks: $e');
            // Don't show error to user, just log it
          }
        }
      }
    } catch (e, stackTrace) {
      debugPrint('Error in _deleteQueuedAssets: $e');
      debugPrint('Stack trace: $stackTrace');

      // Close loading indicator if still open
      if (mounted) {
        try {
          Navigator.of(context).pop();
        } catch (e2) {
          debugPrint('Error closing loading dialog on error: $e2');
        }
        _showSnack('Error deleting files: ${e.toString()}');
      }
    }
  }

  Future<void> _showFireworksOverlay() async {
    if (!mounted) return;

    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'fireworks',
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final scale = Curves.easeOutBack.transform(animation.value);
              final opacity = Curves.easeIn.transform(animation.value);
              return Opacity(
                opacity: opacity,
                child: Transform.scale(scale: scale, child: child),
              );
            },
            child: const Center(
              child: SizedBox(
                width: 280,
                height: 280,
                child: _FireworksCelebration(),
              ),
            ),
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
    await _initGallery(playIntro: false);
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
    _viewModel.dispose();
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = math.min(constraints.maxWidth, constraints.maxHeight);
        return SizedBox(
          width: size,
          height: size,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size(size, size),
                painter: _FireworksPainter(progress: _controller.value),
              );
            },
          ),
        );
      },
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
