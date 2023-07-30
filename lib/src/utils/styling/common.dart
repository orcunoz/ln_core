import 'package:flutter/material.dart';

import 'dart:math' as math;

extension ColorExtensions on Color {
  MaterialStatePropertyAll<Color> get material =>
      MaterialStatePropertyAll(this);

  Color get onColor =>
      ThemeData.estimateBrightnessForColor(this) == Brightness.light
          ? Colors.black
          : Colors.white;

  bool get isLight =>
      ThemeData.estimateBrightnessForColor(this) == Brightness.light;

  bool get isDark =>
      ThemeData.estimateBrightnessForColor(this) == Brightness.dark;

  Color lighten([final int amount = 10]) {
    if (amount <= 0) return this;
    if (amount > 100) return Colors.white;
    final HSLColor hsl = this == const Color(0xFF000000)
        ? HSLColor.fromColor(this).withSaturation(0)
        : HSLColor.fromColor(this);
    return hsl
        .withLightness(math.min(1, math.max(0, hsl.lightness + amount / 100)))
        .toColor();
  }

  Color darken([final int amount = 10]) {
    if (amount <= 0) return this;
    if (amount > 100) return Colors.black;
    final HSLColor hsl = HSLColor.fromColor(this);
    return hsl
        .withLightness(math.min(1, math.max(0, hsl.lightness - amount / 100)))
        .toColor();
  }

  Color blend(final Color input, [final int amount = 10]) {
    if (amount <= 0) return this;
    if (amount >= 100) return input;
    return Color.alphaBlend(input.withAlpha(255 * amount ~/ 100), this);
  }

  Color blendAlpha(final Color input, [final int alpha = 0x0A]) {
    if (alpha <= 0) return this;
    if (alpha >= 255) return input;
    return Color.alphaBlend(input.withAlpha(alpha), this);
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

extension ThemeDataExtensions on ThemeData {
  TextStyle get defaultFormFieldStyle =>
      useMaterial3 ? textTheme.bodyLarge! : textTheme.titleMedium!;
}

extension EdgeInsetsExtensions on EdgeInsets {
  EdgeInsets symetricScale({num vertical = 1, num horizontal = 1}) => copyWith(
        left: left * horizontal,
        right: right * horizontal,
        top: top * vertical,
        bottom: bottom * vertical,
      );

  MaterialStateProperty<EdgeInsets> get material =>
      MaterialStatePropertyAll(this);
}

extension EdgeInsetsGeometryExtensions on EdgeInsetsGeometry {
  EdgeInsetsGeometry get double => add(this);

  EdgeInsets at(BuildContext context) => this is EdgeInsets
      ? this as EdgeInsets
      : resolve(Directionality.of(context));

  MaterialStateProperty<EdgeInsetsGeometry> get material =>
      MaterialStatePropertyAll(this);
}
