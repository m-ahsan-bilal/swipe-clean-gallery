// import 'package:flutter/material.dart';
// import 'package:swipe_clean_gallery/services/app_colors.dart';

// class SplashScreen extends StatefulWidget {
//   final VoidCallback onComplete;

//   const SplashScreen({super.key, required this.onComplete});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with TickerProviderStateMixin {
//   late AnimationController _fadeController;
//   late AnimationController _swipeController;
//   late AnimationController _scaleController;

//   late Animation<double> _fadeAnimation;
//   late Animation<Offset> _swipeAnimation;
//   late Animation<double> _scaleAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _fadeController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _swipeController = AnimationController(
//       duration: const Duration(milliseconds: 1200),
//       vsync: this,
//     );

//     _scaleController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );

//     _fadeAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

//     _swipeAnimation =
//         Tween<Offset>(begin: Offset.zero, end: const Offset(0, -3)).animate(
//           CurvedAnimation(parent: _swipeController, curve: Curves.easeInOut),
//         );

//     _scaleAnimation = Tween<double>(
//       begin: 1.0,
//       end: 0.5,
//     ).animate(CurvedAnimation(parent: _scaleController, curve: Curves.easeIn));

//     _startAnimationSequence();
//   }

//   Future<void> _startAnimationSequence() async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     await _fadeController.forward();

//     await Future.delayed(const Duration(milliseconds: 400));
//     _swipeController.repeat(reverse: true);

//     await Future.delayed(const Duration(milliseconds: 2400));
//     _swipeController.stop();

//     await _scaleController.forward();

//     widget.onComplete();
//   }

//   @override
//   void dispose() {
//     _fadeController.dispose();
//     _swipeController.dispose();
//     _scaleController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundSurface,
//       body: AnimatedBuilder(
//         animation: Listenable.merge([
//           _fadeAnimation,
//           _swipeAnimation,
//           _scaleAnimation,
//         ]),
//         builder: (context, child) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Spacer(),

//                 // App Icon with swipe animation
//                 Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     // Background glow
//                     Container(
//                       width: 140,
//                       height: 140,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: RadialGradient(
//                           colors: [
//                             Colors.amber.withOpacity(0.3),
//                             Colors.transparent,
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Animated photo card
//                     SlideTransition(
//                       position: _swipeAnimation,
//                       child: Transform.scale(
//                         scale: _scaleAnimation.value,
//                         child: Opacity(
//                           opacity: 1.0 - (_swipeAnimation.value.dy.abs() / 3),
//                           child: Container(
//                             width: 100,
//                             height: 100,
//                             decoration: BoxDecoration(
//                               color: AppColors.backgroundSurface,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.3),
//                                   blurRadius: 20,
//                                   spreadRadius: 2,
//                                 ),
//                               ],
//                             ),
//                             child: Icon(
//                               Icons.image_outlined,
//                               size: 50,
//                               color: AppColors.textSecondary.withOpacity(0.5),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     // Upward arrow indicator
//                     if (_swipeController.isAnimating)
//                       Positioned(
//                         bottom: 0,
//                         child: Icon(
//                           Icons.arrow_upward_rounded,
//                           color: Colors.amber.withOpacity(0.7),
//                           size: 32,
//                         ),
//                       ),
//                   ],
//                 ),

//                 const SizedBox(height: 60),

//                 // App name
//                 FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: const Text(
//                     'Swipe Clean',
//                     style: TextStyle(
//                       fontSize: 36,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.textPrimary,
//                       letterSpacing: 1.2,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 8),

//                 // Tagline
//                 FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Text(
//                     'Gallery with Simplicity',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: AppColors.textSecondary.withOpacity(0.8),
//                       letterSpacing: 0.5,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: 40),

//                 // Swipe gesture hint
//                 if (_swipeController.isAnimating)
//                   FadeTransition(
//                     opacity: _fadeAnimation,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.swipe_up_rounded,
//                           color: Colors.amber.withOpacity(0.7),
//                           size: 20,
//                         ),
//                         const SizedBox(width: 8),
//                         Text(
//                           'Swipe up to delete',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: AppColors.textSecondary.withOpacity(0.7),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                 const Spacer(),

//                 // Loading indicator
//                 FadeTransition(
//                   opacity: _fadeAnimation,
//                   child: Padding(
//                     padding: const EdgeInsets.only(bottom: 50),
//                     child: SizedBox(
//                       width: 30,
//                       height: 30,
//                       child: CircularProgressIndicator(
//                         strokeWidth: 3,
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                           Colors.amber.withOpacity(0.2),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:swipe_clean_gallery/services/app_colors.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const SplashScreen({super.key, required this.onComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _swipeController;
  late AnimationController _scaleController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _swipeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    // Simulates a smooth hand drag upward with elastic ease
    _swipeAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -2.4)).animate(
          CurvedAnimation(
            parent: _swipeController,
            curve: Curves.easeInOutBack,
          ),
        );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    await _fadeController.forward();

    await Future.delayed(const Duration(milliseconds: 400));
    _swipeController.repeat(reverse: true);

    await Future.delayed(const Duration(milliseconds: 3000));
    _swipeController.stop();

    await _scaleController.forward();

    widget.onComplete();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _swipeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSurface,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _fadeController,
          _swipeController,
          _scaleController,
        ]),
        builder: (context, child) {
          final glowIntensity = (0.4 + 0.3 * _swipeController.value).clamp(
            0.4,
            0.7,
          );

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // App Icon with enhanced blue glow & hand-like swipe animation
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Blue glow pulse
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF0A8AFF).withOpacity(glowIntensity),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    // Animated photo card
                    SlideTransition(
                      position: _swipeAnimation,
                      child: Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Opacity(
                          opacity:
                              (1.0 - (_swipeAnimation.value.dy.abs() / 2.5))
                                  .clamp(0.0, 1.0),
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: const Color(0xFF10161B),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF0A8AFF,
                                  ).withOpacity(0.35 + glowIntensity * 0.2),
                                  blurRadius: 25,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.image_outlined,
                              size: 56,
                              color: Colors.white.withOpacity(0.65),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Soft upward arrow indicator
                    if (_swipeController.isAnimating)
                      Positioned(
                        bottom: -8,
                        child: Icon(
                          Icons.arrow_upward_rounded,
                          color: const Color(0xFF0A8AFF).withOpacity(0.8),
                          size: 34,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 60),

                // App name
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    'Swipe Clean',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Tagline
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Gallery, the effortless way',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textSecondary.withOpacity(0.85),
                      letterSpacing: 0.6,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Swipe hint
                if (_swipeController.isAnimating)
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.swipe_up_rounded,
                          color: const Color(0xFF0A8AFF).withOpacity(0.7),
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Swipe up to delete',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary.withOpacity(0.7),
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                const Spacer(),

                // Blue loading indicator
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          const Color(0xFF0A8AFF).withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
