final RegExp _upperAlphaRegex = RegExp(r'[A-Z]');
const symbolSet = {' ', '.', '/', '_', '\\', '-'};

extension StringExtensions on String {
  String toFixed(int requiredLength,
      {String fillChar = ' ', bool alignLeft = true}) {
    assert(fillChar.length == 1);
    if (requiredLength > length) {
      return alignLeft
          ? padRight(requiredLength, fillChar)
          : padLeft(requiredLength, fillChar);
    } else {
      return alignLeft
          ? substring(0, requiredLength)
          : substring(length - requiredLength, length);
    }
  }

  String limitLength(int limit) {
    return length > limit ? substring(0, limit) : this;
  }

  List<String> get words {
    StringBuffer sb = StringBuffer();
    List<String> wds = [];
    bool isAllCaps = toUpperCase() == this;

    for (int i = 0; i < length; i++) {
      String char = this[i];
      String? nextChar = i + 1 == length ? null : this[i + 1];

      if (symbolSet.contains(char)) {
        continue;
      }

      sb.write(char);

      bool isEndOfWord = nextChar == null ||
          (_upperAlphaRegex.hasMatch(nextChar) && !isAllCaps) ||
          symbolSet.contains(nextChar);

      if (isEndOfWord) {
        wds.add(sb.toString());
        sb.clear();
      }
    }

    return wds;
  }

  String get camelCase => words
      .map((w) => w.toLowerCase().upperCaseFirstLetter)
      .join()
      .lowerCaseFirstLetter;

  String get constantCase => words.join('_').toUpperCase();

  String get sentenceCase => words.join(' ').toLowerCase().upperCaseFirstLetter;

  String get snakeCase => words.join('_').toLowerCase();

  String get dotCase => words.join('.').toLowerCase();

  String get paramCase => words.join('-').toLowerCase();

  String get pathCase => words.join('/').toLowerCase();

  String get pascalCase =>
      words.map((w) => w.toLowerCase().upperCaseFirstLetter).join('');

  String get headerCase =>
      words.map((w) => w.toLowerCase().upperCaseFirstLetter).join('-');

  String get titleCase =>
      words.map((w) => w.toLowerCase().upperCaseFirstLetter).join(' ');

  String get upperCaseFirstLetter =>
      length > 1 ? '${this[0].toUpperCase()}${substring(1)}' : toUpperCase();

  String get lowerCaseFirstLetter =>
      length > 1 ? '${this[0].toLowerCase()}${substring(1)}' : toLowerCase();
}
