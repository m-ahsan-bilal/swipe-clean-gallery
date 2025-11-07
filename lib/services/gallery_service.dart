import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:swipe_clean_gallery/services/recently_deleted_service.dart';

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
          _groupImages(filteredImages);
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

  void _groupImages(List<AssetEntity> images) {
    debugPrint("Grouping ${images.length} items...");

    for (var asset in images) {
      final date = asset.createDateTime;
      final String label = _formatDateLabel(date);

      if (!groupedImages.containsKey(label)) {
        groupedImages[label] = [];
        debugPrint("Created new group: $label");
      }

      groupedImages[label]!.add(asset);
    }

    debugPrint("Grouping complete. Total groups: ${groupedImages.length}");
  }

  String _formatDateLabel(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return "Today";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return "This Week";
    } else if (difference.inDays < 30) {
      return "This Month";
    } else if (date.year == now.year) {
      return "${_getMonthName(date.month)} ${date.year}";
    } else {
      return "${date.year}";
    }
  }

  String _getMonthName(int month) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[month - 1];
  }
}
