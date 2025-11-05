import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryService {
  List<AssetEntity> allImages = [];
  Map<String, List<AssetEntity>> groupedImages = {};

  bool isLoading = false;
  int currentPage = 0;
  static const int pageSize = 100;
  AssetPathEntity? _cachedAlbum;

  /// New notifier to tell UI when data is ready 🎯
  ValueNotifier<bool> isGalleryReady = ValueNotifier(false);

  Future<void> initGallery() async {
    try {
      isGalleryReady.value = false; // Reset before loading
      debugPrint("🔄 Initializing gallery...");

      allImages.clear();
      groupedImages.clear();
      currentPage = 0;
      _cachedAlbum = null;

      final PermissionState ps = await PhotoManager.requestPermissionExtend();
      if (!ps.isAuth) {
        debugPrint("❌ Permission denied");
        isGalleryReady.value = true;
        return;
      }

      debugPrint("✅ Permission granted");
      await PhotoManager.clearFileCache();

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        hasAll: true,
      );

      if (albums.isEmpty) {
        debugPrint("❌ No albums found");
        isGalleryReady.value = true;
        return;
      }

      _cachedAlbum = albums.first;
      await loadMoreImages();
    } catch (e, stackTrace) {
      debugPrint("❌ Error initializing gallery: $e");
      debugPrint("$stackTrace");
    } finally {
      isGalleryReady.value = true; // Tell UI we're done
    }
  }

  Future<void> loadMoreImages() async {
    if (isLoading) return;

    try {
      isLoading = true;

      if (_cachedAlbum == null) {
        final albums = await PhotoManager.getAssetPathList(
          type: RequestType.image,
          hasAll: true,
        );

        if (albums.isEmpty) return;
        _cachedAlbum = albums.first;
      }

      final newImages = await _cachedAlbum!.getAssetListPaged(
        page: currentPage,
        size: pageSize,
      );

      if (newImages.isNotEmpty) {
        allImages.addAll(newImages);
        _groupImages(newImages);
        currentPage++;
      }
    } catch (e, stackTrace) {
      debugPrint("❌ Error loading images: $e\n$stackTrace");
    } finally {
      isLoading = false;
    }
  }

  void _groupImages(List<AssetEntity> images) {
    for (var asset in images) {
      final date = asset.createDateTime;
      final label = _formatDateLabel(date);
      groupedImages.putIfAbsent(label, () => []);
      groupedImages[label]!.add(asset);
    }
  }

  String _formatDateLabel(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) return "Today";
    if (difference.inDays == 1) return "Yesterday";
    if (difference.inDays < 7) return "This Week";
    if (difference.inDays < 30) return "This Month";
    if (date.year == now.year) {
      return "${_getMonthName(date.month)} ${date.year}";
    }
    return "${date.year}";
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
