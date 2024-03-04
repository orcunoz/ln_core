import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

class AnimatedSlideShrink extends ImplicitlyAnimatedWidget {
  const AnimatedSlideShrink({
    super.key,
    required this.shrinked,
    required this.slideDirection,
    super.duration = const Duration(milliseconds: 300),
    super.curve = Curves.easeInOut,
    this.child,
  });

  final bool shrinked;
  final AxisDirection slideDirection;
  final Widget? child;

  @override
  ImplicitlyAnimatedWidgetState<AnimatedSlideShrink> createState() =>
      _AnimatedSlideShrinkState();
}

class _AnimatedSlideShrinkState
    extends ImplicitlyAnimatedWidgetState<AnimatedSlideShrink> {
  Size? _measuredSize;
  Tween<double>? _shrinkTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _shrinkTween = visitor(
      _shrinkTween,
      widget.shrinked ? .0 : 1.0,
      (value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  double? get _transition => _shrinkTween?.evaluate(animation);

  Size? get _animatedSize {
    final transition = _transition;
    final size = _measuredSize;
    return size == null || transition == null
        ? null
        : switch (widget.slideDirection) {
            AxisDirection.left ||
            AxisDirection.right =>
              Size.fromWidth(size.width * transition),
            AxisDirection.up ||
            AxisDirection.down =>
              Size.fromHeight(size.height * transition),
          };
  }

  Axis get constrainedAxis => switch (widget.slideDirection) {
        AxisDirection.up || AxisDirection.down => Axis.horizontal,
        AxisDirection.left || AxisDirection.right => Axis.vertical,
      };

  Alignment get alignment => switch (widget.slideDirection) {
        AxisDirection.left => Alignment.centerRight,
        AxisDirection.up => Alignment.bottomCenter,
        AxisDirection.right => Alignment.centerLeft,
        AxisDirection.down => Alignment.topCenter,
      };

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) => SizedBox.fromSize(
        size: _animatedSize,
        child: child,
      ),
      child: UnconstrainedBox(
        clipBehavior: Clip.hardEdge,
        alignment: alignment,
        constrainedAxis: constrainedAxis,
        child: Measurable(
          computedSize: _measuredSize,
          onLayout: (size) => LnSchedulerCallbacks.endOfFrame(
            () => setState(() {
              _measuredSize = size;
            }),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
