import 'dart:async';

import 'package:ln_core/ln_core.dart';
import 'package:flutter/material.dart';

class CopyableCard extends StatefulWidget {
  const CopyableCard({
    super.key,
    required this.text,
    this.copyMessage,
  });

  final String text;
  final String? copyMessage;

  @override
  State<CopyableCard> createState() => _CopyableCardState();
}

class _CopyableCardState extends State<CopyableCard> {
  Offset _offset = Offset(1, 0);
  Timer? _resetterTimer;

  void _onPressCopy() async {
    await DeviceUtils.copyToClipboard(widget.text);
    setState(() {
      _offset = Offset(0, 0);
    });
    _resetterTimer?.cancel();
    _resetterTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _offset = Offset(1, 0);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(kMinInteractiveDimension / 2);

    return ClipRRect(
      borderRadius: borderRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: theme.inputDecorationTheme.fillColor,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
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
                Padding(
                  padding: EdgeInsets.all(4),
                  child: FilledButton.icon(
                    onPressed: _onPressCopy,
                    icon: Icon(Icons.copy, size: 20),
                    label: Text(LnLocalizations.current.copy),
                  ),
                ),
              ],
            ),
            Positioned.fill(
              child: AnimatedSlide(
                offset: _offset,
                duration: const Duration(milliseconds: 200),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: borderRadius,
                    color: theme.colorScheme.primaryContainer,
                  ),
                  child: Center(
                    child: Text(LnLocalizations.current.linkCopiedToClipboard),
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
