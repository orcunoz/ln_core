import 'package:flutter/material.dart' hide BottomSheet;

class BottomSheet extends StatelessWidget {
  const BottomSheet({
    super.key,
    this.animationDuration = const Duration(milliseconds: 500),
    this.animationCurve = Curves.ease,
    this.open = false,
    required this.child,
  });

  final Curve animationCurve;
  final Duration animationDuration;
  final bool open;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      offset: open ? Offset.zero : const Offset(0, 1.1),
      duration: animationDuration,
      curve: animationCurve,
      child: child,
    );
  }
}
