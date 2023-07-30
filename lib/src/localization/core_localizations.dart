import 'package:flutter/material.dart';
import 'package:ln_core/ln_core.dart';

import 'locale_en.dart';
import 'locale_tr.dart';

abstract class LnCoreLocalizations extends LnLocalizations {
  const LnCoreLocalizations(super.languageCode);

  String get copy;
  String get linkCopiedToClipboard;

  static const delegate = LnLocalizationsDelegate<LnCoreLocalizations>(
    [LocaleEn(), LocaleTr()],
    _setInstance,
  );

  static _setInstance(LnCoreLocalizations loc) => _instance = loc;
  static LnCoreLocalizations? _instance;
  static LnCoreLocalizations get current {
    assert(
        _instance != null, "No AlertsLocalizations instance created before!");
    return _instance!;
  }

  static LnCoreLocalizations of(BuildContext context) =>
      Localizations.of<LnCoreLocalizations>(context, LnCoreLocalizations)!;
}
