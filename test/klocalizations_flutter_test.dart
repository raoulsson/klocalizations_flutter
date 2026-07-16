import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:klocalizations_flutter/src/klocalizations.dart';
import 'package:klocalizations_flutter/src/klocalizations_loader.dart';

/// A test loader that returns a fixed map instead of loading from assets.
class TestLoader extends KLocalizationsLoader {
  final Map<String, dynamic> data;
  TestLoader(this.data);

  @override
  Future<Map<String, dynamic>> loadMapForLocale(Locale locale) async => data;
}

void main() {
  group('translate', () {
    late KLocalizations kl;

    setUp(() async {
      kl = KLocalizations(
        locale: const Locale('en'),
        defaultLocale: const Locale('en'),
        supportedLocales: const [Locale('en')],
        loader: TestLoader({
          'simple': 'Hello',
          'with.dot': 'Value with dot key',
          'with,comma': 'Value with comma key',
          'nested': {
            'key': 'Nested value',
          },
          'greeting': 'Hello, {{name}}. Welcome!',
          'price': 'Total: \$1,000.00',
        }),
      );
      await kl.load();
    });

    test('translates a simple key', () {
      expect(kl.translate('simple'), 'Hello');
    });

    test('translates a flat key containing a dot', () {
      expect(kl.translate('with.dot'), 'Value with dot key');
    });

    test('translates a flat key containing a comma', () {
      expect(kl.translate('with,comma'), 'Value with comma key');
    });

    test('translates a nested key via dot notation', () {
      expect(kl.translate('nested.key'), 'Nested value');
    });

    test('interpolates params in value containing comma and dot', () {
      expect(
        kl.translate('greeting', params: {'name': 'Alice'}),
        'Hello, Alice. Welcome!',
      );
    });

    test('returns value containing commas and dots as-is', () {
      expect(kl.translate('price'), 'Total: \$1,000.00');
    });

    test('returns key when translation is missing', () {
      expect(kl.translate('missing.key'), 'missing.key');
    });

    test('returns key (no throw) when an intermediate segment is a leaf', () {
      // 'simple' resolves to the String 'Hello'; descending into 'simple.foo'
      // must not attempt "Hello"["foo"] and throw a TypeError.
      expect(kl.translate('simple.foo'), 'simple.foo');
    });
  });

  group('textDirection', () {
    test('falls back to ltr without _config, even in strict mode', () async {
      final kl = KLocalizations(
        locale: const Locale('en'),
        defaultLocale: const Locale('en'),
        supportedLocales: const [Locale('en')],
        throwOnMissingTranslation: true,
        loader: TestLoader({'simple': 'Hello'}),
      );
      await kl.load();
      expect(kl.textDirection, TextDirection.ltr);
    });

    test('reads rtl from _config', () async {
      final kl = KLocalizations(
        locale: const Locale('ar'),
        defaultLocale: const Locale('ar'),
        supportedLocales: const [Locale('ar')],
        loader: TestLoader({
          '_config': {'textDirection': 'rtl'},
        }),
      );
      await kl.load();
      expect(kl.textDirection, TextDirection.rtl);
    });
  });

  group('setLocaleAndReload', () {
    test('loads new strings before notifying, and notifies once', () async {
      final kl = KLocalizations(
        locale: const Locale('en'),
        defaultLocale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('es')],
        loader: _PerLocaleLoader({
          const Locale('en'): {'greeting': 'Hello'},
          const Locale('es'): {'greeting': 'Hola'},
        }),
      );
      await kl.load();
      expect(kl.translate('greeting'), 'Hello');

      var notifications = 0;
      String? stringsAtNotify;
      kl.addListener(() {
        notifications++;
        stringsAtNotify = kl.translate('greeting');
      });

      await kl.setLocaleAndReload(const Locale('es'));

      expect(kl.locale, const Locale('es'));
      expect(kl.translate('greeting'), 'Hola');
      expect(notifications, 1);
      // The listener must observe the already-loaded new strings, not the old.
      expect(stringsAtNotify, 'Hola');
    });
  });
}

class _PerLocaleLoader extends KLocalizationsLoader {
  final Map<Locale, Map<String, dynamic>> byLocale;
  _PerLocaleLoader(this.byLocale);

  @override
  Future<Map<String, dynamic>> loadMapForLocale(Locale locale) async =>
      byLocale[locale] ?? <String, dynamic>{};
}
