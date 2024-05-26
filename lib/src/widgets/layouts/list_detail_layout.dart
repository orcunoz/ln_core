import 'package:flutter/material.dart' hide BottomSheet;

import '../bottom_sheet.dart';

class ListDetailLayout extends StatelessWidget {
  const ListDetailLayout({
    super.key,
    required this.listPane,
    required this.listPaneWidth,
    this.detailView,
    this.detailsOpen = false,
    required this.expandedLayout,
  });

  final Widget listPane;
  final Widget? detailView;
  final bool detailsOpen;
  final double listPaneWidth;
  final bool expandedLayout;

  @override
  Widget build(BuildContext context) {
    final List<Widget> children;

    if (expandedLayout) {
      children = [
        Positioned(
          width: listPaneWidth,
          left: 0,
          top: 0,
          bottom: 0,
          child: listPane,
        ),
        if (detailView != null)
          Positioned.fill(
            left: listPaneWidth,
            child: detailView!,
          ),
      ];
    } else {
      children = [
        listPane,
        if (detailView != null)
          Positioned.fill(
            child: BottomSheet(
              open: detailsOpen,
              child: detailView!,
            ),
          ),
      ];
    }

    return Stack(
      clipBehavior: Clip.none,
      children: children,
    );
  }
}
