import 'angle_utils.dart';

/// Represents celestial coordinates in the Equatorial Coordinate system (J2000 epoch).
///
/// Conventions:
/// - Right Ascension ($\alpha$) is measured eastward along the celestial equator from
///   the vernal equinox, in decimal hours [0.0, 24.0) or degrees [0.0, 360.0).
/// - Declination ($\delta$) is measured north (+) or south (-) from the celestial
///   equator, in decimal degrees [-90.0, +90.0].
class EquatorialCoordinate {
  /// Right Ascension expressed in decimal hours [0.0, 24.0).
  final double rightAscensionHours;

  /// Declination expressed in decimal degrees [-90.0, +90.0].
  final double declinationDegrees;

  /// Right Ascension expressed in decimal degrees [0.0, 360.0).
  double get rightAscensionDegrees => AngleUtils.toHourAngleDegrees(rightAscensionHours);

  /// Right Ascension expressed in radians for trigonometric computations.
  double get rightAscensionRadians => AngleUtils.hoursToRadians(rightAscensionHours);

  /// Declination expressed in radians for trigonometric computations.
  double get declinationRadians => AngleUtils.toRadians(declinationDegrees);

  const EquatorialCoordinate({
    required this.rightAscensionHours,
    required this.declinationDegrees,
  })  : assert(
          rightAscensionHours >= 0.0 && rightAscensionHours < 24.0,
          'Right Ascension must be in [0.0, 24.0) hours',
        ),
        assert(
          declinationDegrees >= -90.0 && declinationDegrees <= 90.0,
          'Declination must be in [-90.0, +90.0] degrees',
        );

  /// Constructs an EquatorialCoordinate from RA in decimal degrees [0.0, 360.0).
  factory EquatorialCoordinate.fromDegrees({
    required double rightAscensionDegrees,
    required double declinationDegrees,
  }) {
    final normRa = AngleUtils.normalizeDegrees(rightAscensionDegrees);
    final normDec = AngleUtils.clampAltitude(declinationDegrees);
    return EquatorialCoordinate(
      rightAscensionHours: AngleUtils.degreesToDecimalHours(normRa),
      declinationDegrees: normDec,
    );
  }

  /// Constructs an EquatorialCoordinate from separate hours, minutes, seconds and degrees.
  factory EquatorialCoordinate.fromHms({
    required int raHours,
    required int raMinutes,
    required double raSeconds,
    required int decDegrees,
    required int decMinutes,
    required double decSeconds,
    bool isDecNegative = false,
  }) {
    final decimalRaHours = raHours + (raMinutes / 60.0) + (raSeconds / 3600.0);
    var decimalDecDegrees = decDegrees.abs() + (decMinutes / 60.0) + (decSeconds / 3600.0);
    if (decDegrees < 0 || isDecNegative) {
      decimalDecDegrees = -decimalDecDegrees;
    }

    return EquatorialCoordinate(
      rightAscensionHours: AngleUtils.normalizeHours(decimalRaHours),
      declinationDegrees: AngleUtils.clampAltitude(decimalDecDegrees),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EquatorialCoordinate &&
          runtimeType == other.runtimeType &&
          rightAscensionHours == other.rightAscensionHours &&
          declinationDegrees == other.declinationDegrees;

  @override
  int get hashCode => rightAscensionHours.hashCode ^ declinationDegrees.hashCode;

  @override
  String toString() =>
      'EquatorialCoordinate(RA: ${rightAscensionHours.toStringAsFixed(4)}h, '
      'Dec: ${declinationDegrees.toStringAsFixed(4)}°)';
}
