import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

typedef OnMenuItemTap = void Function(LnMenuItem);

extension EdgeInsetsGeometryExtension on EdgeInsetsGeometry {
  EdgeInsetsGeometry align(WrapCrossAlignment alignment, bool stretch) {
    if (alignment == WrapCrossAlignment.center) return this;
    final insets = resolve(TextDirection.ltr);

    return EdgeInsetsDirectional.only(
      top: insets.top,
      bottom: insets.bottom,
      start: alignment == WrapCrossAlignment.start
          ? 0
          : (stretch ? insets.left : insets.horizontal),
      end: alignment == WrapCrossAlignment.end
          ? 0
          : (stretch ? insets.right : insets.horizontal),
    );
  }
}

extension EdgeInsetsExtension on EdgeInsets {
  EdgeInsets alignLeft(bool stretch) {
    return EdgeInsets.only(
      top: top,
      bottom: bottom,
      left: 0,
      right: stretch ? right : horizontal,
    );
  }

  EdgeInsets alignRight(bool stretch) {
    return EdgeInsets.only(
      top: top,
      bottom: bottom,
      left: stretch ? left : horizontal,
      right: 0,
    );
  }
}

class LnVerticalMenuItemDecoration {
  const LnVerticalMenuItemDecoration({
    required this.height,
    required this.margin,
    required this.padding,
    required this.iconTheme,
    required this.indicatorIconTheme,
    required this.textStyle,
    required this.indicatorTextStyle,
    required this.indicatorBorderSide,
    required this.indicatorBorderRadius,
    required this.indicatorColor,
  });

  final double height;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final IconThemeData iconTheme;
  final IconThemeData indicatorIconTheme;
  final TextStyle textStyle;
  final TextStyle indicatorTextStyle;
  final BorderSide indicatorBorderSide;
  final BorderRadius indicatorBorderRadius;
  final Color indicatorColor;

  static LnVerticalMenuItemDecoration? lerp(LnVerticalMenuItemDecoration? a,
      LnVerticalMenuItemDecoration? b, double t) {
    if (t == 0) {
      return a;
    } else if (t == 1) {
      return b;
    } else {
      if (a == null) {
        return t < .5 ? null : b;
      } else if (b == null) {
        return t < .5 ? b : null;
      } else {
        return LnVerticalMenuItemDecoration(
          height: lerpDouble(a.height, b.height, t)!,
          margin: EdgeInsets.lerp(a.margin, b.margin, t)!,
          padding: EdgeInsets.lerp(a.padding, b.padding, t)!,
          iconTheme: IconThemeData.lerp(a.iconTheme, b.iconTheme, t),
          indicatorIconTheme:
              IconThemeData.lerp(a.indicatorIconTheme, b.indicatorIconTheme, t),
          textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t)!,
          indicatorTextStyle:
              TextStyle.lerp(a.indicatorTextStyle, b.indicatorTextStyle, t)!,
          indicatorBorderSide:
              BorderSide.lerp(a.indicatorBorderSide, b.indicatorBorderSide, t),
          indicatorBorderRadius: BorderRadius.lerp(
              a.indicatorBorderRadius, b.indicatorBorderRadius, t)!,
          indicatorColor: Color.lerp(a.indicatorColor, b.indicatorColor, t)!,
        );
      }
    }
  }
}

class LnVerticalMenuDecoration {
  LnVerticalMenuDecoration({
    required this.elevation,
    required this.scrollablePadding,
    required this.margin,
    required this.padding,
    required this.groupTitleStyle,
    required this.groupsSpacing,
    required this.backgroundColor,
    required this.borderRadius,
    required this.borderSide,
    required this.itemDecoration,
  });

  final double elevation;
  final Color backgroundColor;
  final BorderSide borderSide;
  final BorderRadius borderRadius;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final EdgeInsets scrollablePadding;
  final TextStyle groupTitleStyle;
  final double groupsSpacing;
  final LnVerticalMenuItemDecoration itemDecoration;

  double get horizontalInsetsSum =>
      padding.horizontal +
      scrollablePadding.horizontal +
      itemDecoration.padding.horizontal +
      itemDecoration.margin.horizontal;

  EdgeInsets get groupTitleInsets => EdgeInsets.only(
        top: groupsSpacing,
        left: itemDecoration.padding.left + itemDecoration.margin.left,
        right: itemDecoration.padding.right + itemDecoration.margin.right,
      );

  static LnVerticalMenuDecoration? lerp(
      LnVerticalMenuDecoration? a, LnVerticalMenuDecoration? b, double t) {
    if (t == 0) {
      return a;
    } else if (t == 1) {
      return b;
    } else {
      if (a == null) {
        return t < .5 ? null : b;
      } else if (b == null) {
        return t < .5 ? b : null;
      } else {
        return LnVerticalMenuDecoration(
          elevation: lerpDouble(a.elevation, b.elevation, t)!,
          scrollablePadding:
              EdgeInsets.lerp(a.scrollablePadding, b.scrollablePadding, t)!,
          margin: EdgeInsets.lerp(a.margin, b.margin, t)!,
          padding: EdgeInsets.lerp(a.padding, b.padding, t)!,
          groupsSpacing: lerpDouble(a.groupsSpacing, b.groupsSpacing, t)!,
          groupTitleStyle:
              TextStyle.lerp(a.groupTitleStyle, b.groupTitleStyle, t)!,
          backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
          borderRadius: BorderRadius.lerp(a.borderRadius, b.borderRadius, t)!,
          borderSide: BorderSide.lerp(a.borderSide, b.borderSide, t),
          itemDecoration: LnVerticalMenuItemDecoration.lerp(
              a.itemDecoration, b.itemDecoration, t)!,
        );
      }
    }
  }
}

class LnVerticalMenuItemTheme {
  const LnVerticalMenuItemTheme({
    this.height,
    this.margin,
    this.padding,
    this.iconTheme,
    this.textStyle,
    this.indicatorBorderSide,
    this.indicatorBorderRadius,
    this.indicatorColor,
    this.indicatorOnColor,
  });

  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final IconThemeData? iconTheme;
  final TextStyle? textStyle;
  final BorderSide? indicatorBorderSide;
  final BorderRadiusGeometry? indicatorBorderRadius;
  final Color? indicatorColor;
  final Color? indicatorOnColor;

  LnVerticalMenuItemTheme copyWith({
    double? height,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    IconThemeData? iconTheme,
    TextStyle? textStyle,
    BorderSide? indicatorBorderSide,
    BorderRadiusGeometry? indicatorBorderRadius,
    Color? indicatorColor,
    Color? indicatorOnColor,
  }) {
    return LnVerticalMenuItemTheme(
      padding: padding ?? this.padding,
      margin: margin ?? this.margin,
      iconTheme: iconTheme ?? this.iconTheme,
      textStyle: textStyle ?? this.textStyle,
      indicatorBorderSide: indicatorBorderSide ?? this.indicatorBorderSide,
      indicatorBorderRadius:
          indicatorBorderRadius ?? this.indicatorBorderRadius,
      indicatorColor: indicatorColor ?? this.indicatorColor,
      indicatorOnColor: indicatorOnColor ?? this.indicatorOnColor,
    );
  }

  LnVerticalMenuItemTheme _aligned(WrapCrossAlignment alignment) {
    return copyWith(
      margin: margin?.align(alignment, true),
      indicatorBorderRadius: indicatorBorderRadius
          ?.onlyDirectional(DirectionalCorners.byAlignment(alignment)),
    );
  }

  LnVerticalMenuItemDecoration _applyDefaults(
    ThemeData theme,
    TextDirection menuDirection,
  ) {
    final colorScheme = theme.tonalScheme;
    final iconTheme = this.iconTheme ??
        theme.navigationDrawerTheme.iconTheme?.resolve({}) ??
        IconThemeData(size: 20, color: colorScheme.onSurfaceVariant);

    final textStyle = this.textStyle ??
        theme.navigationDrawerTheme.labelTextStyle?.resolve({}) ??
        theme.textTheme.titleMedium!.copyWith(color: colorScheme.onSurface);

    final indicatorOnColor = this.indicatorOnColor ??
        theme.navigationDrawerTheme.labelTextStyle
            ?.resolve({MaterialState.selected})?.color ??
        switch (colorScheme.brightness) {
          Brightness.light => colorScheme.onPrimaryFixedVariant,
          Brightness.dark => colorScheme.onPrimaryContainer,
        };

    return LnVerticalMenuItemDecoration(
      margin: margin?.resolve(menuDirection) ?? EdgeInsets.zero,
      padding: padding?.resolve(menuDirection) ??
          EdgeInsets.symmetric(horizontal: 12),
      height: height ??
          theme.navigationDrawerTheme.tileHeight ??
          kMinInteractiveDimension,
      textStyle: textStyle,
      indicatorTextStyle: textStyle.copyWith(color: indicatorOnColor),
      iconTheme: iconTheme,
      indicatorIconTheme: iconTheme.copyWith(color: indicatorOnColor),
      indicatorBorderRadius: (indicatorBorderRadius ??
                  theme.navigationDrawerTheme.indicatorShape?.borderRadius)
              ?.resolve(menuDirection) ??
          const BorderRadius.all(Radius.circular(kMinInteractiveDimension / 2)),
      indicatorBorderSide: indicatorBorderSide ??
          theme.navigationDrawerTheme.indicatorShape?.borderSide ??
          BorderSide.none,
      indicatorColor: indicatorColor ??
          theme.navigationDrawerTheme.indicatorColor ??
          switch (colorScheme.brightness) {
            Brightness.light => colorScheme.primaryFixed,
            Brightness.dark => colorScheme.primaryContainer,
          },
    );
  }

  LnVerticalMenuItemDecoration _withBase(
      LnVerticalMenuDecoration base, TextDirection menuDirection) {
    final itemBase = base.itemDecoration;
    final indicatorTextColor =
        indicatorOnColor ?? itemBase.indicatorTextStyle.color;
    final indicatorIconColor =
        indicatorOnColor ?? itemBase.indicatorIconTheme.color;

    return LnVerticalMenuItemDecoration(
      margin: margin?.resolve(menuDirection) ?? itemBase.margin,
      padding: padding?.resolve(menuDirection) ?? itemBase.padding,
      height: height ?? itemBase.height,
      textStyle: textStyle ?? itemBase.textStyle,
      indicatorTextStyle: textStyle?.copyWith(color: indicatorTextColor) ??
          itemBase.indicatorTextStyle,
      iconTheme: iconTheme ?? itemBase.iconTheme,
      indicatorIconTheme: iconTheme?.copyWith(color: indicatorIconColor) ??
          itemBase.indicatorIconTheme,
      indicatorBorderRadius: indicatorBorderRadius?.resolve(menuDirection) ??
          itemBase.indicatorBorderRadius,
      indicatorBorderSide: indicatorBorderSide ?? itemBase.indicatorBorderSide,
      indicatorColor: indicatorColor ?? itemBase.indicatorColor,
    );
  }
}

class LnVerticalMenuTheme {
  const LnVerticalMenuTheme({
    this.elevation,
    this.borderRadius,
    this.borderSide,
    this.backgroundColor,
    this.margin,
    this.padding,
    this.scrollablePadding,
    this.groupTitleStyle,
    this.groupsSpacing,
    this.itemTheme,
  });

  final double? elevation;
  final BorderRadiusGeometry? borderRadius;
  final BorderSide? borderSide;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? scrollablePadding;
  final TextStyle? groupTitleStyle;
  final double? groupsSpacing;
  final LnVerticalMenuItemTheme? itemTheme;

  LnVerticalMenuTheme copyWith({
    double? elevation,
    BorderRadiusGeometry? borderRadius,
    BorderSide? borderSide,
    Color? backgroundColor,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? scrollablePadding,
    TextStyle? groupTitleStyle,
    double? groupsSpacing,
    LnVerticalMenuItemTheme? itemTheme,
  }) {
    return LnVerticalMenuTheme(
      elevation: elevation ?? this.elevation,
      borderRadius: borderRadius ?? this.borderRadius,
      borderSide: borderSide ?? this.borderSide,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      margin: margin ?? this.margin,
      padding: padding ?? this.padding,
      scrollablePadding: scrollablePadding ?? this.scrollablePadding,
      groupTitleStyle: groupTitleStyle ?? this.groupTitleStyle,
      groupsSpacing: groupsSpacing ?? this.groupsSpacing,
      itemTheme: itemTheme ?? this.itemTheme,
    );
  }

  LnVerticalMenuTheme aligned(WrapCrossAlignment alignment) {
    return copyWith(
      margin: margin?.align(alignment, true),
      padding: padding?.align(alignment, true),
      scrollablePadding: scrollablePadding?.align(alignment, true),
      borderRadius: borderRadius
          ?.onlyDirectional(DirectionalCorners.byAlignment(alignment)),
      itemTheme: itemTheme?._aligned(alignment),
    );
  }

  LnVerticalMenuDecoration applyDefaults(
    ThemeData theme,
    TextDirection direction,
    Color backdropColor,
  ) {
    final themeDrawerShape = switch (direction) {
      TextDirection.ltr => theme.drawerTheme.shape,
      TextDirection.rtl => theme.drawerTheme.endShape,
    };
    final colorScheme = theme.tonalScheme;

    final backgroundColor = this.backgroundColor ??
        theme.navigationDrawerTheme.backgroundColor ??
        colorScheme.surfaceBright;

    return LnVerticalMenuDecoration(
      margin: margin?.resolve(direction) ?? EdgeInsets.zero,
      padding: padding?.resolve(direction) ?? const EdgeInsets.only(bottom: 12),
      scrollablePadding: scrollablePadding?.resolve(direction) ??
          const EdgeInsets.only(top: 12, left: 12, right: 12),
      elevation: elevation ?? theme.navigationDrawerTheme.elevation ?? 0,
      groupTitleStyle: groupTitleStyle ??
          theme.textTheme.labelMedium!.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
      groupsSpacing: groupsSpacing ?? 16,
      backgroundColor: backgroundColor == Colors.transparent
          ? backdropColor
          : backgroundColor,
      borderRadius: (borderRadius ?? themeDrawerShape?.borderRadius)
              ?.resolve(direction) ??
          BorderRadius.zero,
      borderSide: borderSide ?? themeDrawerShape?.borderSide ?? BorderSide.none,
      itemDecoration: (itemTheme ?? LnVerticalMenuItemTheme())
          ._applyDefaults(theme, direction),
    );
  }

  LnVerticalMenuDecoration withBase(
      LnVerticalMenuDecoration base, TextDirection direction) {
    return LnVerticalMenuDecoration(
      margin: margin?.resolve(direction) ?? base.margin,
      padding: padding?.resolve(direction) ?? base.padding,
      scrollablePadding:
          scrollablePadding?.resolve(direction) ?? base.scrollablePadding,
      elevation: elevation ?? base.elevation,
      groupTitleStyle: groupTitleStyle ?? base.groupTitleStyle,
      groupsSpacing: groupsSpacing ?? base.groupsSpacing,
      backgroundColor: backgroundColor ?? base.backgroundColor,
      borderRadius: borderRadius?.resolve(direction) ?? base.borderRadius,
      borderSide: borderSide ?? base.borderSide,
      itemDecoration:
          itemTheme?._withBase(base, direction) ?? base.itemDecoration,
    );
  }
}

class LnVerticalMenuThemeTween extends Tween<LnVerticalMenuDecoration?> {
  LnVerticalMenuThemeTween({super.begin, super.end});

  @override
  LnVerticalMenuDecoration? lerp(double t) {
    return LnVerticalMenuDecoration.lerp(begin, end, t);
  }
}

class _LnVerticalMenuScope extends InheritedWidget {
  const _LnVerticalMenuScope({
    required this.state,
    required super.child,
  });

  final LnVerticalMenuState state;

  static LnVerticalMenuState of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_LnVerticalMenuScope>();
    assert(scope != null);
    return scope!.state;
  }

  @override
  bool updateShouldNotify(_LnVerticalMenuScope old) => state != old.state;
}

class LnVerticalMenu extends StatefulWidget {
  const LnVerticalMenu({
    super.key,
    this.railMode = false,
    this.itemSelectedKey,
    required this.decoration,
    this.itemOnTap,
    required this.child,
  });

  final bool railMode;
  final LnVerticalMenuDecoration decoration;

  final Key? itemSelectedKey;
  final OnMenuItemTap? itemOnTap;
  final Widget child;

  @override
  State<LnVerticalMenu> createState() => LnVerticalMenuState();
}

class LnVerticalMenuState extends LnState<LnVerticalMenu>
    with SingleTickerProviderStateMixin {
  final Set<_LnMenuItemState> _items = {};
  final Set<_LnMenuGroupTitleState> _groupTitles = {};

  LnVerticalMenuDecoration get decoration => widget.decoration;

  LnMenuItem? findItem(Key key) {
    return _items.firstWhereOrNull((i) => i.widget.key == key)?.widget;
  }

  void _register(_LnMenuItemState item) {
    _items.add(item);
  }

  void _registerTitle(_LnMenuGroupTitleState item) {
    _groupTitles.add(item);
  }

  void _unregister(_LnMenuItemState item) {
    _items.remove(item);
  }

  void _unregisterTitle(_LnMenuGroupTitleState item) {
    _groupTitles.remove(item);
  }

  @override
  void didUpdateWidget(LnVerticalMenu oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.railMode != oldWidget.railMode ||
        widget.decoration != oldWidget.decoration) {
      for (var groupTitle in _groupTitles) {
        groupTitle.setState(() {});
      }
    }

    if (widget.railMode != oldWidget.railMode) {
      for (var item in _items) {
        item.setState(() {});
      }
    } else if (widget.itemSelectedKey != oldWidget.itemSelectedKey ||
        widget.decoration != oldWidget.decoration) {
      _items.firstWhereOrNull((item) => item.selected)?.setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return _LnVerticalMenuScope(
      state: this,
      child: Padding(
        padding: decoration.margin,
        child: Material(
          color: decoration.backgroundColor,
          type: decoration.backgroundColor == Colors.transparent
              ? MaterialType.transparency
              : MaterialType.canvas,
          surfaceTintColor: Colors.transparent,
          shadowColor:
              theme.navigationDrawerTheme.shadowColor ?? theme.shadowColor,
          elevation: decoration.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: decoration.borderRadius,
            side: decoration.borderSide,
          ),
          clipBehavior: Clip.none,
          child: Padding(
            padding: decoration.padding,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class LnMenuGroupTitle extends StatefulWidget {
  const LnMenuGroupTitle(
    this.title, {
    super.key,
  });

  final String title;

  @override
  State<LnMenuGroupTitle> createState() => _LnMenuGroupTitleState();
}

class _LnMenuGroupTitleState extends State<LnMenuGroupTitle> {
  LnVerticalMenuState? _menu;
  LnVerticalMenuState get menu {
    assert(_menu != null);
    return _menu!;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _menu = _LnVerticalMenuScope.of(context).._registerTitle(this);
  }

  @override
  void dispose() {
    _menu?._unregisterTitle(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = menu.decoration.groupTitleStyle;
    return Padding(
      padding: menu.decoration.groupTitleInsets,
      child: UnconstrainedBox(
        constrainedAxis: Axis.vertical,
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.hardEdge,
        child: LimitedBox(
          maxWidth: menu.theme.ln.menuWidth,
          child: Visibility(
            visible: !menu.widget.railMode,
            replacement: PrecisionDivider(
              height: (style.fontSize ?? 14) * (style.height ?? 1),
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: style.color?.withOpacity(.5),
            ),
            child: Text(
              widget.title,
              overflow: TextOverflow.clip,
              maxLines: 1,
              style: style,
            ),
          ),
        ),
      ),
    );
  }
}

class LnMenuItem extends StatefulWidget {
  const LnMenuItem({
    super.key,
    required this.icon,
    required this.title,
    this.countBadge,
    this.onTap,
  });

  final Widget icon;
  final String title;
  final int? countBadge;
  final void Function()? onTap;

  @override
  State<LnMenuItem> createState() => _LnMenuItemState();
}

class _LnMenuItemState extends State<LnMenuItem> {
  LnVerticalMenuState? _menu;
  LnVerticalMenuState get menu {
    assert(_menu != null);
    return _menu!;
  }

  LnVerticalMenuDecoration get menuDecoration => menu.decoration;
  LnVerticalMenuItemDecoration get decoration => menuDecoration.itemDecoration;

  bool get selected => menu.widget.itemSelectedKey == widget.key;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _menu = _LnVerticalMenuScope.of(context).._register(this);
  }

  @override
  void dispose() {
    _menu?._unregister(this);
    super.dispose();
  }

  Widget _buildTrailingBadge(
    int count, {
    double size = 18,
    required Color color,
    required Color onColor,
  }) {
    return Transform.translate(
      offset: Offset(size / 2, 0),
      child: SizedOverflowBox(
        size: Size.fromWidth(0),
        alignment: Alignment.centerRight,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(size / 2),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: size,
              minHeight: size,
              maxHeight: size,
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size / 4),
                child: Text(
                  "$count",
                  style: menu.theme.textTheme.labelMedium?.copyWith(
                    color: onColor,
                    fontSize: size / 1.6,
                    height: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback? onTap = widget.onTap ??
        (menu.widget.itemOnTap != null
            ? () => menu.widget.itemOnTap!(widget)
            : null);

    final effectiveShape = selected
        ? RoundedRectangleBorder(
            borderRadius: decoration.indicatorBorderRadius,
            side: decoration.indicatorBorderSide,
          )
        : null;

    final hasBadge = widget.countBadge != null && widget.countBadge! > 0;
    Widget result = IconTheme(
      data: selected ? decoration.indicatorIconTheme : decoration.iconTheme,
      child: widget.icon,
    );

    if (hasBadge && menu.widget.railMode) {
      result = Badge.count(
        offset: Offset(10, -6),
        count: widget.countBadge!,
        child: result,
      );
    }

    result = SpacedRow(
      spacing: decoration.padding.right,
      children: [
        result,
        Expanded(
          child: Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:
                selected ? decoration.indicatorTextStyle : decoration.textStyle,
          ),
        ),
        if (hasBadge)
          _buildTrailingBadge(
            widget.countBadge!,
            color: menu.theme.tonalScheme.primary,
            onColor: menu.theme.tonalScheme.onPrimary,
          ),
      ],
    );

    result = Tooltip(
      message: widget.title,
      triggerMode: menu.widget.railMode
          ? TooltipTriggerMode.manual
          : TooltipTriggerMode.longPress,
      waitDuration: Duration(milliseconds: 200),
      child: Padding(
        padding: decoration.margin,
        child: Material(
          shape: effectiveShape,
          borderRadius:
              effectiveShape == null ? decoration.indicatorBorderRadius : null,
          color: selected ? decoration.indicatorColor : Colors.transparent,
          type: selected ? MaterialType.canvas : MaterialType.transparency,
          child: InkWell(
            onTap: onTap,
            borderRadius: decoration.indicatorBorderRadius,
            child: UnconstrainedBox(
              constrainedAxis: Axis.vertical,
              alignment: Alignment.centerLeft,
              clipBehavior: Clip.hardEdge,
              child: Padding(
                padding: decoration.padding,
                child: SizedBox(
                  height: decoration.height - decoration.padding.vertical,
                  width: menu.theme.ln.expandedMenuItemInsideWidth,
                  child: result,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    return result;
  }
}




  /*LnVerticalMenuDirectionalTheme applyDefaults(
    TonalScheme colorScheme,
    DrawerThemeData drawerTheme,
    NavigationDrawerThemeData navigationDrawerTheme,
    IconThemeData iconTheme,
    TextTheme textTheme,
  ) {
    final Color indicatorOnColor = switch (colorScheme.brightness) {
      Brightness.light => colorScheme.onPrimaryFixedVariant,
      Brightness.dark => colorScheme.onPrimaryContainer,
    };

    final padding = this.padding?.resolve(menuDirection) ??
        const EdgeInsetsDirectional.only(bottom: 12);
    final scrollablePadding = this.scrollablePadding?.resolve(menuDirection) ??
        const EdgeInsetsDirectional.only(top: 12, end: 12);
    final itemsMargin =
        this.itemsMargin?.resolve(menuDirection) ?? EdgeInsets.zero;
    final itemsPadding = this.itemsPadding?.resolve(menuDirection) ??
        EdgeInsets.symmetric(horizontal: 12);
    final menuIconTheme = this.iconTheme ??
        MaterialStateProperty.resolveWith((states) => states
                .contains(MaterialState.selected)
            ? (navigationDrawerTheme.iconTheme
                    ?.resolve({MaterialState.selected}) ??
                iconTheme.copyWith(size: 20, color: indicatorOnColor))
            : (navigationDrawerTheme.iconTheme?.resolve({}) ??
                iconTheme.copyWith(
                    size: 20, color: colorScheme.onSurfaceVariant)));

    final labelStyle =
        (textStyle ?? navigationDrawerTheme.labelTextStyle)?.resolve({}) ??
            textTheme.titleMedium!.copyWith(color: colorScheme.onSurface);
    final indicatorLabelStyle =
        (textStyle ?? navigationDrawerTheme.labelTextStyle)
                ?.resolve({MaterialState.selected}) ??
            textTheme.titleMedium!.copyWith(color: indicatorOnColor);

    return LnVerticalMenuDirectionalTheme._(
      computed: true,
      padding: padding,
      scrollablePadding: scrollablePadding,
      itemsMargin: itemsMargin,
      itemsPadding: itemsPadding,
      elevation: elevation ?? navigationDrawerTheme.elevation ?? 0,
      groupTitleStyle: groupTitleStyle ??
          textTheme.labelMedium!.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
      groupsSpacing: groupsSpacing ?? 16,
      itemHeight: itemHeight ??
          navigationDrawerTheme.tileHeight ??
          kMinInteractiveDimension,
      backgroundColor: backgroundColor ?? navigationDrawerTheme.backgroundColor,
      borderRadius: (borderRadius ?? drawerTheme.shape)
          ?.borderRadius
          ?.resolve(menuDirection),
      borderSide: borderSide ??
          (menuDirection == TextDirection.ltr
                  ? drawerTheme.shape
                  : drawerTheme.endShape)
              ?.borderSide ??
          BorderSide.none,
      textStyle: MaterialStateProperty.resolveWith((states) =>
          states.contains(MaterialState.selected)
              ? indicatorLabelStyle
              : labelStyle),
      iconTheme: menuIconTheme,
      indicatorBorderRadius: (indicatorBorderRadius ??
                  navigationDrawerTheme.indicatorShape?.borderRadius)
              ?.resolve(menuDirection) ??
          const BorderRadius.all(Radius.circular(kMinInteractiveDimension / 2)),
      indicatorBorderSide: indicatorBorderSide ??
          navigationDrawerTheme.indicatorShape?.borderSide ??
          BorderSide.none,
      indicatorColor: indicatorColor ??
          navigationDrawerTheme.indicatorColor ??
          switch (colorScheme.brightness) {
            Brightness.light => colorScheme.primaryFixed,
            Brightness.dark => colorScheme.primaryContainer,
          },
    );
  }*/