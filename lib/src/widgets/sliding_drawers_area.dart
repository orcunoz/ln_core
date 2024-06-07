import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import 'dart:math' as math;

part 'sliding_drawer.dart';

const _kDrawDebugBounds = false;

class _SlidingDrawersScope extends InheritedWidget {
  const _SlidingDrawersScope({
    required _SlidingDrawersAreaState state,
    required super.child,
  }) : _state = state;

  final _SlidingDrawersAreaState _state;

  @override
  bool updateShouldNotify(covariant _SlidingDrawersScope oldWidget) {
    return _state != oldWidget._state;
  }

  static _SlidingDrawersAreaState of(BuildContext context) {
    final state = maybeOf(context);
    assert(state != null, "No SlidingDrawersArea found in context.");
    return state!;
  }

  static _SlidingDrawersAreaState? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_SlidingDrawersScope>()
        ?._state;
  }
}

class SlidingDrawersScrollable extends StatefulWidget {
  const SlidingDrawersScrollable({
    super.key,
    this.fillViewport = false,
    this.padding,
    this.primary,
    this.controller,
    this.dragStartBehavior = DragStartBehavior.start,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.child,
  });

  SlidingDrawersScrollable.listView({
    super.key,
    this.fillViewport = false,
    this.controller,
    this.padding,
    this.dragStartBehavior = DragStartBehavior.start,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.clipBehavior = Clip.hardEdge,
    this.restorationId,
    this.primary,
    required int itemCount,
    required Widget? Function(BuildContext, int) itemBuilder,
    int? Function(Key)? findChildIndexCallback,
    Widget Function(BuildContext, int)? separatorBuilder,
  }) : child = ListView.builder(
          key: key,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          padding: EdgeInsets.zero,
          itemCount: (separatorBuilder == null
              ? itemCount
              : (math.max(0, 2 * itemCount - 1))),
          findChildIndexCallback: separatorBuilder == null
              ? findChildIndexCallback
              : findChildIndexCallback == null
                  ? null
                  : (key) {
                      var index = findChildIndexCallback(key);
                      return index == null ? null : (index / 2).floor();
                    },
          itemBuilder: separatorBuilder == null
              ? itemBuilder
              : (context, index) {
                  final itemIndex = (index / 2).floor();
                  return index.isEven
                      ? itemBuilder(context, itemIndex)
                      : separatorBuilder(context, itemIndex);
                },
        );

  final bool fillViewport;
  final EdgeInsetsGeometry? padding;
  final bool? primary;
  final ScrollController? controller;
  final DragStartBehavior dragStartBehavior;
  final Clip clipBehavior;
  final String? restorationId;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;
  final Widget? child;

  @override
  State<SlidingDrawersScrollable> createState() =>
      _SlidingDrawersScrollableState();
}

class _SlidingDrawersScrollableState extends State<SlidingDrawersScrollable>
    with WidgetsBindingObserver {
  _SlidingDrawersAreaState? _scope;
  _SlidingDrawersAreaState get scope {
    assert(_scope != null);
    return _scope!;
  }

  ScrollController? _localController;
  ScrollController get controller => widget.controller ?? _localController!;

  late final DebouncedAction _scrollEndAction = DebouncedAction(
    duration: Duration(milliseconds: 200),
    action: () {
      _scope?.top.snapDrawers(() => _scrollEndAction.debounced);
      _scope?.bottom.snapDrawers(() => _scrollEndAction.debounced);
    },
  );

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _localController = ScrollController();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final scope = _SlidingDrawersScope.of(context);
    if (_scope != scope) {
      _scope = scope..resetDrawers();
      _notifyScope();
    }
  }

  void _notifyScope() {
    final position =
        controller.positions.firstWhereOrNull((p) => p.axis == Axis.vertical);
    if (position != null) {
      scope.handleScrollUpdate(0, position.pixels, position.maxScrollExtent);
    }
  }

  @override
  void didUpdateWidget(covariant SlidingDrawersScrollable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        _localController!.dispose();
        _localController = null;
      } else {
        //_unsyncController(oldWidget.controller!);
      }

      if (widget.controller == null) {
        _localController = ScrollController();
      } else {
        //_syncController(widget.controller!);
      }

      _notifyScope();
    }
  }

  @override
  void deactivate() {
    _scope?.resetDrawers();
    super.deactivate();
  }

  @override
  void dispose() {
    super.dispose();
    _localController?.dispose();
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth != 0) return false;

    if (notification is ScrollEndNotification) {
      _scrollEndAction.invoke();
    } else if (notification is OverscrollNotification) {
      //Log.i("-- OverscrollNotification");
    } else if (notification is ScrollUpdateNotification) {
      scope.handleScrollUpdate(
        notification.scrollDelta ?? 0,
        notification.metrics.pixels,
        notification.metrics.maxScrollExtent,
      );
      return true;
    }

    return false;
  }

  Widget _buildScrollable(
      BuildContext context, EdgeInsetsGeometry padding, Widget? child) {
    return ValueListenableBuilder(
      valueListenable: scope.scrollableInsetsNotifier,
      builder: (context, scrollableInsets, child) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          primary: widget.primary,
          padding: padding.add(scrollableInsets),
          controller: controller,
          physics: ClampingScrollPhysics(),
          dragStartBehavior: widget.dragStartBehavior,
          clipBehavior: widget.clipBehavior,
          restorationId: widget.restorationId,
          keyboardDismissBehavior: widget.keyboardDismissBehavior,
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? viewport = widget.child;

    final padding = widget.padding ?? EdgeInsets.zero;

    if (_kDrawDebugBounds) {
      // Viewport bounds
      viewport = DebugAreaBounds(child: viewport);
    }

    Widget scrollable = widget.fillViewport
        ? LayoutBuilder(builder: (context, constraints) {
            final scrollableHeight = constraints.maxHeight;
            return _buildScrollable(
              context,
              padding,
              ValueListenableBuilder(
                valueListenable: scope.fillViewportExtendsNotifier,
                builder: (context, fillViewportExtends, child) {
                  final viewportHeight =
                      scrollableHeight - padding.vertical + fillViewportExtends;

                  //Log.i("scrollable: ${scrollableHeight.toStringAsFixed(2)}");
                  //Log.i("viewport: ${viewportHeight.toStringAsFixed(2)}");

                  return ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: viewportHeight, minWidth: double.infinity),
                    child: child,
                  );
                },
                child: viewport,
              ),
            );
          })
        : _buildScrollable(context, padding, viewport);

    if (_kDrawDebugBounds) {
      // Scrollable bounds
      scrollable = DebugAreaBounds(
        color: Colors.green,
        child: scrollable,
      );
    }

    return NotificationListener(
      onNotification: _handleScrollNotification,
      child: scrollable,
    );
  }
}

mixin SlidingDrawers on LnState<SlidingDrawersArea> {
  static SlidingDrawers of(BuildContext context) {
    return _SlidingDrawersScope.of(context);
  }

  _SlidingDrawersGroup _groupOf(VerticalDirection direction) =>
      switch (direction) {
        VerticalDirection.up => top,
        VerticalDirection.down => bottom,
      };

  late final top = _SlidingDrawersGroup._top(this as _SlidingDrawersAreaState);
  late final bottom =
      _SlidingDrawersGroup._bottom(this as _SlidingDrawersAreaState);

  void resetDrawers({
    Duration? duration = kSlidingDrawersAnimationDuration,
    Curve? curve = kSlidingDrawersAnimationCurve,
  }) {
    top.resetDrawerPositions(duration: duration, curve: curve);
    bottom.resetDrawerPositions(duration: duration, curve: curve);
  }

  VerticalDirection? directionOf(final SlidingDrawer drawer) {
    if (widget.topDrawers.contains(drawer)) {
      return VerticalDirection.up;
    }
    if (widget.bottomDrawers.contains(drawer)) {
      return VerticalDirection.down;
    }

    return null;
  }

  void register(SlidingDrawerState state, VerticalDirection direction) {
    _groupOf(direction)._register(state);
  }

  void unregister(SlidingDrawerState state) {
    top._unregister(state);
    bottom._unregister(state);
  }
}

class SlidingDrawersArea extends StatefulWidget {
  const SlidingDrawersArea({
    super.key,
    this.topDrawers = const [],
    this.bottomDrawers = const [],
    this.isolated = false,
    //this.keepChildHeightConstant = false,
    required this.child,
  });

  final bool keepChildHeightConstant = false;
  final bool isolated;
  final List<Widget> topDrawers;
  final List<Widget> bottomDrawers;
  final Widget child;

  @override
  State<SlidingDrawersArea> createState() => _SlidingDrawersAreaState();
}

class _SlidingDrawersAreaState extends LnState<SlidingDrawersArea>
    with SlidingDrawers {
  final fillViewportExtendsNotifier = ValueNotifier<double>(0);
  late final scrollableInsetsNotifier =
      ValueNotifier<EdgeInsets>(EdgeInsets.zero);

  void _computeFillViewportExtends() {
    final recursiveOutsideSlideableLengths =
        top.recursiveOutsideSlideableLengthsSumNotifier.value +
            bottom.recursiveOutsideSlideableLengthsSumNotifier.value;
    final recursiveOutSlideSum = top.recursiveOutsideSlideSumNotifier.value +
        bottom.recursiveOutsideSlideSumNotifier.value;
    final insideShrinkedHeightsSum =
        top.insideShrinkedHeightsSumNotifier.value +
            bottom.insideShrinkedHeightsSumNotifier.value;

    fillViewportExtendsNotifier.value = recursiveOutsideSlideableLengths -
        recursiveOutSlideSum -
        insideShrinkedHeightsSum;
  }

  void _computeScrollableInset() {
    scrollableInsetsNotifier.value = EdgeInsets.only(
      top: top.insideExpandedHeightsSumNotifier.value +
          top.recursiveOutsideSlideSumNotifier.value,
      bottom: bottom.insideExpandedHeightsSumNotifier.value +
          bottom.recursiveOutsideSlideSumNotifier.value,
    );
  }

  late final Listenable areaInsetsListenable = Listenable.merge([
    top.outsideExpandedHeightsSumNotifier,
    top.outsideSlideSumNotifier,
    bottom.outsideExpandedHeightsSumNotifier,
    bottom.outsideSlideSumNotifier
  ]);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _refreshParentRegistration();
  }

  @override
  void didUpdateWidget(covariant SlidingDrawersArea oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isolated != oldWidget.isolated) {
      _refreshParentRegistration();
    }
  }

  void _refreshParentRegistration() {
    final parent =
        widget.isolated ? null : _SlidingDrawersScope.maybeOf(context);
    top.setParent(parent?.top);
    bottom.setParent(parent?.bottom);
    _computeScrollableInset();
    _computeFillViewportExtends();
  }

  void handleScrollUpdate(double change, double offset, double maxScroll) {
    top.handleScrollUpdate(change, offset, maxScroll);
    bottom.handleScrollUpdate(change, offset, maxScroll);
  }

  Widget _buildStack(BuildContext context, BoxConstraints? constraints) {
    // ignore: invalid_use_of_protected_member
    final hasScrollable = scrollableInsetsNotifier.hasListeners;
    Widget child = widget.child;

    child = Stack(
      clipBehavior: Clip.none,
      children: [
        ListenableBuilder(
          listenable: areaInsetsListenable,
          builder: (context, child) {
            if (hasScrollable && widget.keepChildHeightConstant) {
              return Positioned(
                left: 0,
                right: 0,
                top: top.outsideExpandedHeightsSumNotifier.value -
                    top.outsideSlideSumNotifier.value,
                height: constraints!.maxHeight -
                    top.recursiveOutsideSlideableLengthsSumNotifier.value,
                child: child!,
              );
            } else {
              return Padding(
                padding: EdgeInsets.only(
                  top: top.outsideExpandedHeightsSumNotifier.value -
                      top.outsideSlideSumNotifier.value,
                  bottom: bottom.outsideExpandedHeightsSumNotifier.value -
                      bottom.outsideSlideSumNotifier.value,
                ),
                child: child!,
              );
            }
          },
          child: child,
        ),
        Positioned.fill(
          top: null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.up,
            children: widget.bottomDrawers.reversed.toList(),
          ),
        ),
        Positioned.fill(
          bottom: null,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: widget.topDrawers,
          ),
        ),
      ],
    );

    if (_kDrawDebugBounds) {
      child = DebugAreaBounds(
        color: hasScrollable ? Colors.red : Colors.yellow,
        child: child,
      );
    }

    return child;
  }

  @override
  void dispose() {
    top.dispose();
    bottom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _SlidingDrawersScope(
      state: this,
      child: widget.keepChildHeightConstant
          ? LayoutBuilder(builder: _buildStack)
          : _buildStack(context, null),
    );
  }
}

class SlidingDrawersGroupState {
  const SlidingDrawersGroupState({
    required this.atStart,
    required this.scrollOffsetUnderDrawers,
    required this.shrinkedHeightsSum,
    required this.allDrawersShrinked,
  });

  final bool atStart;
  final bool scrollOffsetUnderDrawers;
  final double shrinkedHeightsSum;
  final bool allDrawersShrinked;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is SlidingDrawersGroupState &&
        other.atStart == atStart &&
        other.scrollOffsetUnderDrawers == scrollOffsetUnderDrawers &&
        other.shrinkedHeightsSum == shrinkedHeightsSum &&
        other.allDrawersShrinked == allDrawersShrinked;
  }

  @override
  int get hashCode => Object.hash(
        atStart,
        scrollOffsetUnderDrawers,
        shrinkedHeightsSum,
        allDrawersShrinked,
      );

  @override
  String toString() {
    return "SlidingDrawersGroupState: ("
        "atStart: $atStart, "
        "scrollOffsetUnderDrawers: $scrollOffsetUnderDrawers, "
        "shrinkedHeightsSumZero: $shrinkedHeightsSum, "
        "allDrawersShrinked: $allDrawersShrinked"
        ")";
  }
}

class _SlidingDrawersGroup {
  _SlidingDrawersGroup._top(this.area) : direction = VerticalDirection.up;
  _SlidingDrawersGroup._bottom(this.area) : direction = VerticalDirection.down;
  final VerticalDirection direction;

  final _states = <SlidingDrawerState>{};
  List<SlidingDrawerState> _pinnedStates = [];
  List<List<SlidingDrawerState>> _notPinnedSortedStates = [];

  final _stateNotifier = ValueNotifier<SlidingDrawersGroupState?>(null);
  SlidingDrawersGroupState? get state => _stateNotifier.value;
  Listenable get listenable => _stateNotifier;

  _SlidingDrawersGroup? _parent;
  final _SlidingDrawersAreaState area;

  double insideSlideSum = 0;
  double? distanceToStart;

  late final insideShrinkedHeightsSumNotifier = ValueNotifier<double>(0)
    ..addListener(area._computeFillViewportExtends);
  late final insideExpandedHeightsSumNotifier = ValueNotifier<double>(0)
    ..addListener(area._computeScrollableInset);
  late final outsideSlideableLengthsSumNotifier = ValueNotifier<double>(0)
    ..addListener(_computeRecursiveOutsideSlideableLengthsSum);
  final outsideExpandedHeightsSumNotifier = ValueNotifier<double>(0);
  late final outsideSlideSumNotifier = ValueNotifier<double>(0)
    ..addListener(_computeRecursiveOutsideSlideSum);

  late final recursiveOutsideSlideSumNotifier = ValueNotifier<double>(0)
    ..addListener(() {
      area
        .._computeScrollableInset()
        .._computeFillViewportExtends();
    });
  late final recursiveOutsideSlideableLengthsSumNotifier =
      ValueNotifier<double>(0)..addListener(area._computeFillViewportExtends);

  Iterable<SlidingDrawerState> get insideDrawers =>
      _states.where((d) => d.onScrollableBounds);

  Iterable<SlidingDrawerState> get outsideDrawers =>
      _states.where((d) => !d.onScrollableBounds);

  void _computeRecursiveOutsideSlideSum() {
    recursiveOutsideSlideSumNotifier.value =
        (_parent?.recursiveOutsideSlideSumNotifier.value ?? 0) +
            outsideSlideSumNotifier.value;
  }

  void _computeRecursiveOutsideSlideableLengthsSum() {
    recursiveOutsideSlideableLengthsSumNotifier.value =
        (_parent?.recursiveOutsideSlideableLengthsSumNotifier.value ?? 0) +
            outsideSlideableLengthsSumNotifier.value;
  }

  void _computeOutsideSlideSum() {
    outsideSlideSumNotifier.value =
        outsideDrawers.fold(.0, (sum, d) => sum + d.slideAmount);
  }

  void _computeOutsideSlideableLengthsSum() {
    outsideSlideableLengthsSumNotifier.value =
        outsideDrawers.fold(.0, (sum, d) => sum + d.slideableLength);
  }

  void _computeOutsideExpandedHeightsSum() {
    outsideExpandedHeightsSumNotifier.value =
        outsideDrawers.fold(.0, (sum, d) => sum + d.maxHeight);
  }

  void _computeInsideShrinkedHeightsSum() {
    insideShrinkedHeightsSumNotifier.value =
        insideDrawers.fold(.0, (sum, d) => sum + d.minHeight);
  }

  void _computeInsideExpandedHeightsSum() {
    insideExpandedHeightsSumNotifier.value =
        insideDrawers.fold(.0, (sum, d) => sum + d.maxHeight);
  }

  void _computeInsideSlideSum() {
    insideSlideSum = insideDrawers.fold(.0, (sum, d) => sum + d.slideAmount);
  }

  void _computeState() {
    _computeInsideSlideSum();
    _computeInsideShrinkedHeightsSum();
    _computeInsideExpandedHeightsSum();
    _computeOutsideSlideSum();
    _computeOutsideSlideableLengthsSum();
    _computeOutsideExpandedHeightsSum();

    _computeRecursiveOutsideSlideSum();
    _computeRecursiveOutsideSlideableLengthsSum();

    _computeGroupState();
  }

  void setParent(_SlidingDrawersGroup? parent) {
    _parent
      ?..recursiveOutsideSlideSumNotifier
          .removeListener(_computeRecursiveOutsideSlideSum)
      ..recursiveOutsideSlideableLengthsSumNotifier
          .removeListener(_computeRecursiveOutsideSlideableLengthsSum);

    _parent = parent
      ?..recursiveOutsideSlideSumNotifier
          .addListener(_computeRecursiveOutsideSlideSum)
      ..recursiveOutsideSlideableLengthsSumNotifier
          .addListener(_computeRecursiveOutsideSlideableLengthsSum);

    _computeRecursiveOutsideSlideSum();
    _computeRecursiveOutsideSlideableLengthsSum();
  }

  void dispose() {
    setParent(null);
    insideShrinkedHeightsSumNotifier.dispose();
    insideExpandedHeightsSumNotifier.dispose();
    outsideSlideableLengthsSumNotifier.dispose();
    outsideExpandedHeightsSumNotifier.dispose();
    outsideSlideSumNotifier.dispose();
    recursiveOutsideSlideSumNotifier.dispose();
    recursiveOutsideSlideableLengthsSumNotifier.dispose();
  }

  void _register(SlidingDrawerState state) {
    final added = _states.add(state);
    assert(added);

    if (state.onScrollableBounds) {
      state
        ..boundsListenable.addListener(_computeInsideShrinkedHeightsSum)
        ..boundsListenable.addListener(_computeInsideExpandedHeightsSum)
        ..positionListenable.addListener(_computeInsideSlideSum)
        ..positionListenable.addListener(_computeGroupState);
    } else {
      state
        ..boundsListenable.addListener(_computeOutsideExpandedHeightsSum)
        ..boundsListenable.addListener(_computeOutsideSlideableLengthsSum)
        ..positionListenable.addListener(_computeOutsideSlideSum)
        ..positionListenable.addListener(_computeGroupState);
    }

    _refreshSortedStates();
    _computeState();
  }

  void _unregister(SlidingDrawerState state) {
    final removed = _states.remove(state);
    if (removed) {
      state
        ..boundsListenable.removeListener(_computeInsideShrinkedHeightsSum)
        ..boundsListenable.removeListener(_computeInsideExpandedHeightsSum)
        ..boundsListenable.removeListener(_computeOutsideExpandedHeightsSum)
        ..boundsListenable.removeListener(_computeOutsideSlideableLengthsSum)
        ..positionListenable.removeListener(_computeInsideSlideSum)
        ..positionListenable.removeListener(_computeOutsideSlideSum);

      _refreshSortedStates();
      _computeState();
    }
  }

  void _refreshSortedStates() {
    final directionSign = switch (direction) {
      VerticalDirection.down => -1,
      VerticalDirection.up => 1,
    };

    _notPinnedSortedStates = _states
        .where((e) => !e.widget.pinned)
        .groupListsBy((s) => s.priority)
        .entries
        .sorted((a, b) => (a.key - b.key) * directionSign)
        .map((g) => g.value)
        .toList();

    _pinnedStates = _states
        .where((e) => e.widget.pinned)
        .sorted((a, b) => (a.priority - b.priority) * directionSign)
        .toList();
  }

  void resetDrawerPositions({
    Duration? duration = kSlidingDrawersAnimationDuration,
    Curve? curve = kSlidingDrawersAnimationCurve,
  }) {
    for (final state in _states) {
      if (!state.isReverse) {
        state.open(duration: duration, curve: curve);
      }
    }
    _parent?.resetDrawerPositions(duration: duration, curve: curve);
  }

  Future<double> snapDrawers(bool Function() checkCanceled,
      [double? remain]) async {
    remain ??= distanceToStart! -
        recursiveOutsideSlideSumNotifier.value -
        insideDrawers.fold(.0, (sum, d) => sum + d.slideAmount);

    if (_parent != null) {
      remain = await _parent!.snapDrawers(checkCanceled, remain);
    }
    if (checkCanceled()) return remain;

    const Duration duration = Duration(milliseconds: 250);

    for (var group in _notPinnedSortedStates) {
      for (var state in group.reversed.where((ds) => ds.widget.snap)) {
        double targetSlideAmount =
            state.transition > .5 ? state.slideableLength : 0;
        double slideChange = targetSlideAmount - state.slideAmount;

        if (remain! + precisionErrorTolerance < slideChange) {
          slideChange -= state.slideableLength;
        }

        state.slideTo(
          state.slideAmount + slideChange,
          duration: duration,
        );

        remain -= slideChange;
      }
    }

    return remain!;
  }

  void handleScrollUpdate(
      final double change, final double offset, final double maxScroll) {
    final startOffset = switch (direction) {
      VerticalDirection.up => 0,
      VerticalDirection.down => maxScroll,
    };
    final directionSign = switch (direction) {
      VerticalDirection.up => 1,
      VerticalDirection.down => -1,
    };

    distanceToStart = (startOffset - offset).abs();

    final distanceToUnpinnedsStart =
        distanceToStart! - _handleOffsetUpdate(distanceToStart!);

    double safeChange = change;
    if (directionSign == change.sign) {
      safeChange =
          math.min(change.abs(), distanceToUnpinnedsStart) * change.sign;
    }
    safeChange = _handleScrollSlide(safeChange);
    _computeGroupState();
  }

  void _computeGroupState() {
    final slideSum = recursiveOutsideSlideSumNotifier.value + insideSlideSum;

    final shrinkedHeightsSum = outsideExpandedHeightsSumNotifier.value -
        outsideSlideableLengthsSumNotifier.value +
        insideShrinkedHeightsSumNotifier.value;

    final slideableLengthsSum =
        recursiveOutsideSlideableLengthsSumNotifier.value +
            insideExpandedHeightsSumNotifier.value -
            insideShrinkedHeightsSumNotifier.value;

    final distanceToStart = this.distanceToStart ??
        switch (direction) {
          VerticalDirection.up => 0,
          VerticalDirection.down => double.infinity,
        };

    final newState = SlidingDrawersGroupState(
      atStart: distanceToStart == slideSum,
      scrollOffsetUnderDrawers: distanceToStart > slideSum,
      shrinkedHeightsSum: shrinkedHeightsSum,
      allDrawersShrinked: slideableLengthsSum == slideSum,
    );

    if (newState != state) {
      _stateNotifier.value = newState;
    }
  }

  double _handleOffsetUpdate(final double distanceToStart) {
    double parentsPinnedDrawersSlideSum =
        _parent?._handleOffsetUpdate(distanceToStart) ?? 0;

    for (var state in _pinnedStates) {
      state.setSlidePosition(
        slide: distanceToStart - parentsPinnedDrawersSlideSum,
      );
      parentsPinnedDrawersSlideSum += state.slideAmount;
    }

    return parentsPinnedDrawersSlideSum;
  }

  double _handleScrollSlide(
    final double amount, {
    final bool overs = true,
    final bool outs = true,
  }) {
    double remain = amount;
    if (!overs && !outs) return remain;

    double updateParentOutDrawers(double change) =>
        _parent?._handleScrollSlide(change, overs: false, outs: outs) ?? change;

    final bool directionDown = amount > 0;

    var groups = directionDown
        ? _notPinnedSortedStates.reversed
        : _notPinnedSortedStates;

    _parent?._handleScrollSlide(remain, overs: overs, outs: false);

    if (!directionDown) {
      remain = updateParentOutDrawers(remain);
    }

    for (Iterable<SlidingDrawerState> group in groups) {
      if (!outs) group = group.where((d) => d.onScrollableBounds);
      if (!overs) group = group.where((d) => !d.onScrollableBounds);

      final states = group.toList();
      while (remain.abs() > precisionErrorTolerance && states.isNotEmpty) {
        final sharedSlide = remain / states.length;
        for (var state in states.toList()) {
          final change = state.handleScroll(sharedSlide);
          if (change.abs() < precisionErrorTolerance) {
            states.remove(state);
          }
          remain -= change;
        }
      }
    }

    if (directionDown) {
      remain = updateParentOutDrawers(remain);
    }

    return remain;
  }
}
