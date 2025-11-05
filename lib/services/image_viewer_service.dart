import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ImageViewerService {
  final List<AssetEntity> images;
  final Map<String, Future<Uint8List?>> _imageCache = {};
  int deletedCount = 0;

  /// Optional callback for UI updates
  VoidCallback? onUpdate;

  ImageViewerService(this.images, {this.onUpdate});

  Future<Uint8List?> getImageBytes(AssetEntity asset) {
    return _imageCache.putIfAbsent(asset.id, () => asset.originBytes);
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

        // Notify UI to refresh
        if (onUpdate != null) onUpdate!();

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Photo deleted ($deletedCount deleted total)"),
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
            content: Text("Error deleting photo: $e"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return false;
    }
  }

  int getDeletedCount() => deletedCount;
}
