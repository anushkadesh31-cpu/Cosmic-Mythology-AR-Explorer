// test/core/cosmic_core/astronomy/transformations/coordinate_transformer_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/astronomy/coordinates/equatorial_coordinate.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/astronomy/coordinates/geographic_location.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/astronomy/transformations/coordinate_transformer.dart';

void main() {
  group('CoordinateTransformer', () {
    test('Roundtrip conversion without refraction', () {
      // Observer at Greenwich
      final observer = GeographicLocation(
        latitudeDegrees: 0.0,
        longitudeDegrees: 0.0,
        elevationMeters: 0.0,
      );
      // Date and time (UTC)
      final dateTime = DateTime.utc(2022, 1, 1, 0, 0, 0);
      // Celestial object: RA=6h, Dec=0°
      final equatorial = EquatorialCoordinate(
        rightAscensionHours: 6.0,
        declinationDegrees: 0.0,
      );

      final horizontal = CoordinateTransformer.equatorialToHorizontal(
        celestial: equatorial,
        observer: observer,
        dateTime: dateTime,
        applyAtmosphericRefraction: false,
      );

      final backEquatorial = CoordinateTransformer.horizontalToEquatorial(
        horizontal: horizontal,
        observer: observer,
        dateTime: dateTime,
      );

      expect(backEquatorial.rightAscensionHours,
          closeTo(equatorial.rightAscensionHours, 1e-6));
      expect(backEquatorial.declinationDegrees,
          closeTo(equatorial.declinationDegrees, 1e-6));
    });
  });
}
