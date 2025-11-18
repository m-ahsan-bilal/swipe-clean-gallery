// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:swipe_clean_gallery/screens/splash_screen.dart';
import 'package:swipe_clean_gallery/services/app_colors.dart';
import 'package:swipe_clean_gallery/services/localization_service.dart';
import 'package:swipe_clean_gallery/services/theme_service.dart';
import 'package:swipe_clean_gallery/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling
  try {
    await Firebase.initializeApp();
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
    // Continue app execution even if Firebase fails
  }

  // Initialize the Mobile Ads SDK
  try {
    await MobileAds.instance.initialize();

    // Add your device as a test device
    RequestConfiguration configuration = RequestConfiguration(
      testDeviceIds: ['E4AFC181484798EFEE831B49363CA387'],
    );
    MobileAds.instance.updateRequestConfiguration(configuration);
  } catch (e) {
    debugPrint('Ads initialization error: $e');
    // Continue app execution even if ads fail
  }

  // Initialize services
  final localizationService = LocalizationService();
  await localizationService.loadSavedLanguage();

  final themeService = ThemeService();
  await themeService.loadTheme();

  runApp(
    MyApp(localizationService: localizationService, themeService: themeService),
  );
}

class MyApp extends StatelessWidget {
  final LocalizationService localizationService;
  final ThemeService themeService;

  const MyApp({
    super.key,
    required this.localizationService,
    required this.themeService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: localizationService),
        ChangeNotifierProvider.value(value: themeService),
      ],
      child: Consumer2<LocalizationService, ThemeService>(
        builder: (context, locService, themeService, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Swipe Clean Gallery',

            // Localization delegates
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // Supported locales
            supportedLocales: LocalizationService.supportedLocales,

            // Current locale
            locale: locService.currentLocale,

            // Theme mode
            themeMode: themeService.themeMode,

            // Light theme
            theme: ThemeData(
              brightness: Brightness.light,
              scaffoldBackgroundColor: const Color(0xFFF7F7F9),
              canvasColor: const Color(0xFFF7F7F9),
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF2E68E4),
                brightness: Brightness.light,
                primary: const Color(0xFF2E68E4),
                surface: const Color(0xFFFFFFFF),
                background: const Color(0xFFF7F7F9),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFFF7F7F9),
                elevation: 0,
                foregroundColor: Color(0xFF0B0B0B),
              ),
              dialogTheme: const DialogThemeData(
                backgroundColor: Color(0xFFFFFFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                titleTextStyle: TextStyle(
                  color: Color(0xFF0B0B0B),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                contentTextStyle: TextStyle(
                  color: Color(0xFF5B5B65),
                  fontSize: 14,
                ),
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF2E68E4),
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E68E4),
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
              ),
              snackBarTheme: const SnackBarThemeData(
                backgroundColor: Color(0xFFFFFFFF),
                contentTextStyle: TextStyle(color: Color(0xFF0B0B0B)),
                behavior: SnackBarBehavior.floating,
              ),
            ),

            // Dark theme
            darkTheme: ThemeData(
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
              appBarTheme: AppBarTheme(
                backgroundColor: AppColors.backgroundPrimary,
                elevation: 0,
                foregroundColor: AppColors.textPrimary,
              ),
              dialogTheme: DialogThemeData(
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
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textSecondary,
                ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandPrimary,
                  foregroundColor: AppColors.textPrimary,
                  shape: const StadiumBorder(),
                ),
              ),
              snackBarTheme: SnackBarThemeData(
                backgroundColor: AppColors.backgroundSurface,
                contentTextStyle: TextStyle(color: AppColors.textPrimary),
                behavior: SnackBarBehavior.floating,
              ),
            ),

            // Routes
            routes: {'/splash': (context) => const SplashScreen()},

            // Home - auto-detect language and navigate
            home: const AppInitializer(),
          );
        },
      ),
    );
  }
}

/// Widget to handle app initialization
class AppInitializer extends StatefulWidget {
  const AppInitializer({super.key});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  @override
  void initState() {
    super.initState();
    // Navigate after first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Navigate directly to splash screen
        // Language is already auto-detected from system or loaded from preferences
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SplashScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while initializing
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.brandPrimary),
      ),
    );
  }
}
