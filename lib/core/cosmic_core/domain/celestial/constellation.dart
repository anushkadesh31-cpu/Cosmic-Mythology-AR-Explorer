// lib/core/cosmic_core/domain/celestial/constellation.dart

import 'celestial_object.dart';
import 'celestial_object_type.dart';
import '../../astronomy/coordinates/equatorial_coordinate.dart';

/// A constellation aggregates multiple stars (and optionally other objects).
class Constellation extends CelestialObject {
  /// List of member star identifiers (stable IDs).
  final List<String> memberStarIds;

  const Constellation({
    required String id,
    required String name,
    List<String>? alternateNames,
    EquatorialCoordinate? equatorialCoordinate,
    required this.memberStarIds,
  }) : super(
          id: id,
          name: name,
          type: CelestialObjectType.constellation,
          alternateNames: alternateNames,
          equatorialCoordinate: equatorialCoordinate,
        );

  @override
  String toString() =>
      'Constellation(id: $id, name: $name, members: ${memberStarIds.length})';
}
