import 'angle_utils.dart';

/// Represents local topocentric coordinates in the Horizontal Coordinate system.
///
/// Conventions:
/// - Altitude ($h$) is measured vertically from the ideal astronomical horizon:
///   Horizon = 0°, Zenith = +90°, Nadir = -90°.
/// - Azimuth ($A$) is measured clockwise around the horizon starting from
///   True North: North = 0°, East = 90°, South = 180°, West = 270°.
class HorizontalCoordinate {
  /// True geometric altitude in decimal degrees [-90.0, +90.0].
  final double altitudeDegrees;

  /// True Azimuth in decimal degrees [0.0, 360.0) clockwise from True North.
  final double azimuthDegrees;

  /// Optional apparent altitude incorporating atmospheric refraction in degrees.
  final double? apparentAltitudeDegrees;

  /// Altitude in radians for trigonometric computations.
  double get altitudeRadians => AngleUtils.toRadians(altitudeDegrees);

  /// Azimuth in radians for trigonometric computations.
  double get azimuthRadians => AngleUtils.toRadians(azimuthDegrees);

  /// Zenith distance in decimal degrees ($z = 90^\circ - h$).
  double get zenithDistanceDegrees => 90.0 - altitudeDegrees;

  /// Whether the celestial object is above the astronomical horizon ($h > 0$).
  bool get isAboveHorizon => (apparentAltitudeDegrees ?? altitudeDegrees) > 0.0;

  const HorizontalCoordinate({
    required this.altitudeDegrees,
    required this.azimuthDegrees,
    this.apparentAltitudeDegrees,
  })  : assert(
          altitudeDegrees >= -90.0 && altitudeDegrees <= 90.0,
          'Altitude must be in [-90.0, +90.0] degrees',
        ),
        assert(
          azimuthDegrees >= 0.0 && azimuthDegrees < 360.0,
          'Azimuth must be in [0.0, 360.0) degrees',
        );

  /// Factory constructor that automatically clamps altitude and normalizes azimuth.
  factory HorizontalCoordinate.fromRaw({
    required double altitudeDegrees,
    required double azimuthDegrees,
    double? apparentAltitudeDegrees,
  }) {
    return HorizontalCoordinate(
      altitudeDegrees: AngleUtils.clampAltitude(altitudeDegrees),
      azimuthDegrees: AngleUtils.normalizeDegrees(azimuthDegrees),
      apparentAltitudeDegrees: apparentAltitudeDegrees != null
          ? AngleUtils.clampAltitude(apparentAltitudeDegrees)
          : null,
    );
  }

  /// Cardinal or intercardinal compass direction string (e.g. "N", "NE", "SSW").
  String get compassDirection {
    const directions = [
      'N', 'NNE', 'NE', 'ENE',
      'E', 'ESE', 'SE', 'SSE',
      'S', 'SSW', 'SW', 'WSW',
      'W', 'WNW', 'NW', 'NNW',
    ];
    final index = ((azimuthDegrees + 11.25) % 360.0 / 22.5).floor();
    return directions[index % 16];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HorizontalCoordinate &&
          runtimeType == other.runtimeType &&
          altitudeDegrees == other.altitudeDegrees &&
          azimuthDegrees == other.azimuthDegrees &&
          apparentAltitudeDegrees == other.apparentAltitudeDegrees;

  @override
  int get hashCode =>
      altitudeDegrees.hashCode ^
      azimuthDegrees.hashCode ^
      apparentAltitudeDegrees.hashCode;

  @override
  String toString() =>
      'HorizontalCoordinate(Alt: ${altitudeDegrees.toStringAsFixed(2)}°, '
      'Az: ${azimuthDegrees.toStringAsFixed(2)}° [$compassDirection]'
      '${apparentAltitudeDegrees != null ? ', ApparentAlt: ${apparentAltitudeDegrees!.toStringAsFixed(2)}°' : ''})';
}
