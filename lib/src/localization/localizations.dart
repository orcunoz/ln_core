import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import 'locale_en.dart';
import 'locale_tr.dart';

abstract class LnLocalizations extends LnLocalizationsBase {
  const LnLocalizations(super.languageCode);

  String get copy;
  String get linkCopiedToClipboard;
  String get ok;
  String get confirm;
  String get reject;
  String get close;

  String get information;
  String get successful;
  String get warning;
  String get somethingWentWrong;
  String get noResultsFound;
  String get unauthorizedAccess;

  String get refresh;
  String get restore;
  String get clear;

  static const delegate = LnLocalizationsDelegate<LnLocalizations>(
    [LocaleEn(), LocaleTr()],
    _setInstance,
  );

  static _setInstance(LnLocalizations loc) => _instance = loc;
  static LnLocalizations? _instance;
  static LnLocalizations get current {
    assert(_instance != null, "No LnLocalizations instance created before!");
    return _instance!;
  }

  static LnLocalizations of(BuildContext context) =>
      Localizations.of<LnLocalizations>(context, LnLocalizations)!;
}
