import 'angle_utils.dart';

/// Observer geographical position on Earth.
///
/// Convention:
/// - Latitude is positive North (+0° to +90°), negative South (-0° to -90°).
/// - Longitude is positive East of Greenwich (0° to +180°), negative West (0° to -180°),
///   consistent with the International Astronomical Union (IAU) standard.
class GeographicLocation {
  /// Latitude in decimal degrees [-90.0, +90.0].
  final double latitudeDegrees;

  /// Longitude in decimal degrees [-180.0, +180.0].
  final double longitudeDegrees;

  /// Elevation above mean sea level in meters.
  final double elevationMeters;

  /// Latitude expressed in radians for trigonometric computations.
  double get latitudeRadians => AngleUtils.toRadians(latitudeDegrees);

  /// Longitude expressed in radians.
  double get longitudeRadians => AngleUtils.toRadians(longitudeDegrees);

  const GeographicLocation({
    required this.latitudeDegrees,
    required this.longitudeDegrees,
    this.elevationMeters = 0.0,
  })  : assert(
          latitudeDegrees >= -90.0 && latitudeDegrees <= 90.0,
          'Latitude must be between -90 and +90 degrees',
        ),
        assert(
          longitudeDegrees >= -180.0 && longitudeDegrees <= 180.0,
          'Longitude must be between -180 and +180 degrees',
        );

  /// Factory constructor that automatically clamps latitude and normalizes longitude.
  factory GeographicLocation.fromNormalized({
    required double latitudeDegrees,
    required double longitudeDegrees,
    double elevationMeters = 0.0,
  }) {
    return GeographicLocation(
      latitudeDegrees: AngleUtils.clampAltitude(latitudeDegrees),
      longitudeDegrees: AngleUtils.normalizeSignedDegrees(longitudeDegrees),
      elevationMeters: elevationMeters,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeographicLocation &&
          runtimeType == other.runtimeType &&
          latitudeDegrees == other.latitudeDegrees &&
          longitudeDegrees == other.longitudeDegrees &&
          elevationMeters == other.elevationMeters;

  @override
  int get hashCode =>
      latitudeDegrees.hashCode ^
      longitudeDegrees.hashCode ^
      elevationMeters.hashCode;

  @override
  String toString() =>
      'GeographicLocation(lat: ${latitudeDegrees.toStringAsFixed(4)}°, '
      'lon: ${longitudeDegrees.toStringAsFixed(4)}°, '
      'alt: ${elevationMeters.toStringAsFixed(1)}m)';
}
