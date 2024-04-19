import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import 'dart:math' as math;

const kSlidingDrawersAnimationDuration = Duration(milliseconds: 300);

typedef SlideTransitionBuilder = Widget Function(
    BuildContext context, SlidingDrawerPosition position, Widget child);

class LimitedRange {
  const LimitedRange({this.min, this.max})
      : assert(min == null || max == null || min <= max,
            "min <= max': is not true ($min <= $max)");

  const LimitedRange.constant(num value) : this(min: value, max: value);

  final num? min;
  final num? max;

  @override
  String toString() => "$min < limits < $max";

  LimitedRange operator *(num operand) => LimitedRange(
        min: min == null ? null : min! * operand,
        max: max == null ? null : max! * operand,
      );

  LimitedRange operator +(LimitedRange operand) => LimitedRange(
        min: (min ?? 0) + (operand.min ?? 0),
        max: (max ?? 0) + (operand.max ?? 0),
      );

  LimitedRange operator -(LimitedRange operand) => LimitedRange(
        min: (min ?? 0) - (operand.min ?? 0),
        max: (max ?? 0) - (operand.max ?? 0),
      );

  static LimitedRange? lerp(LimitedRange? a, LimitedRange? b, double t) {
    if (t <= 0 || t >= 1 || a == null || b == null) {
      return t >= .5 ? b : a;
    } else {
      return LimitedRange(
        min: a.min == null || b.min == null
            ? (t >= .5 ? b.min : a.min)
            : lerpDouble(a.min, b.min, t)!,
        max: a.max == null || b.max == null
            ? (t >= .5 ? b.max : a.max)
            : lerpDouble(a.max, b.max, t)!,
      );
    }
  }
}

class LimitedRangeTween extends Tween<LimitedRange> {
  LimitedRangeTween({super.begin, super.end});

  /// Returns the value this variable has at the given animation clock value.
  @override
  LimitedRange lerp(double t) => LimitedRange.lerp(begin, end, t)!;
}

class ReverseSlidingDrawer extends SlidingDrawer {
  ReverseSlidingDrawer({
    super.key,
    required this.reverseOf,
    super.frameBuilder,
    required super.child,
  }) : super._reverse();

  final GlobalKey<SlidingDrawerState> reverseOf;

  @override
  State<SlidingDrawer> createState() => _ReverseSlidingDrawerState();
}

class SlidingDrawer extends StatefulWidget {
  SlidingDrawer({
    super.key,
    this.pinnedOffset,
    this.snap = true,
    this.slideLimits,
    this.heightLimits,
    int slidePriority = 1,
    required this.slideDirection,
    this.onScrollableBounds = false,
    this.frameBuilder,
    this.child,
  }) : slidePriority = pinnedOffset != null
            ? NumberUtils.maxInt
            : slidePriority >= NumberUtils.maxInt
                ? NumberUtils.maxInt - 1
                : slidePriority;

  SlidingDrawer._reverse({
    super.key,
    this.frameBuilder,
    this.child,
  })  : snap = false,
        onScrollableBounds = false,
        slideDirection = null,
        pinnedOffset = null,
        heightLimits = null,
        slideLimits = null,
        slidePriority = 1;

  final bool onScrollableBounds;
  final bool snap;
  final double? pinnedOffset;
  final LimitedRange? slideLimits;
  final LimitedRange? heightLimits;
  final int slidePriority;
  final VerticalDirection? slideDirection;
  final SlideTransitionBuilder? frameBuilder;
  final Widget? child;

  @override
  State<SlidingDrawer> createState() => _SlidingDrawerState();
}

abstract class SlidingDrawerState extends LnState<SlidingDrawer>
    implements SlidingDrawerActions {
  double slideRelativeOffset = 0;
  bool get isReverse => this is _ReverseSlidingDrawerState;

  int get priority => widget.slidePriority;
  bool get onScrollableBounds => widget.onScrollableBounds;

  final _positionNotifier = ValueNotifier<SlidingDrawerPosition>(
      SlidingDrawerPosition(visibleHeight: 0));
  Listenable get listenable => _positionNotifier;

  SlidingDrawerPosition get position => _positionNotifier.value;
  set position(SlidingDrawerPosition value) => _positionNotifier.value = value;

  void setPosition({
    SlidingDrawerBounds? bounds,
    double? visibleHeight,
    bool? slidingToForward,
    bool? atStart,
  }) {
    position = position.copyWith(
      bounds: bounds,
      visibleHeight: visibleHeight,
      slidingToForward: slidingToForward,
      atStart: atStart,
    );
  }

  Size? _measuredSize;
  SlidingDrawers? _area;

  VerticalDirection? slideDirection;

  SlidingDrawerBounds? _calculateBounds(double? measuredHeight);

  void setSlidePosition({double? slide, double? height, double? transition});

  void _recalculateBounds() {
    final previousSlide = position.slideAmount;

    setPosition(bounds: _calculateBounds(_measuredSize?.height));
    setSlidePosition(slide: previousSlide);
  }

  double handleScroll(double offset, double change) {
    if (change == 0) return 0;

    double sign = switch (widget.slideDirection!) {
      VerticalDirection.up => 1.0,
      VerticalDirection.down => -1.0,
    };

    bool slidingToForward = sign == change.sign;
    bool atStart = offset == 0;

    if (isReverse) {
      setPosition(
        atStart: atStart,
        slidingToForward: slidingToForward,
      );
      return 0;
    } else {
      final previousSlide = position.slideAmount;

      final double newSlide = widget.pinnedOffset != null
          ? (offset - slideRelativeOffset).clamp(0, double.infinity)
          : previousSlide + change * sign;

      setPosition(
        atStart: atStart,
        slidingToForward: slidingToForward,
        visibleHeight: position.bounds?.normalizedHeightOf(slide: newSlide),
      );

      return (position.slideAmount - previousSlide) * sign;
    }
  }

  void _refreshRegistration({bool force = false}) {
    final area = SlidingDrawers.of(context);
    slideDirection = isReverse
        ? ((widget as ReverseSlidingDrawer).reverseOf.currentWidget
                as SlidingDrawer?)
            ?.slideDirection
        : area.directionOf(widget) ?? widget.slideDirection;

    assert(slideDirection != null,
        "SlidingDrawer slide direction couldn't resolve");

    if (area != _area || force) {
      _area?.unregister(this);
      _area = area..register(this, slideDirection!);
    }
  }

  @override
  void afterLayout() {
    super.afterLayout();

    _recalculateBounds();
  }

  @override
  void didUpdateWidget(SlidingDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.onScrollableBounds != oldWidget.onScrollableBounds ||
        widget.slideDirection != oldWidget.slideDirection ||
        widget.slidePriority != oldWidget.slidePriority) {
      _refreshRegistration(force: true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _refreshRegistration();
  }

  @override
  void dispose() {
    _positionNotifier.dispose();

    _area?.unregister(this);
    _area = null;
    super.dispose();
  }

  Widget _buildChild() {
    return UnconstrainedBox(
      alignment: switch (slideDirection) {
        VerticalDirection.up => Alignment.bottomCenter,
        _ => Alignment.topCenter,
      },
      clipBehavior: Clip.hardEdge,
      constrainedAxis: Axis.horizontal,
      child: Measurable(
        computedSize: _measuredSize,
        onLayout: (size) {
          bool needUpdate = size.height != _measuredSize?.height;
          _measuredSize = size;
          if (needUpdate) {
            endOfFrame(_recalculateBounds);
          }
        },
        child: widget.child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: ListenableBuilder(
        listenable: listenable,
        builder: (context, child) {
          return SizedBox(
            height: position.visibleHeight,
            child:
                widget.frameBuilder?.call(context, position, child!) ?? child!,
          );
        },
        child: _buildChild(),
      ),
    );
  }

  @override
  void close({Duration? duration = kSlidingDrawersAnimationDuration}) {
    slideTo(double.infinity, duration: duration);
  }

  @override
  void open({Duration? duration = kSlidingDrawersAnimationDuration}) {
    slideTo(0, duration: duration);
  }
}

class _ReverseSlidingDrawerState extends SlidingDrawerState {
  @override
  ReverseSlidingDrawer get widget => super.widget as ReverseSlidingDrawer;
  SlidingDrawerState get reverseController => widget.reverseOf.currentState!;

  double? _convertVisibleHeightToReverse(double? height) => height == null ||
          position.bounds == null ||
          reverseController.position.bounds == null
      ? null
      : reverseController.position.maxHeight -
          (height - position.bounds!.minHeight);

  @override
  void slideTo(double value, {Duration? duration}) {
    reverseController.slideTo(
      position.slideableLength - value,
      duration: duration,
    );
  }

  void _syncReverseDrawer(SlidingDrawerState reverseDrawer) {
    reverseDrawer.listenable.addListener(_handleReverseSlide);
    _recalculateBounds();
  }

  void _unsyncReverseDrawer(SlidingDrawerState reverseDrawer) {
    reverseDrawer.listenable.addListener(_handleReverseSlide);
    _recalculateBounds();
  }

  @override
  void setSlidePosition({double? slide, double? height, double? transition}) {
    final visibleHeight = position.bounds?.normalizedHeightOf(
      slide: slide,
      height: height,
      transition: transition,
    );

    final reverseHeight = _convertVisibleHeightToReverse(visibleHeight);

    if (reverseHeight != null) {
      reverseController.setSlidePosition(height: reverseHeight);
    }
  }

  void _handleReverseSlide() {
    setPosition(
      visibleHeight: position.bounds?.normalizedHeightOf(
          height: position.bounds!.minHeight +
              reverseController.position.slideAmount),
    );
  }

  @override
  SlidingDrawerBounds? _calculateBounds(double? measuredHeight) {
    if (reverseController.position.bounds == null) return null;
    final reverseBounds = reverseController.position.bounds!;
    measuredHeight ??= reverseBounds.maxHeight;

    final additionalHeight =
        math.max(measuredHeight - reverseBounds.maxHeight, 0);
    return SlidingDrawerBounds(
      minHeight: reverseBounds.minHeight + additionalHeight,
      maxHeight: reverseBounds.maxHeight + additionalHeight,
      measuredHeight: reverseBounds.maxHeight + additionalHeight,
    );
  }

  @override
  void initState() {
    super.initState();

    _syncReverseDrawer(reverseController);
  }

  @override
  void didUpdateWidget(covariant ReverseSlidingDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.reverseOf != oldWidget.reverseOf) {
      _unsyncReverseDrawer(oldWidget.reverseOf.currentState!);
      _syncReverseDrawer(widget.reverseOf.currentState!);
    }
  }

  @override
  void dispose() {
    _unsyncReverseDrawer(reverseController);
    super.dispose();
  }
}

class _SlidingDrawerState extends SlidingDrawerState
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  Animation<double>? _slideAnimation;

  @override
  void slideTo(double value, {Duration? duration}) {
    _slideAnimation?.removeListener(_handleAnimationUpdate);
    if (duration == null) {
      setSlidePosition(slide: value);
    } else {
      _slideAnimation = Tween<double>(
        begin: position.slideAmount,
        end: value.clamp(0, position.slideableLength),
      ).animate(_animationController)
        ..addListener(_handleAnimationUpdate);
      _animationController
        ..duration = duration
        ..forward(from: 0);
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      value: 0,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void setSlidePosition({double? slide, double? height, double? transition}) {
    setPosition(
      visibleHeight: position.bounds?.normalizedHeightOf(
        slide: slide,
        height: height,
        transition: transition,
      ),
    );
  }

  void _handleAnimationUpdate() {
    setSlidePosition(slide: _slideAnimation!.value);
  }

  @override
  void didUpdateWidget(covariant SlidingDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.slideLimits != oldWidget.slideLimits ||
        widget.heightLimits != oldWidget.heightLimits) {
      endOfFrame(_recalculateBounds);
    }
  }

  @override
  SlidingDrawerBounds? _calculateBounds(double? measuredHeight) {
    LimitedRange? heightLimits = widget.heightLimits;
    LimitedRange? slideLimits = widget.slideLimits;

    double? minHeight = heightLimits?.min?.toDouble();
    double? maxHeight = heightLimits?.max?.toDouble();

    if (slideLimits != null && measuredHeight != null) {
      if (slideLimits.max != null) {
        minHeight = math.max(
          minHeight ?? 0,
          measuredHeight - slideLimits.max!,
        );
      }
      if (slideLimits.min != null) {
        maxHeight = math.min(
          maxHeight ?? double.infinity,
          measuredHeight - slideLimits.min!,
        );
      }
    }

    minHeight ??= 0;
    maxHeight ??= measuredHeight != null
        ? math.max(minHeight, measuredHeight)
        : minHeight;

    return SlidingDrawerBounds(
      minHeight: minHeight,
      maxHeight: maxHeight,
      measuredHeight: measuredHeight,
    );
  }
}

abstract class SlidingDrawerActions {
  void open({Duration? duration = kSlidingDrawersAnimationDuration});

  void close({Duration? duration = kSlidingDrawersAnimationDuration});

  void slideTo(double value, {Duration? duration});
}

class SlidingDrawerPosition {
  const SlidingDrawerPosition({
    this.bounds,
    required this.visibleHeight,
    this.slidingToForward,
    this.atStart,
  });

  final SlidingDrawerBounds? bounds;
  final double visibleHeight;
  final bool? slidingToForward;
  final bool? atStart;

  double get slideAmount =>
      bounds == null ? 0 : bounds!.maxHeight - visibleHeight;

  double get slideableLength => bounds?.maxSlide ?? 0;

  double get maxHeight => bounds?.maxHeight ?? .0;

  double get transition {
    if (bounds != null && slideableLength > 0) {
      return (slideAmount / slideableLength).clamp(0, 1);
    }
    return 0;
  }

  double get reverseTransition {
    return 1 - transition;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SlidingDrawerPosition &&
        other.bounds == bounds &&
        other.visibleHeight == visibleHeight &&
        other.slidingToForward == slidingToForward &&
        other.atStart == atStart;
  }

  @override
  int get hashCode => Object.hash(bounds, visibleHeight, slidingToForward);

  SlidingDrawerPosition copyWith({
    SlidingDrawerBounds? bounds,
    double? visibleHeight,
    bool? slidingToForward,
    bool? atStart,
  }) {
    return SlidingDrawerPosition(
      bounds: bounds ?? this.bounds,
      visibleHeight: visibleHeight ?? this.visibleHeight,
      slidingToForward: slidingToForward ?? this.slidingToForward,
      atStart: atStart ?? this.atStart,
    );
  }
}

class SlidingDrawerBounds {
  const SlidingDrawerBounds({
    required this.minHeight,
    required this.maxHeight,
    required this.measuredHeight,
  })  : assert(minHeight >= 0 && maxHeight >= minHeight,
            "($minHeight) >= 0 && ($maxHeight) >= ($minHeight) is not true."),
        assert(measuredHeight == null || measuredHeight >= 0);

  final double minHeight;
  final double maxHeight;
  final double? measuredHeight;

  double get maxSlide => maxHeight - minHeight;

  double? normalizedHeightOf(
      {double? height, double? slide, double? transition}) {
    assert(slide == null || height == null || transition == null);
    assert(transition == null || (transition >= 0 && transition <= 1));

    if (transition != null) {
      slide = maxSlide * transition;
    }

    if (slide != null) {
      height = maxHeight - slide;
    }

    return height?.clamp(minHeight, maxHeight);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SlidingDrawerBounds &&
        other.minHeight == minHeight &&
        other.maxHeight == maxHeight &&
        other.measuredHeight == measuredHeight;
  }

  @override
  int get hashCode => Object.hash(minHeight, maxHeight, measuredHeight);

  @override
  String toString() {
    return "SlidingDrawerBounds: $minHeight <= height <= $maxHeight";
  }
}
