// lib/core/cosmic_core/domain/celestial/moon.dart

import 'celestial_object.dart';
import 'celestial_object_type.dart';
import '../../astronomy/coordinates/equatorial_coordinate.dart';

/// Scientific model for a Moon (natural satellite).
class Moon extends CelestialObject {
  /// Apparent magnitude (average).
  final double apparentMagnitude;

  /// Radius in kilometers.
  final double radiusKm;

  const Moon({
    required String id,
    required String name,
    List<String>? alternateNames,
    EquatorialCoordinate? equatorialCoordinate,
    this.apparentMagnitude = 0.12,
    this.radiusKm = 1737.4,
  }) : super(
          id: id,
          name: name,
          type: CelestialObjectType.moon,
          alternateNames: alternateNames,
          equatorialCoordinate: equatorialCoordinate,
        );

  @override
  String toString() =>
      'Moon(id: $id, name: $name, mag: $apparentMagnitude, radiusKm: $radiusKm)';
}
