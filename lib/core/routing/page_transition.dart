// page_transitions.dart
import 'package:flutter/material.dart';

class PageTransitions {
  static Route modernSlideTransition({
    required WidgetBuilder builder,
    required RouteSettings settings,
    Duration duration = const Duration(milliseconds: 600), // Increased duration
  }) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Using smoother, more natural curves
        const curve = Curves.easeInOutCubic;
        const reverseCurve = Curves.easeInOutCubic;

        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
          reverseCurve: reverseCurve,
        );

        // Gentler slide animation
        final slideAnimation = Tween<Offset>(
          begin: const Offset(1.0, 0.0), // Start from right
          end: Offset.zero, // End at center
        ).animate(curvedAnimation);

        // Reduced secondary slide distance for subtlety
        final secondarySlideAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(-0.15, 0.0), // Reduced from -0.3 to -0.15
        ).animate(CurvedAnimation(
          parent: secondaryAnimation,
          curve: curve,
        ));

        // Smoother fade with extended duration
        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.5,
              curve: Curves.easeOut), // Extended from 0.3 to 0.5
        ));

        // Gentler scale animation
        final scaleAnimation = Tween<double>(
          begin: 0.98, // Reduced from 0.95 to 0.98 for subtlety
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.7,
              curve: Curves.easeOutQuart), // Extended and smoother curve
        ));

        return Stack(
          children: [
            if (secondaryAnimation.status != AnimationStatus.dismissed)
              SlideTransition(
                position: secondarySlideAnimation,
                child: Container(
                  color: Colors.black
                      .withOpacity(0.05), // Reduced opacity for subtlety
                ),
              ),
            SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: Material(
                    elevation: 4.0, // Reduced elevation for less visual noise
                    shadowColor:
                        Colors.black.withOpacity(0.15), // Softer shadow
                    child: child,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Alternative: Even smoother minimal transition
  static Route ultraSmoothTransition({
    required WidgetBuilder builder,
    required RouteSettings settings,
    Duration duration = const Duration(milliseconds: 800),
  }) {
    return PageRouteBuilder(
      settings: settings,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutQuart,
          reverseCurve: Curves.easeInOutQuart,
        );

        // Simple slide with no scale or complex effects
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0.3, 0.0), // Shorter slide distance
          end: Offset.zero,
        ).animate(curvedAnimation);

        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
        ));

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }
}
