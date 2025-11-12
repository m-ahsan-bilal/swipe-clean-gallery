// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:swipe_clean_gallery/services/app_colors.dart';
import 'package:swipe_clean_gallery/services/localization_service.dart';
import 'package:swipe_clean_gallery/l10n/app_localizations.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedLanguage;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onLanguageSelected(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  Future<void> _onContinue() async {
    if (_selectedLanguage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a language'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final localizationService = Provider.of<LocalizationService>(
      context,
      listen: false,
    );
    await localizationService.changeLanguage(_selectedLanguage!);
    await localizationService.setFirstLaunchComplete();

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/splash');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topCenter,
                radius: 1.5,
                colors: [
                  AppColors.brandPrimary.withOpacity(0.1),
                  AppColors.backgroundPrimary,
                  AppColors.backgroundPrimary,
                ],
              ),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      // Language icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.brandPrimary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.brandPrimary.withOpacity(0.2),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.language,
                          size: 40,
                          color: AppColors.brandPrimary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Title
                      Text(
                        l10n.languageSelectionTitle,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      // Subtitle
                      Text(
                        l10n.languageSelectionSubtitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                          letterSpacing: 0.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                // Language list
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      itemCount: LocalizationService.supportedLanguages.length,
                      itemBuilder: (context, index) {
                        final entry = LocalizationService
                            .supportedLanguages
                            .entries
                            .toList()[index];
                        final languageCode = entry.key;
                        final languageData = entry.value;
                        final isSelected = _selectedLanguage == languageCode;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => _onLanguageSelected(languageCode),
                              borderRadius: BorderRadius.circular(16),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.brandPrimary.withOpacity(0.15)
                                      : AppColors.backgroundSurface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.brandPrimary
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                  boxShadow: isSelected
                                      ? [
                                          BoxShadow(
                                            color: AppColors.brandPrimary
                                                .withOpacity(0.3),
                                            blurRadius: 12,
                                            spreadRadius: 0,
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Row(
                                  children: [
                                    // Flag
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.backgroundPrimary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          languageData['flag'] ?? '🌐',
                                          style: const TextStyle(fontSize: 28),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    // Language name
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            languageData['nativeName'] ?? '',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: isSelected
                                                  ? AppColors.brandPrimary
                                                  : AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            languageData['name'] ?? '',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Selection indicator
                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 200,
                                      ),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: isSelected
                                            ? AppColors.brandPrimary
                                            : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected
                                              ? AppColors.brandPrimary
                                              : AppColors.textTertiary,
                                          width: 2,
                                        ),
                                      ),
                                      child: isSelected
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                              size: 16,
                                            )
                                          : null,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // Continue button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _selectedLanguage != null ? _onContinue : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandPrimary,
                        disabledBackgroundColor: AppColors.textDisabled,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: _selectedLanguage != null ? 4 : 0,
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
