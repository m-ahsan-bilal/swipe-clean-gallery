import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage app localization and language preferences
class LocalizationService extends ChangeNotifier {
  static const String _languageKey = 'app_language';
  static const String _firstLaunchKey = 'is_first_launch';

  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  /// Supported languages with their native names and locale codes
  static const Map<String, Map<String, String>> supportedLanguages = {
    'en': {'name': 'English', 'nativeName': 'English', 'flag': '🇬🇧'},
    'ur': {'name': 'Urdu', 'nativeName': 'اردو', 'flag': '🇵🇰'},
    'ar': {'name': 'Arabic', 'nativeName': 'العربية', 'flag': '🇸🇦'},
    'es': {'name': 'Spanish', 'nativeName': 'Español', 'flag': '🇪🇸'},
    'fr': {'name': 'French', 'nativeName': 'Français', 'flag': '🇫🇷'},
    'de': {'name': 'German', 'nativeName': 'Deutsch', 'flag': '🇩🇪'},
    'zh': {'name': 'Chinese', 'nativeName': '中文', 'flag': '🇨🇳'},
    'hi': {'name': 'Hindi', 'nativeName': 'हिन्दी', 'flag': '🇮🇳'},
  };

  /// Get list of supported locales
  static List<Locale> get supportedLocales {
    return supportedLanguages.keys.map((code) => Locale(code)).toList();
  }

  /// Check if this is the first app launch
  Future<bool> isFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_firstLaunchKey) ?? true;
  }

  /// Mark that the app has been launched before
  Future<void> setFirstLaunchComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstLaunchKey, false);
  }

  /// Load saved language preference or use system language
  Future<void> loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString(_languageKey);
    
    if (savedLanguageCode != null && supportedLanguages.containsKey(savedLanguageCode)) {
      // User has previously selected a language
      _currentLocale = Locale(savedLanguageCode);
    } else {
      // First launch or no saved preference - use system language
      await _setSystemLanguage(prefs);
    }
    notifyListeners();
  }

  /// Set language based on system locale
  Future<void> _setSystemLanguage(SharedPreferences prefs) async {
    // Get system locale (from platform)
    final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
    final systemLanguageCode = systemLocale.languageCode;
    
    // Check if system language is supported
    if (supportedLanguages.containsKey(systemLanguageCode)) {
      _currentLocale = Locale(systemLanguageCode);
      // Save the auto-detected language
      await prefs.setString(_languageKey, systemLanguageCode);
    } else {
      // Fallback to English
      _currentLocale = const Locale('en');
      await prefs.setString(_languageKey, 'en');
    }
  }

  /// Change the app language
  Future<void> changeLanguage(String languageCode) async {
    if (!supportedLanguages.containsKey(languageCode)) {
      return;
    }

    _currentLocale = Locale(languageCode);
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    
    notifyListeners();
  }

  /// Get the native name for a language code
  static String getNativeName(String languageCode) {
    return supportedLanguages[languageCode]?['nativeName'] ?? 'Unknown';
  }

  /// Get the flag emoji for a language code
  static String getFlag(String languageCode) {
    return supportedLanguages[languageCode]?['flag'] ?? '🌐';
  }

  /// Check if a language uses RTL (Right-to-Left) layout
  static bool isRTL(String languageCode) {
    return languageCode == 'ar' || languageCode == 'ur';
  }

  /// Get text direction for current locale
  TextDirection get textDirection {
    return isRTL(_currentLocale.languageCode) 
        ? TextDirection.rtl 
        : TextDirection.ltr;
  }
}
