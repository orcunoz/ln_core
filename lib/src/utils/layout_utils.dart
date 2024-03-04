import 'package:flutter/material.dart';

import 'dart:math' as math;

import '../../ln_core.dart';

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
        width: UI.formHorizontalSpacing,
        height: UI.formVerticalSpacing,
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

enum LayoutLevel {
  compact(1),
  medium(2),
  expanded(3),
  expandedPlus(4);

  const LayoutLevel(this.value);

  final int value;

  bool operator <(LayoutLevel operand) => value < operand.value;

  bool operator <=(LayoutLevel operand) => value <= operand.value;

  bool operator >(LayoutLevel operand) => value > operand.value;

  bool operator >=(LayoutLevel operand) => value >= operand.value;
}

extension MediaQueryDataExtensions on MediaQueryData {
  bool get isCompact => layoutLevel == LayoutLevel.compact;
  bool get isMedium => layoutLevel == LayoutLevel.medium;
  bool get isExpanded => layoutLevel == LayoutLevel.expanded;
  bool get isExpandedPlus => layoutLevel == LayoutLevel.expandedPlus;

  bool get isExpandedOrWider => layoutLevel >= LayoutLevel.expanded;

  LayoutLevel get layoutLevel => switch (size.width) {
        < UI.compactLayoutThreshold => LayoutLevel.compact,
        < UI.expandedLayoutThreshold => LayoutLevel.medium,
        < UI.expandedPlusLayoutThreshold => LayoutLevel.expanded,
        _ => LayoutLevel.expandedPlus,
      };

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
    double spacing = UI.formVerticalSpacing,
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
    double spacing = UI.formHorizontalSpacing,
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
    super.spacing = UI.formHorizontalSpacing,
    super.runAlignment,
    super.runSpacing = UI.formVerticalSpacing,
    super.crossAxisAlignment,
    super.textDirection,
    super.verticalDirection,
    super.clipBehavior,
    super.children,
  });
}
