// lib/core/cosmic_core/domain/celestial/asterism.dart

import 'celestial_object.dart';
import 'celestial_object_type.dart';
import '../../astronomy/coordinates/equatorial_coordinate.dart';

/// An asterism is a recognized pattern of stars, not a formal constellation.
class Asterism extends CelestialObject {
  /// List of star identifiers that compose the asterism.
  final List<String> starIds;

  const Asterism({
    required String id,
    required String name,
    List<String>? alternateNames,
    EquatorialCoordinate? equatorialCoordinate,
    required this.starIds,
  }) : super(
          id: id,
          name: name,
          type: CelestialObjectType.asterism,
          alternateNames: alternateNames,
          equatorialCoordinate: equatorialCoordinate,
        );

  @override
  String toString() =>
      'Asterism(id: $id, name: $name, stars: ${starIds.length})';
}
