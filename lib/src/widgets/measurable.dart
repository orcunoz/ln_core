import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

typedef OnSizeChange = void Function(Size? size);

class Measurable extends SingleChildRenderObjectWidget {
  const Measurable({super.key, required this.onChange, required super.child});

  final OnSizeChange onChange;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _MeasureSizeRenderObject(onChange);
}

class _MeasureSizeRenderObject extends RenderProxyBox {
  _MeasureSizeRenderObject(this.onChange);

  final OnSizeChange onChange;
  Size? _savedSize;

  @override
  void performLayout() {
    super.performLayout();
    final newSize = child?.size;
    if (_savedSize != newSize) {
      _savedSize = newSize;
      WidgetsBinding.instance.addPostFrameCallback((_) => onChange(newSize));
    }
  }
}
