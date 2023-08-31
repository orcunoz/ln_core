import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Measurable extends SingleChildRenderObjectWidget {
  const Measurable({
    super.key,
    this.onLayout,
    this.afterLayout,
    required super.child,
  });

  final ValueChanged<Size>? onLayout;
  final ValueChanged<Size>? afterLayout;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _MeasurableRenderObject(onLayout, afterLayout);
}

class _MeasurableRenderObject extends RenderProxyBox {
  _MeasurableRenderObject(this.onLayout, this.afterLayout);

  final ValueChanged<Size>? onLayout;
  final ValueChanged<Size>? afterLayout;

  @override
  void performLayout() {
    super.performLayout();

    if (onLayout != null) onLayout!(size);
    if (afterLayout != null) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        afterLayout!(size);
      });
    }
  }
}
