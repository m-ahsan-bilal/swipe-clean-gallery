import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../screens/gallery_screen.dart';

class PermissionService {
  /// Requests permission to access media files.
  static Future<void> requestPermission(BuildContext context) async {
    final PermissionState result = await PhotoManager.requestPermissionExtend();

    if (result.isAuth) {
      _navigateToGallery(context);
    } else if (result == PermissionState.limited) {
      // Limited access to a subset of photos
      await PhotoManager.presentLimited();
      _navigateToGallery(context);
    } else {
      _showPermissionDeniedMessage(context);
    }
  }

  /// Navigates to GalleryScreen after permission is granted
  static void _navigateToGallery(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const GalleryScreen()),
    );
  }

  /// Shows snackbar when permission is denied
  static void _showPermissionDeniedMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Permission is needed to browse photos. Please allow access in Settings.",
        ),
      ),
    );
  }

  /// Checks if permission is already granted
  static Future<bool> hasPermission() async {
    final PermissionState state = await PhotoManager.requestPermissionExtend();
    return state.isAuth || state == PermissionState.limited;
  }
}
