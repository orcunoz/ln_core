import 'package:flutter/material.dart';

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

extension CornerRadiusDirectionalExtensions on BorderRadiusGeometry {
  BorderRadiusGeometry onlyDirectional(Iterable<DirectionalCorner> corners) {
    final self = resolve(TextDirection.ltr);
    return BorderRadiusDirectional.only(
      topStart: corners.contains(DirectionalCorner.topStart)
          ? self.topLeft
          : Radius.zero,
      topEnd: corners.contains(DirectionalCorner.topEnd)
          ? self.topRight
          : Radius.zero,
      bottomEnd: corners.contains(DirectionalCorner.bottomEnd)
          ? self.bottomRight
          : Radius.zero,
      bottomStart: corners.contains(DirectionalCorner.bottomStart)
          ? self.bottomLeft
          : Radius.zero,
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

final class DirectionalCorners {
  static const none = <DirectionalCorner>[];
  static const topStart = <DirectionalCorner>[DirectionalCorner.topStart];
  static const topEnd = <DirectionalCorner>[DirectionalCorner.topEnd];
  static const bottomEnd = <DirectionalCorner>[DirectionalCorner.bottomEnd];
  static const bottomStart = <DirectionalCorner>[DirectionalCorner.bottomStart];
  static const start = <DirectionalCorner>[
    DirectionalCorner.topStart,
    DirectionalCorner.bottomStart
  ];
  static const top = <DirectionalCorner>[
    DirectionalCorner.topStart,
    DirectionalCorner.topEnd
  ];
  static const end = <DirectionalCorner>[
    DirectionalCorner.topEnd,
    DirectionalCorner.bottomEnd
  ];
  static const bottom = <DirectionalCorner>[
    DirectionalCorner.bottomStart,
    DirectionalCorner.bottomEnd
  ];
  static const all = DirectionalCorner.values;

  static List<DirectionalCorner> byAlignment(WrapCrossAlignment alignment) =>
      switch (alignment) {
        WrapCrossAlignment.start => DirectionalCorners.end,
        WrapCrossAlignment.end => DirectionalCorners.start,
        _ => DirectionalCorners.all,
      };
}

enum Corner {
  topLeft,
  topRight,
  bottomRight,
  bottomLeft;
}

enum DirectionalCorner {
  topStart,
  topEnd,
  bottomEnd,
  bottomStart;
}
