// lib/core/cosmic_core/domain/celestial/celestial_object.dart

import '../../astronomy/coordinates/equatorial_coordinate.dart';
import 'celestial_object_type.dart';

/// Base class for scientific celestial objects.
///
/// All scientific entities share a stable identifier, a human‑readable name,
/// a [CelestialObjectType] discriminator and optionally a list of alternate
/// names. Objects that have a known position expose an optional
/// [EquatorialCoordinate].
///
/// The class is deliberately pure‑Dart and contains no cultural or UI data.
abstract class CelestialObject {
  /// Stable identifier – e.g., a catalog ID (HIP, SAO, etc.) or a generated UUID.
  final String id;

  /// Primary display name (e.g., "Sirius").
  final String name;

  /// Optional additional names or aliases.
  final List<String>? alternateNames;

  /// The scientific type of the object.
  final CelestialObjectType type;

  /// Optional equatorial coordinates (J2000).
  final EquatorialCoordinate? equatorialCoordinate;

  const CelestialObject({
    required this.id,
    required this.name,
    required this.type,
    this.alternateNames,
    this.equatorialCoordinate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CelestialObject &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          type == other.type &&
          listEquals(alternateNames, other.alternateNames) &&
          equatorialCoordinate == other.equatorialCoordinate;

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      type.hashCode ^
      (alternateNames?.hashCode ?? 0) ^
      (equatorialCoordinate?.hashCode ?? 0);

  @override
  String toString() =>
      '${type.name.toUpperCase()}(id: $id, name: $name, coord: $equatorialCoordinate)';

  // Helper for list equality without pulling in collection package.
  static bool listEquals<T>(List<T>? a, List<T>? b) {
    if (identical(a, b)) return true;
    if (a == null || b == null) return false;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
