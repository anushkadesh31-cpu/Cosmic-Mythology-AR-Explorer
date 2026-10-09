// test/core/cosmic_core/domain/observer/observer_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/observer/observer.dart';

void main() {
  group('Observer model', () {
    test('valid values are accepted', () {
      final obs = Observer(latitude: 45.0, longitude: -120.0, elevation: 250);
      expect(obs.latitude, 45.0);
      expect(obs.longitude, -120.0);
      expect(obs.elevation, 250);
    });

    test('boundary values are accepted', () {
      expect(() => Observer(latitude: -90.0, longitude: -180.0), returnsNormally);
      expect(() => Observer(latitude: 90.0, longitude: 180.0), returnsNormally);
    });

    test('invalid latitude throws AssertionError', () {
      expect(() => Observer(latitude: -91.0, longitude: 0.0), throwsA(isA<AssertionError>()));
      expect(() => Observer(latitude: 91.0, longitude: 0.0), throwsA(isA<AssertionError>()));
    });

    test('invalid longitude throws AssertionError', () {
      expect(() => Observer(latitude: 0.0, longitude: -181.0), throwsA(isA<AssertionError>()));
      expect(() => Observer(latitude: 0.0, longitude: 181.0), throwsA(isA<AssertionError>()));
    });
  });
}
