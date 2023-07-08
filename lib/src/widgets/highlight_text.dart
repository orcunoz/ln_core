import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String? highlightedText;
  final TextStyle? style;
  final TextStyle? highlightStyle;
  final Color? highlightColor;
  final Color? highlightBackColor;
  final bool ignoreCase;

  const HighlightedText(
    this.text, {
    super.key,
    required this.highlightedText,
    this.style,
    this.highlightColor,
    this.highlightBackColor,
    this.highlightStyle,
    this.ignoreCase = true,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle nnTextStyle = style ?? DefaultTextStyle.of(context).style;
    TextStyle nnHighlightStyle = highlightStyle ??
        nnTextStyle.copyWith(
          color: highlightColor ?? Theme.of(context).primaryColor,
          backgroundColor:
              highlightBackColor ?? Theme.of(context).highlightColor,
        );

    InlineSpan highlightedSpan(String content) {
      return TextSpan(text: content, style: nnHighlightStyle);
    }

    InlineSpan normalSpan(String content) {
      return TextSpan(text: content, style: nnTextStyle);
    }

    final text = this.text;
    if (highlightedText == null || highlightedText!.isEmpty || text.isEmpty) {
      return Text(text, style: nnTextStyle);
    }

    var sourceText = ignoreCase ? text.toLowerCase() : text;
    var targetHighlight =
        ignoreCase ? highlightedText!.toLowerCase() : highlightedText!;

    List<InlineSpan> spans = [];
    int start = 0;
    int indexOfHighlight;
    do {
      indexOfHighlight = sourceText.indexOf(targetHighlight, start);
      if (indexOfHighlight < 0) {
        spans.add(normalSpan(text.substring(start)));
        break;
      }
      if (indexOfHighlight > start) {
        spans.add(normalSpan(text.substring(start, indexOfHighlight)));
      }
      start = indexOfHighlight + targetHighlight.length;
      spans.add(highlightedSpan(text.substring(indexOfHighlight, start)));
    } while (true);

    return Text.rich(TextSpan(children: spans));
  }
}
