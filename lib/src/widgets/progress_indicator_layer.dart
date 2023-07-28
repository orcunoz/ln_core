import 'package:flutter/material.dart';

class ProgressIndicatorLayer extends StatelessWidget {
  final double size;
  final EdgeInsets? padding;
  final bool withCard;
  final bool withBackLayer;

  const ProgressIndicatorLayer({
    super.key,
    this.size = 84,
    this.padding,
    this.withCard = true,
    this.withBackLayer = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      width: size,
      height: size,
      padding: padding ?? EdgeInsets.all(size / 3.5),
      child: CircularProgressIndicator(
        strokeWidth: size / 20,
      ),
    );

    if (withCard) {
      child = Card(
        child: child,
      );
    }

    if (withBackLayer) {
      child = AbsorbPointer(
        child: Container(
          alignment: Alignment.center,
          color: Theme.of(context).colorScheme.background.withOpacity(0.5),
          child: child,
        ),
      );
    } else {
      child = Center(
        child: child,
      );
    }

    return child;
  }
}
