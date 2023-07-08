import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import 'dart:math' as math;

extension WidgetListExtensions<X extends Widget> on List<X> {
  List<Widget> separated({Widget seperator = const Divider()}) {
    return [
      for (var child in this) ...[
        child,
        if (child != last) seperator,
      ]
    ];
  }

  List<Widget> spaced({double? width, double? height}) {
    late Widget spacer;
    if (width == null && height == null) {
      spacer = const SizedBox(
        width: formHorizontalSpacing,
        height: formVerticalSpacing,
      );
    } else {
      spacer = SizedBox(
        width: width,
        height: height,
      );
    }
    return [
      for (var (child) in this) ...[
        child,
        if (child != last) spacer,
      ]
    ];
  }
}

extension MediaQueryDataExtensions on MediaQueryData {
  EdgeInsets get safePadding =>
      padding.copyWith(bottom: math.max(padding.bottom, viewInsets.bottom));

  EdgeInsets get safeBottomPadding =>
      EdgeInsets.only(bottom: math.max(padding.bottom, viewInsets.bottom));
}

class SpacedColumn extends Column {
  SpacedColumn({
    super.key,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    List<Widget> children = const <Widget>[],
    double spacing = formVerticalSpacing,
  }) : super(
          children: children.spaced(height: spacing),
        );
}

class SpacedRow extends Row {
  SpacedRow({
    super.key,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    List<Widget> children = const <Widget>[],
    double spacing = formHorizontalSpacing,
  }) : super(
          children: children.spaced(width: spacing),
        );
}
