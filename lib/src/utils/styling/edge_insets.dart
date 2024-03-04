import 'package:flutter/material.dart';
import 'package:ln_core/src/ln_state.dart';

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
  EdgeInsets at(LnContextDependentsGetters dependents) => this is EdgeInsets
      ? this as EdgeInsets
      : resolve(dependents.textDirection);

  EdgeInsets get removeHorizontal =>
      resolve(TextDirection.ltr).copyWith(left: 0, right: 0);

  EdgeInsets get removeVertical =>
      resolve(TextDirection.ltr).copyWith(top: 0, bottom: 0);

  MaterialStateProperty<EdgeInsetsGeometry> get material =>
      MaterialStatePropertyAll(this);
}
