import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension RenderObjectExtensions on RenderObject {
  Future<void> ensureVisible(
    ScrollPosition scrollPosition, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeIn,
  }) {
    final viewport = RenderAbstractViewport.of(this);

    late double alignment;

    if (scrollPosition.pixels > viewport.getOffsetToReveal(this, 0.0).offset) {
      // Move down to the top of the viewport
      alignment = 0;
    } else if (scrollPosition.pixels <
        viewport.getOffsetToReveal(this, 1.0).offset) {
      // Move up to the bottom of the viewport
      alignment = 1.0;
    } else {
      return Future.value(null);
    }

    return scrollPosition.ensureVisible(
      this,
      alignment: alignment,
      duration: duration,
      curve: curve,
    );
  }
}
