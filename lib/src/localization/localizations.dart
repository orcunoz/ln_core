import 'localizations_delegate.dart';

abstract class LnLocalizations {
  final String languageCode;
  const LnLocalizations(this.languageCode);

  static List<LnLocalizationsDelegate<LnLocalizations>> delegates = [];
}
