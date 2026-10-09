import '../domain/celestial/celestial_object_type.dart';

/// Immutable model describing a visible celestial object.
class VisibleObject {
  final String id;
  final String name;
  final CelestialObjectType type;
  final double altitude;
  final double azimuth;
  final double? apparentMagnitude;

  const VisibleObject({
    required this.id,
    required this.name,
    required this.type,
    required this.altitude,
    required this.azimuth,
    this.apparentMagnitude,
  });
}
