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
  });

  static const _default = LnSurfacesTheme();

  final BorderRadius borderRadius;
  final BorderSide? borderSide;
  final double elevation;
  final EdgeInsets margin;
  final Clip clipBehavior;

  @override
  ThemeExtension<LnSurfacesTheme> copyWith({
    BorderRadius? borderRadius,
    BorderSide? borderSide,
    double? elevation,
    EdgeInsets? margin,
    Clip? clipBehavior,
  }) {
    return LnSurfacesTheme(
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
    return extension<LnSurfacesTheme>() ?? LnSurfacesTheme._default;
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

typedef TonalColorResolver = Color Function(TonalScheme);

class SurfaceColorGetters {}

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

  const Surfaces(this.resolver);

  final TonalColorResolver resolver;

  static Color _normal(TonalScheme s) => s.surface;
  static Color _dimmest(TonalScheme s) => s.surfaceDimmest;
  static Color _dim(TonalScheme s) => s.surfaceDim;
  static Color _middle(TonalScheme s) => s.surfaceMid;
  static Color _lessBright(TonalScheme s) => s.surfaceLessBright;
  static Color _bright(TonalScheme s) => s.surfaceBright;
  static Color _brightest(TonalScheme s) => s.surfaceBrightest;
  static Color _containerHighest(TonalScheme s) => s.surfaceContainerHighest;
  static Color _containerHigh(TonalScheme s) => s.surfaceContainerHigh;
  static Color _container(TonalScheme s) => s.surfaceContainer;
  static Color _containerLow(TonalScheme s) => s.surfaceContainerLow;
  static Color _containerLowest(TonalScheme s) => s.surfaceContainerLowest;
}

class LnSurfaceDecoration {
  LnSurfaceDecoration(
    Surfaces surface, {
    this.elevation,
    this.borderRadius,
    this.borderSide,
  }) : resolve = surface.resolver;

  LnSurfaceDecoration.frameless(
    Surfaces surface, {
    this.borderRadius,
  })  : resolve = surface.resolver,
        borderSide = BorderSide.none,
        elevation = 0;

  LnSurfaceDecoration.custom(
    Color color, {
    this.elevation,
    this.borderRadius,
    this.borderSide,
  }) : resolve = ((_) => color);

  LnSurfaceDecoration._resolver(
    this.resolve, {
    this.elevation,
    this.borderRadius,
    this.borderSide,
  });

  final TonalColorResolver resolve;
  final BorderRadiusGeometry? borderRadius;
  final BorderSide? borderSide;
  final double? elevation;

  LnSurfaceDecoration copyWith({
    Surfaces? surface,
    BorderRadiusGeometry? borderRadius,
    BorderSide? borderSide,
    bool? borderOnForeground,
    double? elevation,
  }) {
    return LnSurfaceDecoration._resolver(
      surface?.resolver ?? resolve,
      borderRadius: borderRadius ?? this.borderRadius,
      borderSide: borderSide ?? this.borderSide,
      elevation: elevation ?? this.elevation,
    );
  }

  static LnSurfaceDecoration? lerp(
      LnSurfaceDecoration? a, LnSurfaceDecoration? b, double t) {
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
    return LnSurfaceDecoration._resolver(
      (s) => Color.lerp(a.resolve(s), b.resolve(s), t)!,
      borderRadius:
          BorderRadiusGeometry.lerp(a.borderRadius, b.borderRadius, t)!,
      borderSide: BorderSide.lerp(a.borderSide!, b.borderSide!, t),
      elevation: lerpDouble(a.elevation, b.elevation, t),
    );
  }
}

class LnSurfaceDecorationTween extends Tween<LnSurfaceDecoration> {
  LnSurfaceDecorationTween({super.begin, super.end});

  /// Returns the value this variable has at the given animation clock value.
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
    this.clipBehavior,
    required this.child,
  })  : borderOnForeground = false,
        decoration = LnSurfaceDecoration.custom(
          Colors.transparent,
          elevation: 0,
          borderSide: BorderSide.none,
        );

  final LnSurfaceDecoration decoration;
  final EdgeInsetsGeometry? margin;
  final bool borderOnForeground;
  final Clip? clipBehavior;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = decoration.resolve(theme.tonalScheme);
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
