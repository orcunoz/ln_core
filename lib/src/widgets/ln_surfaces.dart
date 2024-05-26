import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

typedef TonalColorResolver = Color Function(ThemeData);

enum Surfaces {
  normal(_normal),
  dimmest(_dimmest),
  dim(_dim),
  middle(_middle),
  almostBright(_almostBright),
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
  static Color _almostBright(ThemeData t) => t.tonalScheme.surfaceAlmostBright;
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

extension SurfacesThemeDataExtensions on ThemeData {
  LnSurfacesTheme get surfaces {
    return extension<LnSurfacesTheme>() ?? LnSurfacesTheme.defaults;
  }
}

class LnSurfacesTheme extends ThemeExtension<LnSurfacesTheme> {
  const LnSurfacesTheme({
    this.shape,
    this.elevation,
    this.margin,
    this.clipBehavior,
  });

  static LnSurfacesTheme defaults = LnSurfacesTheme(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    elevation: 0,
    margin: EdgeInsets.zero,
    clipBehavior: Clip.antiAlias,
  );

  final ShapeBorder? shape;
  final double? elevation;
  final EdgeInsets? margin;
  final Clip? clipBehavior;

  @override
  LnSurfacesTheme copyWith({
    TonalColorResolver? defaultColorResolver,
    ShapeBorder? shape,
    double? elevation,
    EdgeInsets? margin,
    Clip? clipBehavior,
  }) {
    return LnSurfacesTheme(
      shape: shape ?? this.shape,
      elevation: elevation ?? this.elevation,
      margin: margin ?? this.margin,
      clipBehavior: clipBehavior ?? this.clipBehavior,
    );
  }

  @override
  LnSurfacesTheme lerp(covariant LnSurfacesTheme? other, double t) {
    return LnSurfacesTheme(
      shape: ShapeBorder.lerp(shape, other?.shape, t),
      elevation: lerpDouble(elevation, other?.elevation, t),
      margin: EdgeInsets.lerp(margin, other?.margin, t),
      clipBehavior: t < .5 ? clipBehavior : other?.clipBehavior,
    );
  }
}

class LnSurfaceDecoration {
  LnSurfaceDecoration({
    Surfaces? surface,
    Color? color,
    TonalColorResolver? resolver,
    ShapeBorder? shape,
    BorderRadiusGeometry? borderRadius,
    double? elevation,
    this.borderOnForeground,
    this.margin,
    this.clipBehavior,
    this.shadowColor,
    this.deep = false,
  })  : assert(shape == null || borderRadius == null),
        elevation = deep == true ? 0 : elevation,
        _resolver = resolver,
        _color = color,
        _surface = surface,
        shape = shape ??
            (borderRadius == null
                ? null
                : RoundedRectangleBorder(borderRadius: borderRadius));

  LnSurfaceDecoration.frameless({
    Surfaces? surface,
    Color? color,
    TonalColorResolver? resolver,
    BorderRadiusGeometry? borderRadius,
    this.margin,
    this.clipBehavior,
    this.shadowColor,
    this.deep = false,
  })  : elevation = 0,
        borderOnForeground = false,
        _resolver = resolver,
        _color = color,
        _surface = surface,
        shape = (borderRadius == null
            ? null
            : RoundedRectangleBorder(borderRadius: borderRadius));

  final Surfaces? _surface;
  final Color? _color;
  final TonalColorResolver? _resolver;
  final ShapeBorder? shape;
  final bool? borderOnForeground;
  final double? elevation;
  final EdgeInsets? margin;
  final Clip? clipBehavior;
  final Color? shadowColor;
  final bool deep;

  BorderRadiusGeometry? get borderRadius => shape?.borderRadius;

  TonalColorResolver? get resolveColor {
    final color = _color;
    return _resolver ??
        _surface?.resolve ??
        (color != null ? (t) => color : null);
  }

  LnSurfaceDecoration clipper() {
    return LnSurfaceDecoration.frameless(
      borderRadius: shape?.borderRadius,
      margin: margin,
      clipBehavior: Clip.antiAlias,
    );
  }

  LnSurfaceDecoration copyWith({
    Surfaces? surface,
    Color? color,
    TonalColorResolver? resolver,
    ShapeBorder? shape,
    BorderRadiusGeometry? borderRadius,
    bool? borderOnForeground,
    double? elevation,
    EdgeInsets? margin,
    Clip? clipBehavior,
    Color? shadowColor,
    bool? deep,
  }) {
    assert(shape == null || borderRadius == null);
    assert([resolver, surface, color].nonNulls.length <= 1);
    if (resolver == null && surface == null && color == null) {
      resolver = _resolver;
      surface = _surface;
      color = _color;
    }

    if (borderRadius != null) {
      shape = RoundedRectangleBorder(borderRadius: borderRadius);
    }

    return LnSurfaceDecoration(
      resolver: resolver,
      surface: surface,
      color: color,
      shape: shape ?? this.shape,
      borderOnForeground: borderOnForeground ?? this.borderOnForeground,
      elevation: elevation ?? this.elevation,
      margin: margin ?? this.margin,
      clipBehavior: clipBehavior ?? this.clipBehavior,
      shadowColor: shadowColor ?? this.shadowColor,
      deep: deep ?? this.deep,
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

    TonalColorResolver? resolver;
    if (a.resolveColor != null && b.resolveColor != null) {
      resolver = (s) => Color.lerp(a.resolveColor!(s), b.resolveColor!(s), t)!;
    } else {
      resolver = t < .5 ? a.resolveColor : b.resolveColor;
    }

    return LnSurfaceDecoration(
      resolver: resolver,
      shape: ShapeBorder.lerp(a.shape, b.shape, t),
      borderOnForeground: t < .5 ? a.borderOnForeground : b.borderOnForeground,
      elevation: lerpDouble(a.elevation, b.elevation, t),
      margin: EdgeInsets.lerp(a.margin, b.margin, t),
      clipBehavior: t < .5 ? a.clipBehavior : b.clipBehavior,
      shadowColor: Color.lerp(a.shadowColor, b.shadowColor, t),
      deep: t < .5 ? a.deep : b.deep,
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
    required this.child,
  }) : clipBehavior = null;

  LnSurface.clipper({
    this.clipBehavior = Clip.antiAlias,
    required this.child,
  }) : decoration = LnSurfaceDecoration.frameless(
          color: Colors.transparent,
        );

  final LnSurfaceDecoration decoration;
  final Clip? clipBehavior;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = decoration.resolveColor?.call(theme);
    final type = color == null || color == Colors.transparent
        ? MaterialType.transparency
        : MaterialType.button;

    final clipBehavior = this.clipBehavior ??
        decoration.clipBehavior ??
        theme.surfaces.clipBehavior ??
        Clip.none;

    return Padding(
      padding: decoration.margin ?? EdgeInsets.zero,
      child: Material(
        type: type,
        color: color,
        shadowColor: decoration.shadowColor ?? theme.shadowColor,
        elevation: decoration.elevation ?? theme.surfaces.elevation ?? 0.0,
        shape: decoration.shape ?? theme.surfaces.shape,
        borderOnForeground: decoration.borderOnForeground ?? true,
        clipBehavior: clipBehavior,
        child: child,
      ),
    );
  }
}

class LnSurfaceTransition extends AnimatedWidget {
  const LnSurfaceTransition({
    super.key,
    required this.decoration,
    required this.child,
  }) : super(listenable: decoration);

  final Animation<LnSurfaceDecoration> decoration;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LnSurface(
      decoration.value,
      child: child,
    );
  }
}
