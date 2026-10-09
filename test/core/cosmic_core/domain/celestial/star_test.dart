import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/star.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/celestial_object_type.dart';

import 'package:cosmic_mythology_ar/core/cosmic_core/astronomy/coordinates/equatorial_coordinate.dart';

void main() {
  test('Star equality and properties', () {
    final eq = EquatorialCoordinate(rightAscensionHours: 10.0, declinationDegrees: -5.0);
    final star1 = Star(
      id: 'star-001',
      name: 'Sirius',
      alternateNames: ['Alpha Canis Majoris'],
      equatorialCoordinate: eq,
      apparentMagnitude: -1.46,
      distanceLy: 8.6,
      spectralClass: 'A1V',
      constellationId: 'orion',
    );
    final star2 = Star(
      id: 'star-001',
      name: 'Sirius',
      alternateNames: ['Alpha Canis Majoris'],
      equatorialCoordinate: eq,
      apparentMagnitude: -1.46,
      distanceLy: 8.6,
      spectralClass: 'A1V',
      constellationId: 'orion',
    );
    expect(star1, equals(star2));
    expect(star1.apparentMagnitude, -1.46);
    expect(star1.distanceLy, 8.6);
    expect(star1.spectralClass, 'A1V');
    expect(star1.constellationId, 'orion');
    expect(star1.type, CelestialObjectType.star);
  });
}
