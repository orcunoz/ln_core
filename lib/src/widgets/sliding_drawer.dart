part of 'sliding_drawers_area.dart';

enum DrawerPosition {
  top,
  bottom,
}

enum TriggerWhen {
  scroll,
  overTriggerOffset,
  always,
  never,
}

enum TriggerBehavior {
  open,
  close,
  both,
}

class SlidingDrawer extends StatefulWidget {
  final TriggerWhen when;
  final TriggerBehavior behavior;
  final double triggerOffset;
  final DrawerPosition position;
  final bool openAtStart;
  final bool stucked = false;

  final Duration slideAnimationDuration;
  final Curve slideAnimationCurve;

  final Widget? child;

  const SlidingDrawer({
    super.key,
    this.behavior = TriggerBehavior.open,
    this.when = TriggerWhen.scroll,
    required this.position,
    this.triggerOffset = .0,
    this.openAtStart = true,
    this.slideAnimationDuration = const Duration(milliseconds: 500),
    this.slideAnimationCurve = Curves.easeInOut,
    required this.child,
  });

  @override
  State<SlidingDrawer> createState() => SlidingDrawerState();
}

class SlidingDrawerState extends State<SlidingDrawer> {
  bool _lock = false;

  Size? _measuredSize;
  final ValueNotifier<double?> _computedHeight = ValueNotifier<double?>(null);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _SlidingDrawersScope.of(context).register(this);
    });
  }

  @override
  void deactivate() {
    _SlidingDrawersScope.of(context).unregister(this);
    super.deactivate();
  }

  bool get open => _computedHeight.value == null || _measuredSize == null
      ? widget.openAtStart
      : _measuredSize!.height / 2 < _computedHeight.value!;
  set open(bool value) {
    Log.wtf(value);
    if (!_lock) {
      _lock = true;
      _computedHeight.value = value ? _measuredSize?.height : 0;
      Future.delayed(widget.slideAnimationDuration, () => _lock = false);
    }
  }

  @override
  void didUpdateWidget(covariant SlidingDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.behavior != oldWidget.behavior) {
      //updateState(_lastOffset, .0);
    }
  }

  double updateState(double offset, double offsetChange) {
    final double previousOffset = offset - offsetChange;
    final bool trigger = switch (widget.when) {
      TriggerWhen.scroll => offsetChange != .0,
      TriggerWhen.overTriggerOffset => (offset - widget.triggerOffset).sign !=
          (previousOffset - widget.triggerOffset).sign,
      TriggerWhen.always => true,
      TriggerWhen.never => false,
    };

    final newOpenState = !trigger
        ? null
        : switch (widget.behavior) {
            TriggerBehavior.open => true,
            TriggerBehavior.close => false,
            TriggerBehavior.both => offsetChange < 0,
          };

    final previousHeight = _computedHeight.value ?? 0;
    double change = 0;

    if (trigger) {
      var height = (_computedHeight.value ?? 0) +
          (widget.position == DrawerPosition.top ? -1.0 : 1.0) * offsetChange;
      height = math.max(height, 0);
      height = math.min(height, _measuredSize?.height ?? .0);
      change = height - previousHeight;
      _computedHeight.value = height;
    }

    return change;
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: ValueListenableBuilder(
        valueListenable: _computedHeight,
        builder: (context, value, child) {
          return SizedOverflowBox(
            size: Size.fromHeight(value ?? 0),
            alignment: widget.position == DrawerPosition.bottom
                ? Alignment.topCenter
                : Alignment.bottomCenter,
            child: child,
          );
        },
        child: Measurable(
          afterLayout: (size) {
            _computedHeight.value ??= widget.openAtStart ? size.height : .0;
            _measuredSize = size;
          },
          child: widget.child,
        ),
      ),
    );
  }
}
