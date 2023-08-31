import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

enum LayerType {
  color,
  blur,
}

class ProgressIndicatorStack extends StatelessWidget {
  final WidgetBuilder _builder;

  ProgressIndicatorStack({
    super.key,
    AlignmentGeometry alignment = AlignmentDirectional.topStart,
    TextDirection? textDirection,
    StackFit fit = StackFit.loose,
    Clip clipBehavior = Clip.hardEdge,
    bool absorbPointer = true,
    bool inProgress = true,
    double effectFactor = .3,
    Duration animationDuration = const Duration(milliseconds: 300),
    LayerType layerType = LayerType.color,
    Color? layerColor,
    required List<Widget> children,
  }) : _builder = ((BuildContext context) {
          Widget child = AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: inProgress ? 1 : 0,
            child: const ProgressIndicatorBox(),
          );

          if (layerType == LayerType.blur) {
            child = AnimatedBlurLayer(
              enabled: inProgress,
              effectFactor: effectFactor,
              child: child,
            );
          } else {
            child = Container(
              color: layerColor,
              alignment: Alignment.center,
              child: child,
            );
          }

          if (absorbPointer) {
            child = AbsorbPointer(
              child: child,
            );
          }

          return Stack(
            alignment: alignment,
            textDirection: textDirection,
            fit: fit,
            clipBehavior: clipBehavior,
            children: [
              for (var child in children) child,
              child,
            ],
          );
        });

  @override
  Widget build(BuildContext context) {
    return _builder(context);
  }
}
