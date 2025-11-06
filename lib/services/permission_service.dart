import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../screens/gallery_screen.dart';

class PermissionService {
  /// Requests permission to access media files.
  static Future<void> requestPermission(BuildContext context) async {
    final PermissionState result = await PhotoManager.requestPermissionExtend();

    if (result.isAuth) {
      _navigateToGallery(context);
      return;
    }

    if (result == PermissionState.limited) {
      // We don't allow limited access: ask user to grant full access in Settings
      if (context.mounted) {
        await showDialog<void>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Full Access Needed'),
            content: const Text(
              'Please grant full photo access to browse and clean your gallery.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await PhotoManager.openSetting();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }
      return;
    }

    _showPermissionDeniedMessage(context);
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
      SnackBar(
        content: const Text(
          "Permission needed to browse photos. Please allow in Settings.",
        ),
        action: SnackBarAction(
          label: 'Open Settings',
          onPressed: () {
            PhotoManager.openSetting();
          },
        ),
      ),
    );
  }

  /// Checks if permission is already granted
  static Future<bool> hasPermission() async {
    final PermissionState state = await PhotoManager.requestPermissionExtend();
    // Only full access qualifies
    return state.isAuth;
  }
}
