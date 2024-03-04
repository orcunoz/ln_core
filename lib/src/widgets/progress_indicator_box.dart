import 'package:flutter/material.dart';

class ProgressIndicatorBox extends StatelessWidget {
  const ProgressIndicatorBox({
    super.key,
    this.color,
    this.size = 84,
    double? strokeWidth,
    double? padding,
    this.boxColor,
    this.elevation = 1,
  })  : strokeWidth = size / 16,
        padding = size / 5.0;

  final double size;
  final double strokeWidth;
  final double padding;
  final Color? color;
  final Color? boxColor;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: boxColor,
        elevation: elevation,
        child: SizedBox(
          width: size,
          height: size,
          child: Padding(
            padding: EdgeInsets.all(strokeWidth / 2.0 + padding),
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
