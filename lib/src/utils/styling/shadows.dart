import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

extension ShadowsExtensions on BoxShadow {
  BoxShadow withColor(Color color) => BoxShadow(
        color: color,
        offset: offset,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
        blurStyle: blurStyle,
      );
}

abstract final class Shadows {
  static List<BoxShadow> _scaleList(List<BoxShadow> shadows, double factor) {
    return [
      for (var shadow in shadows) shadow.scale(factor),
    ];
  }

  static List<BoxShadow> of(
    double elevation, {
    Color color = Colors.black,
    bool shine = false,
  }) {
    assert(color.opacity == 1);
    assert(elevation >= 0);
    List<BoxShadow> shadows;
    if (elevation == 0) {
      return [];
    } else if (elevation < 1) {
      shadows = BoxShadow.lerpList([], kElevationToShadow[1]!, elevation)!;
    } else {
      final floor = kElevationToShadow.keys.lastWhere((e) => e <= elevation);
      List<BoxShadow> floorList = kElevationToShadow[floor]!;

      if (floor == elevation) {
        shadows = floorList;
      } else {
        final ceil =
            kElevationToShadow.keys.firstWhereOrNull((e) => e >= elevation);
        if (ceil == null) {
          shadows = _scaleList(floorList, elevation / floor);
        } else {
          List<BoxShadow> ceilList = kElevationToShadow[ceil]!;
          double t = (elevation - floor) / (ceil - floor);
          shadows = BoxShadow.lerpList(floorList, ceilList, t)!;
        }
      }
    }

    final multiplier = shine ? 4 : 1;
    return [
      for (var shadow in shadows)
        BoxShadow(
          color: color.withOpacity(shadow.color.opacity * multiplier),
          offset: shadow.offset,
          blurRadius: shadow.blurRadius,
          spreadRadius: shadow.spreadRadius,
          blurStyle: shadow.blurStyle,
        ),
    ];
  }
}
