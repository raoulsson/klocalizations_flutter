# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A Flutter package that wraps `flutter_localizations` with convenience features: dot-notation nested key access, `{{param}}` interpolation, pluggable translation loaders, and reactive locale switching via Provider/ChangeNotifier.

Published on pub.dev as `klocalizations_flutter` (v0.0.9). This is a library, not an application.

## Build & Test Commands

```bash
# Get dependencies
flutter pub get

# Run all tests
flutter test

# Run a single test file
flutter test test/klocalizations_flutter_test.dart

# Analyze code (lint)
flutter analyze

# Run the example app
cd example && flutter run
```

## Architecture

**Entry point**: `lib/klocalizations_flutter.dart` — public API facade that re-exports all public classes plus key Flutter localization globals (`GlobalMaterialLocalizations`, etc.).

**Core class**: `KLocalizations` (`lib/src/klocalizations.dart`)
- Extends `ChangeNotifier`; injected into the widget tree via `KLocalizations.asChangeNotifier()` which wraps a `ChangeNotifierProvider`
- Retrieved via `KLocalizations.of(context)` (uses `Provider.of`)
- Holds `_localizedStrings` (flat map from loaded JSON), current `_locale`, and config
- `translate(key, params?)` resolves dot-notation keys through nested maps, then applies `{{key}}` interpolation
- `setLocale()` triggers reload + `notifyListeners()` to rebuild dependents

**Translation loading**: `KLocalizationsLoader` (`lib/src/klocalizations_loader.dart`)
- Abstract interface: `loadMapForLocale(Locale) → Future<Map<String, dynamic>>`
- Default implementation `KLocalizationsLoaderJson` loads from asset JSON files at `{assetsPath}/{languageCode}.json`
- Custom loaders (HTTP, DB, etc.) can be passed to `KLocalizations.asChangeNotifier(loader: ...)`

**Delegate**: `KLocalizationsDelegate` (`lib/src/klocalizations_delegate.dart`) — standard `LocalizationsDelegate<KLocalizations>` that calls `load()` on the KLocalizations instance.

**Widgets**:
- `LocalizedText` (`lib/src/widgets/localized_text.dart`) — drop-in `Text` replacement that auto-translates its key. Supports params, uppercase, selectable mode, full Text API.
- `LanguageSelector` (`lib/src/widgets/language_selector.dart`) — dropdown using `languages.{code}` translation keys.

**Utilities** (`lib/src/utils.dart`): `getValueFromPath()` for dot-notation traversal, `interpolate()` for `{{key}}` replacement.

## Translation File Format

JSON files named `{languageCode}.json`. Special `_config.textDirection` key controls RTL/LTR:

```json
{
  "_config": { "textDirection": "ltr" },
  "home": { "title": "My App" },
  "languages": { "en": "English" }
}
```

## Dependencies

- `provider` (6.1.2) for state management
- `flutter_localizations` (SDK) for base localization support
- SDK constraints: Dart >=3.7.0, Flutter >=3.29.0
