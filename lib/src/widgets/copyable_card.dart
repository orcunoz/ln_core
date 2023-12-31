import 'dart:async';

import 'package:ln_core/ln_core.dart';
import 'package:flutter/material.dart';

class CopyableCard extends StatefulWidget {
  final String text;
  final String? copyMessage;
  const CopyableCard({
    super.key,
    required this.text,
    this.copyMessage,
  });

  @override
  State<CopyableCard> createState() => _CopyableCardState();
}

class _CopyableCardState extends State<CopyableCard> {
  double _scale = 0;
  Timer? _resetterTimer;

  void _onPressCopy() async {
    await DeviceUtils.copyToClipboard(widget.text);
    setState(() {
      _scale = 1;
    });
    _resetterTimer?.cancel();
    _resetterTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _scale = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.primaryColor.withOpacity(0.4);
    return SelectableCard(
      onTap: _onPressCopy,
      selected: false,
      margin: EdgeInsets.zero,
      shape: theme.cardTheme.shape?.copyWith(
        borderSide:
            theme.cardTheme.shape?.borderSide?.copyWith(color: borderColor),
      ),
      child: IntrinsicHeight(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.text,
                      style: theme.textTheme.labelMedium,
                    ),
                  ),
                ),
                PrecisionVerticalDivider(color: borderColor),
                Container(
                  color: theme.highlightColor,
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.center,
                  child: SpacedRow(
                    spacing: 6,
                    children: [
                      Icon(
                        Icons.copy,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      Text(
                        LnLocalizations.current.copy,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            AnimatedScale(
              scale: _scale,
              duration: const Duration(milliseconds: 200),
              child: Card(
                color: theme.colorScheme.primaryContainer,
                margin: EdgeInsets.zero,
                child: Center(
                  child: Text(
                    LnLocalizations.current.linkCopiedToClipboard,
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
