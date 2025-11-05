import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // For testing, use this:
      return 'ca-app-pub-7697382522642064/9838937971'; // Google test banner ad

      // For production, use this:
      // return 'ca-app-pub-7697382522642064/9838937971';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
