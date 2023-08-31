// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ln_core/ln_core.dart';

part 'sieve_target.dart';

class _SieveAreaScope extends InheritedWidget {
  final _SieveAreaState state;

  const _SieveAreaScope({required this.state, required super.child});

  @override
  bool updateShouldNotify(covariant _SieveAreaScope oldWidget) {
    return state != oldWidget.state;
  }

  static _SieveAreaState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_SieveAreaScope>();
    assert(scope != null, "No SieveArea found in context.");
    return scope!.state;
  }
}

class _SieveTargetRegistration {
  final _SieveTargetState _state;
  late final ValueNotifier<Rect?> replacementRect = ValueNotifier(null)
    ..addListener(() {
      _state.visible = replacementRect.value == null;
    });
  int order = 0;

  _SieveTargetRegistration({
    required _SieveTargetState state,
  }) : _state = state;

  @override
  bool operator ==(covariant _SieveTargetRegistration other) {
    if (identical(this, other)) return true;

    return other._state == _state;
  }

  @override
  int get hashCode => _state.hashCode;
}

class SieveArea extends StatefulWidget {
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final Widget child;
  const SieveArea({
    super.key,
    this.top,
    this.right,
    this.bottom,
    this.left,
    required this.child,
  });

  @override
  State<SieveArea> createState() => _SieveAreaState();
}

class _SieveAreaState extends LnState<SieveArea> {
  final Set<_SieveTargetRegistration> _sieveRegs = {};

  int generateOrderNumber() {
    return _sieveRegs.fold<int>(0, (max, reg) => math.max(reg.order, max)) + 1;
  }

  void register(_SieveTargetState state) {
    final registration = _SieveTargetRegistration(state: state);
    final ancestor = context.findRenderObject();
    if (ancestor != null) {
      registration.replacementRect.value = _calculateReplacementRect(
        state.renderTransform,
        ancestor,
      );
    }

    _sieveRegs.add(registration);
    rebuild();
  }

  void unregister(_SieveTargetState state) {
    _sieveRegs.removeWhere((reg) => reg._state == state);

    rebuild(postFrameCallback: true);
  }

  Rect? _calculateReplacementRect(
      RenderTransform renderTransform, RenderObject? ancestor) {
    final ancestorSize =
        ((ancestor ?? context.findRenderObject()) as RenderBox).size;

    final rect =
        renderTransform.localToGlobal(Offset.zero, ancestor: ancestor) &
            renderTransform.size;

    final bounds = Rect.fromLTRB(
      widget.left ?? double.negativeInfinity,
      widget.top ?? double.negativeInfinity,
      widget.right == null
          ? double.infinity
          : ancestorSize.width - widget.right!,
      widget.bottom == null
          ? double.infinity
          : ancestorSize.height - widget.bottom!,
    );

    Offset shift = Offset(
        math.max(bounds.left - rect.left, 0) +
            math.min(bounds.right - rect.right, 0),
        math.max(bounds.top - rect.top, 0) +
            math.min(bounds.bottom - rect.bottom, 0));

    if (shift == Offset.zero) return null;

    return rect.shift(shift);
  }

  @override
  Widget build(BuildContext context) {
    return _SieveAreaScope(
      state: this,
      child: NotificationListener(
        onNotification: (ScrollUpdateNotification scrollNotification) {
          var ancestor = context.findRenderObject();
          for (var reg in _sieveRegs) {
            reg.replacementRect.value = _calculateReplacementRect(
              reg._state.renderTransform,
              ancestor,
            );
          }

          return true;
        },
        child: Stack(
          children: [
            widget.child,
            for (var reg
                in _sieveRegs.toList()..sort((r1, r2) => r1.order - r2.order))
              ValueListenableBuilder(
                valueListenable: reg.replacementRect,
                builder: (BuildContext context, Rect? rect, Widget? child) =>
                    rect == null
                        ? SizedBox.shrink()
                        : Positioned(
                            left: rect.left,
                            top: rect.top,
                            width: rect.width,
                            height: rect.height,
                            child: child!,
                          ),
                child: reg._state.widget.child,
              ),
          ],
        ),
      ),
    );
  }
}
