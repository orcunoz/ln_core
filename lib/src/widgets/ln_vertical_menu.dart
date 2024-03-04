import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

typedef OnMenuItemTap = void Function(LnMenuItem);

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
    this.backgroundColor,
    this.shape,
    this.groupsSpacing = 20,
    this.replaceTitlesWithDivider = false,
    this.itemSelectedKey,
    required this.itemExpandedWidth,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    this.itemOnTap,
    this.itemIndicatorShape,
    this.itemIndicatorColor,
    this.itemIndicatorOnColor,
    required this.child,
  });

  final ShapeBorder? shape;
  final Color? backgroundColor;

  final double groupsSpacing;
  final bool replaceTitlesWithDivider;

  final Key? itemSelectedKey;
  final EdgeInsets itemPadding;
  final double itemExpandedWidth;
  final ShapeBorder? itemIndicatorShape;
  final Color? itemIndicatorColor;
  final Color? itemIndicatorOnColor;
  final OnMenuItemTap? itemOnTap;
  final Widget child;

  @override
  State<LnVerticalMenu> createState() => LnVerticalMenuState();
}

class LnVerticalMenuState extends LnState<LnVerticalMenu>
    with SingleTickerProviderStateMixin {
  final Set<_LnMenuItemState> _items = {};
  final Set<_LnMenuGroupTitleState> _groupTitles = {};

  ShapeBorder? _itemIndicatorShape;
  late Color _itemIndicatorColor;
  late Color _itemIndicatorOnColor;
  double? get _itemTileHeight => theme.navigationDrawerTheme.tileHeight;
  MaterialStateProperty<TextStyle?>? get _itemTextStyle =>
      theme.navigationDrawerTheme.labelTextStyle;
  MaterialStateProperty<IconThemeData?>? get _itemIconTheme =>
      theme.navigationDrawerTheme.iconTheme;

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

  void _computeIndicatorStyle() {
    _itemIndicatorShape =
        widget.itemIndicatorShape ?? theme.navigationDrawerTheme.indicatorShape;
    _itemIndicatorOnColor = widget.itemIndicatorOnColor ??
        theme.navigationDrawerTheme.labelTextStyle
            ?.resolve({MaterialState.selected})?.color ??
        theme.colorScheme.onPrimaryContainer;
    _itemIndicatorColor = widget.itemIndicatorColor ??
        theme.navigationDrawerTheme.indicatorColor ??
        theme.colorScheme.primaryContainer;
  }

  @override
  void initState() {
    super.initState();
    _computeIndicatorStyle();
  }

  @override
  void didUpdateWidget(LnVerticalMenu oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.replaceTitlesWithDivider != oldWidget.replaceTitlesWithDivider ||
        widget.groupsSpacing != oldWidget.groupsSpacing ||
        widget.itemPadding != oldWidget.itemPadding) {
      for (var groupTitle in _groupTitles) {
        groupTitle.setState(() {});
      }
    }

    if (widget.replaceTitlesWithDivider != oldWidget.replaceTitlesWithDivider ||
        widget.itemPadding != oldWidget.itemPadding) {
      for (var item in _items) {
        item.setState(() {});
      }
    } else if (widget.itemSelectedKey != oldWidget.itemSelectedKey ||
        widget.itemIndicatorShape != oldWidget.itemIndicatorShape ||
        widget.itemIndicatorColor != oldWidget.itemIndicatorColor ||
        widget.itemIndicatorOnColor != oldWidget.itemIndicatorOnColor) {
      _computeIndicatorStyle();
      _items.firstWhereOrNull((item) => item.selected)?.setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        widget.backgroundColor ?? theme.navigationDrawerTheme.backgroundColor;
    final shape = widget.shape ?? theme.drawerTheme.shape;

    return _LnVerticalMenuScope(
      state: this,
      child: IconTheme(
        data: _itemIconTheme?.resolve({}) ??
            IconThemeData(color: _itemTextStyle?.resolve({})?.color),
        child: Material(
          color: backgroundColor,
          type: backgroundColor == Colors.transparent
              ? MaterialType.transparency
              : MaterialType.canvas,
          surfaceTintColor: theme.navigationDrawerTheme.surfaceTintColor,
          shadowColor: theme.navigationDrawerTheme.shadowColor,
          elevation: theme.navigationDrawerTheme.elevation ?? .0,
          shape: shape,
          clipBehavior: Clip.none,
          child: widget.child,
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
    super.dispose();

    _menu?._unregisterTitle(this);
  }

  @override
  Widget build(BuildContext context) {
    final style = menu.theme.textTheme.bodySmall!
        .copyWith(color: menu._itemTextStyle?.resolve({})?.color);
    return Padding(
      padding: menu.widget.itemPadding +
          EdgeInsets.only(top: menu.widget.groupsSpacing),
      child: UnconstrainedBox(
        constrainedAxis: Axis.vertical,
        alignment: Alignment.centerLeft,
        clipBehavior: Clip.hardEdge,
        child: LimitedBox(
          maxWidth: menu.widget.itemExpandedWidth,
          child: Visibility(
            replacement: PrecisionDivider(
              height: (style.fontSize ?? 14) * (style.height ?? 1),
              thickness: 1,
              color: style.color?.withOpacity(.5),
            ),
            visible: !menu.widget.replaceTitlesWithDivider,
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

  ThemeData get theme => menu.theme;

  bool get selected => menu.widget.itemSelectedKey == widget.key;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _menu = _LnVerticalMenuScope.of(context).._register(this);
  }

  @override
  void dispose() {
    super.dispose();

    _menu?._unregister(this);
  }

  Widget _buildTrailingBadge(
    int count, {
    double size = 20,
    required Color color,
    required Color onColor,
  }) {
    return SizedOverflowBox(
      size: Size.fromWidth(0),
      alignment: Alignment.centerRight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(size / 2),
          /*border: Border.all(
            width: 1,
            color: borderColor,
          ),*/
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: size,
            minHeight: size,
            maxHeight: size,
          ),
          child: Center(
            child: Text(
              "$count",
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: onColor,
                fontSize: size / 1.8,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = menu._itemTileHeight ?? kMinInteractiveDimension;
    final indicatorColor = menu._itemIndicatorColor;

    VoidCallback? onTap = widget.onTap ??
        (menu.widget.itemOnTap != null
            ? () => menu.widget.itemOnTap!(widget)
            : null);

    final hasBadge = widget.countBadge != null && widget.countBadge! > 0;
    Widget result = selected
        ? IconTheme(
            data: menu._itemIconTheme?.resolve({MaterialState.selected}) ??
                IconThemeData(color: menu._itemIndicatorOnColor),
            child: widget.icon,
          )
        : widget.icon;

    if (hasBadge && menu.widget.replaceTitlesWithDivider) {
      result = Badge.count(
        offset: Offset(10, -6),
        count: widget.countBadge!,
        child: result,
      );
    }

    result = SpacedRow(
      spacing: menu.widget.itemPadding.right,
      children: [
        result,
        Expanded(
          child: Text(
            widget.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: menu._itemTextStyle?.resolve({
              if (selected) MaterialState.selected,
            })?.copyWith(
              color: selected ? menu._itemIndicatorOnColor : null,
            ),
          ),
        ),
        if (hasBadge)
          Transform.translate(
            offset: Offset(menu.widget.itemPadding.right / 2, 0),
            child: _buildTrailingBadge(
              widget.countBadge!,
              color: selected
                  ? theme.tonalScheme.primaryFixedDim
                  : theme.tonalScheme.secondaryFixedDim,
              onColor: selected
                  ? theme.tonalScheme.onPrimaryFixedVariant
                  : theme.tonalScheme.onSecondaryFixedVariant,
            ),
          ),
      ],
    );

    return Material(
      shape: selected
          ? menu._itemIndicatorShape
          : menu._itemIndicatorShape?.frameless,
      color: selected ? indicatorColor : Colors.transparent,
      type: selected ? MaterialType.canvas : MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius:
            menu._itemIndicatorShape?.borderRadius?.resolve(TextDirection.ltr),
        child: UnconstrainedBox(
          constrainedAxis: Axis.vertical,
          alignment: Alignment.centerLeft,
          clipBehavior: Clip.hardEdge,
          child: SizedBox(
            height: height,
            width: menu.widget.itemExpandedWidth,
            child: Padding(
              padding: menu.widget.itemPadding,
              child: result,
            ),
          ),
        ),
      ),
    );
  }
}
