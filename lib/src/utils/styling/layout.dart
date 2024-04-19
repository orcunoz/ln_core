import 'dart:ui';

import 'package:flutter/material.dart';

const kColumnWidth = 500.0;
const kDrawerShrinkedWidth = 78.0;
const kDrawerExpandedWidth = 310.0;

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

  static LayoutLevel of(BuildContext context) {
    return Theme.of(context).appLayout.levelOf(MediaQuery.of(context));
  }

  bool get isCompact => this == LayoutLevel.compact;
  bool get isMedium => this == LayoutLevel.medium;
  bool get isExpanded => this == LayoutLevel.expanded;
  bool get isExpandedPlus => this == LayoutLevel.expandedPlus;

  bool get isExpandedOrBigger => this >= LayoutLevel.expanded;
}

extension LayoutThemeDataExtension on ThemeData {
  LnLayoutExtension get appLayout => extension<LnLayoutExtension>()!;
}

class LnLayoutExtension extends ThemeExtension<LnLayoutExtension> {
  const LnLayoutExtension({
    this.columnWidth = kColumnWidth,
    this.dialogsMaxWidth = kColumnWidth,
    this.formsMaxWidth = kColumnWidth * 1.28,
    this.listsMaxWidth = kColumnWidth * 1.64,
    this.maxColumnWidth = kColumnWidth * 2,
    this.drawerShrinkedWidth = kDrawerShrinkedWidth,
    this.drawerExpandedWidth = kDrawerExpandedWidth,
    this.formsMargin = const EdgeInsets.symmetric(
      vertical: 12,
      horizontal: 16,
    ),
    this.listsMargin = const EdgeInsets.symmetric(
      horizontal: 12,
    ),
    this.formsButtonsAlignment = Alignment.center,
  });

  final double columnWidth;
  final double formsMaxWidth;
  final double listsMaxWidth;
  final double dialogsMaxWidth;
  final double maxColumnWidth;

  final double drawerShrinkedWidth;
  final double drawerExpandedWidth;

  final Alignment formsButtonsAlignment;
  final EdgeInsets formsMargin;
  final EdgeInsets listsMargin;

  double get compactLayoutThreshold => columnWidth + drawerShrinkedWidth;
  double get expandedLayoutThreshold =>
      2 * columnWidth + drawerShrinkedWidth + 200;
  double get expandedPlusLayoutThreshold =>
      2 * columnWidth + drawerExpandedWidth + 200;
  double get maxDialogWidth => compactLayoutThreshold - 40;

  LayoutLevel levelOf(MediaQueryData mediaQuery) =>
      switch (mediaQuery.size.width) {
        var w when w < compactLayoutThreshold => LayoutLevel.compact,
        var w when w < expandedLayoutThreshold => LayoutLevel.medium,
        var w when w < expandedPlusLayoutThreshold => LayoutLevel.expanded,
        _ => LayoutLevel.expandedPlus,
      };

  @override
  ThemeExtension<LnLayoutExtension> copyWith({
    double? columnWidth,
    double? formsMaxWidth,
    double? listsMaxWidth,
    double? dialogsMaxWidth,
    double? maxColumnWidth,
    double? drawerShrinkedWidth,
    double? drawerExpandedWidth,
    Alignment? formsButtonsAlignment,
    EdgeInsets? formsMargin,
    EdgeInsets? listsMargin,
    double? horizontalSpacer,
  }) {
    return LnLayoutExtension(
      columnWidth: columnWidth ?? this.columnWidth,
      formsMaxWidth: formsMaxWidth ?? this.formsMaxWidth,
      listsMaxWidth: listsMaxWidth ?? this.listsMaxWidth,
      dialogsMaxWidth: dialogsMaxWidth ?? this.dialogsMaxWidth,
      maxColumnWidth: maxColumnWidth ?? this.maxColumnWidth,
      drawerShrinkedWidth: drawerShrinkedWidth ?? this.drawerShrinkedWidth,
      drawerExpandedWidth: drawerExpandedWidth ?? this.drawerExpandedWidth,
      formsButtonsAlignment:
          formsButtonsAlignment ?? this.formsButtonsAlignment,
      formsMargin: formsMargin ?? this.formsMargin,
      listsMargin: listsMargin ?? this.listsMargin,
    );
  }

  @override
  ThemeExtension<LnLayoutExtension> lerp(
      covariant LnLayoutExtension other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return LnLayoutExtension(
        columnWidth: lerpDouble(columnWidth, other.columnWidth, t)!,
        formsMaxWidth: lerpDouble(formsMaxWidth, other.formsMaxWidth, t)!,
        listsMaxWidth: lerpDouble(listsMaxWidth, other.listsMaxWidth, t)!,
        dialogsMaxWidth: lerpDouble(dialogsMaxWidth, other.dialogsMaxWidth, t)!,
        maxColumnWidth: lerpDouble(maxColumnWidth, other.maxColumnWidth, t)!,
        drawerShrinkedWidth:
            lerpDouble(drawerShrinkedWidth, other.drawerShrinkedWidth, t)!,
        drawerExpandedWidth:
            lerpDouble(drawerExpandedWidth, other.drawerExpandedWidth, t)!,
        formsMargin: EdgeInsets.lerp(formsMargin, other.formsMargin, t)!,
        listsMargin: EdgeInsets.lerp(listsMargin, other.listsMargin, t)!,
        formsButtonsAlignment:
            t < .5 ? formsButtonsAlignment : other.formsButtonsAlignment,
      );
    }
  }
}
