import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageViewerService {
  final List<AssetEntity> images;
  final Map<String, Future<Uint8List?>> _imageCache = {};
  int deletedCount = 0;

  VoidCallback? onUpdate;

  ImageViewerService(this.images, {this.onUpdate});

  /// Get thumbnail bytes for both images and videos
  Future<Uint8List?> getThumbnailBytes(AssetEntity asset) {
    return _imageCache.putIfAbsent(asset.id, () async {
      try {
        // For videos, use thumbnail. For images, use original or high quality
        if (asset.type == AssetType.video) {
          // Get video thumbnail
          final thumb = await asset.thumbnailDataWithSize(
            const ThumbnailSize(1920, 1920),
            quality: 95,
          );
          return thumb;
        } else {
          // For images, try to get original bytes, fall back to thumbnail
          try {
            final original = await asset.originBytes;
            return original;
          } catch (e) {
            debugPrint("⚠️ Failed to get original bytes, using thumbnail: $e");
            final thumb = await asset.thumbnailDataWithSize(
              const ThumbnailSize(1920, 1920),
              quality: 95,
            );
            return thumb;
          }
        }
      } catch (e) {
        debugPrint("❌ Error loading asset ${asset.id}: $e");
        return null;
      }
    });
  }

  Future<bool> deletePhoto(BuildContext context, int currentIndex) async {
    if (currentIndex >= images.length) return false;
    final asset = images[currentIndex];

    try {
      final deletedIds = await PhotoManager.editor.deleteWithIds([asset.id]);
      final success = deletedIds.contains(asset.id);

      if (success) {
        await PhotoManager.clearFileCache();
        images.removeAt(currentIndex);
        _imageCache.remove(asset.id);
        deletedCount++;

        if (onUpdate != null) onUpdate!();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${asset.type == AssetType.video ? 'Video' : 'Photo'} deleted ($deletedCount deleted total)",
              ),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(milliseconds: 800),
            ),
          );
        }
      }
      return success;
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Error deleting ${asset.type == AssetType.video ? 'video' : 'photo'}: $e",
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    }
  }

  int getDeletedCount() => deletedCount;
}
