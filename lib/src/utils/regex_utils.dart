abstract class RegexUtilities {
  RegexUtilities._();

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
}
