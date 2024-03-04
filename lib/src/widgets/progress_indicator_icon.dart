import 'package:flutter/material.dart';
import 'package:ln_core/src/widgets/progress_indicator_box.dart';

class ProgressIndicatorIcon extends StatelessWidget {
  final IconData? icon;
  final Color? color;
  final double? size;
  final bool progress;

  const ProgressIndicatorIcon({
    super.key,
    required this.icon,
    required this.progress,
    this.color,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final color = this.color ??
        Theme.of(context).iconButtonTheme.style?.iconColor?.resolve({}) ??
        iconTheme.color ??
        Theme.of(context).colorScheme.onSurface;
    final size =
        this.size ?? iconTheme.size ?? Theme.of(context).iconTheme.size ?? 24;
    return progress
        ? ProgressIndicatorBox(
            size: size,
            color: color,
          )
        : Icon(icon, size: size, color: color);
  }
}
