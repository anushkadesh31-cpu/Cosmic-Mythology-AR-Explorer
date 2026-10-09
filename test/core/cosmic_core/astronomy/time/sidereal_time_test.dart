// test/core/cosmic_core/astronomy/time/sidereal_time_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/astronomy/time/sidereal_time.dart';


void main() {
  group('SiderealTime', () {
    test('GMST at J2000 epoch (JD 2451545.0)', () {
      // Known GMST value at 2000-01-01 12:00 UT is 18.697374558 hours
      final gmst = SiderealTime.gmstHoursFromJd(2451545.0);
      expect(gmst, closeTo(18.697374558, 1e-6));
    });

    test('Hour angle calculation', () {
      const lst = 10.0; // hours
      const ra = 5.0; // hours
      final ha = SiderealTime.hourAngleHours(lstHours: lst, rightAscensionHours: ra);
      expect(ha, 5.0);
    });
  });
}
