import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

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

mixin SlidingDrawers on LnState<SlidingDrawersArea> {
  static Widget scrollView({
    Key? key,
    bool fillViewport = false,
    bool reverse = false,
    EdgeInsetsGeometry? padding,
    bool? primary,
    ScrollController? controller,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    Clip clipBehavior = Clip.hardEdge,
    String? restorationId,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    Widget? child,
  }) {
    Widget scrollable(double? height) {
      return SlidingDrawersInsets.builder(
        builder: (context, state, _) {
          return SingleChildScrollView(
            key: key,
            scrollDirection: Axis.vertical,
            reverse: reverse,
            primary: primary,
            padding: padding?.add(state.insets) ?? state.insets,
            controller: controller,
            physics: const ClampingScrollPhysics(),
            dragStartBehavior: dragStartBehavior,
            clipBehavior: clipBehavior,
            restorationId: restorationId,
            keyboardDismissBehavior: keyboardDismissBehavior,
            child: height == null
                ? child
                : ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: height - state.nonSlideableLengths.vertical,
                    ),
                    child: child,
                  ),
          );
        },
      );
    }

    if (fillViewport) {
      return LayoutBuilder(builder: (context, constraints) {
        return scrollable(constraints.maxHeight);
      });
    } else {
      return scrollable(null);
    }
  }

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

  void expandDrawers();

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
  })  : padding = null,
        _scrollable = false,
        fillViewport = false,
        scrollController = null;

  const SlidingDrawersArea.scrollable({
    super.key,
    EdgeInsets this.padding = EdgeInsets.zero,
    this.scrollController,
    this.fillViewport = true,
    this.topDrawers = const [],
    this.bottomDrawers = const [],
    required this.child,
  }) : _scrollable = true;

  final bool _scrollable;
  final bool fillViewport;
  final ScrollController? scrollController;
  final List<Widget> topDrawers;
  final List<Widget> bottomDrawers;
  final EdgeInsets? padding;
  final Widget child;

  @override
  State<SlidingDrawersArea> createState() => _SlidingDrawersAreaState();
}

class _SlidingDrawersAreaState extends LnState<SlidingDrawersArea>
    with SlidingDrawers {
  int _depth = NumberUtils.maxInt;

  @override
  void expandDrawers() {
    top.resetDrawerPositions();
    bottom.resetDrawerPositions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _depth = NumberUtils.maxInt;
    final parent = _SlidingDrawersScope.maybeOf(context);
    top.setParent(parent?.top);
    bottom.setParent(parent?.bottom);
  }

  bool _handleScrollNotification(final ScrollNotification notification) {
    final newOffset = notification.metrics.extentBefore;
    final offsetChange = switch (notification) {
      var n when n is OverscrollNotification => n.overscroll,
      var n when n is ScrollUpdateNotification => n.scrollDelta ?? 0,
      _ => .0,
    };

    if (offsetChange != 0 &&
        notification.metrics.axis == Axis.vertical &&
        notification.depth <= _depth) {
      //_depth = notification.depth;

      top._handleScroll(newOffset, offsetChange);
      bottom._handleScroll(newOffset, offsetChange);

      /*double topRemain = offsetChange;
      topRemain = _parent?.top._handleScroll(newOffset, topRemain) ?? 0.0;
      if (topRemain.abs() > precisionErrorTolerance) {
        topRemain = top._handleScroll(newOffset, topRemain);
      }

      double bottomRemain = offsetChange;
      bottomRemain =
          _parent?.bottom._handleScroll(newOffset, bottomRemain) ?? 0.0;
      if (bottomRemain.abs() > precisionErrorTolerance) {
        bottomRemain = bottom._handleScroll(newOffset, bottomRemain);
      }*/
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    Widget result = widget.child;

    if (widget._scrollable) {
      result = SlidingDrawers.scrollView(
        fillViewport: widget.fillViewport,
        controller: widget.scrollController,
        padding: widget.padding,
        child: widget.child,
      );
    }

    return _SlidingDrawersScope(
      state: this,
      child: NotificationListener(
        onNotification: _handleScrollNotification,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SlidingDrawersInsets.builder(
              builder: (context, state, child) {
                Log.i(state.insetsToString());
                return Positioned.fill(
                  //top: top,
                  //bottom: bottom,
                  top: state.outInsets.top,
                  bottom: 0, //-state.topOutInset + state.bottomOutInset,
                  //top: state.topOutInset,
                  //bottom: state.bottomOutInset -
                  //    state.slideableLengths.top -
                  //    state.slideableLengths.bottom,
                  child: child!,
                );
              },
              child: result,
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
      ),
    );
  }
}

class DrawersGroupState {
  const DrawersGroupState({
    this.inset = 0,
    this.margin = 0,
    this.slideableLength = 0,
    this.nonSlideableLength = 0,
  });

  final double inset;
  final double margin;
  final double slideableLength;
  final double nonSlideableLength;

  @override
  bool operator ==(Object other) =>
      other is DrawersGroupState &&
      inset == other.inset &&
      margin == other.margin &&
      slideableLength == other.slideableLength &&
      nonSlideableLength == other.nonSlideableLength;

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

  DrawersGroupState _state = DrawersGroupState();

  @override
  DrawersGroupState get value => _state;

  double get insetsSum => value.inset; // + (_parent?.insetsSum ?? 0);

  void setParent(SlidingDrawersGroup? parent) {
    if (_parent != parent) {
      _parent = parent;
      //_refreshSortedStates();
    }
  }

  void setState(DrawersGroupState value) {
    bool willNotify = _state != value;
    _state = value;

    if (willNotify) {
      LnSchedulerCallbacks.endOfFrame(notifyListeners);
    }
  }

  void _register(SlidingDrawerState state) {
    final added = _states.add(state);
    assert(added);
    state.addListener(_updateState);
    _refreshSortedStates();
  }

  void _unregister(SlidingDrawerState state) {
    final removed = _states.remove(state);
    if (removed) {
      state.removeListener(_updateState);
      _refreshSortedStates();
    }
  }

  void _updateState() {
    double innerInsets = .0;
    double outerInsets = .0;
    double slideableLengths = .0;
    double nonSlideableLengths = .0;

    for (final state in _states) {
      if (state.onScrollableBounds) {
        innerInsets += state.position.maxHeight;
      } else {
        innerInsets += state.position.slideAmount;
        outerInsets += state.position.visibleHeight;
      }

      slideableLengths += state.position.slideableLength;
      nonSlideableLengths +=
          state.position.maxHeight - state.position.slideableLength;
    }

    setState(DrawersGroupState(
      inset: innerInsets,
      margin: outerInsets,
      slideableLength: slideableLengths,
      nonSlideableLength: nonSlideableLengths,
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
        state.relativeScrollOffset = slSum;
        slSum += state.position.slideableLength;
      }
    }

    _updateState();
  }

  void resetDrawerPositions() {
    for (final state in _states) {
      if (!state.isReverse) {
        state.open();
      }
    }
  }

  double _handleScroll(final double offset, final double offsetChange) {
    var groups =
        offsetChange < 0 ? _sortedStates.toList().reversed : _sortedStates;

    var remain = offsetChange;

    for (var group in groups) {
      final states = group.toList();
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
      remain = _parent?._handleScroll(offset, remain) ?? remain;
    }

    _updateState();
    return remain;
  }
}

typedef ScrollableInsetsBuilder = Widget Function(
    BuildContext, ScrollableInsetsState, Widget?);

class SlidingDrawersInsets extends StatefulWidget {
  const SlidingDrawersInsets({
    super.key,
    this.additionalPadding = EdgeInsets.zero,
    required this.child,
  })  : builder = null,
        _out = false;

  const SlidingDrawersInsets.outside({
    super.key,
    required this.child,
  })  : builder = null,
        _out = true,
        additionalPadding = EdgeInsets.zero;

  const SlidingDrawersInsets.builder({
    super.key,
    required ScrollableInsetsBuilder this.builder,
    this.child,
  })  : _out = false,
        additionalPadding = EdgeInsets.zero;

  static Widget top() => Builder(builder: (context) {
        return ValueListenableBuilder(
          valueListenable: _SlidingDrawersScope.of(context).top,
          builder: (context, topState, child) => SizedBox(
            height: topState.inset,
          ),
        );
      });

  static Widget bottom() => Builder(builder: (context) {
        return ValueListenableBuilder(
          valueListenable: _SlidingDrawersScope.of(context).bottom,
          builder: (context, bottomState, child) => SizedBox(
            height: bottomState.inset,
          ),
        );
      });

  final bool _out;
  final EdgeInsetsGeometry additionalPadding;
  final ScrollableInsetsBuilder? builder;
  final Widget? child;

  @override
  State<SlidingDrawersInsets> createState() {
    return _SlidingDrawersInsetsState();
  }
}

class _SlidingDrawersInsetsState extends State<SlidingDrawersInsets>
    with ScrollableInsetsState {
  _SlidingDrawersAreaState? _scope;
  _SlidingDrawersAreaState get scope {
    assert(_scope != null);
    return _scope!;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final newScope = _SlidingDrawersScope.of(context);
    if (_scope != newScope) {
      _scope
        ?..top.removeListener(rebuild)
        ..bottom.removeListener(rebuild);
      _scope = newScope
        ..top.addListener(rebuild)
        ..bottom.addListener(rebuild);
    }
  }

  @override
  void dispose() {
    super.dispose();

    _scope
      ?..top.removeListener(rebuild)
      ..bottom.removeListener(rebuild);
  }

  void rebuild() => setState(() {});

  @override
  EdgeInsets get insets => EdgeInsets.only(
        top: scope.top.value.inset,
        bottom: scope.bottom.value.inset,
      );

  @override
  EdgeInsets get outInsets => EdgeInsets.only(
        top: scope.top.value.margin,
        bottom: scope.bottom.value.margin,
      );

  @override
  EdgeInsets get slideableLengths => EdgeInsets.only(
        top: scope.top.value.slideableLength,
        bottom: scope.bottom.value.slideableLength,
      );

  @override
  EdgeInsets get nonSlideableLengths => EdgeInsets.only(
        top: scope.top.value.nonSlideableLength,
        bottom: scope.bottom.value.nonSlideableLength,
      );

  @override
  Widget build(BuildContext context) {
    return widget.builder != null
        ? widget.builder!(context, this, widget.child)
        : Padding(
            padding: (widget._out ? outInsets : insets)
                .add(widget.additionalPadding),
            child: widget.child,
          );
  }
}

mixin ScrollableInsetsState {
  EdgeInsets get insets;
  EdgeInsets get outInsets;
  EdgeInsets get slideableLengths;
  EdgeInsets get nonSlideableLengths;

  String insetsToString() {
    return "Insets: ${insets.top} < ${insets.bottom}, "
        "OutInsets: ${outInsets.top} < ${outInsets.bottom}, "
        "SlideableLength: ${slideableLengths.top} < ${slideableLengths.bottom}, "
        "NonSlideableLength: ${nonSlideableLengths.top} < ${nonSlideableLengths.bottom}";
  }
}
