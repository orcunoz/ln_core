import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import 'dart:math' as math;

part 'sliding_drawer.dart';

class _SlidingDrawersScope extends InheritedWidget {
  final _SlidingDrawersAreaState state;

  const _SlidingDrawersScope({required this.state, required super.child});

  @override
  bool updateShouldNotify(covariant _SlidingDrawersScope oldWidget) {
    return state != oldWidget.state;
  }

  static _SlidingDrawersAreaState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_SlidingDrawersScope>();
    assert(scope != null, "No SlidingDrawersArea found in context.");
    return scope!.state;
  }
}

class SlidingDrawersArea extends StatefulWidget {
  const SlidingDrawersArea({
    super.key,
    this.topDrawers = const [],
    this.bottomDrawers = const [],
    required this.child,
  });

  final List<SlidingDrawer> topDrawers;
  final List<SlidingDrawer> bottomDrawers;
  final Widget child;

  @override
  State<SlidingDrawersArea> createState() => _SlidingDrawersAreaState();
}

class _SlidingDrawersAreaState extends State<SlidingDrawersArea> {
  final Set<SlidingDrawerState> _drawers = <SlidingDrawerState>{};
  double? _lastOffset;
  double? _lastHeight;
  int? _depth;

  final ValueNotifier<EdgeInsets> _padding = ValueNotifier(EdgeInsets.zero);
  final ValueNotifier<bool> _absorbing = ValueNotifier(true);

  void register(SlidingDrawerState drawer) {
    _drawers.add(drawer);
  }

  void unregister(SlidingDrawerState drawer) {
    _drawers.remove(drawer);
  }

  void _handleUpdate(int depth, double offset, double offsetChange) {
    //Log.wtf("$offsetChange");

    _depth = depth;
    _lastOffset = offset;

    /*final topDrawers =
        _drawers.where((e) => e.widget.position == DrawerPosition.top).toList();
    var remain = offsetChange;
    for (var drawer in topDrawers) {
      remain += drawer.updateState(offset, remain);
    }*/

    final bottomDrawers = _drawers
        .where((e) => e.widget.position == DrawerPosition.bottom)
        .toList();
    var remain = offsetChange;
    for (var drawer in bottomDrawers) {
      remain -= drawer.updateState(offset, remain);
    }

    /*_padding.value = EdgeInsets.only(
      top: topDrawers.fold(
          0,
          (previousValue, item) =>
              previousValue + (item._computedHeight.value ?? .0)),
      bottom: bottomDrawers.fold(
          0,
          (previousValue, item) =>
              previousValue + (item._computedHeight.value ?? .0)),
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return _SlidingDrawersScope(
      state: this,
      child: NotificationListener(
        onNotification: (Notification notification) {
          if (notification is OverscrollNotification &&
              notification.metrics.axis == Axis.vertical &&
              notification.depth <= (_depth ?? 999)) {
            final newOffset = notification.metrics.extentBefore;
            final offsetChange = notification.overscroll;

            _handleUpdate(notification.depth, newOffset, offsetChange);
          }

          if (notification is ScrollUpdateNotification &&
              notification.metrics.axis == Axis.vertical &&
              notification.depth <= (_depth ?? 999)) {
            final newOffset = notification.metrics.extentBefore;
            final offsetChange = newOffset - (_lastOffset ?? newOffset);

            _handleUpdate(notification.depth, newOffset, offsetChange);
          }

          return true;
        },
        child: Column(
          children: [
            Expanded(
              child: widget.topDrawers.isNotEmpty
                  ? NestedScrollView(
                      floatHeaderSlivers: true,
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          for (var drawer in widget.topDrawers
                              .where((d) => d.child != null)
                              .toList())
                            SliverToBoxAdapter(
                              child: drawer,
                            ),
                        ];
                      },
                      body: widget.child,
                    )
                  : widget.child,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.bottomDrawers,
            ),
          ],
        ),
      ),
    );
  }
}

/*class _SlidingDrawersScrollViewState extends State<SlidingDrawersScrollView> {
  double? _measuredBottomDrawersHeight;
  final ValueNotifier<double?> _computedBottomDrawersHeight =
      ValueNotifier<double?>(null);

  Widget _wrapTopDrawerContainer(
    BuildContext context,
    Widget topDrawer,
    Widget child,
  ) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverToBoxAdapter(
            child: topDrawer,
          ),
        ];
      },
      body: child,
    );
  }

  Widget _wrapBottomDrawerContainer(
    BuildContext context,
    Widget bottomDrawer,
    Widget child,
  ) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (ScrollUpdateNotification notification) {
        if (notification.scrollDelta != null &&
            _measuredBottomDrawersHeight != null) {
          var height = (_computedBottomDrawersHeight.value ??
                  _measuredBottomDrawersHeight!) +
              notification.scrollDelta!;

          height = math.min(height, _measuredBottomDrawersHeight!);
          height = math.max(height, 0);

          _computedBottomDrawersHeight.value = height;
        }
        return false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: child,
          ),
          ListenableBuilder(
            listenable: _computedBottomDrawersHeight,
            builder: (context, child) => SizedOverflowBox(
              alignment: Alignment.topCenter,
              size: Size.fromHeight(_computedBottomDrawersHeight.value ?? 0),
              child: child,
            ),
            child: Measurable(
              onLayout: (size) {
                _measuredBottomDrawersHeight = size.height;
                _computedBottomDrawersHeight.value ??= size.height;
              },
              child: bottomDrawer,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child ?? SizedBox.shrink();

    if (widget.padding != null) {
      child = Padding(
        padding: widget.padding!,
        child: widget.child,
      );
    }

    if (widget.topDrawer != null) {
      child = _wrapTopDrawerContainer(context, widget.topDrawer!, child);
    }

    if (widget.bottomDrawer != null) {
      child = _wrapBottomDrawerContainer(context, widget.bottomDrawer!, child);
    }

    return Listener(
      onPointerMove: (event) => Log.wtf(event.delta),
      child: child,
    );
  }
}*/