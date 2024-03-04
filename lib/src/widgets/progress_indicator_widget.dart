import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final Widget widget;
  final bool progress;
  final Color? color;
  final double? size;

  const ProgressIndicatorWidget({
    super.key,
    required this.widget,
    required this.progress,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final size = this.size ?? iconTheme.size ?? 24;
    final color = this.color ??
        iconTheme.color ??
        Theme.of(context).colorScheme.onSurface;

    return progress
        ? Container(
            width: size,
            height: size,
            padding: EdgeInsets.all(size / 8.0),
            child: CircularProgressIndicator(
              color: color,
              strokeWidth: size / 10.0,
            ),
          )
        : widget;
  }
}
