// lib/core/cosmic_core/domain/observer/observer.dart

/// Immutable model representing a geographic observer on Earth.
/// All values are in decimal degrees. Elevation is optional and expressed in meters.
class Observer {
  /// Latitude in degrees, valid range [-90, +90].
  final double latitude;

  /// Longitude in degrees, valid range [-180, +180] (East positive).
  final double longitude;

  /// Optional elevation above sea level in meters.
  final double? elevation;

  Observer({
    required this.latitude,
    required this.longitude,
    this.elevation,
  })  : assert(_isValidLatitude(latitude), 'Latitude must be between -90 and +90 degrees'),
        assert(_isValidLongitude(longitude), 'Longitude must be between -180 and +180 degrees');

  static bool _isValidLatitude(double lat) => lat >= -90.0 && lat <= 90.0;
  static bool _isValidLongitude(double lon) => lon >= -180.0 && lon <= 180.0;
}
