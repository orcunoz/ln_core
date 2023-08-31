import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

class ProgressIndicatorBox extends StatelessWidget {
  const ProgressIndicatorBox({
    super.key,
    this.color,
    this.size = 84,
    double? strokeWidth,
    double? padding,
    this.boxColor,
  })  : strokeWidth = size / 16,
        padding = size / 5.0;

  final double size;
  final double strokeWidth;
  final double padding;
  final Color? boxColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardTheme = CardTheme.of(context);
    final defaultCardTheme = theme.cardTheme;

    final shape = cardTheme.shape ?? defaultCardTheme.shape;
    final boxColor = this.boxColor ??
        cardTheme.color ??
        defaultCardTheme.color ??
        theme.colorScheme.background;

    Widget child = Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: boxColor,
          border: shape?.borderSide != null
              ? Border.fromBorderSide(shape!.borderSide!)
              : null,
          borderRadius: shape?.borderRadius,
        ),
        padding: EdgeInsets.all(strokeWidth / 2.0 + padding),
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          color: color,
        ),
      ),
    );

    return child;
  }
}
