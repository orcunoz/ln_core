import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import 'dart:math' as math;

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
    this.physics,
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
    this.physics,
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
          itemCount: (separatorBuilder == null
              ? itemCount
              : (math.max(0, 2 * itemCount - 1))),
          findChildIndexCallback: separatorBuilder == null
              ? findChildIndexCallback
              : findChildIndexCallback == null
                  ? null
                  : (key) {
                      var index = findChildIndexCallback(key);
                      return index == null ? null : (index / 2).round();
                    },
          itemBuilder: separatorBuilder == null
              ? itemBuilder
              : (context, index) {
                  final itemIndex = (index / 2).round();
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
  final ScrollPhysics? physics;
  final Widget? child;

  @override
  State<SlidingDrawersScrollable> createState() =>
      _SlidingDrawersScrollableState();
}

class _SlidingDrawersScrollableState extends State<SlidingDrawersScrollable> {
  ScrollController? _localController;
  ScrollController get controller => widget.controller ?? _localController!;

  _SlidingDrawersAreaState? _scope;
  _SlidingDrawersAreaState get scope {
    assert(_scope != null);
    return _scope!;
  }

  late final DebouncedAction _scrollEndAction = DebouncedAction(
    duration: Duration(milliseconds: 250),
    action: () {
      _scope?.top._handleScrollEnd();
      _scope?.bottom._handleScrollEnd();
    },
  );

  late double _scrollOffset;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _localController = ScrollController();
    }

    controller.addListener(_handleScroll);
    _scrollOffset = controller.hasClients ? controller.offset : 0;
  }

  @override
  void didUpdateWidget(covariant SlidingDrawersScrollable oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.controller != oldWidget.controller) {
      oldWidget.controller?.removeListener(_handleScroll);

      if (oldWidget.controller == null) {
        _localController?.dispose();
        _localController = null;
      }

      if (widget.controller == null) {
        _localController =
            ScrollController(initialScrollOffset: oldWidget.controller!.offset)
              ..addListener(_handleScroll);
      }

      controller.addListener(_handleScroll);
    }

    if (widget.child != oldWidget.child) {
      scope.resetDrawers();
    }
  }

  void _handleScroll() {
    final offsetChange = controller.offset - _scrollOffset;
    if (offsetChange != 0) {
      _scrollOffset = controller.offset;

      _scope?.top
          ._handleScroll(_scrollOffset, offsetChange, overs: true, outs: true);
      _scope?.bottom
          ._handleScroll(_scrollOffset, offsetChange, overs: true, outs: true);

      _scrollEndAction.invoke();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scope = _SlidingDrawersScope.of(context);
  }

  @override
  void dispose() {
    _localController?.dispose();
    _scope?.resetDrawers();
    super.dispose();
  }

  Widget _build(BuildContext context, double? viewportHeight, Widget? child) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        scope.top.insetsListenable,
        scope.bottom.insetsListenable,
      ]),
      builder: (context, _) {
        final insets = EdgeInsets.only(
          top: scope.top.computedScrollableInset,
          bottom: scope.bottom.computedScrollableInset,
        );
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          primary: widget.primary,
          padding: widget.padding?.add(insets) ?? insets,
          controller: controller,
          physics: widget.physics,
          dragStartBehavior: widget.dragStartBehavior,
          clipBehavior: widget.clipBehavior,
          restorationId: widget.restorationId,
          keyboardDismissBehavior: widget.keyboardDismissBehavior,
          child: viewportHeight == null
              ? child
              : ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportHeight -
                        (widget.padding?.vertical ?? 0) -
                        (scope.top.value.inset + scope.bottom.value.inset) +
                        (scope.top.value.slideableLength +
                            scope.bottom.value.slideableLength) +
                        (scope.top._parent?.value.margin ?? 0) +
                        (scope.bottom._parent?.value.margin ?? 0),
                  ),
                  child: child,
                ),
        );
      },
    );
    /*return NotificationListener(
      onNotification: (ScrollNotification notification) {
        Log.i(notification);

        if (notification.depth == 0 &&
            notification.metrics.axis == Axis.vertical) {
          scope._handleScrollNotification(notification);
          _scrollEndAction.invoke();
          return true;
        }

        return false;
      },
      child: ,
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return widget.fillViewport
        ? LayoutBuilder(builder: (context, constraints) {
            return _build(
              context,
              constraints.maxHeight,
              widget.child,
            );
          })
        : _build(context, null, widget.child);
  }
}

mixin SlidingDrawers on LnState<SlidingDrawersArea> {
  static SlidingDrawers of(BuildContext context) {
    return _SlidingDrawersScope.of(context);
  }

  SlidingDrawersGroup _groupOf(VerticalDirection direction) =>
      switch (direction) {
        VerticalDirection.up => top,
        VerticalDirection.down => bottom,
      };

  final top = SlidingDrawersGroup._top();
  final bottom = SlidingDrawersGroup._bottom();

  void resetDrawers({Duration? duration = kSlidingDrawersAnimationDuration}) {
    top.resetDrawerPositions(duration: duration);
    bottom.resetDrawerPositions(duration: duration);
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
    required this.child,
  });

  final List<Widget> topDrawers;
  final List<Widget> bottomDrawers;
  final Widget child;

  @override
  State<SlidingDrawersArea> createState() => _SlidingDrawersAreaState();
}

class _SlidingDrawersAreaState extends LnState<SlidingDrawersArea>
    with SlidingDrawers {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final parent = _SlidingDrawersScope.maybeOf(context);
    top.setParent(parent?.top);
    bottom.setParent(parent?.bottom);
  }

  /*void _handleScrollNotification(ScrollNotification notification) {
    final newOffset = notification.metrics.extentBefore;
    double offsetChange = switch (notification) {
      var n when n is OverscrollNotification => n.overscroll,
      var n when n is ScrollUpdateNotification => n.scrollDelta ?? 0,
      _ => 0,
    };

    if (offsetChange != 0) {
      top._handleScroll(newOffset, offsetChange, overs: true, outs: true);
      bottom._handleScroll(newOffset, offsetChange, overs: true, outs: true);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return _SlidingDrawersScope(
      state: this,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ListenableBuilder(
            listenable: Listenable.merge([top, bottom]),
            builder: (context, child) {
              return Padding(
                padding: EdgeInsets.only(
                  top: top.value.margin,
                  bottom: bottom.value.margin,
                ),
                child: child,
              );
            },
            child: widget.child,
          ),
          Positioned.fill(
            top: null,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.up,
              children: widget.bottomDrawers,
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
      ),
    );
  }
}

class DrawersGroupState {
  const DrawersGroupState({
    required this.inset,
    required this.margin,
    required this.slideableLength,
    required this.nonSlideableLength,
    required this.shrinkedOutInset,
  });

  final double inset;
  final double margin;
  final double slideableLength;
  final double nonSlideableLength;
  final double shrinkedOutInset;

  @override
  bool operator ==(Object other) =>
      other is DrawersGroupState &&
      inset == other.inset &&
      margin == other.margin &&
      slideableLength == other.slideableLength &&
      nonSlideableLength == other.nonSlideableLength &&
      shrinkedOutInset == other.shrinkedOutInset;

  @override
  int get hashCode => Object.hash(inset, margin);
}

class SlidingDrawersGroup extends ValueListenable<DrawersGroupState>
    with ChangeNotifier {
  SlidingDrawersGroup._top() : direction = VerticalDirection.up;
  SlidingDrawersGroup._bottom() : direction = VerticalDirection.down;
  final VerticalDirection direction;

  final _states = <SlidingDrawerState>{};
  Iterable<List<SlidingDrawerState>> _sortedStates = [];

  SlidingDrawersGroup? _parent;
  DrawersGroupState _state = DrawersGroupState(
    inset: 0,
    margin: 0,
    shrinkedOutInset: 0,
    slideableLength: 0,
    nonSlideableLength: 0,
  );

  @override
  DrawersGroupState get value => _state;

  final _computedSlideSumNotifier = ChangeNotifier();
  late final insetsListenable =
      Listenable.merge([_computedSlideSumNotifier, this]);
  double get computedSlideSum =>
      (value.shrinkedOutInset) + (_parent?.computedSlideSum ?? 0);

  double get computedScrollableInset =>
      _hasChildGroup ? 0 : (value.inset + (_parent?.computedSlideSum ?? 0));

  bool _hasChildGroup = false;
  double scrollOffset = 0;

  void _notifyChild(bool has) {
    _hasChildGroup = has;
  }

  void setParent(SlidingDrawersGroup? parent) {
    if (_parent != parent) {
      _parent
        ?..removeListener(_computedSlideSumNotifier.notifyListeners)
        .._notifyChild(false);
      _parent = parent;
      _parent
        ?..addListener(_computedSlideSumNotifier.notifyListeners)
        .._notifyChild(true);
      _computedSlideSumNotifier.notifyListeners();
      //_refreshSortedStates();
    }
  }

  @override
  void dispose() {
    _parent?.removeListener(_computedSlideSumNotifier.notifyListeners);
    _computedSlideSumNotifier.dispose();
    super.dispose();
  }

  void setState(DrawersGroupState value) {
    //_relativeScrollOffset = _lastScrollOffset - value.inset;
    if (_state != value) {
      _state = value;
      LnSchedulerCallbacks.endOfFrame(notifyListeners);
    }
  }

  void _register(SlidingDrawerState state) {
    final added = _states.add(state);
    assert(added);
    state.listenable.addListener(_updateState);
    _refreshSortedStates();
  }

  void _unregister(SlidingDrawerState state) {
    final removed = _states.remove(state);
    if (removed) {
      state.listenable.removeListener(_updateState);
      _refreshSortedStates();
    }
  }

  void _updateState() {
    double innerInsets = .0;
    double outerInsets = .0;
    double slideableLengths = .0;
    double nonSlideableLengths = .0;
    double shrinkedOutInsets = .0;

    for (final state in _states) {
      if (state.onScrollableBounds) {
        innerInsets += state.position.maxHeight;
        nonSlideableLengths +=
            state.position.maxHeight - state.position.slideableLength;
      } else {
        innerInsets += state.position.slideAmount;
        outerInsets += state.position.visibleHeight;
        shrinkedOutInsets += state.position.slideAmount;
      }

      slideableLengths += state.position.slideableLength;
    }

    setState(DrawersGroupState(
      inset: innerInsets,
      margin: outerInsets,
      slideableLength: slideableLengths,
      nonSlideableLength: nonSlideableLengths,
      shrinkedOutInset: shrinkedOutInsets,
    ));
  }

  void _refreshSortedStates() {
    final directionSign = switch (direction) {
      VerticalDirection.down => 1,
      VerticalDirection.up => -1,
    };

    _sortedStates = _states
        //.followedBy(_parent?._states ?? [])
        .groupListsBy((s) => s.priority)
        .entries
        .sorted((a, b) => (a.key - b.key) * directionSign)
        .map((g) => g.value);

    double slSum = .0;
    for (var group in _sortedStates) {
      for (var state in group) {
        state.slideRelativeOffset = slSum;
        slSum += state.position.slideableLength;
      }
    }

    _updateState();
  }

  void resetDrawerPositions({
    Duration? duration = kSlidingDrawersAnimationDuration,
  }) {
    for (final state in _states) {
      if (!state.isReverse) {
        state.open(duration: duration);
      }
    }
    _parent?.resetDrawerPositions(duration: duration);
  }

  void _handleScrollEnd() {
    const Duration duration = Duration(milliseconds: 300);
    for (var group in _sortedStates) {
      for (var state in group
          .where((ds) => ds.widget.snap && ds.widget.pinnedOffset == null)) {
        double targetTransition = state.position.transition > .5 ? 1 : 0;
        if (state.slideDirection == VerticalDirection.up &&
            (state.slideRelativeOffset + state.position.maxHeight) >
                scrollOffset - (_parent?.computedSlideSum ?? 0)) {
          targetTransition = 0;
        }
        state.slideTo(
          targetTransition * state.position.slideableLength,
          duration: duration,
        );
      }
    }

    _parent?._handleScrollEnd();
  }

  double _handleScroll(
    final double offset,
    final double offsetChange, {
    required bool overs,
    required bool outs,
  }) {
    scrollOffset = offset;
    assert(overs || outs);
    var groups =
        offsetChange < 0 ? _sortedStates.toList().reversed : _sortedStates;

    var remain = offsetChange;

    _parent?._handleScroll(offset, remain, overs: true, outs: false);

    for (var group in groups) {
      final states = switch ((overs, outs)) {
        (true, true) => group.toList(),
        (true, false) => group.where((d) => d.onScrollableBounds).toList(),
        (false, true) => group.where((d) => !d.onScrollableBounds).toList(),
        _ => const <SlidingDrawerState>[],
      };
      while (remain.abs() > precisionErrorTolerance && states.isNotEmpty) {
        final sharedSlide = remain / states.length;
        for (var state in states.toList()) {
          final change = state.handleScroll(offset, sharedSlide);
          if (change.abs() < precisionErrorTolerance) {
            states.remove(state);
          }
          remain -= change;
        }
      }
    }

    if (remain.abs() > precisionErrorTolerance) {
      remain =
          _parent?._handleScroll(offset, remain, overs: false, outs: true) ??
              remain;
    }

    _updateState();
    return remain;
  }
}
