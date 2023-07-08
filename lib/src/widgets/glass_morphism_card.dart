import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

class GlassMorphismCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final BorderRadius? borderRadius;
  final double depth;
  final double noiseEffect;
  final double colorEffect;
  final EdgeInsets padding;
  final double? borderWidth;
  final double? height;

  const GlassMorphismCard({
    super.key,
    required this.child,
    this.color,
    this.borderRadius,
    this.depth = 3,
    this.noiseEffect = 0,
    this.colorEffect = 0.3,
    this.padding = EdgeInsets.zero,
    this.borderWidth,
    this.height,
  })  : assert(noiseEffect >= 0 && noiseEffect <= 1.0),
        assert(colorEffect >= 0 && colorEffect <= 1.0),
        assert(borderWidth == null || borderWidth >= 0);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nnBorderRadius = borderRadius ??
        theme.cardTheme.shape?.borderRadius?.at(context) ??
        BorderRadius.zero;

    final foregroundColor = color ?? theme.colorScheme.onBackground;

    return ClipRRect(
      borderRadius: nnBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: depth * 2, sigmaY: depth * 2),
        child: Container(
          padding: padding,
          height: height,
          decoration: BoxDecoration(
            image: noiseEffect == 0
                ? null
                : DecorationImage(
                    image: const AssetImage('assets/images/television_noise.jpg'),
                    fit: BoxFit.none,
                    repeat: ImageRepeat.repeat,
                    scale: 2,
                    opacity: noiseEffect,
                  ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
                foregroundColor.withOpacity(colorEffect * 0.66),
                foregroundColor.withOpacity(colorEffect * 0.33)
              ],
            ),
            color: foregroundColor.withOpacity(colorEffect),
            borderRadius: nnBorderRadius,
            border: borderWidth == 0
                ? null
                : Border.all(
                    width: borderWidth ?? 0.5,
                    color: foregroundColor.withOpacity(colorEffect),
                  ),
          ),
          child: child,
        ),
      ),
    );
  }
}
