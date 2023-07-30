import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:window_manager/window_manager.dart';

class DraggableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final EdgeInsets? padding;

  const DraggableAppBar({
    super.key,
    this.title,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final foregroundColor =
        this.foregroundColor ?? Theme.of(context).appBarTheme.foregroundColor;
    final backgroundColor =
        this.backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor;

    Widget child = AppBar(
      title: title,
      actions: actions,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    );

    if (padding != null) {
      child = Container(
        padding: padding,
        color: backgroundColor,
        child: child,
      );
    }

    if (UniversalPlatform.isDesktop) {
      child = DragToMoveArea(
        child: child,
      );
    }

    return child;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
