import 'package:flutter/material.dart';

import 'dart:math' as math;

const kVerticalSpacing = 14.0;
const kHorizontalSpacing = 8.0;

extension WidgetListExtensions<X extends Widget> on List<X> {
  List<Widget> separated([Widget separator = const Divider()]) {
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
        width: kHorizontalSpacing,
        height: kVerticalSpacing,
      );
    } else {
      spacer = SizedBox(
        width: width,
        height: height,
      );
    }
    return [
      for (var child in this) ...[
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
    double spacing = kVerticalSpacing,
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
    Widget separator = const Divider(height: .5, thickness: .5),
  }) : super(
          children: children.separated(separator),
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
    double spacing = kHorizontalSpacing,
  }) : super(children: children.spaced(width: spacing));
}

class SeparatedRow extends Row {
  SeparatedRow({
    super.key,
    super.mainAxisAlignment,
    super.mainAxisSize,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.textBaseline,
    List<Widget> children = const <Widget>[],
    Widget separator = const VerticalDivider(width: .5, thickness: .5),
  }) : super(children: children.separated(separator));
}

class SpacedWrap extends Wrap {
  const SpacedWrap({
    super.key,
    super.direction,
    super.alignment,
    super.spacing = kHorizontalSpacing,
    super.runAlignment,
    super.runSpacing = kVerticalSpacing,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.clipBehavior,
    super.children,
  });
}
