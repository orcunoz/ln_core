import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

class ElevatedImage extends StatelessWidget {
  const ElevatedImage({
    super.key,
    this.elevation = 2,
    this.backLightColor,
    required this.image,
  });

  final double elevation;
  final Color? backLightColor;
  final Image image;

  bool get backlight => backLightColor != null;

  Widget _shade(BoxShadow shadow) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: shadow.blurSigma,
        sigmaY: shadow.blurSigma,
      ),
      child: Image(
        image: image.image,
        loadingBuilder: image.loadingBuilder,
        errorBuilder: image.errorBuilder,
        semanticLabel: image.semanticLabel,
        excludeFromSemantics: image.excludeFromSemantics,
        width: image.width,
        height: image.height,
        frameBuilder: image.frameBuilder,
        fit: image.fit,
        alignment: image.alignment,
        color: shadow.color,
        repeat: image.repeat,
        centerSlice: image.centerSlice,
        matchTextDirection: image.matchTextDirection,
        gaplessPlayback: image.gaplessPlayback,
        isAntiAlias: image.isAntiAlias,
        filterQuality: image.filterQuality,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Iterable<BoxShadow> shadows = Shadows.of(
      elevation,
      color: backLightColor ?? Colors.black,
      shine: backlight,
    );

    return Stack(
      clipBehavior: Clip.none,
      children: [
        for (BoxShadow shadow in shadows)
          backlight
              ? _shade(shadow)
              : ImageFiltered(
                  imageFilter: ImageFilter.matrix(
                    Matrix4.translationValues(
                      shadow.offset.dx,
                      shadow.offset.dy,
                      0,
                    ).storage,
                  ),
                  child: _shade(shadow),
                ),
        image,
      ],
    );
  }
}
