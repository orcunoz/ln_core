import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HtmlContent extends Builder {
  HtmlContent({
    super.key,
    String? data,
    Map<String, Style> style = const {},
    double? defaultFontSize,
    bool shrinkWrap = false,
    OnTap? onLinkTap,
    Color? linkTextColor,
    Color? textColor,
    List<HtmlExtension> extensions = const [],
    Set<String>? onlyRenderTheseTags,
    Set<String>? doNotRenderTheseTags,
  }) : super(
          builder: (context) {
            final defaultStyle = DefaultTextStyle.of(context).style;
            final fontSize = FontSize(
              defaultFontSize ?? defaultStyle.fontSize ?? 14,
              Unit.px,
            );
            final defaultColor = textColor ?? defaultStyle.color;
            final linkColor =
                linkTextColor ?? Theme.of(context).colorScheme.primary;

            return Html(
              data: data,
              style: {
                "body": (style["body"] ?? Style()).copyWith(
                  padding: HtmlPaddings.zero,
                  margin: Margins.zero,
                ),
                "*": (style["*"] ?? Style()).copyWith(
                  color: defaultColor,
                  fontSize: fontSize,
                ),
                "a": (style["a"] ?? Style()).copyWith(
                  color: linkColor,
                  textDecoration: TextDecoration.none,
                ),
                ...style,
              },
              onLinkTap: onLinkTap ??
                  (url, _, __) {
                    if (url != null) launchUrlString(url);
                  },
              onCssParseError: (s, messageList) =>
                  messageList.toList().join(", "),
            );
          },
        );
}
