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
  });
}
