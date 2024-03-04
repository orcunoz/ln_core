import 'package:flutter/material.dart';

import 'dart:math' as math;

extension ColorExtensions on Color {
  MaterialStatePropertyAll<Color> get material =>
      MaterialStatePropertyAll(this);

  Color get onColor => switch (ThemeData.estimateBrightnessForColor(this)) {
        Brightness.light => const Color(0xFF111111),
        Brightness.dark => Colors.white,
      };

  bool get isLight =>
      ThemeData.estimateBrightnessForColor(this) == Brightness.light;

  bool get isDark =>
      ThemeData.estimateBrightnessForColor(this) == Brightness.dark;

  Color lighten([final num amount = 10]) {
    if (amount <= 0) return this;
    if (amount > 100) return Colors.white;
    final HSLColor hsl = this == const Color(0xFF000000)
        ? HSLColor.fromColor(this).withSaturation(0)
        : HSLColor.fromColor(this);
    return hsl
        .withLightness(math.min(1, math.max(0, hsl.lightness + amount / 100.0)))
        .toColor();
  }

  Color darken([final num amount = 10]) {
    if (amount <= 0) return this;
    if (amount > 100) return Colors.black;
    final HSLColor hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness(math.min(1, math.max(0, hsl.lightness - amount / 100.0)))
        .toColor();
  }

  Color blend(final Color input, [final num amount = 10]) {
    if (amount <= .0) return this;
    if (amount >= 100.0) return input;
    return Color.alphaBlend(input.withAlpha((255.0 * amount) ~/ 100), this);
  }

  Color blendAlpha(final Color input, [final int alpha = 0x0A]) {
    if (alpha <= 0) return this;
    if (alpha >= 255) return input;
    return Color.alphaBlend(input.withAlpha(alpha), this);
  }

  Color withOpacityFactor(final num factor) {
    assert(0 <= factor);
    return withOpacity((opacity * factor).clamp(0, 1));
  }
}

extension StringColorExtensions on String {
  Color get toColor {
    if (this == '') return const Color(0xFF000000);
    String hexColor = replaceAll('#', '');
    hexColor = hexColor.replaceAll('0x', '');
    hexColor = hexColor.padLeft(6, '0');
    hexColor = hexColor.padLeft(8, 'F');
    final int length = hexColor.length;
    return Color(int.tryParse('0x${hexColor.substring(length - 8, length)}') ??
        0xFF000000);
  }
}
