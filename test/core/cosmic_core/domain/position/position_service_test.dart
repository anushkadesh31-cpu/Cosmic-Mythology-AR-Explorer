import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/star.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/observer/observer.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/position/position_service.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/time/observation_time.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/astronomy/coordinates/equatorial_coordinate.dart';

void main() {
  group('CelestialPositionService', () {
    const service = CelestialPositionService();

    final testObserver = Observer(
      latitude: 52.52,
      longitude: 13.405,
    );

    final observationTime = ObservationTime(DateTime.utc(2026, 6, 21, 22, 0));

    test('calculates position deterministically for a star with coordinates', () {
      const star = Star(
        id: 'polaris',
        name: 'Polaris',
        equatorialCoordinate: EquatorialCoordinate(
          rightAscensionHours: 2.53,
          declinationDegrees: 89.26,
        ),
      );

      final pos1 = service.calculatePosition(
        celestialObject: star,
        observer: testObserver,
        observationTime: observationTime,
      );

      final pos2 = service.calculatePosition(
        celestialObject: star,
        observer: testObserver,
        observationTime: observationTime,
      );

      expect(pos1, isNotNull);
      expect(pos1!.altitudeDeg, closeTo(pos2!.altitudeDeg, 1e-9));
      expect(pos1.azimuthDeg, closeTo(pos2.azimuthDeg, 1e-9));
      expect(pos1.objectId, equals('polaris'));
      expect(pos1.isAboveHorizon, isTrue);
    });

    test('returns null if celestial object has no equatorial coordinates', () {
      const starNoCoord = Star(
        id: 'no_coord',
        name: 'Unknown',
      );

      final pos = service.calculatePosition(
        celestialObject: starNoCoord,
        observer: testObserver,
        observationTime: observationTime,
      );

      expect(pos, isNull);
    });
  });
}
