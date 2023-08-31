import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

class Responsive extends Container {
  Responsive({
    super.key,
    super.alignment = Alignment.topCenter,
    bool card = false,
    bool double = false,
    required Widget child,
  }) : super(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth:
                  double ? 2 * smallLayoutThreshold : smallLayoutThreshold,
            ),
            child: card
                ? Card(
                    margin: EdgeInsets.zero,
                    child: child,
                  )
                : child,
          ),
        );
}
