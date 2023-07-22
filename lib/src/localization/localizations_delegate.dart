import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'localizations.dart';

class LnLocalizationsDelegate<T extends LnLocalizations>
    extends LocalizationsDelegate<T> {
  final void Function(T locale)? onLoad;
  final List<T> locales;
  const LnLocalizationsDelegate(this.locales, this.onLoad);

  @override
  bool isSupported(Locale locale) {
    return locales
        .any((lnLocale) => locale.languageCode == lnLocale.languageCode);
  }

  @override
  Future<T> load(Locale locale) {
    final loc = locales
        .firstWhere((lnLoc) => lnLoc.languageCode == locale.languageCode);
    return SynchronousFuture<T>(loc).then((value) {
      onLoad?.call(value);
      return value;
    });
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<T> old) => false;
}
