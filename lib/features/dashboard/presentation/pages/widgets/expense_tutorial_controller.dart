import 'package:flutter/material.dart';
import 'package:inovola_task/core/constants/app_dimens.dart';

class ExpenseTutorialController {
  AnimationController? _tutorialController;
  Animation<Offset>? _slideAnimation;
  Animation<double>? _backgroundOpacityAnimation;
  bool _hasShownTutorial = false;
  final VoidCallback onTutorialComplete;

  ExpenseTutorialController({
    required this.onTutorialComplete,
  });

  void initialize(TickerProvider vsync) {
    _tutorialController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: vsync,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.3, 0),
    ).animate(CurvedAnimation(
      parent: _tutorialController!,
      curve: Curves.easeInOut,
    ));

    _backgroundOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _tutorialController!,
      curve: Curves.easeInOut,
    ));
  }

  void showTutorialIfNeeded({
    required bool hasExpenses,
    required bool wasEmpty,
  }) {
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
    if (_tutorialController == null) return;

    Future.delayed(const Duration(milliseconds: 800), () {
      _tutorialController?.forward().then((_) {
        Future.delayed(const Duration(milliseconds: 500), () {
          _tutorialController?.reverse().then((_) {
            onTutorialComplete();
          });
        });
      });
    });
  }

  Widget wrapWithTutorial({
    required bool isFirstItem,
    required Widget child,
  }) {
    if (!isFirstItem ||
        _slideAnimation == null ||
        _backgroundOpacityAnimation == null) {
      return child;
    }

    return Stack(
      children: [
        // Animated delete background for tutorial
        AnimatedBuilder(
          animation: _backgroundOpacityAnimation!,
          builder: (context, child) {
            return Opacity(
              opacity: _backgroundOpacityAnimation!.value,
              child: _buildTutorialBackground(),
            );
          },
        ),
        // Sliding expense item
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
    _tutorialController?.dispose();
  }
}
