import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

class DraggableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsets? padding;
  final PreferredSizeWidget? bottom;

  const DraggableAppBar({
    super.key,
    this.title,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor =
        this.foregroundColor ?? AppBarTheme.of(context).foregroundColor;
    final backgroundColor =
        this.backgroundColor ?? AppBarTheme.of(context).backgroundColor;

    Widget child = AppBar(
      title: title,
      actions: actions,
      leading: leading,
      foregroundColor: foregroundColor,
      centerTitle: false,
      bottom: bottom,
    );

    child = Container(
      padding: padding,
      color: backgroundColor,
      constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).safePadding.top + preferredSize.height),
      child: child,
    );

    if (UniversalPlatform.isDesktop) {
      child = DragToMoveArea(
        child: child,
      );
    }

    return child;
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
