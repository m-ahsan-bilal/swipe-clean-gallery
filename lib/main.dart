import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:swipe_clean_gallery/screens/permission_screen.dart';
import 'package:swipe_clean_gallery/services/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the Mobile Ads SDK
  await MobileAds.instance.initialize();

  // 👇 Add your device as a test device
  RequestConfiguration configuration = RequestConfiguration(
    testDeviceIds: ['E4AFC181484798EFEE831B49363CA387'], // <-- your ID
  );
  MobileAds.instance.updateRequestConfiguration(configuration);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Swipe Clean Gallery',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundPrimary,
        canvasColor: AppColors.backgroundPrimary,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.brandPrimary,
          brightness: Brightness.dark,
          primary: AppColors.brandPrimary,
          surface: AppColors.backgroundSurface,
          background: AppColors.backgroundPrimary,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.backgroundPrimary,
          elevation: 0,
          foregroundColor: AppColors.textPrimary,
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: AppColors.dialogBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          contentTextStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColors.textSecondary),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.brandPrimary,
            foregroundColor: AppColors.textPrimary,
            shape: const StadiumBorder(),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: AppColors.backgroundSurface,
          contentTextStyle: TextStyle(color: AppColors.textPrimary),
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const PermissionScreen(),
    );
  }
}
