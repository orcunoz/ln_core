import 'package:flutter/material.dart';

import 'locale.dart';

class LnLocalizationScope<T extends LnLocale> {
  final List<T> locales;
  LnLocalizationScope(this.locales);

  T of(BuildContext context) =>
      _lastCalledInstance = byLocale(Localizations.localeOf(context));

  T byLocale(Locale locale) =>
      locales.firstWhere((lnLoc) => lnLoc.languageCode == locale.languageCode);

  T? _lastCalledInstance;
  T get current {
    assert(_lastCalledInstance != null,
        "No $T instance created before. Call LnLocalizationScope<$T>.of(context) first.");
    return _lastCalledInstance!;
  }
}
