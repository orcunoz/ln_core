import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

extension DrawerAlignmentThemeExtension on DrawerAlignment {
  TextDirection get direction => switch (this) {
        DrawerAlignment.start => TextDirection.ltr,
        DrawerAlignment.end => TextDirection.rtl,
      };
}

extension LnThemeDataExtension on ThemeData {
  LnComputedTheme get ln {
    final layoutTheme = extension<LnComputedTheme>();
    assert(layoutTheme != null, "LnTheme extension is required.");
    return layoutTheme!;
  }
}

class LnComputedTheme extends ThemeExtension<LnComputedTheme>
    implements LnThemeData {
  const LnComputedTheme({
    required this.dialogsMaxWidth,
    required this.formsMaxWidth,
    required this.listsMaxWidth,
    required this.maxColumnWidth,
    required this.formsMargin,
    required this.listsMargin,
    required this.listsPadding,
    required this.listsSeparator,
    required this.listItemsBorderRadius,
    required this.listItemsBorderSide,
    required this.listItemsColor,
    required this.listItemsIndicatorColor,
    required this.listItemsElevation,
    required this.listItemsPadding,
    required this.listItemsTitleStyle,
    required this.listItemsDescriptionStyle,
    required this.listItemsTimeStampStyle,
    required this.appBarDecoration,
    required this.formsButtonsAlignment,
    required this.backdropColor,
    required this.containerColor,
    required this.paneContainerColor,
    required this.paneColor,
    required this.subPaneColor,
    required this.containerDecoration,
    required this.paneContainerDecoration,
    required this.paneDecoration,
    required this.subPaneDecoration,
    required this.paneHeaderDecoration,
    required this.paneBottomDecoration,
    required this.paneBodyDecoration,
    required this.slidingDrawerDividers,
    required this.slidingDrawerDividerDecoration,
    required this.backdropPadding,
    required this.containerPadding,
    required this.layoutAnimationsDuration,
    required this.layoutAnimationsCurve,
    required this.menuAlignment,
    required this.menuWidth,
    required this.menuAnimationScaleFactor,
    required this.menuDecoration,
    required this.shrinkedMenuDecoration,
  });

  @override
  final double dialogsMaxWidth;

  @override
  final double formsMaxWidth;

  @override
  final double listsMaxWidth;

  @override
  final double maxColumnWidth;

  @override
  final EdgeInsets formsMargin;

  @override
  final BorderRadius listItemsBorderRadius;

  @override
  final BorderSide listItemsBorderSide;

  @override
  final Color listItemsColor;

  @override
  final Color listItemsIndicatorColor;

  @override
  final double listItemsElevation;

  @override
  final Widget? listsSeparator;

  @override
  final EdgeInsets listsMargin;

  @override
  final EdgeInsets listsPadding;

  @override
  final EdgeInsets listItemsPadding;

  @override
  final TextStyle listItemsTitleStyle;

  @override
  final TextStyle listItemsDescriptionStyle;

  @override
  final TextStyle listItemsTimeStampStyle;

  @override
  final LnSurfaceDecoration? appBarDecoration;

  @override
  final Alignment formsButtonsAlignment;

  @override
  final Color backdropColor;

  @override
  final DrawerAlignment menuAlignment;

  @override
  final double menuWidth;

  @override
  final double menuAnimationScaleFactor;

  @override
  final EdgeInsets? backdropPadding;

  @override
  final EdgeInsets? containerPadding;

  final Color containerColor;

  final Color paneContainerColor;

  final Color paneColor;

  final Color subPaneColor;

  @override
  final LnSurfaceDecoration? containerDecoration;

  @override
  final LnSurfaceDecoration? paneContainerDecoration;

  @override
  final LnSurfaceDecoration? paneDecoration;

  @override
  final LnSurfaceDecoration? subPaneDecoration;

  @override
  final LnSurfaceDecoration? paneHeaderDecoration;

  @override
  final LnSurfaceDecoration? paneBottomDecoration;

  @override
  final LnSurfaceDecoration? paneBodyDecoration;

  @override
  final bool slidingDrawerDividers;

  @override
  final BoxDecoration? slidingDrawerDividerDecoration;

  @override
  final Duration layoutAnimationsDuration;

  @override
  final Curve layoutAnimationsCurve;

  final LnVerticalMenuDecoration menuDecoration;
  final LnVerticalMenuDecoration? shrinkedMenuDecoration;

  double? get shrinkedMenuWidth {
    if (shrinkedMenuDecoration == null) return null;

    return shrinkedMenuDecoration!.horizontalInsetsSum +
        (shrinkedMenuDecoration!.itemDecoration.iconTheme.size ?? 20.0);
  }

  double get expandedMenuItemInsideWidth =>
      menuWidth - menuDecoration.horizontalInsetsSum;

  Color get drawerBackColor {
    return menuDecoration.backgroundColor == Colors.transparent
        ? backdropColor
        : menuDecoration.backgroundColor;
  }

  @override
  ThemeExtension<LnComputedTheme> copyWith({
    double? formsMaxWidth,
    double? listsMaxWidth,
    double? dialogsMaxWidth,
    double? maxColumnWidth,
    Alignment? formsButtonsAlignment,
    EdgeInsets? formsMargin,
    EdgeInsets? listsMargin,
    EdgeInsets? listsPadding,
    Widget? listsSeparator,
    BorderRadius? listItemsBorderRadius,
    BorderSide? listItemsBorderSide,
    Color? listItemsColor,
    Color? listItemsIndicatorColor,
    double? listItemsElevation,
    EdgeInsets? listItemsPadding,
    TextStyle? listItemsTitleStyle,
    TextStyle? listItemsDescriptionStyle,
    TextStyle? listItemsTimeStampStyle,
    LnSurfaceDecoration? appBarDecoration,
    Color? backdropColor,
    EdgeInsets? backdropPadding,
    EdgeInsets? containerPadding,
    EdgeInsets? containerMargin,
    EdgeInsets? paneMargin,
    EdgeInsets? subPaneMargin,
    Color? containerColor,
    Color? paneContainerColor,
    Color? paneColor,
    Color? subPaneColor,
    LnSurfaceDecoration? containerDecoration,
    LnSurfaceDecoration? paneContainerDecoration,
    LnSurfaceDecoration? paneDecoration,
    LnSurfaceDecoration? subPaneDecoration,
    LnSurfaceDecoration? paneHeaderDecoration,
    LnSurfaceDecoration? paneBottomDecoration,
    LnSurfaceDecoration? paneBodyDecoration,
    bool? slidingDrawerDividers,
    BoxDecoration? slidingDrawerDividerDecoration,
    Duration? layoutAnimationsDuration,
    Curve? layoutAnimationsCurve,
    DrawerAlignment? menuAlignment,
    double? menuWidth,
    double? menuAnimationScaleFactor,
    LnVerticalMenuDecoration? shrinkedMenuDecoration,
    LnVerticalMenuDecoration? menuDecoration,
  }) {
    return LnComputedTheme(
      formsMaxWidth: formsMaxWidth ?? this.formsMaxWidth,
      listsMaxWidth: listsMaxWidth ?? this.listsMaxWidth,
      dialogsMaxWidth: dialogsMaxWidth ?? this.dialogsMaxWidth,
      maxColumnWidth: maxColumnWidth ?? this.maxColumnWidth,
      formsButtonsAlignment:
          formsButtonsAlignment ?? this.formsButtonsAlignment,
      formsMargin: formsMargin ?? this.formsMargin,
      listsMargin: listsMargin ?? this.listsMargin,
      listsPadding: listsPadding ?? this.listsPadding,
      listsSeparator: listsSeparator ?? this.listsSeparator,
      listItemsBorderRadius:
          listItemsBorderRadius ?? this.listItemsBorderRadius,
      listItemsBorderSide: listItemsBorderSide ?? this.listItemsBorderSide,
      listItemsColor: listItemsColor ?? this.listItemsColor,
      listItemsIndicatorColor:
          listItemsIndicatorColor ?? this.listItemsIndicatorColor,
      listItemsElevation: listItemsElevation ?? this.listItemsElevation,
      listItemsPadding: listItemsPadding ?? this.listItemsPadding,
      listItemsTitleStyle: listItemsTitleStyle ?? this.listItemsTitleStyle,
      listItemsDescriptionStyle:
          listItemsDescriptionStyle ?? this.listItemsDescriptionStyle,
      listItemsTimeStampStyle:
          listItemsTimeStampStyle ?? this.listItemsTimeStampStyle,
      appBarDecoration: appBarDecoration ?? this.appBarDecoration,
      backdropColor: backdropColor ?? this.backdropColor,
      backdropPadding: backdropPadding ?? this.backdropPadding,
      containerColor: containerColor ?? this.containerColor,
      paneContainerColor: paneContainerColor ?? this.paneContainerColor,
      paneColor: paneColor ?? this.paneColor,
      subPaneColor: subPaneColor ?? this.subPaneColor,
      containerPadding: containerPadding ?? this.containerPadding,
      containerDecoration: containerDecoration ?? this.containerDecoration,
      paneContainerDecoration:
          paneContainerDecoration ?? this.paneContainerDecoration,
      paneDecoration: paneDecoration ?? this.paneDecoration,
      subPaneDecoration: subPaneDecoration ?? this.subPaneDecoration,
      paneHeaderDecoration: paneHeaderDecoration ?? this.paneHeaderDecoration,
      paneBottomDecoration: paneBottomDecoration ?? this.paneBottomDecoration,
      paneBodyDecoration: paneBodyDecoration ?? this.paneBodyDecoration,
      slidingDrawerDividers:
          slidingDrawerDividers ?? this.slidingDrawerDividers,
      slidingDrawerDividerDecoration:
          slidingDrawerDividerDecoration ?? this.slidingDrawerDividerDecoration,
      layoutAnimationsDuration:
          layoutAnimationsDuration ?? this.layoutAnimationsDuration,
      layoutAnimationsCurve:
          layoutAnimationsCurve ?? this.layoutAnimationsCurve,
      menuAlignment: menuAlignment ?? this.menuAlignment,
      menuWidth: menuWidth ?? this.menuWidth,
      menuAnimationScaleFactor:
          menuAnimationScaleFactor ?? this.menuAnimationScaleFactor,
      shrinkedMenuDecoration:
          shrinkedMenuDecoration ?? this.shrinkedMenuDecoration,
      menuDecoration: menuDecoration ?? this.menuDecoration,
    );
  }

  @override
  LnComputedTheme lerp(covariant LnComputedTheme other, double t) {
    if (t == 0) {
      return this;
    } else if (t == 1) {
      return other;
    } else {
      return LnComputedTheme(
        formsMaxWidth: lerpDouble(formsMaxWidth, other.formsMaxWidth, t)!,
        listsMaxWidth: lerpDouble(listsMaxWidth, other.listsMaxWidth, t)!,
        dialogsMaxWidth: lerpDouble(dialogsMaxWidth, other.dialogsMaxWidth, t)!,
        maxColumnWidth: lerpDouble(maxColumnWidth, other.maxColumnWidth, t)!,
        formsButtonsAlignment:
            t < .5 ? formsButtonsAlignment : other.formsButtonsAlignment,
        formsMargin: EdgeInsets.lerp(formsMargin, other.formsMargin, t)!,
        listsMargin: EdgeInsets.lerp(listsMargin, other.listsMargin, t)!,
        listsPadding: EdgeInsets.lerp(listsPadding, other.listsPadding, t)!,
        listsSeparator: t < .5 ? listsSeparator : other.listsSeparator,
        listItemsBorderRadius: BorderRadius.lerp(
            listItemsBorderRadius, other.listItemsBorderRadius, t)!,
        listItemsBorderSide:
            BorderSide.lerp(listItemsBorderSide, other.listItemsBorderSide, t),
        listItemsColor: Color.lerp(listItemsColor, other.listItemsColor, t)!,
        listItemsIndicatorColor: Color.lerp(
            listItemsIndicatorColor, other.listItemsIndicatorColor, t)!,
        listItemsElevation:
            lerpDouble(listItemsElevation, other.listItemsElevation, t)!,
        listItemsPadding:
            EdgeInsets.lerp(listItemsPadding, other.listItemsPadding, t)!,
        listItemsTitleStyle:
            TextStyle.lerp(listItemsTitleStyle, other.listItemsTitleStyle, t)!,
        listItemsDescriptionStyle: TextStyle.lerp(
            listItemsDescriptionStyle, other.listItemsDescriptionStyle, t)!,
        listItemsTimeStampStyle: TextStyle.lerp(
            listItemsTimeStampStyle, other.listItemsTimeStampStyle, t)!,
        appBarDecoration: LnSurfaceDecoration.lerp(
            appBarDecoration, other.appBarDecoration, t),
        backdropColor: Color.lerp(backdropColor, other.backdropColor, t)!,
        backdropPadding:
            EdgeInsets.lerp(backdropPadding, other.backdropPadding, t),
        containerPadding:
            EdgeInsets.lerp(containerPadding, other.containerPadding, t),
        containerColor: Color.lerp(containerColor, other.containerColor, t)!,
        paneContainerColor:
            Color.lerp(paneContainerColor, other.paneContainerColor, t)!,
        paneColor: Color.lerp(paneColor, other.paneColor, t)!,
        subPaneColor: Color.lerp(subPaneColor, other.subPaneColor, t)!,
        containerDecoration: LnSurfaceDecoration.lerp(
            containerDecoration, other.containerDecoration, t),
        paneContainerDecoration: LnSurfaceDecoration.lerp(
            paneContainerDecoration, other.paneContainerDecoration, t),
        paneDecoration:
            LnSurfaceDecoration.lerp(paneDecoration, other.paneDecoration, t),
        subPaneDecoration: LnSurfaceDecoration.lerp(
            subPaneDecoration, other.subPaneDecoration, t),
        paneHeaderDecoration: LnSurfaceDecoration.lerp(
            paneHeaderDecoration, other.paneHeaderDecoration, t),
        paneBottomDecoration: LnSurfaceDecoration.lerp(
            paneBottomDecoration, other.paneBottomDecoration, t),
        paneBodyDecoration: LnSurfaceDecoration.lerp(
            paneBodyDecoration, other.paneBodyDecoration, t),
        slidingDrawerDividers:
            t < .5 ? slidingDrawerDividers : other.slidingDrawerDividers,
        slidingDrawerDividerDecoration: BoxDecoration.lerp(
            slidingDrawerDividerDecoration,
            other.slidingDrawerDividerDecoration,
            t),
        layoutAnimationsDuration:
            t < .5 ? layoutAnimationsDuration : other.layoutAnimationsDuration,
        layoutAnimationsCurve:
            t < .5 ? layoutAnimationsCurve : other.layoutAnimationsCurve,
        menuWidth: lerpDouble(menuWidth, other.menuWidth, t)!,
        menuDecoration: LnVerticalMenuDecoration.lerp(
            menuDecoration, other.menuDecoration, t)!,
        menuAlignment: t < .5 ? menuAlignment : other.menuAlignment,
        shrinkedMenuDecoration: LnVerticalMenuDecoration.lerp(
            shrinkedMenuDecoration, other.shrinkedMenuDecoration, t),
        menuAnimationScaleFactor: lerpDouble(
            menuAnimationScaleFactor, other.menuAnimationScaleFactor, t)!,
      );
    }
  }
}

abstract class LnThemeData {
  const LnThemeData({
    this.dialogsMaxWidth,
    this.formsMaxWidth,
    this.listsMaxWidth,
    this.maxColumnWidth,
    this.formsMargin,
    this.listsMargin,
    this.listsPadding,
    this.listsSeparator,
    this.listItemsBorderRadius,
    this.listItemsBorderSide,
    this.listItemsColor,
    this.listItemsIndicatorColor,
    this.listItemsElevation,
    this.listItemsPadding,
    this.listItemsTitleStyle,
    this.listItemsDescriptionStyle,
    this.listItemsTimeStampStyle,
    this.appBarDecoration,
    this.formsButtonsAlignment,
    this.backdropColor,
    this.backdropPadding,
    this.containerPadding,
    this.containerDecoration,
    this.paneContainerDecoration,
    this.paneDecoration,
    this.subPaneDecoration,
    this.paneHeaderDecoration,
    this.paneBottomDecoration,
    this.paneBodyDecoration,
    this.slidingDrawerDividers,
    this.slidingDrawerDividerDecoration,
    this.layoutAnimationsDuration,
    this.layoutAnimationsCurve,
    this.menuAlignment,
    this.menuWidth,
    this.menuAnimationScaleFactor,
  });

  final double? formsMaxWidth;
  final double? listsMaxWidth;
  final double? dialogsMaxWidth;
  final double? maxColumnWidth;

  final Alignment? formsButtonsAlignment;
  final EdgeInsets? formsMargin;
  final EdgeInsets? listsMargin;

  final EdgeInsets? listsPadding;
  final EdgeInsets? listItemsPadding;
  final Widget? listsSeparator;
  final BorderRadius? listItemsBorderRadius;
  final BorderSide? listItemsBorderSide;
  final Color? listItemsColor;
  final Color? listItemsIndicatorColor;
  final double? listItemsElevation;
  final TextStyle? listItemsTitleStyle;
  final TextStyle? listItemsDescriptionStyle;
  final TextStyle? listItemsTimeStampStyle;

  final LnSurfaceDecoration? appBarDecoration;

  final EdgeInsets? backdropPadding;
  final Color? backdropColor;
  final EdgeInsets? containerPadding;

  final LnSurfaceDecoration? containerDecoration;
  final LnSurfaceDecoration? paneContainerDecoration;
  final LnSurfaceDecoration? paneDecoration;
  final LnSurfaceDecoration? subPaneDecoration;
  final LnSurfaceDecoration? paneHeaderDecoration;
  final LnSurfaceDecoration? paneBottomDecoration;
  final LnSurfaceDecoration? paneBodyDecoration;

  final bool? slidingDrawerDividers;
  final BoxDecoration? slidingDrawerDividerDecoration;

  final Duration? layoutAnimationsDuration;
  final Curve? layoutAnimationsCurve;

  final DrawerAlignment? menuAlignment;
  final double? menuWidth;
  final double? menuAnimationScaleFactor;
}

class LnTheme extends LnThemeData {
  const LnTheme({
    super.dialogsMaxWidth,
    super.formsMaxWidth,
    super.listsMaxWidth,
    super.maxColumnWidth,
    super.formsMargin,
    super.listsMargin,
    super.listsPadding,
    super.listsSeparator,
    super.listItemsBorderRadius,
    super.listItemsBorderSide,
    super.listItemsColor,
    super.listItemsIndicatorColor,
    super.listItemsElevation,
    super.listItemsPadding,
    super.listItemsTitleStyle,
    super.listItemsDescriptionStyle,
    super.listItemsTimeStampStyle,
    super.appBarDecoration,
    super.formsButtonsAlignment,
    super.backdropColor,
    super.backdropPadding,
    super.containerPadding,
    super.containerDecoration,
    super.paneContainerDecoration,
    super.paneDecoration,
    super.subPaneDecoration,
    super.paneHeaderDecoration,
    super.paneBottomDecoration,
    super.paneBodyDecoration,
    super.slidingDrawerDividers,
    super.slidingDrawerDividerDecoration,
    super.layoutAnimationsDuration,
    super.layoutAnimationsCurve,
    super.menuAlignment,
    super.menuWidth,
    super.menuAnimationScaleFactor,
    this.menuTheme,
    this.shrinkedMenuTheme,
  });

  final LnVerticalMenuTheme? shrinkedMenuTheme;
  final LnVerticalMenuTheme? menuTheme;

  LnComputedTheme applyDefaults(ThemeData theme) {
    assert(shrinkedMenuTheme == null || menuTheme != null);
    assert(menuTheme == null || this.menuAlignment != null);

    final colorScheme = theme.tonalScheme;
    final backdropColor = this.backdropColor ?? theme.tonalScheme.surface;
    final menuAlignment = this.menuAlignment ?? DrawerAlignment.start;

    final resolveContainerColor =
        containerDecoration?.resolveColor ?? (t) => backdropColor;

    final resolvePaneContainerColor =
        paneContainerDecoration?.resolveColor ?? resolveContainerColor;

    return LnComputedTheme(
      dialogsMaxWidth: dialogsMaxWidth ?? LnLayoutConstants.columnWidth,
      formsMaxWidth: formsMaxWidth ?? LnLayoutConstants.columnWidth * 1.5,
      listsMaxWidth: listsMaxWidth ?? LnLayoutConstants.columnWidth * 1.6,
      maxColumnWidth: maxColumnWidth ?? LnLayoutConstants.columnWidth * 2,
      formsMargin: formsMargin ??
          const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      listsMargin: listsMargin ?? const EdgeInsets.symmetric(horizontal: 12),
      listsPadding: listsPadding ??
          const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      listsSeparator: listsSeparator ?? SizedBox(height: 8),
      listItemsBorderRadius: listItemsBorderRadius ??
          theme.cardTheme.shape?.borderRadius?.resolve(TextDirection.ltr) ??
          BorderRadius.circular(8),
      listItemsBorderSide: listItemsBorderSide ??
          theme.cardTheme.shape?.borderSide ??
          BorderSide.none,
      listItemsColor:
          listItemsColor ?? theme.cardTheme.color ?? Colors.transparent,
      listItemsIndicatorColor: listItemsIndicatorColor ?? theme.indicatorColor,
      listItemsElevation: listItemsElevation ?? theme.cardTheme.elevation ?? 0,
      listItemsPadding:
          listItemsPadding ?? EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      listItemsTitleStyle: listItemsTitleStyle ??
          theme.textTheme.bodyLarge!.copyWith(color: colorScheme.onSurface),
      listItemsDescriptionStyle: listItemsDescriptionStyle ??
          theme.textTheme.bodyMedium!
              .copyWith(color: colorScheme.brightness.onColor),
      listItemsTimeStampStyle: listItemsTimeStampStyle ??
          theme.textTheme.labelMedium!
              .copyWith(color: colorScheme.onSurfaceVariant),
      appBarDecoration: appBarDecoration,
      formsButtonsAlignment: formsButtonsAlignment ?? Alignment.center,
      backdropColor: backdropColor,
      containerColor: resolveContainerColor(theme),
      paneContainerColor: resolvePaneContainerColor(theme),
      paneColor:
          (paneDecoration?.resolveColor ?? resolvePaneContainerColor)(theme),
      subPaneColor:
          (subPaneDecoration?.resolveColor ?? resolvePaneContainerColor)(theme),
      containerDecoration: containerDecoration,
      paneContainerDecoration: paneContainerDecoration,
      paneDecoration: paneDecoration,
      subPaneDecoration: subPaneDecoration,
      paneHeaderDecoration: paneHeaderDecoration,
      paneBottomDecoration: paneBottomDecoration,
      paneBodyDecoration: paneBodyDecoration,
      slidingDrawerDividers: slidingDrawerDividers ?? false,
      slidingDrawerDividerDecoration: slidingDrawerDividerDecoration,
      backdropPadding: backdropPadding,
      containerPadding: containerPadding,
      layoutAnimationsDuration:
          layoutAnimationsDuration ?? const Duration(milliseconds: 500),
      layoutAnimationsCurve: layoutAnimationsCurve ?? Curves.easeInOut,
      menuAlignment: menuAlignment,
      menuWidth: menuWidth ?? 290,
      menuAnimationScaleFactor: menuAnimationScaleFactor ?? 1,
      menuDecoration: (menuTheme ?? LnVerticalMenuTheme())
          .applyDefaults(theme, menuAlignment.direction, backdropColor),
      shrinkedMenuDecoration: shrinkedMenuTheme?.applyDefaults(
          theme, menuAlignment.direction, backdropColor),
    );
  }

  LnTheme copyWith({
    double? formsMaxWidth,
    double? listsMaxWidth,
    double? dialogsMaxWidth,
    double? maxColumnWidth,
    Alignment? formsButtonsAlignment,
    EdgeInsets? formsMargin,
    Widget? listsSeparator,
    EdgeInsets? listsMargin,
    EdgeInsets? listsPadding,
    EdgeInsets? listItemsPadding,
    BorderRadius? listItemsBorderRadius,
    BorderSide? listItemsBorderSide,
    Color? listItemsColor,
    Color? listItemsIndicatorColor,
    double? listItemsElevation,
    TextStyle? listItemsTitleStyle,
    TextStyle? listItemsDescriptionStyle,
    TextStyle? listItemsTimeStampStyle,
    LnSurfaceDecoration? appBarDecoration,
    Color? backdropColor,
    EdgeInsets? backdropPadding,
    EdgeInsets? containerPadding,
    LnSurfaceDecoration? containerDecoration,
    LnSurfaceDecoration? paneContainerDecoration,
    LnSurfaceDecoration? paneDecoration,
    LnSurfaceDecoration? subPaneDecoration,
    LnSurfaceDecoration? paneHeaderDecoration,
    LnSurfaceDecoration? paneBottomDecoration,
    LnSurfaceDecoration? paneBodyDecoration,
    bool? slidingDrawerDividers,
    BoxDecoration? slidingDrawerDividerDecoration,
    Duration? layoutAnimationsDuration,
    Curve? layoutAnimationsCurve,
    DrawerAlignment? menuAlignment,
    double? menuWidth,
    LnVerticalMenuTheme? shrinkedMenuTheme,
    LnVerticalMenuTheme? menuTheme,
    double? menuAnimationScaleFactor,
  }) {
    return LnTheme(
      formsMaxWidth: formsMaxWidth ?? this.formsMaxWidth,
      listsMaxWidth: listsMaxWidth ?? this.listsMaxWidth,
      dialogsMaxWidth: dialogsMaxWidth ?? this.dialogsMaxWidth,
      maxColumnWidth: maxColumnWidth ?? this.maxColumnWidth,
      formsButtonsAlignment:
          formsButtonsAlignment ?? this.formsButtonsAlignment,
      formsMargin: formsMargin ?? this.formsMargin,
      listsSeparator: listsSeparator ?? this.listsSeparator,
      listsMargin: listsMargin ?? this.listsMargin,
      listsPadding: listsPadding ?? this.listsPadding,
      listItemsBorderRadius:
          listItemsBorderRadius ?? this.listItemsBorderRadius,
      listItemsBorderSide: listItemsBorderSide ?? this.listItemsBorderSide,
      listItemsColor: listItemsColor ?? this.listItemsColor,
      listItemsIndicatorColor:
          listItemsIndicatorColor ?? this.listItemsIndicatorColor,
      listItemsElevation: listItemsElevation ?? this.listItemsElevation,
      listItemsPadding: listItemsPadding ?? this.listItemsPadding,
      listItemsTitleStyle: listItemsTitleStyle ?? this.listItemsTitleStyle,
      listItemsDescriptionStyle:
          listItemsDescriptionStyle ?? this.listItemsDescriptionStyle,
      listItemsTimeStampStyle:
          listItemsTimeStampStyle ?? this.listItemsTimeStampStyle,
      appBarDecoration: appBarDecoration ?? this.appBarDecoration,
      backdropColor: backdropColor ?? this.backdropColor,
      backdropPadding: backdropPadding ?? this.backdropPadding,
      containerPadding: containerPadding ?? this.containerPadding,
      containerDecoration: containerDecoration ?? this.containerDecoration,
      paneContainerDecoration:
          paneContainerDecoration ?? this.paneContainerDecoration,
      paneDecoration: paneDecoration ?? this.paneDecoration,
      subPaneDecoration: subPaneDecoration ?? this.subPaneDecoration,
      paneHeaderDecoration: paneHeaderDecoration ?? this.paneHeaderDecoration,
      paneBottomDecoration: paneBottomDecoration ?? this.paneBottomDecoration,
      paneBodyDecoration: paneBodyDecoration ?? this.paneBodyDecoration,
      slidingDrawerDividers:
          slidingDrawerDividers ?? this.slidingDrawerDividers,
      slidingDrawerDividerDecoration:
          slidingDrawerDividerDecoration ?? this.slidingDrawerDividerDecoration,
      layoutAnimationsDuration:
          layoutAnimationsDuration ?? this.layoutAnimationsDuration,
      layoutAnimationsCurve:
          layoutAnimationsCurve ?? this.layoutAnimationsCurve,
      menuWidth: menuWidth ?? this.menuWidth,
      shrinkedMenuTheme: shrinkedMenuTheme ?? this.shrinkedMenuTheme,
      menuAlignment: menuAlignment ?? this.menuAlignment,
      menuTheme: menuTheme ?? this.menuTheme,
      menuAnimationScaleFactor:
          menuAnimationScaleFactor ?? this.menuAnimationScaleFactor,
    );
  }
}
