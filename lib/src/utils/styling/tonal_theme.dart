import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';
import 'package:material_color_utilities/dynamiccolor/src/contrast_curve.dart';
import 'package:material_color_utilities/dynamiccolor/src/tone_delta_pair.dart';

export 'package:material_color_utilities/material_color_utilities.dart';

extension TonalThemeDataExtensions on ThemeData {
  TonalScheme get tonalScheme {
    final tonalSchemeExtension = extension<TonalTheme>();
    assert(tonalSchemeExtension != null);
    return tonalSchemeExtension!.tonalScheme;
  }
}

class MaterialCustomColor {
  MaterialCustomColor(
    this.seedColor, {
    required this.scheme,
  }) : palette = TonalPalette.fromHct(Hct.fromInt(Blend.harmonize(
          seedColor,
          MaterialDynamicColors.primary.getArgb(scheme),
        )));

  final int seedColor;
  final DynamicScheme scheme;
  final TonalPalette palette;

  late final Color color = Color(_color.getArgb(scheme));
  late final Color onColor = Color(_onColor.getArgb(scheme));
  late final Color container = Color(_container.getArgb(scheme));
  late final Color onContainer = Color(_onContainer.getArgb(scheme));
  late final Color fixed = Color(_fixed.getArgb(scheme));
  late final Color onFixed = Color(_onFixed.getArgb(scheme));
  late final Color fixedDim = Color(_fixedDim.getArgb(scheme));
  late final Color onFixedVariant = Color(_onFixedVariant.getArgb(scheme));

  static bool _isFidelity(DynamicScheme scheme) =>
      scheme.variant == Variant.fidelity || scheme.variant == Variant.content;

  static bool _isMonochrome(DynamicScheme scheme) =>
      scheme.variant == Variant.monochrome;

  /*static DynamicColor highestSurface(bool isDark) {
    return isDark
        ? MaterialDynamicColors.surfaceBright
        : MaterialDynamicColors.surfaceDim;
  }*/

  late final DynamicColor _color = DynamicColor.fromPalette(
    name: 'color',
    palette: (s) => palette,
    tone: (s) {
      if (_isMonochrome(s)) {
        return s.isDark ? 100 : 0;
      }
      return s.isDark ? 80 : 40;
    },
    isBackground: true,
    background: MaterialDynamicColors.highestSurface,
    contrastCurve: ContrastCurve(3, 4.5, 7, 11),
    toneDeltaPair: (s) =>
        ToneDeltaPair(_container, _color, 15, TonePolarity.nearer, false),
  );

  late final DynamicColor _onColor = DynamicColor.fromPalette(
    name: 'on_color',
    palette: (s) => palette,
    tone: (s) {
      if (_isMonochrome(s)) {
        return s.isDark ? 10 : 90;
      }
      return s.isDark ? 20 : 100;
    },
    background: (s) => _color,
    contrastCurve: ContrastCurve(4.5, 7, 11, 21),
  );

  late final DynamicColor _container = DynamicColor.fromPalette(
    name: 'container',
    palette: (s) => palette,
    tone: (s) {
      if (_isFidelity(s)) {
        return _performAlbers(s.sourceColorHct, s);
      }
      if (_isMonochrome(s)) {
        return s.isDark ? 85 : 25;
      }
      return s.isDark ? 30 : 90;
    },
    isBackground: true,
    background: MaterialDynamicColors.highestSurface,
    contrastCurve: ContrastCurve(1, 1, 3, 7),
    toneDeltaPair: (s) =>
        ToneDeltaPair(_container, _color, 15, TonePolarity.nearer, false),
  );

  late final DynamicColor _onContainer = DynamicColor.fromPalette(
    name: 'on_container',
    palette: (s) => palette,
    tone: (s) {
      if (_isFidelity(s)) {
        return DynamicColor.foregroundTone(
            MaterialDynamicColors.primaryContainer.tone(s), 4.5);
      }
      if (_isMonochrome(s)) {
        return s.isDark ? 0 : 100;
      }
      return s.isDark ? 90 : 10;
    },
    background: (s) => MaterialDynamicColors.primaryContainer,
    contrastCurve: ContrastCurve(4.5, 7, 11, 21),
  );

  late final DynamicColor _fixed = DynamicColor.fromPalette(
    name: 'fixed',
    palette: (s) => palette,
    tone: (s) => _isMonochrome(s) ? 40.0 : 90.0,
    isBackground: true,
    background: MaterialDynamicColors.highestSurface,
    contrastCurve: ContrastCurve(1, 1, 3, 7),
    toneDeltaPair: (s) =>
        ToneDeltaPair(_fixed, _fixedDim, 10, TonePolarity.lighter, true),
  );

  late final DynamicColor _fixedDim = DynamicColor.fromPalette(
    name: 'fixed_dim',
    palette: (s) => palette,
    tone: (s) => _isMonochrome(s) ? 30.0 : 80.0,
    isBackground: true,
    background: MaterialDynamicColors.highestSurface,
    contrastCurve: ContrastCurve(1, 1, 3, 7),
    toneDeltaPair: (s) =>
        ToneDeltaPair(_fixed, _fixedDim, 10, TonePolarity.lighter, true),
  );

  late final DynamicColor _onFixed = DynamicColor.fromPalette(
    name: 'on_fixed',
    palette: (s) => palette,
    tone: (s) => _isMonochrome(s) ? 100.0 : 10.0,
    background: (s) => _fixedDim,
    secondBackground: (s) => _fixed,
    contrastCurve: ContrastCurve(4.5, 7, 11, 21),
  );

  late final DynamicColor _onFixedVariant = DynamicColor.fromPalette(
    name: 'on_fixed_variant',
    palette: (s) => palette,
    tone: (s) => _isMonochrome(s) ? 90.0 : 30.0,
    background: (s) => _fixedDim,
    secondBackground: (s) => _fixed,
    contrastCurve: ContrastCurve(3, 4.5, 7, 11),
  );

  static double _performAlbers(Hct prealbers, DynamicScheme scheme) {
    final albersd = prealbers.inViewingConditions(
        ViewingConditions.make(backgroundLstar: scheme.isDark ? 30 : 80));
    if (DynamicColor.tonePrefersLightForeground(prealbers.tone) &&
        !DynamicColor.toneAllowsLightForeground(albersd.tone)) {
      return DynamicColor.enableLightForeground(prealbers.tone);
    } else {
      return DynamicColor.enableLightForeground(albersd.tone);
    }
  }

  static MaterialCustomColor? lerp(
      MaterialCustomColor? from, MaterialCustomColor? to, double t) {
    if (t <= 0) {
      return from;
    } else if (t >= 1) {
      return to;
    } else {
      if (from != null && to != null) {
        return MaterialCustomColor(
          Color.lerp(Color(from.seedColor), Color(to.seedColor), t)!.value,
          scheme: t <= .5 ? from.scheme : to.scheme,
        );
      } else {
        return t <= .5 ? from : to;
      }
    }
  }
}

class TonalTheme extends ThemeExtension<TonalTheme> {
  TonalTheme.fromColorScheme(ColorScheme colorScheme)
      : this(TonalScheme.fromColorScheme(colorScheme,
            seedColor: colorScheme.primary));
  const TonalTheme(this.tonalScheme);

  final TonalScheme tonalScheme;

  @override
  ThemeExtension<TonalTheme> copyWith({ColorScheme? colorScheme}) {
    final newScheme = colorScheme ?? tonalScheme;
    return newScheme is TonalScheme
        ? TonalTheme(newScheme)
        : TonalTheme.fromColorScheme(newScheme);
  }

  @override
  TonalTheme lerp(covariant TonalTheme? other, double t) {
    if (other == null) return this;
    if (t <= 0) return this;
    if (t >= 1) return other;
    final sch = tonalScheme;
    final oSch = other.tonalScheme;

    return TonalTheme(TonalScheme(
      brightness: t <= .5 ? sch.brightness : oSch.brightness,
      contrastLevel: lerpDouble(sch.contrastLevel, oSch.contrastLevel, t)!,
      seedColor: Color.lerp(sch.seedColor, oSch.seedColor, t)!,
      neutral: Color.lerp(sch.neutral, oSch.neutral, t)!,
      neutralVariant: Color.lerp(sch.neutralVariant, oSch.neutralVariant, t)!,
      custom: {
        ...oSch.custom,
        for (var entry in sch.custom.entries)
          if (oSch.custom.containsKey(entry.key))
            entry.key: MaterialCustomColor.lerp(
                entry.value, oSch.custom[entry.key], t)!
          else if (t <= .5)
            entry.key: entry.value,
      },
      surfaceDimmest: Color.lerp(sch.surfaceDimmest, oSch.surfaceDimmest, t)!,
      surfaceLessDim: Color.lerp(sch.surfaceLessDim, oSch.surfaceLessDim, t)!,
      surfaceMid: Color.lerp(sch.surfaceMid, oSch.surfaceMid, t)!,
      surfaceLessBright:
          Color.lerp(sch.surfaceLessBright, oSch.surfaceLessBright, t)!,
      surfaceBrightest:
          Color.lerp(sch.surfaceBrightest, oSch.surfaceBrightest, t)!,
      surfaceBright: Color.lerp(sch.surfaceBright, oSch.surfaceBright, t)!,
      surfaceDim: Color.lerp(sch.surfaceDim, oSch.surfaceDim, t)!,
      surfaceContainerLowest: Color.lerp(
          sch.surfaceContainerLowest, oSch.surfaceContainerLowest, t)!,
      surfaceContainerLow:
          Color.lerp(sch.surfaceContainerLow, oSch.surfaceContainerLow, t)!,
      surfaceContainer:
          Color.lerp(sch.surfaceContainer, oSch.surfaceContainer, t)!,
      surfaceContainerHigh:
          Color.lerp(sch.surfaceContainerHigh, oSch.surfaceContainerHigh, t)!,
      surfaceContainerHighest: Color.lerp(
          sch.surfaceContainerHighest, oSch.surfaceContainerHighest, t)!,
      // primary
      primary: Color.lerp(sch.primary, oSch.primary, t)!,
      onPrimary: Color.lerp(sch.onPrimary, oSch.onPrimary, t)!,
      primaryContainer:
          Color.lerp(sch.primaryContainer, oSch.primaryContainer, t)!,
      onPrimaryContainer:
          Color.lerp(sch.onPrimaryContainer, oSch.onPrimaryContainer, t)!,
      primaryFixed: Color.lerp(sch.primaryFixed, oSch.primaryFixed, t)!,
      primaryFixedDim:
          Color.lerp(sch.primaryFixedDim, oSch.primaryFixedDim, t)!,
      onPrimaryFixed: Color.lerp(sch.onPrimaryFixed, oSch.onPrimaryFixed, t)!,
      onPrimaryFixedVariant:
          Color.lerp(sch.onPrimaryFixedVariant, oSch.onPrimaryFixedVariant, t)!,
      inversePrimary: Color.lerp(sch.inversePrimary, oSch.inversePrimary, t)!,
      // secondary
      secondary: Color.lerp(sch.secondary, oSch.secondary, t)!,
      onSecondary: Color.lerp(sch.onSecondary, oSch.onSecondary, t)!,
      secondaryContainer:
          Color.lerp(sch.secondaryContainer, oSch.secondaryContainer, t)!,
      onSecondaryContainer:
          Color.lerp(sch.onSecondaryContainer, oSch.onSecondaryContainer, t)!,
      secondaryFixed: Color.lerp(sch.secondaryFixed, oSch.secondaryFixed, t)!,
      secondaryFixedDim:
          Color.lerp(sch.secondaryFixedDim, oSch.secondaryFixedDim, t)!,
      onSecondaryFixed:
          Color.lerp(sch.onSecondaryFixed, oSch.onSecondaryFixed, t)!,
      onSecondaryFixedVariant: Color.lerp(
          sch.onSecondaryFixedVariant, oSch.onSecondaryFixedVariant, t)!,
      inverseSecondary:
          Color.lerp(sch.inverseSecondary, oSch.inverseSecondary, t)!,
      // tertiary
      tertiary: Color.lerp(sch.tertiary, oSch.tertiary, t)!,
      onTertiary: Color.lerp(sch.onTertiary, oSch.onTertiary, t)!,
      tertiaryContainer:
          Color.lerp(sch.tertiaryContainer, oSch.tertiaryContainer, t)!,
      onTertiaryContainer:
          Color.lerp(sch.onTertiaryContainer, oSch.onTertiaryContainer, t)!,
      tertiaryFixed: Color.lerp(sch.tertiaryFixed, oSch.tertiaryFixed, t)!,
      tertiaryFixedDim:
          Color.lerp(sch.tertiaryFixedDim, oSch.tertiaryFixedDim, t)!,
      onTertiaryFixed: Color.lerp(
          sch.onTertiaryFixedVariant, oSch.onTertiaryFixedVariant, t)!,
      onTertiaryFixedVariant: Color.lerp(
          sch.onTertiaryFixedVariant, oSch.onTertiaryFixedVariant, t)!,
      inverseTertiary:
          Color.lerp(sch.inverseTertiary, oSch.inverseTertiary, t)!,
      // other
      error: Color.lerp(sch.error, oSch.error, t)!,
      onError: Color.lerp(sch.onError, oSch.onError, t)!,
      errorContainer: Color.lerp(sch.errorContainer, oSch.errorContainer, t)!,
      onErrorContainer:
          Color.lerp(sch.onErrorContainer, oSch.onErrorContainer, t)!,
      background: Color.lerp(sch.background, oSch.background, t)!,
      onBackground: Color.lerp(sch.onBackground, oSch.onBackground, t)!,
      surface: Color.lerp(sch.surface, oSch.surface, t)!,
      onSurface: Color.lerp(sch.onSurface, oSch.onSurface, t)!,
      surfaceVariant: Color.lerp(sch.surfaceVariant, oSch.surfaceVariant, t)!,
      onSurfaceVariant:
          Color.lerp(sch.onSurfaceVariant, oSch.onSurfaceVariant, t)!,
      outline: Color.lerp(sch.outline, oSch.outline, t)!,
      outlineVariant: Color.lerp(sch.outlineVariant, oSch.outlineVariant, t)!,
      shadow: Color.lerp(sch.shadow, oSch.shadow, t)!,
      scrim: Color.lerp(sch.scrim, oSch.scrim, t)!,
      inverseSurface: Color.lerp(sch.inverseSurface, oSch.inverseSurface, t)!,
      onInverseSurface:
          Color.lerp(sch.onInverseSurface, oSch.onInverseSurface, t)!,
      surfaceTint: Color.lerp(sch.surfaceTint, oSch.surfaceTint, t)!,
    ));
  }
}

extension DynamicSchemeExtension on DynamicScheme {
  Color surfaceColor(double brightness) {
    final tone = lerpDouble(
      MaterialDynamicColors.surfaceDim.tone(this),
      MaterialDynamicColors.surfaceBright.tone(this),
      brightness,
    )!
        .round();

    return Color(neutralPalette.get(tone));
  }
}

enum TonalThemeBackground {
  grayscale,
  normal,
  colorful,
}

class TonalScheme with Diagnosticable implements ColorScheme {
  factory TonalScheme.fromSeed({
    required Color seedColor,
    required Brightness brightness,
    double contrastLevel = 0.0,
    TonalThemeBackground background = TonalThemeBackground.normal,
    Variant variant = Variant.vibrant,
    Map<String, int>? customColors,
  }) =>
      TonalScheme.fromColorScheme(
        ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: brightness,
        ),
        seedColor: seedColor,
        contrastLevel: contrastLevel,
        variant: variant,
        background: background,
        customColors: customColors,
      );

  factory TonalScheme.fromColorScheme(
    ColorScheme colorScheme, {
    Color? seedColor,
    double contrastLevel = 0.0,
    TonalThemeBackground background = TonalThemeBackground.normal,
    Variant variant = Variant.vibrant,
    Map<String, int>? customColors,
  }) {
    if (colorScheme.brightness.isLight &&
        background == TonalThemeBackground.colorful) {
      background = TonalThemeBackground.normal;
    }

    Color neutral, neutralVariant;
    (neutral, neutralVariant) = switch (background) {
      TonalThemeBackground.grayscale => () {
          final greyPalette = _tonalPaletteOf(Colors.grey);
          int neutralTone = colorScheme.brightness.isDark ? 6 : 98;
          int variantTone = colorScheme.brightness.isDark ? 30 : 90;
          return (
            Color(greyPalette.get(neutralTone)),
            Color(greyPalette.get(variantTone)),
          );
        }(),
      TonalThemeBackground.normal => (
          colorScheme.surface,
          colorScheme.surfaceVariant,
        ),
      TonalThemeBackground.colorful => (
          colorScheme.surface.blend(colorScheme.secondaryContainer, 30),
          colorScheme.surfaceVariant.blend(colorScheme.secondaryContainer, 30),
        ),
    };

    return TonalScheme.fromColors(
      brightness: colorScheme.brightness,
      seedColor: seedColor ?? colorScheme.primary,
      primary: colorScheme.primary,
      secondary: colorScheme.secondary,
      tertiary: colorScheme.tertiary,
      neutral: neutral,
      neutralVariant: neutralVariant,
      variant: variant,
      contrastLevel: contrastLevel,
      customColors: customColors,
    );
  }

  static TonalPalette _tonalPaletteOf(Color color) =>
      TonalPalette.fromHct(Hct.fromInt(color.value));

  factory TonalScheme.fromColors({
    required Brightness brightness,
    required Color seedColor,
    required Color primary,
    required Color secondary,
    required Color tertiary,
    required Color neutral,
    required Color neutralVariant,
    Variant variant = Variant.vibrant,
    double contrastLevel = 0.0,
    Map<String, int>? customColors,
  }) {
    final scheme = DynamicScheme(
      sourceColorArgb: seedColor.value,
      variant: variant,
      isDark: brightness.isDark,
      contrastLevel: contrastLevel,
      primaryPalette: _tonalPaletteOf(primary),
      secondaryPalette: _tonalPaletteOf(secondary),
      tertiaryPalette: _tonalPaletteOf(tertiary),
      neutralPalette: _tonalPaletteOf(neutral),
      neutralVariantPalette: _tonalPaletteOf(neutralVariant),
    );

    Color c(DynamicColor dynColor) {
      return Color(dynColor.getArgb(scheme));
    }

    return TonalScheme(
      brightness: brightness,
      contrastLevel: scheme.contrastLevel,
      seedColor: Color(scheme.sourceColorArgb),
      neutral: neutral,
      neutralVariant: neutralVariant,
      custom: {
        if (customColors != null)
          for (var entry in customColors.entries)
            entry.key: MaterialCustomColor(entry.value, scheme: scheme),
      },
      // Surfaces
      surface: c(MaterialDynamicColors.surface),
      onSurface: c(MaterialDynamicColors.onSurface),
      surfaceVariant: c(MaterialDynamicColors.surfaceVariant),
      onSurfaceVariant: c(MaterialDynamicColors.onSurfaceVariant),
      surfaceDimmest: scheme.surfaceColor(-0.2),
      surfaceLessDim: scheme.surfaceColor(.5),
      surfaceMid: scheme.surfaceColor(.6),
      surfaceLessBright: scheme.surfaceColor(.9),
      surfaceBrightest: scheme.surfaceColor(1.1),
      surfaceBright: c(MaterialDynamicColors.surfaceBright),
      surfaceDim: c(MaterialDynamicColors.surfaceDim),
      surfaceContainerLowest: c(MaterialDynamicColors.surfaceContainerLowest),
      surfaceContainerLow: c(MaterialDynamicColors.surfaceContainerLow),
      surfaceContainer: c(MaterialDynamicColors.surfaceContainer),
      surfaceContainerHigh: c(MaterialDynamicColors.surfaceContainerHigh),
      surfaceContainerHighest: c(MaterialDynamicColors.surfaceContainerHighest),
      inverseSurface: c(MaterialDynamicColors.inverseSurface),
      onInverseSurface: c(MaterialDynamicColors.inverseOnSurface),
      // Primary
      primary: c(MaterialDynamicColors.primary),
      onPrimary: c(MaterialDynamicColors.onPrimary),
      primaryContainer: c(MaterialDynamicColors.primaryContainer),
      onPrimaryContainer: c(MaterialDynamicColors.onPrimaryContainer),
      primaryFixed: c(MaterialDynamicColors.primaryFixed),
      primaryFixedDim: c(MaterialDynamicColors.primaryFixedDim),
      onPrimaryFixed: c(MaterialDynamicColors.onPrimaryFixed),
      onPrimaryFixedVariant: c(MaterialDynamicColors.onPrimaryFixedVariant),
      inversePrimary: c(MaterialDynamicColors.inversePrimary),
      // Secondary
      secondary: c(MaterialDynamicColors.secondary),
      onSecondary: c(MaterialDynamicColors.onSecondary),
      secondaryContainer: c(MaterialDynamicColors.secondaryContainer),
      onSecondaryContainer: c(MaterialDynamicColors.onSecondaryContainer),
      secondaryFixed: c(MaterialDynamicColors.secondaryFixed),
      secondaryFixedDim: c(MaterialDynamicColors.secondaryFixedDim),
      onSecondaryFixed: c(MaterialDynamicColors.onSecondaryFixed),
      onSecondaryFixedVariant: c(MaterialDynamicColors.onSecondaryFixedVariant),
      inverseSecondary: c(_inverseSecondary),
      // Tertiary
      tertiary: c(MaterialDynamicColors.tertiary),
      onTertiary: c(MaterialDynamicColors.onTertiary),
      tertiaryContainer: c(MaterialDynamicColors.tertiaryContainer),
      onTertiaryContainer: c(MaterialDynamicColors.onTertiaryContainer),
      tertiaryFixed: c(MaterialDynamicColors.tertiaryFixed),
      tertiaryFixedDim: c(MaterialDynamicColors.tertiaryFixedDim),
      onTertiaryFixed: c(MaterialDynamicColors.onTertiaryFixed),
      onTertiaryFixedVariant: c(MaterialDynamicColors.onTertiaryFixedVariant),
      inverseTertiary: c(_inverseTertiary),
      // Other
      error: c(MaterialDynamicColors.error),
      onError: c(MaterialDynamicColors.onError),
      errorContainer: c(MaterialDynamicColors.errorContainer),
      onErrorContainer: c(MaterialDynamicColors.onErrorContainer),
      background: c(MaterialDynamicColors.background),
      onBackground: c(MaterialDynamicColors.onBackground),
      outline: c(MaterialDynamicColors.outline),
      outlineVariant: c(MaterialDynamicColors.outlineVariant),
      shadow: c(MaterialDynamicColors.shadow),
      scrim: c(MaterialDynamicColors.scrim),
      surfaceTint: c(MaterialDynamicColors.surfaceTint),
    );
  }

  TonalScheme({
    required this.seedColor,
    required this.contrastLevel,
    required this.neutral,
    required this.neutralVariant,
    this.custom = const {},
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.secondary,
    required this.onSecondary,
    required this.secondaryContainer,
    required this.onSecondaryContainer,
    required this.inverseSecondary,
    required this.tertiary,
    required this.onTertiary,
    required this.tertiaryContainer,
    required this.onTertiaryContainer,
    required this.inverseTertiary,
    required this.error,
    required this.onError,
    required this.errorContainer,
    required this.onErrorContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.outline,
    required this.outlineVariant,
    required this.shadow,
    required this.scrim,
    required this.inverseSurface,
    required this.onInverseSurface,
    required this.inversePrimary,
    required this.surfaceTint,
    required this.primaryFixed,
    required this.primaryFixedDim,
    required this.onPrimaryFixed,
    required this.onPrimaryFixedVariant,
    required this.secondaryFixed,
    required this.secondaryFixedDim,
    required this.onSecondaryFixed,
    required this.onSecondaryFixedVariant,
    required this.tertiaryFixed,
    required this.tertiaryFixedDim,
    required this.onTertiaryFixed,
    required this.onTertiaryFixedVariant,
    required this.surfaceBright,
    required this.surfaceDim,
    required this.surfaceContainerLowest,
    required this.surfaceContainerLow,
    required this.surfaceContainer,
    required this.surfaceContainerHigh,
    required this.surfaceContainerHighest,
    required this.brightness,
    required this.surfaceDimmest,
    required this.surfaceLessDim,
    required this.surfaceMid,
    required this.surfaceLessBright,
    required this.surfaceBrightest,
  });

  static final DynamicColor _inverseSecondary = DynamicColor.fromPalette(
    name: 'inverse_secondary',
    palette: (s) => s.secondaryPalette,
    tone: (s) => s.isDark ? 40 : 80,
    background: (s) => MaterialDynamicColors.inverseSurface,
    contrastCurve: ContrastCurve(3, 4.5, 7, 11),
  );

  static final DynamicColor _inverseTertiary = DynamicColor.fromPalette(
    name: 'inverse_tertiary',
    palette: (s) => s.tertiaryPalette,
    tone: (s) => s.isDark ? 40 : 80,
    background: (s) => MaterialDynamicColors.inverseSurface,
    contrastCurve: ContrastCurve(3, 4.5, 7, 11),
  );

  final Color neutral;
  final Color neutralVariant;

  final Color primaryFixed;
  final Color primaryFixedDim;
  final Color onPrimaryFixed;
  final Color onPrimaryFixedVariant;

  final Color secondaryFixed;
  final Color secondaryFixedDim;
  final Color onSecondaryFixed;
  final Color onSecondaryFixedVariant;
  final Color inverseSecondary;

  final Color tertiaryFixed;
  final Color tertiaryFixedDim;
  final Color onTertiaryFixed;
  final Color onTertiaryFixedVariant;
  final Color inverseTertiary;

  // Surfaces
  final Color surfaceContainerLowest;
  final Color surfaceContainerLow;
  final Color surfaceContainer;
  //final late Color surfaceContainer = _scheme.surfaceColor(_scheme.isDark ? .35 : .6);
  final Color surfaceContainerHigh;
  final Color surfaceContainerHighest;

  final Color surfaceDimmest;
  final Color surfaceDim;
  final Color surfaceLessDim;
  final Color surfaceMid;
  final Color surfaceLessBright;
  final Color surfaceBright;
  final Color surfaceBrightest;

  final Map<String, MaterialCustomColor> custom;

  @override
  final Color background;

  @override
  final Brightness brightness;

  @override
  final Color error;

  @override
  final Color errorContainer;

  @override
  final Color inversePrimary;

  @override
  final Color inverseSurface;

  @override
  final Color onBackground;

  @override
  final Color onError;

  @override
  final Color onErrorContainer;

  @override
  final Color onInverseSurface;

  @override
  final Color onPrimary;

  @override
  final Color onPrimaryContainer;

  @override
  final Color onSecondary;

  @override
  final Color onSecondaryContainer;

  @override
  final Color onSurface;

  @override
  final Color onSurfaceVariant;

  @override
  final Color onTertiary;

  @override
  final Color onTertiaryContainer;

  @override
  final Color outline;

  @override
  final Color outlineVariant;

  @override
  final Color primary;

  @override
  final Color primaryContainer;

  @override
  final Color scrim;

  @override
  final Color secondary;

  @override
  final Color secondaryContainer;

  @override
  final Color shadow;

  @override
  final Color surface;

  @override
  final Color surfaceTint;

  @override
  final Color surfaceVariant;

  @override
  final Color tertiary;

  @override
  final Color tertiaryContainer;

  final Color seedColor;

  final double contrastLevel;

  Color surfaceContainerAt(int level) {
    assert(1 <= level && level <= 5);
    return switch (level) {
      1 => surfaceContainerLowest,
      2 => surfaceContainerLow,
      3 => surfaceContainer,
      4 => surfaceContainerHigh,
      5 => surfaceContainerHighest,
      _ => throw Exception(),
    };
  }

  @override
  ColorScheme copyWith({
    Brightness? brightness,
    double? contrastLevel,
    Color? seedColor,
    Color? neutral,
    Color? neutralVariant,
    Map<String, MaterialCustomColor>? custom,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? secondary,
    Color? onSecondary,
    Color? secondaryContainer,
    Color? onSecondaryContainer,
    Color? tertiary,
    Color? onTertiary,
    Color? tertiaryContainer,
    Color? onTertiaryContainer,
    Color? error,
    Color? onError,
    Color? errorContainer,
    Color? onErrorContainer,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? surfaceVariant,
    Color? onSurfaceVariant,
    Color? outline,
    Color? outlineVariant,
    Color? shadow,
    Color? scrim,
    Color? inverseSurface,
    Color? onInverseSurface,
    Color? inversePrimary,
    Color? surfaceTint,
    Color? primaryFixed,
    Color? primaryFixedDim,
    Color? onPrimaryFixed,
    Color? onPrimaryFixedVariant,
    Color? secondaryFixed,
    Color? secondaryFixedDim,
    Color? onSecondaryFixed,
    Color? onSecondaryFixedVariant,
    Color? inverseSecondary,
    Color? tertiaryFixed,
    Color? tertiaryFixedDim,
    Color? onTertiaryFixed,
    Color? onTertiaryFixedVariant,
    Color? inverseTertiary,
    Color? surfaceBright,
    Color? surfaceDim,
    Color? surfaceContainerLowest,
    Color? surfaceContainerLow,
    Color? surfaceContainer,
    Color? surfaceContainerHigh,
    Color? surfaceContainerHighest,
    Color? surfaceDimmest,
    Color? surfaceLessDim,
    Color? surfaceMid,
    Color? surfaceLessBright,
    Color? surfaceBrightest,
  }) {
    return TonalScheme(
      seedColor: seedColor ?? this.seedColor,
      contrastLevel: contrastLevel ?? this.contrastLevel,
      neutral: neutral ?? this.neutral,
      neutralVariant: neutralVariant ?? this.neutralVariant,
      custom: custom ?? this.custom,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      secondary: secondary ?? this.secondary,
      onSecondary: onSecondary ?? this.onSecondary,
      secondaryContainer: secondaryContainer ?? this.secondaryContainer,
      onSecondaryContainer: onSecondaryContainer ?? this.onSecondaryContainer,
      tertiary: tertiary ?? this.tertiary,
      onTertiary: onTertiary ?? this.onTertiary,
      tertiaryContainer: tertiaryContainer ?? this.tertiaryContainer,
      onTertiaryContainer: onTertiaryContainer ?? this.onTertiaryContainer,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      errorContainer: errorContainer ?? this.errorContainer,
      onErrorContainer: onErrorContainer ?? this.onErrorContainer,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      outline: outline ?? this.outline,
      outlineVariant: outlineVariant ?? this.outlineVariant,
      shadow: shadow ?? this.shadow,
      scrim: scrim ?? this.scrim,
      inverseSurface: inverseSurface ?? this.inverseSurface,
      onInverseSurface: onInverseSurface ?? this.onInverseSurface,
      inversePrimary: inversePrimary ?? this.inversePrimary,
      surfaceTint: surfaceTint ?? this.surfaceTint,
      primaryFixed: primaryFixed ?? this.primaryFixed,
      primaryFixedDim: primaryFixedDim ?? this.primaryFixedDim,
      onPrimaryFixed: onPrimaryFixed ?? this.onPrimaryFixed,
      onPrimaryFixedVariant:
          onPrimaryFixedVariant ?? this.onPrimaryFixedVariant,
      secondaryFixed: secondaryFixed ?? this.secondaryFixed,
      secondaryFixedDim: secondaryFixedDim ?? this.secondaryFixedDim,
      onSecondaryFixed: onSecondaryFixed ?? this.onSecondaryFixed,
      onSecondaryFixedVariant:
          onSecondaryFixedVariant ?? this.onSecondaryFixedVariant,
      inverseSecondary: inverseSecondary ?? this.inverseSecondary,
      tertiaryFixed: tertiaryFixed ?? this.tertiaryFixed,
      tertiaryFixedDim: tertiaryFixedDim ?? this.tertiaryFixedDim,
      onTertiaryFixed: onTertiaryFixed ?? this.onTertiaryFixed,
      onTertiaryFixedVariant:
          onTertiaryFixedVariant ?? this.onTertiaryFixedVariant,
      inverseTertiary: inverseTertiary ?? this.inverseTertiary,
      surfaceBright: surfaceBright ?? this.surfaceBright,
      surfaceDim: surfaceDim ?? this.surfaceDim,
      surfaceContainerLowest:
          surfaceContainerLowest ?? this.surfaceContainerLowest,
      surfaceContainerLow: surfaceContainerLow ?? this.surfaceContainerLow,
      surfaceContainer: surfaceContainer ?? this.surfaceContainer,
      surfaceContainerHigh: surfaceContainerHigh ?? this.surfaceContainerHigh,
      surfaceContainerHighest:
          surfaceContainerHighest ?? this.surfaceContainerHighest,
      brightness: brightness ?? this.brightness,
      surfaceDimmest: surfaceDimmest ?? this.surfaceDimmest,
      surfaceLessDim: surfaceLessDim ?? this.surfaceLessDim,
      surfaceMid: surfaceMid ?? this.surfaceMid,
      surfaceLessBright: surfaceLessBright ?? this.surfaceLessBright,
      surfaceBrightest: surfaceBrightest ?? this.surfaceBrightest,
    );
  }
}
