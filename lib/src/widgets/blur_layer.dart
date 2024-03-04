import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math' as math;

const _kBlurSigmaX = 5;
const _kBlurSigmaY = 8;

class BlurryLayer extends StatelessWidget {
  const BlurryLayer({
    super.key,
    this.effectFactor = .2,
    this.alignment = Alignment.center,
    this.child,
  }) : assert(effectFactor >= 0 && effectFactor <= 1);

  final double effectFactor;
  final Widget? child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: _kBlurSigmaX * effectFactor,
        sigmaY: _kBlurSigmaY * effectFactor,
      ),
      child: Align(
        alignment: alignment,
        child: child,
      ),
    );
  }
}

class AnimatedBlurryLayer extends ImplicitlyAnimatedWidget {
  const AnimatedBlurryLayer({
    super.key,
    this.enabled = true,
    this.sharpClarity = true,
    this.effectFactor = .2,
    this.alignment = Alignment.center,
    super.duration = const Duration(milliseconds: 500),
    this.child,
  }) : assert(effectFactor >= 0 && effectFactor <= 1);

  final bool enabled;
  final bool sharpClarity;
  final double effectFactor;
  final Alignment alignment;
  final Widget? child;

  @override
  ImplicitlyAnimatedWidgetState<AnimatedBlurryLayer> createState() =>
      _AnimatedBlurLayerState();
}

class _AnimatedBlurLayerState
    extends AnimatedWidgetBaseState<AnimatedBlurryLayer> {
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
    return BlurryLayer(
      alignment: widget.alignment,
      effectFactor:
          instantTransition ? 0 : _animation.value * widget.effectFactor,
      child: Opacity(
        opacity: math.min(_animation.value * 2, 1.0),
        child: widget.child,
      ),
    );
  }
}
