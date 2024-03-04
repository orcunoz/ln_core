import 'package:flutter/material.dart';

class PrecisionDivider extends Divider {
  const PrecisionDivider({
    super.key,
    super.height = .5,
    super.thickness = .5,
    super.indent,
    super.endIndent,
    super.color,
  });
}

class VerticalPrecisionDivider extends VerticalDivider {
  const VerticalPrecisionDivider({
    super.key,
    super.width = .5,
    super.thickness = .5,
    super.indent,
    super.endIndent,
    super.color,
  });
}
