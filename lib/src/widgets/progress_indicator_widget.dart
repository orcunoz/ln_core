import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final Widget? widget;
  final bool inProgress;
  final Color? color;
  final double? size;

  const ProgressIndicatorWidget({
    super.key,
    required this.widget,
    required this.inProgress,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final size = this.size ?? iconTheme.size ?? 24;
    final strokeWidth = size / 9.0;
    final color = this.color ??
        iconTheme.color ??
        Theme.of(context).colorScheme.onBackground;
    return inProgress
        ? Container(
            width: size,
            height: size,
            padding: EdgeInsets.all(strokeWidth),
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              color: color,
            ),
          )
        : (widget ?? SizedBox());
  }
}
