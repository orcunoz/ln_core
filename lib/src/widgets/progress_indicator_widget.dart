import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final Widget? widget;
  final bool loading;

  const ProgressIndicatorWidget({
    super.key,
    required this.widget,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconTheme = IconTheme.of(context);
    final iconColor = theme.iconButtonTheme.style?.iconColor?.resolve({}) ??
        iconTheme.color ??
        theme.colorScheme.onBackground;
    return loading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: iconColor,
            ),
          )
        : (widget ?? SizedBox());
  }
}
