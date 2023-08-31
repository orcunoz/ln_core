import 'package:flutter/material.dart';

abstract class ScrollListenerWidget implements StatefulWidget {
  ScrollController? get scrollController;
}

mixin ScrollListenerState<T extends ScrollListenerWidget> on State<T> {
  double? _lastOffset;
  double? _offsetChangeDirection;
  double _changeSumInDirection = 0;

  ScrollPosition? get scrollPosition => widget.scrollController?.positions
      .where((p) => p.axis == Axis.vertical)
      .firstOrNull;

  onScrollChanged(double offset, double changeAmount, bool directionChanged,
      double changeAmountInSameDirection);

  _updateScrollValues() {
    double changeAmount = 0;
    final scrollPosition = this.scrollPosition;
    if (scrollPosition == null) return;

    if (_lastOffset != scrollPosition.pixels) {
      changeAmount =
          _lastOffset == null ? 0 : scrollPosition.pixels - _lastOffset!;
      _lastOffset = scrollPosition.pixels;
    }

    final directionChanged = _offsetChangeDirection != changeAmount.sign;
    if (directionChanged) {
      _changeSumInDirection = 0;
    }
    _changeSumInDirection += changeAmount;
    _offsetChangeDirection = changeAmount.sign;
/*
    Rect? targetRect = (renderObject as RenderBox).localToGlobal(Offset.zero, ancestor: viewport);
    /*if (targetRenderObject != null && targetRenderObject != object) {
      targetRect = MatrixUtils.transformRect(
        targetRenderObject.getTransformTo(object),
        object.paintBounds.intersect(targetRenderObject.paintBounds),
      );
    }*/

    double target;
    switch (alignmentPolicy) {
      case ScrollPositionAlignmentPolicy.explicit:
        target = clampDouble(viewport.getOffsetToReveal(object, alignment, rect: targetRect).offset, minScrollExtent, maxScrollExtent);
      case ScrollPositionAlignmentPolicy.keepVisibleAtEnd:
        target = clampDouble(viewport.getOffsetToReveal(object, 1.0, rect: targetRect).offset, minScrollExtent, maxScrollExtent);
        if (target < pixels) {
          target = pixels;
        }
      case ScrollPositionAlignmentPolicy.keepVisibleAtStart:
        target = clampDouble(viewport.getOffsetToReveal(object, 0.0, rect: targetRect).offset, minScrollExtent, maxScrollExtent);
        if (target > pixels) {
          target = pixels;
        }
    }
*/

    if (changeAmount != 0) {
      onScrollChanged(
          _lastOffset!, changeAmount, directionChanged, _changeSumInDirection);
    }
  }

  @override
  void initState() {
    super.initState();

    widget.scrollController?.addListener(_updateScrollValues);
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.scrollController != oldWidget.scrollController) {
      oldWidget.scrollController?.removeListener(_updateScrollValues);
      widget.scrollController?.addListener(_updateScrollValues);
    }
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_updateScrollValues);
    super.dispose();
  }
}
