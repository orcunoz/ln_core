import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

class ElevatedImage extends StatelessWidget {
  final double elevation;
  final Image image;
  final Color? backLightColor;
  const ElevatedImage({
    super.key,
    this.elevation = 2,
    required this.image,
    this.backLightColor,
  });

  @override
  Widget build(BuildContext context) {
    if (elevation == 0) return image;

    final shadow =
        ElevationShadow(elevation, color: backLightColor ?? Colors.black);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: shadow.offset.dy,
          left: shadow.offset.dx,
          child: Image(
            image: image.image,
            frameBuilder: image.frameBuilder,
            loadingBuilder: image.loadingBuilder,
            errorBuilder: image.errorBuilder,
            semanticLabel: image.semanticLabel,
            excludeFromSemantics: image.excludeFromSemantics,
            width: image.width,
            height: image.height,
            color: shadow.color,
            opacity: image.opacity,
            colorBlendMode: image.colorBlendMode,
            fit: image.fit,
            alignment: image.alignment,
            repeat: image.repeat,
            centerSlice: image.centerSlice,
            matchTextDirection: image.matchTextDirection,
            gaplessPlayback: image.gaplessPlayback,
            isAntiAlias: image.isAntiAlias,
            filterQuality: image.filterQuality,
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 1 + shadow.offset.dx / shadow.blurRadius,
            sigmaY: 1 + shadow.offset.dy / shadow.blurRadius,
          ),
          child: image,
        ),
      ],
    );
  }
}
