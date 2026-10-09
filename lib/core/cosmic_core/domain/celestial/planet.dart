// lib/core/cosmic_core/domain/celestial/planet.dart

import 'celestial_object.dart';
import 'celestial_object_type.dart';
import 'planet_type.dart';
import '../../astronomy/coordinates/equatorial_coordinate.dart';

/// Scientific model for a planet.
///
/// Fields are optional where data may be unknown. The model does not perform
/// orbital calculations – those will be added later.
class Planet extends CelestialObject {
  /// Category of the planet (e.g., terrestrial, gas giant).
  final PlanetType? planetType;

  /// Apparent visual magnitude.
  final double? apparentMagnitude;

  /// Distance from Earth in astronomical units (AU) if known.
  final double? distanceAu;

  const Planet({
    required String id,
    required String name,
    List<String>? alternateNames,
    EquatorialCoordinate? equatorialCoordinate,
    this.planetType,
    this.apparentMagnitude,
    this.distanceAu,
  }) : super(
          id: id,
          name: name,
          type: CelestialObjectType.planet,
          alternateNames: alternateNames,
          equatorialCoordinate: equatorialCoordinate,
        );

  @override
  String toString() =>
      'Planet(id: $id, name: $name, type: $planetType, mag: $apparentMagnitude, distAu: $distanceAu)';
}
