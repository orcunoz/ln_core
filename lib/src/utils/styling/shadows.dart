import 'package:flutter/material.dart';

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
          color: color.withOpacity((.25 + elevation * 0.1) * color.opacity),
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
