import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

class HighlightedText extends StatelessWidget {
  const HighlightedText(
    this.text, {
    super.key,
    required this.highlightedText,
    this.style,
    this.highlightColor,
    this.highlightBackColor,
    this.ignoreCase = false,
  });

  final String text;
  final String? highlightedText;
  final TextStyle? style;
  final Color? highlightColor;
  final Color? highlightBackColor;
  final bool ignoreCase;

  @override
  Widget build(BuildContext context) {
    TextStyle style = this.style ?? DefaultTextStyle.of(context).style;
    TextSpan result;

    if (highlightedText == null || highlightedText!.isEmpty || text.isEmpty) {
      result = TextSpan(text: text, style: style);
    } else {
      ThemeData? themeData;
      ThemeData theme() => themeData ??= Theme.of(context);

      TextStyle highlightStyle = style.copyWith(
        color: highlightColor ?? theme().colorScheme.onPrimaryContainer,
        backgroundColor:
            highlightBackColor ?? theme().colorScheme.primaryContainer,
        fontWeight: FontWeight.bold,
      );

      final parts = RegExpUtilities.splitByPart(text, part: highlightedText!);
      result = TextSpan(children: [
        for (var part in parts)
          TextSpan(
            text: part.text,
            style: part.matched ? highlightStyle : style,
          ),
      ]);
    }

    return Text.rich(result);
  }
}
