import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

class Responsive extends Container {
  Responsive({
    super.key,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    super.alignment = Alignment.topCenter,
    bool card = false,
    bool double = false,
    required Widget child,
  }) : super(
          child: card
              ? ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth:
                          double ? largeLayoutThreshold : smallLayoutThreshold),
                  child: Card(
                    margin: margin,
                    child: padding == null
                        ? child
                        : Padding(
                            padding: padding,
                            child: child,
                          ),
                  ),
                )
              : Container(
                  padding: padding,
                  margin: margin,
                  constraints: BoxConstraints(
                      maxWidth:
                          double ? largeLayoutThreshold : smallLayoutThreshold),
                  child: child,
                ),
        );
}
