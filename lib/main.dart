import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:swipe_clean_gallery/screens/splash_screen.dart';
import 'package:swipe_clean_gallery/services/app_colors.dart';
import 'package:swipe_clean_gallery/services/localization_service.dart';
import 'package:swipe_clean_gallery/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the Mobile Ads SDK
  await MobileAds.instance.initialize();

  // 👇 Add your device as a test device
  RequestConfiguration configuration = RequestConfiguration(
    testDeviceIds: ['E4AFC181484798EFEE831B49363CA387'], // <-- your ID
  );
  MobileAds.instance.updateRequestConfiguration(configuration);

  // Initialize localization service
  final localizationService = LocalizationService();
  await localizationService.loadSavedLanguage();

  runApp(MyApp(localizationService: localizationService));
}

class MyApp extends StatelessWidget {
  final LocalizationService localizationService;

  const MyApp({super.key, required this.localizationService});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: localizationService,
      child: Consumer<LocalizationService>(
        builder: (context, locService, child) {
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

            // Theme
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
              snackBarTheme: const SnackBarThemeData(
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
    return const Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.brandPrimary),
      ),
    );
  }
}
