import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

extension ColorSchemeExtensions on ColorScheme {
  bool get isDark => brightness.isDark;
  bool get isLight => brightness.isLight;
}

extension BrightnessExtensions on Brightness {
  bool get isDark => this == Brightness.dark;
  bool get isLight => this == Brightness.light;

  Color get color => switch (this) {
        Brightness.light => Colors.white,
        Brightness.dark => const Color(0xFF111111),
      };

  Color get onColor => switch (this) {
        Brightness.light => const Color(0xFF111111),
        Brightness.dark => Colors.white,
      };

  Color borderColor(
    Color surface, {
    Color? outside,
    num sharpness = 1.0,
  }) {
    assert(0 <= sharpness && sharpness <= 10);
    Color baseColor = surface;

    if (outside != null) {
      final lighterOutside =
          surface.computeLuminance() < outside.computeLuminance();

      if (isDark ^ lighterOutside) {
        baseColor = outside;
      }
    }

    return baseColor.blend(color, sharpness * 5);
  }
}

extension ThemeDataExtensions on ThemeData {
  TextStyle get formFieldStyle =>
      useMaterial3 ? textTheme.bodyLarge! : textTheme.titleMedium!;

  int? get version => extension<VersionExtension>()?.number;

  Brightness get onBrightness => switch (brightness) {
        Brightness.light => Brightness.dark,
        Brightness.dark => Brightness.light,
      };

  bool get isDark => brightness.isDark;
  bool get isLight => brightness.isLight;

  Color borderColor(
    Color surface, {
    Color? outside,
    num sharpness = 1.0,
  }) =>
      onBrightness.borderColor(surface, outside: outside, sharpness: sharpness);

  T call<T extends ThemeExtension<T>>() => extension<T>()!;
}

class VersionExtension extends ThemeExtension<VersionExtension> {
  const VersionExtension(this.number);

  final int number;

  @override
  ThemeExtension<VersionExtension> copyWith({int? number}) {
    return VersionExtension(number ?? this.number);
  }

  @override
  ThemeExtension<VersionExtension> lerp(
      covariant ThemeExtension<VersionExtension>? other, double t) {
    return other ?? this;
  }
}

class LazyLoader<T> {
  LazyLoader(this.loader);

  final FutureOr<T> Function() loader;

  Future<T> load() => Future.sync(loader).then((value) => _data = value);

  T? _data;
  T get data {
    assert(_data != null);
    return _data!;
  }
}
