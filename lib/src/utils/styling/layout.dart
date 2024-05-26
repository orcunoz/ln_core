import 'package:flutter/material.dart';

enum LayoutLevel {
  compact(1),
  medium(2),
  expanded(3),
  large(4);

  const LayoutLevel(this.value);

  final int value;

  bool operator <(LayoutLevel operand) => value < operand.value;

  bool operator <=(LayoutLevel operand) => value <= operand.value;

  bool operator >(LayoutLevel operand) => value > operand.value;

  bool operator >=(LayoutLevel operand) => value >= operand.value;
}

extension LayoutLevelMediaQueryDataExtensions on MediaQueryData {
  bool get isCompact => layoutLevel == LayoutLevel.compact;
  bool get isMedium => layoutLevel == LayoutLevel.medium;
  bool get isExpanded => layoutLevel == LayoutLevel.expanded;
  bool get isLarge => layoutLevel == LayoutLevel.large;

  bool get isExpandedOrLarger => layoutLevel >= LayoutLevel.expanded;

  LayoutLevel get layoutLevel => switch (size.width) {
        var w when w < LnLayoutConstants.compactLayoutThreshold =>
          LayoutLevel.compact,
        var w when w < LnLayoutConstants.mediumLayoutThreshold =>
          LayoutLevel.medium,
        var w when w < LnLayoutConstants.expandedLayoutThreshold =>
          LayoutLevel.expanded,
        _ => LayoutLevel.large,
      };
}

abstract final class LnLayoutConstants {
  static const double menuWidth = 300;
  static const double columnWidth = 480;
  static const double compactLayoutThreshold = columnWidth + 100;
  static const double mediumLayoutThreshold = 2 * columnWidth + 200;
  static const double expandedLayoutThreshold =
      2 * columnWidth + 100 + menuWidth;
}
