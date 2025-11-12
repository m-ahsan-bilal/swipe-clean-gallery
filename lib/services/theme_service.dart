import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_clean_gallery/services/app_colors.dart';

class ThemeService extends ChangeNotifier {
  static const _themeKey = 'theme_mode';

  ThemeMode _themeMode = ThemeMode.dark;
  ThemeMode get themeMode => _themeMode;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_themeKey);
    switch (stored) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'system':
        _themeMode = ThemeMode.system;
        break;
      case 'dark':
      default:
        _themeMode = ThemeMode.dark;
    }

    _syncAppColors();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
    _syncAppColors();
    notifyListeners();
  }

  void toggleDarkMode(bool enabled) {
    updateThemeMode(enabled ? ThemeMode.dark : ThemeMode.light);
  }

  void _syncAppColors() {
    final brightness = switch (_themeMode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system =>
        WidgetsBinding.instance.platformDispatcher.platformBrightness,
    };
    AppColors.update(brightness);
  }
}


