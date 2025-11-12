// ignore_for_file: deprecated_member_use

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipe_clean_gallery/l10n/app_localizations.dart';
import 'package:swipe_clean_gallery/screens/permission_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _loopController;
  int _currentPage = 0;
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loopController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _loopController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    if (_isCompleting) return;
    setState(() => _isCompleting = true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PermissionScreen()),
    );
  }

  void _goToNext() {
    final totalPages = _buildEntries(AppLocalizations.of(context)!).length;
    if (_currentPage >= totalPages - 1) {
      _completeOnboarding();
      return;
    }
    _pageController.animateToPage(
      _currentPage + 1,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  List<_OnboardingEntry> _buildEntries(AppLocalizations l10n) => [
    _OnboardingEntry(
      title: l10n.onboardingWelcomeTitle,
      subtitle: l10n.onboardingWelcomeSubtitle,
      builder: (context, progress) => _WelcomeIllustration(progress: progress),
    ),
    _OnboardingEntry(
      title: l10n.onboardingSwipeTitle,
      subtitle: l10n.onboardingSwipeSubtitle,
      builder: (context, progress) => _SwipeIllustration(progress: progress),
    ),
    _OnboardingEntry(
      title: l10n.onboardingDeleteTitle,
      subtitle: l10n.onboardingDeleteSubtitle,
      builder: (context, progress) => _DeleteIllustration(progress: progress),
    ),
    _OnboardingEntry(
      title: l10n.onboardingOrganizeTitle,
      subtitle: l10n.onboardingOrganizeSubtitle,
      builder: (context, progress) => _OrganizeIllustration(progress: progress),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final pages = _buildEntries(l10n);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _currentPage == pages.length - 1
                    ? null
                    : _completeOnboarding,
                child: Text(
                  l10n.onboardingSkip,
                  style: TextStyle(
                    color: _currentPage == pages.length - 1
                        ? colorScheme.onSurface.withOpacity(0.4)
                        : colorScheme.primary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final entry = pages[index];
                  return _OnboardingPage(
                    title: entry.title,
                    subtitle: entry.subtitle,
                    visual: AnimatedBuilder(
                      animation: _loopController,
                      builder: (context, child) {
                        final wave =
                            math.sin(_loopController.value * math.pi * 2) *
                                0.5 +
                            0.5;
                        final progress = Curves.easeInOut.transform(wave);
                        return entry.builder(context, progress);
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            _OnboardingIndicator(
              count: pages.length,
              current: _currentPage,
              color: colorScheme.primary,
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isCompleting ? null : _goToNext,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const StadiumBorder(),
                  ),
                  child: Text(
                    _currentPage == pages.length - 1
                        ? l10n.onboardingDone
                        : l10n.onboardingNext,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingEntry {
  _OnboardingEntry({
    required this.title,
    required this.subtitle,
    required this.builder,
  });

  final String title;
  final String subtitle;
  final Widget Function(BuildContext context, double progress) builder;
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.visual,
  });

  final String title;
  final String subtitle;
  final Widget visual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headlineStyle = theme.textTheme.headlineSmall;
    final bodyStyle = theme.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Expanded(child: visual),
          const SizedBox(height: 24),
          Text(
            title,
            textAlign: TextAlign.center,
            style: (headlineStyle ?? const TextStyle()).copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: (bodyStyle ?? const TextStyle()).copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _OnboardingIndicator extends StatelessWidget {
  const _OnboardingIndicator({
    required this.count,
    required this.current,
    required this.color,
  });

  final int count;
  final int current;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 10,
          width: isActive ? 28 : 10,
          decoration: BoxDecoration(
            color: isActive ? color : color.withOpacity(0.25),
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }
}

class _WelcomeIllustration extends StatelessWidget {
  const _WelcomeIllustration({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accent = colorScheme.primary;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final cardWidth = maxWidth * 0.6;
        final cardHeight = cardWidth * 1.25;

        return Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: cardWidth * 1.3,
            height: cardHeight * 1.3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Background card 1
                Positioned(
                  bottom: -20,
                  child: _StackedCard(
                    width: cardWidth * 0.94,
                    height: cardHeight,
                    color: accent.withOpacity(0.3),
                    offset: 0,
                  ),
                ),
                // Background card 2
                Positioned(
                  bottom: -10,
                  child: _StackedCard(
                    width: cardWidth * 0.97,
                    height: cardHeight,
                    color: accent.withOpacity(0.5),
                    offset: -5,
                  ),
                ),
                // Main floating card
                Transform.translate(
                  offset: Offset(0, math.sin(progress * math.pi * 2) * 15),
                  child: _GalleryCard(
                    width: cardWidth,
                    height: cardHeight,
                    color: accent,
                    highlight: colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SwipeIllustration extends StatelessWidget {
  const _SwipeIllustration({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final cardWidth = width * 0.6;
        final cardHeight = cardWidth * 1.25;
        final wave = math.sin(progress * math.pi * 2);
        final swipeOffset = wave * width * 0.15;
        final rotation = wave * 0.1;

        return SizedBox(
          width: width,
          height: cardHeight * 1.4,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background stacked cards
              Positioned(
                bottom: 20,
                child: _StackedCard(
                  width: cardWidth * 0.94,
                  height: cardHeight,
                  color: colorScheme.primary.withOpacity(0.3),
                  offset: 0,
                ),
              ),
              Positioned(
                bottom: 35,
                child: _StackedCard(
                  width: cardWidth * 0.97,
                  height: cardHeight,
                  color: colorScheme.primary.withOpacity(0.5),
                  offset: -5,
                ),
              ),
              // Main swiping card
              Positioned(
                bottom: 50,
                child: Transform.translate(
                  offset: Offset(swipeOffset, 0),
                  child: Transform.rotate(
                    angle: rotation,
                    child: _GalleryCard(
                      width: cardWidth,
                      height: cardHeight,
                      color: colorScheme.primary,
                      highlight: colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              // Swipe indicator
              Positioned(
                bottom: 0,
                child: Opacity(
                  opacity: 0.6 + (wave.abs() * 0.3),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: colorScheme.onSurface.withOpacity(
                          wave < 0 ? 0.6 : 0.2,
                        ),
                        size: 32,
                      ),
                      const SizedBox(width: 40),
                      Icon(
                        Icons.arrow_forward,
                        color: colorScheme.onSurface.withOpacity(
                          wave > 0 ? 0.6 : 0.2,
                        ),
                        size: 32,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DeleteIllustration extends StatelessWidget {
  const _DeleteIllustration({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final curve = Curves.easeInOutCubic.transform(progress);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final cardWidth = width * 0.5;
        final cardHeight = cardWidth * 1.25;
        final binSize = 56.0;

        // Upward swipe animation
        final swipeOffset = -curve * 120;
        final cardScale = 1.0 - (curve * 0.2);
        final cardOpacity = 1.0 - curve;
        final binScale = 0.95 + (curve * 0.15);

        return SizedBox(
          width: width,
          height: constraints.maxHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Bin button at top (matching app layout)
              Transform.scale(
                scale: binScale,
                child: Container(
                  width: binSize,
                  height: binSize,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Icon(
                    curve > 0.5 ? Icons.delete : Icons.delete_outline,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Stacked cards below (matching app layout)
              SizedBox(
                width: cardWidth * 1.2,
                height: cardHeight * 1.2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background stack card 1
                    Positioned(
                      bottom: -30,
                      child: _StackedCard(
                        width: cardWidth * 0.94,
                        height: cardHeight,
                        color: colorScheme.secondary.withOpacity(0.3),
                        offset: 0,
                      ),
                    ),
                    // Background stack card 2
                    Positioned(
                      bottom: -15,
                      child: _StackedCard(
                        width: cardWidth * 0.97,
                        height: cardHeight,
                        color: colorScheme.secondary.withOpacity(0.5),
                        offset: -5,
                      ),
                    ),
                    // Main card swiping up
                    Transform.translate(
                      offset: Offset(0, swipeOffset),
                      child: Transform.scale(
                        scale: cardScale,
                        child: Opacity(
                          opacity: cardOpacity,
                          child: _GalleryCard(
                            width: cardWidth,
                            height: cardHeight,
                            color: colorScheme.secondary,
                            highlight: colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrganizeIllustration extends StatelessWidget {
  const _OrganizeIllustration({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final scale = 0.95 + (math.sin(progress * math.pi * 2) * 0.05);
    final glow = (math.sin(progress * math.pi * 2) * 0.4).abs() + 0.3;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final binSize = width * 0.35;

        return SizedBox(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(
                scale: scale,
                child: Container(
                  width: binSize,
                  height: binSize,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(glow * 0.4),
                        blurRadius: 28,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.delete,
                    color: colorScheme.primary,
                    size: binSize * 0.55,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Opacity(
                opacity: glow,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    final delay = index / 3;
                    final sparkProgress =
                        (progress + delay) % 1.0; // loop within 0..1
                    final sparkOpacity =
                        1 - Curves.easeOut.transform(sparkProgress);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Transform.translate(
                        offset: Offset(0, -sparkProgress * 30),
                        child: Opacity(
                          opacity: sparkOpacity.clamp(0.0, 1.0),
                          child: Icon(
                            Icons.star_rounded,
                            color: colorScheme.primary,
                            size: 18 + (sparkProgress * 6),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _StackedCard extends StatelessWidget {
  const _StackedCard({
    required this.width,
    required this.height,
    required this.color,
    required this.offset,
  });

  final double width;
  final double height;
  final Color color;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.8), color.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
    );
  }
}

class _GalleryCard extends StatelessWidget {
  const _GalleryCard({
    required this.width,
    required this.height,
    required this.color,
    required this.highlight,
  });

  final double width;
  final double height;
  final Color color;
  final Color highlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.95), color.withOpacity(0.85)],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            // Gradient overlay for depth
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.transparent,
                    Colors.black.withOpacity(0.2),
                  ],
                ),
              ),
            ),
            // Icon indicators
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.photo_library_outlined,
                    color: highlight.withOpacity(0.8),
                    size: 28,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.image,
                        color: highlight.withOpacity(0.6),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 32,
                        height: 4,
                        decoration: BoxDecoration(
                          color: highlight.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
