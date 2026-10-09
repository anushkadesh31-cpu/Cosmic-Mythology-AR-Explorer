// lib/core/cosmic_core/domain/celestial/sun.dart

import 'celestial_object.dart';
import 'celestial_object_type.dart';
import '../../astronomy/coordinates/equatorial_coordinate.dart';

/// Scientific model for the Sun.
class Sun extends CelestialObject {
  /// Apparent magnitude of the Sun (approx. -26.74).
  final double apparentMagnitude;

  /// Solar radius in kilometers.
  final double radiusKm;

  const Sun({
    required String id,
    required String name,
    List<String>? alternateNames,
    EquatorialCoordinate? equatorialCoordinate,
    this.apparentMagnitude = -26.74,
    this.radiusKm = 696340,
  }) : super(
          id: id,
          name: name,
          type: CelestialObjectType.sun,
          alternateNames: alternateNames,
          equatorialCoordinate: equatorialCoordinate,
        );

  @override
  String toString() =>
      'Sun(id: $id, name: $name, mag: $apparentMagnitude, radiusKm: $radiusKm)';
}
