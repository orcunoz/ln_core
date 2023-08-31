import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

const _kBlurSigmaX = 5;
const _kBlurSigmaY = 8;

class BlurLayer extends StatelessWidget {
  final double effectFactor;
  final Widget? child;
  final Alignment alignment;
  const BlurLayer({
    super.key,
    this.effectFactor = .2,
    this.alignment = Alignment.center,
    this.child,
  }) : assert(effectFactor >= 0 && effectFactor <= 1);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: _kBlurSigmaX * effectFactor,
          sigmaY: _kBlurSigmaY * effectFactor,
        ),
        child: Align(
          alignment: alignment,
          child: child,
        ),
      ),
    );
  }
}

class AnimatedBlurLayer extends ImplicitlyAnimatedWidget {
  final bool enabled;
  final bool sharpClarity;
  final double effectFactor;
  final Widget? child;

  const AnimatedBlurLayer({
    super.key,
    this.enabled = true,
    this.sharpClarity = true,
    this.effectFactor = .2,
    super.duration = const Duration(milliseconds: 500),
    this.child,
  }) : assert(effectFactor >= 0 && effectFactor <= 1);

  @override
  ImplicitlyAnimatedWidgetState<AnimatedBlurLayer> createState() =>
      _AnimatedBlurLayerState();
}

class _AnimatedBlurLayerState
    extends ImplicitlyAnimatedWidgetState<AnimatedBlurLayer> {
  Tween<double>? _blurValue;
  late Animation<double> _animation;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    final targetValue = widget.enabled ? 1.0 : .0;
    _blurValue = visitor(
      _blurValue,
      targetValue,
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  @override
  void didUpdateTweens() {
    _animation = animation.drive(_blurValue!);
  }

  @override
  Widget build(BuildContext context) {
    final instantTransition = widget.sharpClarity && !widget.enabled;
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final animatedValue = instantTransition ? .0 : _animation.value;
        final opacity = math.min(animatedValue * 2, 1.0);

        return Offstage(
          offstage: animatedValue == 0,
          child: AbsorbPointer(
            child: BlurLayer(
              effectFactor: animatedValue * widget.effectFactor,
              child: Opacity(
                opacity: opacity,
                child: child,
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
