import 'package:flutter/material.dart';
import 'dart:math' as math;

extension ShapeBorderExtensions on ShapeBorder {
  ShapeBorder? get frameless {
    if (this is InputBorder) {
      return (this as InputBorder).frameless;
    } else if (this is OutlinedBorder) {
      return (this as OutlinedBorder).frameless;
    }

    return this;
  }

  BorderRadiusGeometry? get borderRadius {
    if (this is InputBorder) {
      return (this as InputBorder).borderRadius;
    } else if (this is OutlinedBorder) {
      return (this as OutlinedBorder).borderRadius;
    }

    return BorderRadius.zero;
  }

  BorderSide? get borderSide {
    if (this is InputBorder) {
      return (this as InputBorder).borderSide;
    } else if (this is OutlinedBorder) {
      return (this as OutlinedBorder).side;
    }

    return null;
  }

  ShapeBorder copyWith({BorderSide? borderSide}) {
    if (this is InputBorder) {
      return (this as InputBorder).copyWith(borderSide: borderSide);
    } else if (this is OutlinedBorder) {
      return (this as OutlinedBorder).copyWith(side: borderSide);
    }

    throw Exception("Unexpected ShapeBorder type!");
  }

  ShapeBorder copyWithBorderRadius(
      {BorderSide? borderSide, BorderRadius? borderRadius}) {
    if (this is InputBorder) {
      return (this as InputBorder)
          .copyWithBorderRadius(side: borderSide, borderRadius: borderRadius);
    } else if (this is OutlinedBorder) {
      return (this as OutlinedBorder)
          .copyWithBorderRadius(side: borderSide, borderRadius: borderRadius);
    }

    throw Exception("Unexpected ShapeBorder type!");
  }
}

extension InputBorderExtensions on InputBorder {
  InputBorder? get frameless => copyWith(borderSide: BorderSide.none);
  BorderRadius? get borderRadius {
    if (this is OutlineInputBorder) {
      return (this as OutlineInputBorder).borderRadius;
    } else if (this is UnderlineInputBorder) {
      return (this as UnderlineInputBorder).borderRadius;
    }

    throw Exception("Unexpected InputBorder type!");
  }

  InputBorder copyWithBorderRadius(
      {BorderSide? side, BorderRadius? borderRadius}) {
    if (this is OutlineInputBorder) {
      return (this as OutlineInputBorder)
          .copyWith(borderSide: side, borderRadius: borderRadius);
    } else if (this is UnderlineInputBorder) {
      return (this as UnderlineInputBorder)
          .copyWith(borderSide: side, borderRadius: borderRadius);
    }

    throw Exception("Unexpected InputBorder type!");
  }
}

extension OutlinedBorderExtensions on OutlinedBorder {
  OutlinedBorder? get frameless => copyWith(side: BorderSide.none);

  BorderRadiusGeometry get borderRadius {
    switch (runtimeType) {
      case CircleBorder:
        return BorderRadius.circular(double.maxFinite);
      case RoundedRectangleBorder:
        return (this as RoundedRectangleBorder).borderRadius;
      case ContinuousRectangleBorder:
        return (this as ContinuousRectangleBorder).borderRadius;
      case BeveledRectangleBorder:
        return (this as BeveledRectangleBorder).borderRadius;
      default:
        throw Exception("Unexpected OutlinedBorder type!");
    }
  }

  OutlinedBorder copyWithBorderRadius(
      {BorderSide? side, BorderRadiusGeometry? borderRadius}) {
    switch (runtimeType) {
      case CircleBorder:
        return (this as CircleBorder).copyWith(side: side);
      case RoundedRectangleBorder:
        return (this as RoundedRectangleBorder)
            .copyWith(side: side, borderRadius: borderRadius);
      case ContinuousRectangleBorder:
        return (this as ContinuousRectangleBorder)
            .copyWith(side: side, borderRadius: borderRadius);
      case BeveledRectangleBorder:
        return (this as BeveledRectangleBorder)
            .copyWith(side: side, borderRadius: borderRadius);
      default:
        throw Exception("Unexpected OutlinedBorder type!");
    }
  }
}

extension InputDecorationExtensions on InputDecoration {
  InputBorder? get defaultBorder => (border ?? enabledBorder ?? focusedBorder);

  BorderRadius? get borderRadius => defaultBorder?.borderRadius;

  BorderSide? get borderSide => defaultBorder?.borderSide;

  InputBorder get readOnlyBorder =>
      defaultBorder?.frameless ?? InputBorder.none;
}

extension InputDecorationThemeExtensions on InputDecorationTheme {
  InputBorder? get defaultBorder => (border ?? enabledBorder ?? focusedBorder);

  BorderRadius? get borderRadius => defaultBorder?.borderRadius;

  BorderSide? get borderSide => defaultBorder?.borderSide;

  InputBorder get readOnlyBorder =>
      defaultBorder?.frameless ?? InputBorder.none;
}

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

extension BorderRaduisGeometryExtensions on BorderRadiusGeometry {
  BorderRadius at(BuildContext context) {
    return this is BorderRadius
        ? this as BorderRadius
        : resolve(Directionality.of(context));
  }
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

extension ShadowExtensions on Shadow {
  List<BoxShadow> inList() {
    return [asBox()];
  }

  BoxShadow asBox() {
    return BoxShadow(
      color: color,
      blurRadius: blurRadius,
      offset: offset,
    );
  }
}

class ElevationShadow extends Shadow {
  ElevationShadow(double elevation, {Color color = Colors.black})
      : assert(elevation >= 0 && elevation <= 50),
        super(
          color: color.withOpacity(.25 + elevation * 0.1),
          blurRadius: (1 + (19.0 / 23.0) * (elevation - 1)),
          offset: Offset(0, elevation * 0.75),
        );
}

class ElevationBoxShadow extends BoxShadow {
  ElevationBoxShadow(double elevation, {Color color = Colors.black})
      : assert(elevation >= 0 && elevation <= 50),
        super(
          color: color.withOpacity(.25 + elevation * 0.1),
          blurRadius: (1 + (19.0 / 23.0) * (elevation - 1)),
          offset: Offset(0, elevation * 0.75),
        );
}

extension ThemeDataExtensions on ThemeData {
  TextStyle get defaultFormFieldStyle =>
      useMaterial3 ? textTheme.bodyLarge! : textTheme.titleMedium!;
}

class LeftlineInputBorder extends InputBorder {
  const LeftlineInputBorder({
    super.borderSide = const BorderSide(width: 6, color: Color(0xffFFB74D)),
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  });

  final BorderRadius borderRadius;

  @override
  bool get isOutline => true;

  @override
  UnderlineInputBorder copyWith(
      {BorderSide? borderSide, BorderRadius? borderRadius}) {
    return UnderlineInputBorder(
      borderSide: borderSide ?? this.borderSide,
      borderRadius: borderRadius ?? this.borderRadius,
    );
  }

  @override
  EdgeInsetsGeometry get dimensions {
    return EdgeInsets.only(left: borderSide.width);
  }

  @override
  LeftlineInputBorder scale(double t) {
    return LeftlineInputBorder(borderSide: borderSide.scale(t));
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return Path()
      ..addRect(Rect.fromLTWH(rect.left, rect.top,
          math.max(0.0, rect.width - borderSide.width), rect.height));
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    return Path()..addRRect(borderRadius.resolve(textDirection).toRRect(rect));
  }

  @override
  void paintInterior(Canvas canvas, Rect rect, Paint paint,
      {TextDirection? textDirection}) {
    canvas.drawRRect(borderRadius.resolve(textDirection).toRRect(rect), paint);
  }

  @override
  bool get preferPaintInterior => true;

  @override
  ShapeBorder? lerpFrom(ShapeBorder? a, double t) {
    if (a is LeftlineInputBorder) {
      return LeftlineInputBorder(
        borderSide: BorderSide.lerp(a.borderSide, borderSide, t),
        borderRadius: BorderRadius.lerp(a.borderRadius, borderRadius, t)!,
      );
    }
    return super.lerpFrom(a, t);
  }

  @override
  ShapeBorder? lerpTo(ShapeBorder? b, double t) {
    if (b is LeftlineInputBorder) {
      return LeftlineInputBorder(
        borderSide: BorderSide.lerp(borderSide, b.borderSide, t),
        borderRadius: BorderRadius.lerp(borderRadius, b.borderRadius, t)!,
      );
    }
    return super.lerpTo(b, t);
  }

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    double? gapStart,
    double gapExtent = 0.0,
    double gapPercentage = 0.0,
    TextDirection? textDirection,
  }) {
    if (borderRadius.topLeft != Radius.zero ||
        borderRadius.bottomLeft != Radius.zero) {
      canvas.clipPath(getOuterPath(rect, textDirection: textDirection));
    }
    canvas.drawLine(rect.topLeft, rect.bottomLeft, borderSide.toPaint());
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is LeftlineInputBorder &&
        other.borderSide == borderSide &&
        other.borderRadius == borderRadius;
  }

  @override
  int get hashCode => Object.hash(borderSide, borderRadius);
}
