import 'package:flutter/material.dart' hide BottomSheet;

import '../bottom_sheet.dart';

class SupportingPaneLayout extends StatelessWidget {
  const SupportingPaneLayout({
    super.key,
    this.supportingPane,
    required this.supportingPaneWidth,
    required this.expandedLayout,
    required this.child,
  });

  final Widget? supportingPane;
  final double supportingPaneWidth;
  final bool expandedLayout;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children;

    if (expandedLayout) {
      children = [
        Positioned.fill(
          right: supportingPaneWidth,
          child: child,
        ),
        Positioned(
          width: supportingPaneWidth,
          right: 0,
          top: 0,
          bottom: 0,
          child: supportingPane ?? const SizedBox.shrink(),
        ),
      ];
    } else {
      children = [
        child,
        BottomSheet(
          open: supportingPane != null,
          child: supportingPane ?? const SizedBox.shrink(),
        ),
      ];
    }

    return Stack(
      clipBehavior: Clip.none,
      children: children,
    );
  }
}
