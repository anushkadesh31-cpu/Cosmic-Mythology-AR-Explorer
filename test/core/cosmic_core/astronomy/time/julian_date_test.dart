// test/core/cosmic_core/astronomy/time/julian_date_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/astronomy/time/julian_date.dart';

void main() {
  group('JulianDate', () {
    test('fromDateTime for J2000 epoch', () {
      // 2000-01-01 12:00:00 UTC corresponds to JD 2451545.0
      final dt = DateTime.utc(2000, 1, 1, 12, 0, 0);
      expect(JulianDate.fromDateTime(dt), closeTo(2451545.0, 1e-9));
    });

    test('centuriesSinceJ2000 calculation', () {
      final jd = 2451545.0; // J2000
      expect(JulianDate.centuriesSinceJ2000(jd), 0.0);
      // 100 years later (2100-01-01 12:00 UTC) -> ~1.0 centuries
      final later = DateTime.utc(2100, 1, 1, 12);
      final jdLater = JulianDate.fromDateTime(later);
      expect(JulianDate.centuriesSinceJ2000(jdLater), closeTo(1.0, 1e-4));
    });
  });
}
