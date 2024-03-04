abstract final class RegExpUtilities {
  RegExpUtilities._();

  static Iterable<RegExpMatch> detectLinks(String input) {
    final matcher = RegExp(
        r"(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{0,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)");
    return matcher.allMatches(input);
  }

  static Iterable<RegExpMatch> detectBrackets(String input) {
    RegExp exp = RegExp(/*r"[\[a-z\]]"*/ r"\[([^\[\]]+)\]");
    return exp.allMatches(input);
  }

  static Iterable<RegExpMatch> lessGreaterThanVariables(String input) {
    RegExp exp = RegExp(r"<[^>]*>" /*r"<([^\[\]]+)>"*/);
    return exp.allMatches(input);
  }

  static List<RegExpSplitPart> splitByPart(
    String text, {
    required String part,
    bool caseSensitive = false,
  }) {
    final matches = RegExp(
      RegExp.escape(part),
      multiLine: true,
      caseSensitive: caseSensitive,
      unicode: true,
      dotAll: true,
    ).allMatches(text).toList();
    var parts = <RegExpSplitPart>[];

    if (matches.isEmpty) {
      parts.add(RegExpSplitPart._(text));
    } else if (matches.first.start != 0) {
      parts.add(RegExpSplitPart._(text.substring(0, matches.first.start)));
    }

    for (var i = 0; i < matches.length; i++) {
      var highlightText = text.substring(matches[i].start, matches[i].end);
      parts.add(RegExpSplitPart._(highlightText, matched: true));
      if (i + 1 < matches.length) {
        parts.add(RegExpSplitPart._(
            text.substring(matches[i].end, matches[i + 1].start)));
      } else if (matches[i].end < text.length) {
        parts.add(
            RegExpSplitPart._(text.substring(matches[i].end, text.length)));
      }
    }

    return parts;
  }
}

class RegExpSplitPart {
  const RegExpSplitPart._(this.text, {this.matched = false});
  final String text;
  final bool matched;
}
