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
