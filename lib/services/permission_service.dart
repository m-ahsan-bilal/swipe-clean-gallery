import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../screens/gallery_screen.dart';

class PermissionService {
  /// Get Android SDK version
  static Future<int> getAndroidSdkVersion() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.sdkInt;
    }
    return 0;
  }

  /// Checks if all required permissions are granted
  static Future<bool> hasAllPermissions() async {
    try {
      // Get Android version
      final androidVersion = await getAndroidSdkVersion();
      
      // For Android 13+, we need READ_MEDIA_IMAGES and READ_MEDIA_VIDEO
      // For Android 12 and below, we need READ_EXTERNAL_STORAGE
      final PermissionState photoState = await PhotoManager.getPermissionState(
        requestOption: PermissionRequestOption(
          androidPermission: AndroidPermission(
            type: androidVersion >= 33 ? RequestType.common : RequestType.common,
            mediaLocation: false, // Don't require mediaLocation for simpler permission flow
          ),
        ),
      );
      
      return photoState.isAuth;
    } catch (e) {
      debugPrint('Error checking permissions: $e');
      return false;
    }
  }

  /// Requests all necessary permissions
  static Future<PermissionStatus> requestPermission(BuildContext context) async {
    try {
      // Get Android version
      final androidVersion = await getAndroidSdkVersion();
      
      // Request permissions based on Android version
      final PermissionState photoResult = await PhotoManager.requestPermissionExtend(
        requestOption: PermissionRequestOption(
          androidPermission: AndroidPermission(
            type: RequestType.common,
            mediaLocation: false, // Simplified permission for better UX
          ),
        ),
      );

      debugPrint('Permission result: $photoResult');

      if (photoResult.isAuth) {
        return PermissionStatus.granted;
      } else if (photoResult == PermissionState.limited) {
        // On Android, limited access still allows basic operations
        return PermissionStatus.granted;
      } else if (photoResult == PermissionState.denied) {
        // Check if permanently denied by trying to request again
        final secondTry = await PhotoManager.requestPermissionExtend();
        if (secondTry == PermissionState.denied) {
          return PermissionStatus.permanentlyDenied;
        }
        return PermissionStatus.denied;
      }
      
      return PermissionStatus.denied;
    } catch (e) {
      debugPrint('Error requesting permissions: $e');
      return PermissionStatus.denied;
    }
  }

  /// Navigates to GalleryScreen after permission is granted
  static void navigateToGallery(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const GalleryScreen()),
    );
  }

  /// Opens app settings
  static Future<void> openAppSettings() async {
    await PhotoManager.openSetting();
  }
}

enum PermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  limited,
}
