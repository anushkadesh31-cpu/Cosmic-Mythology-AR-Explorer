// lib/core/cosmic_core/domain/celestial/star.dart

import 'celestial_object.dart';
import 'celestial_object_type.dart';
import '../../astronomy/coordinates/equatorial_coordinate.dart';

/// Scientific model for a star.
///
/// All fields are optional where data may be unavailable. Nullability is used
/// to indicate unknown or not‑yet‑computed values.
class Star extends CelestialObject {
  /// Apparent visual magnitude (lower is brighter).
  final double? apparentMagnitude;

  /// Distance from Earth in light‑years (if known).
  final double? distanceLy;

  /// Spectral classification (e.g., "A1V").
  final String? spectralClass;

  /// Identifier of the constellation this star belongs to (if any).
  final String? constellationId;

  const Star({
    required String id,
    required String name,
    List<String>? alternateNames,
    EquatorialCoordinate? equatorialCoordinate,
    this.apparentMagnitude,
    this.distanceLy,
    this.spectralClass,
    this.constellationId,
  }) : super(
          id: id,
          name: name,
          type: CelestialObjectType.star,
          alternateNames: alternateNames,
          equatorialCoordinate: equatorialCoordinate,
        );

  @override
  String toString() =>
      'Star(id: $id, name: $name, mag: $apparentMagnitude, distLy: $distanceLy, spec: $spectralClass, constId: $constellationId)';
}
