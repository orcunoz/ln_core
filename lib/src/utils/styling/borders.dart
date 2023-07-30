import 'package:flutter/material.dart';

import 'dart:math' as math;

extension BorderRaduisGeometryExtensions on BorderRadiusGeometry {
  BorderRadius at(BuildContext context) {
    return this is BorderRadius
        ? this as BorderRadius
        : resolve(Directionality.of(context));
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
