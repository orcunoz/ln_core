import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import 'dart:math' as math;

extension WidgetListExtensions<X extends Widget> on List<X> {
  List<Widget> separated({Widget separator = const Divider()}) {
    return [
      for (var child in this) ...[
        child,
        if (child != last) separator,
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

class SeparatedColumn extends Column {
  SeparatedColumn({
    super.key,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    List<Widget> children = const <Widget>[],
    Widget separator = const Divider(
      height: .5,
      thickness: .5,
    ),
  }) : super(
          children: children.separated(separator: separator),
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

class SeperatedRow extends Row {
  SeperatedRow({
    super.key,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    List<Widget> children = const <Widget>[],
    Widget separator = const VerticalDivider(
      width: .5,
      thickness: .5,
    ),
  }) : super(
          children: children.separated(separator: separator),
        );
}

class SpacedWrap extends Wrap {
  const SpacedWrap({
    super.key,
    super.direction,
    super.alignment,
    super.spacing = formHorizontalSpacing,
    super.runAlignment,
    super.runSpacing = formVerticalSpacing,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.clipBehavior,
    super.children,
  });
}
