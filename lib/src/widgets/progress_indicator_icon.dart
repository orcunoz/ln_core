import 'package:flutter/material.dart';

class ProgressIndicatorIcon extends StatelessWidget {
  final IconData? icon;
  final bool loading;

  ProgressIndicatorIcon({
    super.key,
    required this.icon,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final iconColor =
        Theme.of(context).iconButtonTheme.style?.iconColor?.resolve({}) ??
            iconTheme.color ??
            Theme.of(context).colorScheme.onBackground;
    return loading
        ? CircularProgressIndicator(
            strokeWidth: 2.5,
            color: iconColor,
          )
        : Icon(icon, color: iconColor);
  }
}

class ProgressIndicatorWidget extends StatelessWidget {
  final Widget? widget;
  final bool loading;

  ProgressIndicatorWidget({
    super.key,
    required this.widget,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final iconColor =
        Theme.of(context).iconButtonTheme.style?.iconColor?.resolve({}) ??
            iconTheme.color ??
            Theme.of(context).colorScheme.onBackground;
    return loading
        ? CircularProgressIndicator(
            strokeWidth: 2.5,
            color: iconColor,
          )
        : (widget ?? SizedBox());
  }
}
