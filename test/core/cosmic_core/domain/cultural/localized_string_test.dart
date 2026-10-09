import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/cultural/localized_string.dart';

void main() {
  group('LocalizedString', () {
    test('constructs successfully and provides default text', () {
      const loc = LocalizedString(defaultText: 'Orion');
      expect(loc.defaultText, 'Orion');
      expect(loc.translations, isEmpty);
      expect(loc.toString(), 'Orion');
    });

    test('throws assertion error if defaultText is empty', () {
      expect(
        () => LocalizedString(defaultText: ''),
        throwsA(isA<AssertionError>()),
      );
    });

    test('resolves known locale translation', () {
      const loc = LocalizedString(
        defaultText: 'Vedic Nakshatras',
        translations: {
          CulturalLocale.hiIn: 'वैदिक नक्षत्र',
          CulturalLocale.taIn: 'வேத நட்சத்திரங்கள்',
        },
      );

      expect(loc.resolve(CulturalLocale.hiIn), 'वैदिक नक्षत्र');
      expect(loc.resolve(CulturalLocale.taIn), 'வேத நட்சத்திரங்கள்');
    });

    test('falls back to defaultText when requested locale is missing', () {
      const loc = LocalizedString(
        defaultText: 'Vedic Nakshatras',
        translations: {
          CulturalLocale.hiIn: 'वैदिक नक्षत्र',
        },
      );

      expect(loc.resolve(CulturalLocale.teIn), 'Vedic Nakshatras');
      expect(loc.resolve(CulturalLocale.enUs), 'Vedic Nakshatras');
      expect(loc.resolve(CulturalLocale.mrIn), 'Vedic Nakshatras');
    });

    test('supports value equality and hashCode', () {
      const a1 = LocalizedString(
        defaultText: 'Orion',
        translations: {CulturalLocale.enUs: 'The Hunter'},
      );
      const a2 = LocalizedString(
        defaultText: 'Orion',
        translations: {CulturalLocale.enUs: 'The Hunter'},
      );
      const b = LocalizedString(
        defaultText: 'Orion',
        translations: {CulturalLocale.hiIn: 'शिकारी'},
      );

      expect(a1, equals(a2));
      expect(a1.hashCode, equals(a2.hashCode));
      expect(a1, isNot(equals(b)));
    });
  });
}
