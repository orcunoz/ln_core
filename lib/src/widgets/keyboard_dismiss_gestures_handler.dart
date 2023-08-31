import 'package:flutter/material.dart';

class KeyboardDismissGesturesHandler extends StatelessWidget {
  const KeyboardDismissGesturesHandler({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: child,
    );
  }
}
