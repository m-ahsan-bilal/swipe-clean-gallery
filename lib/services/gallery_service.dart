import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:swipe_clean_gallery/services/recently_deleted_service.dart';
import 'package:swipe_clean_gallery/l10n/app_localizations.dart';

class GalleryService {
  List<AssetEntity> allImages = [];
  Map<String, List<AssetEntity>> groupedImages = {};
  bool isLoading = false;
  int currentPage = 0;
  static const int pageSize = 100;
  AssetPathEntity? _cachedAlbum;
  final RecentlyDeletedService _deletedService;

  GalleryService(this._deletedService);

  Future<void> initGallery() async {
    try {
      debugPrint("Initializing gallery...");

      // Clear existing data
      allImages.clear();
      groupedImages.clear();
      currentPage = 0;
      _cachedAlbum = null;

      // Reload deleted items from storage
      await _deletedService.loadDeletedItems();
      debugPrint("Loaded ${_deletedService.count} recently deleted items");

      // Request permissions with proper Android options
      final PermissionState ps = await PhotoManager.requestPermissionExtend(
        requestOption: const PermissionRequestOption(
          androidPermission: AndroidPermission(
            type: RequestType.common,
            mediaLocation: true,
          ),
        ),
      );
      if (!ps.isAuth && ps != PermissionState.limited) {
        debugPrint("Permission denied");
        return;
      }

      debugPrint("Permission granted");

      // Clear any cached file references
      await PhotoManager.clearFileCache();

      // Get fresh albums - IMPORTANT: Request both images AND videos
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType
            .common, // 👈 Changed from RequestType.image to RequestType.common
        hasAll: true,
      );

      debugPrint("Found ${albums.length} albums");

      if (albums.isEmpty) {
        debugPrint("No albums found");
        return;
      }

      _cachedAlbum = albums.first;

      if (_cachedAlbum == null) {
        debugPrint("Failed to get album");
        return;
      }

      final count = await _cachedAlbum!.assetCountAsync;
      debugPrint("Using album: ${_cachedAlbum!.name} with $count items");

      // Load first page
      await loadMoreImages();
      debugPrint("Gallery initialized with ${allImages.length} items");
    } catch (e, stackTrace) {
      debugPrint("Error initializing gallery: $e");
      debugPrint("Stack trace: $stackTrace");
      // Reset state on error
      _cachedAlbum = null;
      allImages.clear();
      groupedImages.clear();
    }
  }

  Future<void> loadMoreImages() async {
    if (isLoading) {
      debugPrint("Already loading, skipping...");
      return;
    }

    try {
      isLoading = true;
      debugPrint("Loading more images (page $currentPage)...");

      // Use cached album or get fresh one
      if (_cachedAlbum == null) {
        final List<AssetPathEntity> albums =
            await PhotoManager.getAssetPathList(
              type: RequestType.common, //common type
              hasAll: true,
            );

        if (albums.isEmpty) {
          debugPrint("No albums found");
          isLoading = false;
          return;
        }

        _cachedAlbum = albums.first;
      }

      final List<AssetEntity> newImages = await _cachedAlbum!.getAssetListPaged(
        page: currentPage,
        size: pageSize,
      );

      debugPrint("Fetched ${newImages.length} items from page $currentPage");

      if (newImages.isNotEmpty) {
        // Filter out deleted items
        final deletedIds = _deletedService.getDeletedIds();
        final filteredImages = newImages
            .where((asset) => !deletedIds.contains(asset.id))
            .toList();

        debugPrint(
          "🗑️ Filtered out ${newImages.length - filteredImages.length} deleted items",
        );

        if (filteredImages.isNotEmpty) {
          allImages.addAll(filteredImages);
          _groupImages(filteredImages); // Context will be added when screen rebuilds
        }

        currentPage++;
        debugPrint(
          "Loaded ${filteredImages.length} items. Total: ${allImages.length}",
        );
        debugPrint("Grouped into ${groupedImages.length} sections");
      } else {
        debugPrint("No more items to load");
      }
    } catch (e, stackTrace) {
      debugPrint(" Error loading images: $e");
      debugPrint("Stack trace: $stackTrace");
    } finally {
      isLoading = false;
    }
  }

  void _groupImages(List<AssetEntity> images, {BuildContext? context}) {
    debugPrint("Grouping ${images.length} items...");

    for (var asset in images) {
      final date = asset.createDateTime;
      final String label = _formatDateLabel(date, context: context);

      if (!groupedImages.containsKey(label)) {
        groupedImages[label] = [];
        debugPrint("Created new group: $label");
      }

      groupedImages[label]!.add(asset);
    }

    debugPrint("Grouping complete. Total groups: ${groupedImages.length}");
  }

  String _formatDateLabel(DateTime date, {BuildContext? context}) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    // Get localizations if context is available
    final l10n = context != null ? AppLocalizations.of(context) : null;

    if (difference.inDays == 0) {
      return l10n?.today ?? "Today";
    } else if (difference.inDays == 1) {
      return l10n?.yesterday ?? "Yesterday";
    } else if (difference.inDays < 7) {
      return l10n?.thisWeek ?? "This Week";
    } else if (difference.inDays < 30) {
      return l10n?.thisMonth ?? "This Month";
    } else if (date.year == now.year) {
      return "${_getMonthName(date.month, l10n)} ${date.year}";
    } else {
      return "${date.year}";
    }
  }

  String _getMonthName(int month, AppLocalizations? l10n) {
    if (l10n == null) {
      const months = [
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December",
      ];
      return months[month - 1];
    }
    
    switch (month) {
      case 1: return l10n.january;
      case 2: return l10n.february;
      case 3: return l10n.march;
      case 4: return l10n.april;
      case 5: return l10n.may;
      case 6: return l10n.june;
      case 7: return l10n.july;
      case 8: return l10n.august;
      case 9: return l10n.september;
      case 10: return l10n.october;
      case 11: return l10n.november;
      case 12: return l10n.december;
      default: return "";
    }
  }
  
  /// Update grouping with context for localization
  void updateGroupingWithContext(BuildContext context) {
    if (allImages.isEmpty) return;
    groupedImages.clear();
    _groupImages(allImages, context: context);
  }
}
