import 'package:flutter/material.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';

class ExpenseTutorialController {
  AnimationController? _tutorialController;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _backgroundOpacityAnimation;

  bool _hasShownTutorial = false;
  bool _disposed = false;

  final VoidCallback onTutorialComplete;

  ExpenseTutorialController({required this.onTutorialComplete});

  void initialize(TickerProvider vsync) {
    _tutorialController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    );

    final curved = CurvedAnimation(
      parent: _tutorialController!,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.3, 0),
    ).animate(curved);

    _backgroundOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(curved);
  }

  /// Public API you call after the list updates.
  void showTutorialIfNeeded({
    required bool hasExpenses,
    required bool wasEmpty,
  }) {
    if (_disposed) return;

    if (hasExpenses) {
      if (!_hasShownTutorial || wasEmpty) {
        _hasShownTutorial = true;
        _startTutorialAnimation();
      }
    } else {
      _hasShownTutorial = false;
    }
  }

  void _startTutorialAnimation() {
    if (_disposed || _tutorialController == null) return;

    // Small delay so the list is painted before animating
    Future.delayed(const Duration(milliseconds: 800), () async {
      if (_disposed || _tutorialController == null) return;

      try {
        if (_tutorialController!.isAnimating) return; // avoid overlapping
        await _tutorialController!.forward();
        if (_disposed) return;

        await Future.delayed(const Duration(milliseconds: 500));
        if (_disposed) return;

        await _tutorialController!.reverse();
        if (_disposed) return;

        onTutorialComplete();
      } catch (_) {
        // Swallow if disposed mid-flight
      }
    });
  }

  /// Wraps only the FIRST item with the tutorial visuals + slide animation.
  Widget wrapWithTutorial({
    required bool isFirstItem,
    required Widget child,
  }) {
    if (!isFirstItem ||
        _disposed ||
        _slideAnimation == null ||
        _backgroundOpacityAnimation == null) {
      return child;
    }

    return Stack(
      children: [
        // Red delete background fading in/out with the animation progress
        AnimatedBuilder(
          animation: _backgroundOpacityAnimation!,
          builder: (context, _) {
            return Opacity(
              opacity: _backgroundOpacityAnimation!.value,
              child: _buildTutorialBackground(),
            );
          },
        ),
        // Slide the list item to reveal background (tutorial effect)
        SlideTransition(
          position: _slideAnimation!,
          child: child,
        ),
      ],
    );
  }

  Widget _buildTutorialBackground() {
    return Container(
      alignment: Alignment.centerRight,
      height: 70,
      padding: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: const Icon(
        Icons.delete,
        color: Colors.white,
        size: 28,
      ),
    );
  }

  void dispose() {
    _disposed = true;
    _tutorialController?.dispose();
  }
}
