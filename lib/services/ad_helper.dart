import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // For testing, use this:
      return 'ca-app-pub-3940256099942544/6300978111'; // Google test banner ad
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
