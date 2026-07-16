import 'package:flutter/widgets.dart';
import 'package:klocalizations_flutter/src/klocalizations.dart';

class KLocalizationsDelegate extends LocalizationsDelegate<KLocalizations> {
  KLocalizations localizations;
  KLocalizationsDelegate(this.localizations);

  @override
  Future<KLocalizations> load(Locale locale) async {
    // Silent: this runs inside Flutter's Localizations resolution (during
    // build), so notifying listeners here would be a notify-during-build.
    await localizations.setLocaleAndReload(locale, silent: true);
    return localizations;
  }

  @override
  bool isSupported(Locale locale) {
    return localizations.supportedLocaleNames.contains(locale.languageCode);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<KLocalizations> old) =>
      false;
}
