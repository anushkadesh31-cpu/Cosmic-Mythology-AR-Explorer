import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/planet.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/celestial_object_type.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/planet_type.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/astronomy/coordinates/equatorial_coordinate.dart';

void main() {
  test('Planet equality and properties', () {
    final eq = EquatorialCoordinate(rightAscensionHours: 15.0, declinationDegrees: 10.0);
    final planet = Planet(
      id: 'planet-001',
      name: 'Mars',
      alternateNames: ['Red Planet'],
      equatorialCoordinate: eq,
      planetType: PlanetType.terrestrial,
      apparentMagnitude: -2.0,
      distanceAu: 1.52,
    );
    expect(planet.id, 'planet-001');
    expect(planet.name, 'Mars');
    expect(planet.type, CelestialObjectType.planet);
    expect(planet.planetType, PlanetType.terrestrial);
    expect(planet.apparentMagnitude, -2.0);
    expect(planet.distanceAu, 1.52);
  });
}
