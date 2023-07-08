import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HtmlContent extends Html {
  HtmlContent({
    super.key,
    super.data,
    style = const {},
    double? defaultFontSize,
    super.shrinkWrap,
    OnTap? onLinkTap,
    required Color linkTextColor,
    required Color textColor,
  }) : super(
          style: {
            "body": Style(
              padding: HtmlPaddings.zero,
              margin: Margins.zero,
            ),
            "*": Style(
              color: textColor,
              fontSize: defaultFontSize == null
                  ? null
                  : FontSize(
                      defaultFontSize,
                      Unit.px,
                    ),
            ),
            "a": Style(
              color: linkTextColor,
              textDecoration: TextDecoration.none,
            ),
            ...style,
          },
          onLinkTap: onLinkTap ??
              (url, _, __) {
                if (url != null) launchUrlString(url);
              },
        );
}
