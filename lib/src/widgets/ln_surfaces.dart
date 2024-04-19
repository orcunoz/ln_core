import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

class LnSurfacesTheme extends ThemeExtension<LnSurfacesTheme> {
  const LnSurfacesTheme({
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.borderSide,
    this.elevation = 0,
    this.margin = EdgeInsets.zero,
    this.clipBehavior = Clip.antiAlias,
    required this.surfaceColor,
    required this.frontSurfaceColor,
    required this.containerColor,
    required this.deepContainerColor,
  });

  static LnSurfacesTheme _defaultsOf(ThemeData t) => LnSurfacesTheme(
        surfaceColor: t.tonalScheme.surfaceBright,
        frontSurfaceColor: t.tonalScheme.surfaceBrightest,
        containerColor: t.tonalScheme.surfaceContainer,
        deepContainerColor: t.tonalScheme.surfaceDim,
      );

  final Color deepContainerColor;
  final Color containerColor;
  final Color surfaceColor;
  final Color frontSurfaceColor;

  final BorderRadius borderRadius;
  final BorderSide? borderSide;
  final double elevation;
  final EdgeInsets margin;
  final Clip clipBehavior;

  @override
  ThemeExtension<LnSurfacesTheme> copyWith({
    Color? surfaceColor,
    Color? frontSurfaceColor,
    Color? containerColor,
    Color? deepContainerColor,
    BorderRadius? borderRadius,
    BorderSide? borderSide,
    double? elevation,
    EdgeInsets? margin,
    Clip? clipBehavior,
  }) {
    return LnSurfacesTheme(
      surfaceColor: surfaceColor ?? this.surfaceColor,
      frontSurfaceColor: frontSurfaceColor ?? this.frontSurfaceColor,
      containerColor: containerColor ?? this.containerColor,
      deepContainerColor: deepContainerColor ?? this.deepContainerColor,
      borderRadius: borderRadius ?? this.borderRadius,
      borderSide: borderSide ?? this.borderSide,
      elevation: elevation ?? this.elevation,
      margin: margin ?? this.margin,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  ThemeExtension<LnSurfacesTheme> lerp(
      covariant LnSurfacesTheme? other, double t) {
    if (other == null) return this;
    return LnSurfacesTheme(
      surfaceColor: Color.lerp(surfaceColor, other.surfaceColor, t)!,
      frontSurfaceColor:
          Color.lerp(frontSurfaceColor, other.frontSurfaceColor, t)!,
      containerColor: Color.lerp(containerColor, other.containerColor, t)!,
      deepContainerColor:
          Color.lerp(deepContainerColor, other.deepContainerColor, t)!,
      borderSide: BorderSide.lerp(borderSide ?? BorderSide.none,
          other.borderSide ?? BorderSide.none, t),
      borderRadius: BorderRadius.lerp(borderRadius, other.borderRadius, t)!,
      elevation: lerpDouble(elevation, other.elevation, t)!,
      margin: EdgeInsets.lerp(margin, other.margin, t)!,
      clipBehavior: other.clipBehavior,
    );
  }
}

extension LnSurfacesThemeExtension on ThemeData {
  LnSurfacesTheme get surfaces {
    return extension<LnSurfacesTheme>() ?? LnSurfacesTheme._defaultsOf(this);
  }

  BorderSide? surfaceBorderSide(
    Color surfaceColor, {
    Color? outside,
    num sharpness = 1.0,
  }) {
    return surfaces.borderSide?.copyWith(
      color: borderColor(
        surfaceColor,
        outside: outside,
        sharpness: sharpness,
      ),
    );
  }
}

extension CornerRadiusExtensions on BorderRadius {
  BorderRadius only(Iterable<Corner> corners) {
    return copyWith(
      topLeft: corners.contains(Corner.topLeft) ? null : Radius.zero,
      topRight: corners.contains(Corner.topRight) ? null : Radius.zero,
      bottomRight: corners.contains(Corner.bottomRight) ? null : Radius.zero,
      bottomLeft: corners.contains(Corner.bottomLeft) ? null : Radius.zero,
    );
  }
}

final class Corners {
  static const none = <Corner>[];
  static const topLeft = <Corner>[Corner.topLeft];
  static const topRight = <Corner>[Corner.topRight];
  static const bottomRight = <Corner>[Corner.bottomRight];
  static const bottomLeft = <Corner>[Corner.bottomLeft];
  static const left = <Corner>[Corner.topLeft, Corner.bottomLeft];
  static const top = <Corner>[Corner.topLeft, Corner.topRight];
  static const right = <Corner>[Corner.topRight, Corner.bottomRight];
  static const bottom = <Corner>[Corner.bottomLeft, Corner.bottomRight];
  static const all = Corner.values;
}

enum Corner {
  topLeft,
  topRight,
  bottomRight,
  bottomLeft;
}

typedef TonalColorResolver = Color Function(ThemeData);

enum Surfaces {
  normal(_normal),
  dimmest(_dimmest),
  dim(_dim),
  middle(_middle),
  lessBright(_lessBright),
  bright(_bright),
  brightest(_brightest),
  containerHighest(_containerHighest),
  containerHigh(_containerHigh),
  container(_container),
  containerLow(_containerLow),
  containerLowest(_containerLowest);

  const Surfaces(this.resolve);

  final TonalColorResolver resolve;

  static Color _normal(ThemeData t) => t.tonalScheme.surface;
  static Color _dimmest(ThemeData t) => t.tonalScheme.surfaceDimmest;
  static Color _dim(ThemeData t) => t.tonalScheme.surfaceDim;
  static Color _middle(ThemeData t) => t.tonalScheme.surfaceMid;
  static Color _lessBright(ThemeData t) => t.tonalScheme.surfaceLessBright;
  static Color _bright(ThemeData t) => t.tonalScheme.surfaceBright;
  static Color _brightest(ThemeData t) => t.tonalScheme.surfaceBrightest;
  static Color _containerHighest(ThemeData t) =>
      t.tonalScheme.surfaceContainerHighest;
  static Color _containerHigh(ThemeData t) =>
      t.tonalScheme.surfaceContainerHigh;
  static Color _container(ThemeData t) => t.tonalScheme.surfaceContainer;
  static Color _containerLow(ThemeData t) => t.tonalScheme.surfaceContainerLow;
  static Color _containerLowest(ThemeData t) =>
      t.tonalScheme.surfaceContainerLowest;
}

class LnSurfaceDecoration {
  LnSurfaceDecoration({
    Surfaces? surface,
    Color? color,
    BorderRadius? borderRadius,
    BorderSide? borderSide,
    double? elevation,
  }) : this._(
          surface: surface,
          color: color,
          borderRadius: borderRadius,
          borderSide: borderSide,
          elevation: elevation,
        );

  LnSurfaceDecoration.frameless({
    Surfaces? surface,
    Color? color,
    BorderRadiusGeometry? borderRadius,
  }) : this._(
          surface: surface,
          color: color,
          borderRadius: borderRadius,
          borderSide: BorderSide.none,
          elevation: 0,
        );

  LnSurfaceDecoration._({
    TonalColorResolver? resolve,
    Surfaces? surface,
    Color? color,
    required this.elevation,
    required this.borderRadius,
    required this.borderSide,
  })  : assert([resolve, surface, color].nonNulls.length == 1),
        resolve = resolve ?? surface?.resolve ?? ((_) => color!);

  final TonalColorResolver resolve;
  final BorderRadiusGeometry? borderRadius;
  final BorderSide? borderSide;
  final double? elevation;

  LnSurfaceDecoration copyWith({
    Surfaces? surface,
    Color? color,
    BorderRadiusGeometry? borderRadius,
    BorderSide? borderSide,
    bool? borderOnForeground,
    double? elevation,
  }) {
    return LnSurfaceDecoration._(
      resolve: surface == null || color == null ? resolve : null,
      surface: surface,
      color: color,
      borderRadius: borderRadius ?? this.borderRadius,
      borderSide: borderSide ?? this.borderSide,
      elevation: elevation ?? this.elevation,
    );
  }

  static LnSurfaceDecoration? lerp(
      LnSurfaceDecoration? a, LnSurfaceDecoration? b, final double t) {
    if (identical(a, b)) {
      return a;
    }
    if (a == null || b == null) {
      return t <= .5 ? a : b;
    }
    if (t == 0.0) {
      return a;
    }
    if (t == 1.0) {
      return b;
    }
    return LnSurfaceDecoration._(
      resolve: (s) => Color.lerp(a.resolve(s), b.resolve(s), t)!,
      borderRadius:
          BorderRadiusGeometry.lerp(a.borderRadius, b.borderRadius, t)!,
      borderSide: BorderSide.lerp(a.borderSide!, b.borderSide!, t),
      elevation: lerpDouble(a.elevation, b.elevation, t),
    );
  }
}

class LnSurfaceDecorationTween extends Tween<LnSurfaceDecoration> {
  LnSurfaceDecorationTween({super.begin, super.end});

  @override
  LnSurfaceDecoration lerp(double t) =>
      LnSurfaceDecoration.lerp(begin, end, t)!;
}

class LnSurface extends StatelessWidget {
  const LnSurface(
    this.decoration, {
    this.margin,
    this.clipBehavior,
    this.borderOnForeground = true,
    required this.child,
  });

  LnSurface.clipper({
    this.margin,
    this.clipBehavior = Clip.antiAlias,
    required this.child,
  })  : borderOnForeground = false,
        decoration = LnSurfaceDecoration.frameless(
          color: Colors.transparent,
        );

  final LnSurfaceDecoration decoration;
  final EdgeInsetsGeometry? margin;
  final bool borderOnForeground;
  final Clip? clipBehavior;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = decoration.resolve(theme);
    BorderSide? borderSide = decoration.borderSide ??
        theme.surfaces.borderSide?.copyWith(
          color: theme.borderColor(surfaceColor),
        );
    BorderRadiusGeometry? borderRadius =
        decoration.borderRadius ?? theme.surfaces.borderRadius;

    return Padding(
      padding: margin ?? theme.surfaces.margin,
      child: Material(
        color: surfaceColor,
        borderOnForeground: borderOnForeground,
        borderRadius: borderSide == null ? borderRadius : null,
        shape: borderSide == null
            ? null
            : RoundedRectangleBorder(
                borderRadius: borderRadius,
                side: borderSide,
              ),
        clipBehavior: clipBehavior ?? theme.surfaces.clipBehavior,
        elevation: decoration.elevation ?? theme.surfaces.elevation,
        child: child,
      ),
    );
  }
}

class LnSurfaceTransition extends AnimatedWidget {
  const LnSurfaceTransition({
    super.key,
    required this.decoration,
    this.margin,
    this.borderOnForeground = true,
    this.clipBehavior,
    required this.child,
  }) : super(listenable: decoration);

  final Animation<LnSurfaceDecoration> decoration;
  final EdgeInsetsGeometry? margin;
  final Clip? clipBehavior;
  final bool borderOnForeground;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LnSurface(
      decoration.value,
      margin: margin,
      clipBehavior: clipBehavior,
      borderOnForeground: borderOnForeground,
      child: child,
    );
  }
}
