import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SelectableCard extends Card {
  final bool selected;
  final Function()? onTap;

  late BuildContext _context;

  SelectableCard({
    super.key,
    super.color,
    super.shadowColor,
    super.surfaceTintColor,
    super.elevation,
    super.shape,
    super.borderOnForeground,
    super.margin,
    super.clipBehavior,
    super.semanticContainer,
    super.child,
    required this.onTap,
    required this.selected,
  });

  @override
  Color? get color =>
      selected ? Theme.of(_context).colorScheme.primaryContainer : super.color;

  @override
  Widget? get child => InkWell(
        onTap: onTap,
        child: super.child,
      );

  @override
  Widget build(BuildContext context) => super.build(_context = context);
}
