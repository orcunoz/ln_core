class CurrencyUtils {
  static String _format(
    num amount, [
    int decimalDigits = 2,
    String decimalSeparator = '.',
    String thousandsSep = ",",
  ]) {
    String result = "";
    String sign = amount.sign < 0 ? "-" : "";
    amount = amount.abs();
    int remain = amount.toInt();
    double decimals = (amount - remain).toDouble();

    while (remain > 0) {
      var thousandPart = (remain % 1000).toString();
      remain = remain ~/ 1000;
      if (remain > 0) {
        while (thousandPart.length < 3) {
          thousandPart = "0$thousandPart";
        }
      }
      result = thousandPart + thousandsSep + result;
    }

    if (result.isEmpty) {
      result = "0$decimalSeparator";
    } else {
      result = result.substring(0, result.length - 1) + decimalSeparator;
    }

    String decimalPart = "";

    if (decimalDigits > 0) {
      decimalPart = decimals.toStringAsFixed(decimalDigits);
      decimalPart = decimalPart.substring(2, decimalPart.length);
    } else {
      result = result.substring(0, result.length - 1);
    }

    return sign + result + decimalPart;
  }

  static String format(num amount, [Currency? currency]) {
    if (currency == null) {
      return _format(amount);
    }

    var str = "";

    if (currency.symbolOnLeft) {
      str += currency.symbol;

      if (currency.spaceBetweenAmountAndSymbol) {
        str += " ";
      }
    }

    str += _format(amount, currency.decimalDigits, currency.decimalSeparator,
        currency.thousandsSeparator);

    if (!currency.symbolOnLeft) {
      if (currency.spaceBetweenAmountAndSymbol) {
        str += " ";
      }

      str += currency.symbol;
    }

    return str;
  }

  static String sign(num number) => number < 0
      ? "-"
      : number > 0
          ? "+"
          : "";
}

class Currency {
  final String? code;
  final String? name;
  final String symbol;
  final String thousandsSeparator;
  final String decimalSeparator;
  final bool symbolOnLeft;
  final bool spaceBetweenAmountAndSymbol;
  final int decimalDigits;

  Currency({
    this.code,
    this.name,
    required this.symbol,
    this.thousandsSeparator = ',',
    this.decimalSeparator = '.',
    this.symbolOnLeft = true,
    this.spaceBetweenAmountAndSymbol = false,
    this.decimalDigits = 2,
  }) : assert(decimalDigits >= 0);

  Currency copyWith({
    String? code,
    String? name,
    String? symbol,
    String? thousandsSeparator,
    String? decimalSeparator,
    bool? symbolOnLeft,
    bool? spaceBetweenAmountAndSymbol,
    int? decimalDigits,
  }) {
    return Currency(
      code: code ?? this.code,
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      thousandsSeparator: thousandsSeparator ?? this.thousandsSeparator,
      decimalSeparator: decimalSeparator ?? this.decimalSeparator,
      symbolOnLeft: symbolOnLeft ?? this.symbolOnLeft,
      spaceBetweenAmountAndSymbol:
          spaceBetweenAmountAndSymbol ?? this.spaceBetweenAmountAndSymbol,
      decimalDigits: decimalDigits ?? this.decimalDigits,
    );
  }

  Currency get nonDecimal => copyWith(decimalDigits: 0);

  // ignore: non_constant_identifier_names
  static final TL = Currency(
    code: "TL",
    name: "Türk Lirası",
    symbol: "₺",
    thousandsSeparator: ".",
    decimalSeparator: ",",
    symbolOnLeft: false,
    spaceBetweenAmountAndSymbol: true,
    decimalDigits: 2,
  );
  // ignore: non_constant_identifier_names
  static final USD = Currency(
    code: "USD",
    name: "Dollar",
    symbol: "\$",
    thousandsSeparator: ",",
    decimalSeparator: ".",
    symbolOnLeft: true,
    spaceBetweenAmountAndSymbol: false,
    decimalDigits: 2,
  );
}

extension CurrencyStringExtensions on num {
  String curr([Currency? currency]) => CurrencyUtils.format(this, currency);
}
