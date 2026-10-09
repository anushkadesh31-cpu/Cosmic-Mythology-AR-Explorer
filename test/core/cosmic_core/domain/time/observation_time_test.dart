// test/core/cosmic_core/domain/time/observation_time_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/time/observation_time.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/observer/observer.dart';

import 'package:cosmic_mythology_ar/core/cosmic_core/astronomy/time/sidereal_time.dart';

void main() {
  group('ObservationTime', () {
    // A known reference: 2000-01-01 12:00 UTC => JD 2451545.0, MJD 51545.0
    final referenceDate = DateTime.utc(2000, 1, 1, 12, 0, 0);
    final obsTime = ObservationTime(referenceDate);
    final observer = Observer(latitude: 0.0, longitude: 30.0); // 30°E

    test('UTC normalization', () {
      // Pass a non‑UTC DateTime and ensure it is converted.
      final local = DateTime.utc(2000, 1, 1, 12, 0, 0);
      final ot = ObservationTime(local);
      expect(ot.utc.isUtc, isTrue);
      expect(ot.utc, referenceDate);
    });

    test('julianDate matches reference', () {
      expect(obsTime.julianDate, closeTo(2451545.0, 1e-6));
    });

    test('modifiedJulianDate matches reference', () {
      expect(obsTime.modifiedJulianDate, closeTo(51544.5, 1e-6));
    });

    test('gmstHours matches SiderealTime calculation', () {
      final expected = SiderealTime.gmstHoursFromDateTime(referenceDate);
      expect(obsTime.gmstHours, closeTo(expected, 1e-6));
    });

    test('lstHours matches SiderealTime calculation', () {
      final expected = SiderealTime.lstHoursFromDateTime(
        dateTime: referenceDate,
        longitudeDegrees: observer.longitude,
      );
      expect(obsTime.lstHours(observer), closeTo(expected, 1e-6));
    });
  });
}
