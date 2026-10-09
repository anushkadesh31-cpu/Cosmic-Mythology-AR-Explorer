// test/core/cosmic_core/astronomy/coordinates/angle_utils_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/astronomy/coordinates/angle_utils.dart';

void main() {
  group('AngleUtils', () {
    test('normalizeDegrees wraps correctly', () {
      expect(AngleUtils.normalizeDegrees(370.0), 10.0);
      expect(AngleUtils.normalizeDegrees(-30.0), 330.0);
    });
    test('normalizeSignedDegrees works', () {
      expect(AngleUtils.normalizeSignedDegrees(190.0), -170.0);
      expect(AngleUtils.normalizeSignedDegrees(-190.0), 170.0);
    });
    test('normalizeHours wraps correctly', () {
      expect(AngleUtils.normalizeHours(25.0), 1.0);
      expect(AngleUtils.normalizeHours(-2.0), 22.0);
    });
    test('normalizeSignedHours works', () {
      expect(AngleUtils.normalizeSignedHours(13.0), -11.0);
      expect(AngleUtils.normalizeSignedHours(-13.0), 11.0);
    });
    test('clampAltitude limits correctly', () {
      expect(AngleUtils.clampAltitude(100.0), 90.0);
      expect(AngleUtils.clampAltitude(-100.0), -90.0);
    });
  });
}
