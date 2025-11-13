import 'package:flutter/material.dart';
import 'package:swipe_clean_gallery/services/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get dark => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.backgroundPrimary,
    canvasColor: AppColors.backgroundSurface,
    colorScheme: ColorScheme.dark(
      primary: AppColors.brandPrimary,
      secondary: AppColors.brandPrimary,
      background: AppColors.backgroundPrimary,
      surface: AppColors.backgroundSurface,
      error: AppColors.deleteIcon,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundPrimary,
      elevation: 0,
      foregroundColor: AppColors.textPrimary,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.dialogBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandPrimary,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.brandPrimary),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.backgroundSurface,
      contentTextStyle: TextStyle(color: AppColors.textPrimary),
      behavior: SnackBarBehavior.floating,
    ),
  );

  static ThemeData get light => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.backgroundPrimary,
    canvasColor: AppColors.backgroundSurface,
    colorScheme: ColorScheme.light(
      primary: AppColors.brandPrimary,
      secondary: AppColors.brandPrimary,
      background: AppColors.backgroundPrimary,
      surface: AppColors.backgroundSurface,
      error: AppColors.deleteIcon,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backgroundPrimary,
      elevation: 0,
      foregroundColor: AppColors.textPrimary,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.dialogBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brandPrimary,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppColors.brandPrimary),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.backgroundSurface,
      contentTextStyle: TextStyle(color: AppColors.textPrimary),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
