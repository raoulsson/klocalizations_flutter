## 0.0.1
* Adds all basic functionality

## 0.0.3
* Improved docs
* Added missing argument [loader] to `asChangeNotifier`

## 0.0.4
* removed provider version contraint

## 0.0.5
* Added `uppercase` property to `LocalizedText`. If true, it will make the resulting localized text uppercase.
  
## 0.0.6
* Added `selectable` property to `LocalizedText`. If true, it will make the resulting localized text selectable.
* Added `LocalizedText.selectable()` constructor. Makes the LocalizedText selectable

## 0.0.8
* KLocalizationsLoader does not require params, it's up to each implementation to ask for specific params

## 0.0.9
* Updated dependencies

## 1.0.2
* `translate` now interpolates `params` even when the resolved translation equals the key (e.g. when the key itself is the English source string, or on missing-translation fallback). Previously interpolation was skipped in that case, leaving `{{placeholder}}` tokens unreplaced. `interpolate` is a no-op when the string contains no placeholders, so keys without params are unaffected.
## 1.3.0
* Removed the `provider` dependency. `KLocalizations.of(context)` and `asChangeNotifier()` now use Flutter's built-in `InheritedNotifier` via the new exported `KLocalizationsScope` widget. Public API is source-compatible for `of()`; `asChangeNotifier()` now returns a `Widget` (was a `ChangeNotifierProvider`). Consumers using Riverpod (or any other state management) can wrap their app in `KLocalizationsScope(notifier: ..., child: ...)` directly.

## 1.3.1
* `KLocalizations.of(context, listen: false)` now honours the `listen` flag: it looks the scope up via `getInheritedWidgetOfExactType` instead of `dependOnInheritedWidgetOfExactType`, so it no longer registers a dependency. This makes non-reactive reads legal in `initState`, constructors, and event callbacks (previously the flag was ignored and every `of()` call created a dependency, throwing when called from `initState`). `listen: true` (the default) is unchanged.

## 1.4.0
* Added `Future<void> setLocaleAndReload(Locale, {bool silent})` — the correct entry point for a reactive language switch. It sets the locale, reloads that locale's translations, and only then notifies listeners, so every dependent refreshes together against the new language. Use this instead of `setLocale` when the user changes language: `setLocale` alone changes `locale` but leaves the previously loaded strings in place (listeners rebuilt against the old language and never heard about the freshly loaded ones), which showed stale text until an unrelated rebuild. `KLocalizationsDelegate.load` now goes through the same path (silently).
* `textDirection` no longer throws under `throwOnMissingTranslation: true` when a translation file omits the optional `_config` block. It now reads `_config.textDirection` directly from the loaded strings and falls back to `TextDirection.ltr`, and is safe to call before the first `load()`. Previously, strict mode made every `LocalizedText` throw `MissingTranslationException("_config.textDirection")`.
* `getValueFromPath` (dot-notation resolution) no longer throws when an intermediate path segment resolves to a non-map leaf. `translate('home.title')` against `{"home": "Welcome"}` now falls back to the key instead of throwing a `TypeError`, honouring the `throwOnMissingTranslation: false` contract.
