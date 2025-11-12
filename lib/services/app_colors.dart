import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static Brightness _brightness = Brightness.dark;

  static bool get _isDark => _brightness == Brightness.dark;

  static void update(Brightness brightness) {
    _brightness = brightness;
  }

  static Color get backgroundPrimary =>
      _isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF7F7F9);

  static Color get backgroundSurface =>
      _isDark ? const Color(0xFF1C1C1E) : const Color(0xFFFFFFFF);

  static Color get dialogBackground =>
      _isDark ? const Color(0xFF1A1F24) : const Color(0xFFFFFFFF);

  static Color get overlay =>
      _isDark ? const Color(0xCC000000) : const Color(0x33000000);

  static Color get overlayLight =>
      _isDark ? const Color(0x4D000000) : const Color(0x1A000000);

  static Color get textPrimary =>
      _isDark ? const Color(0xFFFFFFFF) : const Color(0xFF0B0B0B);

  static Color get textSecondary =>
      _isDark ? const Color(0xFF8E8E93) : const Color(0xFF5B5B65);

  static Color get textTertiary =>
      _isDark ? const Color(0xFF636366) : const Color(0xFF8F8F95);

  static Color get textDisabled =>
      _isDark ? const Color(0xFF48484A) : const Color(0xFFB2B2B4);

  static Color get brandPrimary => const Color(0xFF2E68E4);

  static Color get deleteIcon =>
      _isDark ? const Color(0xFFFF453A) : const Color(0xFFDA362B);

  // Legacy fallbacks for light palette usage
  static Color get backgroundLight => const Color(0xFFFFFFFF);
  static Color get surfaceLight => const Color(0xFFF2F2F7);
  static Color get textLight => const Color(0xFF000000);
  static Color get textSecondaryLight => const Color(0xFF6C6C70);
}
