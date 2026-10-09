import '../coordinates/angle_utils.dart';
import 'julian_date.dart';

/// Calculations for Greenwich Mean Sidereal Time (GMST) and Local Sidereal Time (LST).
///
/// Implements Jean Meeus: Astronomical Algorithms (2nd Edition, Chapter 12).
abstract final class SiderealTime {
  /// Computes Greenwich Mean Sidereal Time (GMST) in decimal hours [0.0, 24.0)
  /// for a given Julian Date [jd].
  ///
  /// Uses Meeus Formula 12.4 with high-precision polynomial terms.
  static double gmstHoursFromJd(double jd) {
    final t = JulianDate.centuriesSinceJ2000(jd);

    // Formula 12.4 gives GMST in degrees at 0h UT, or for instantaneous UT
    // theta0 = 280.46061837 + 360.98564736629*(JD - 2451545.0) + 0.000387933*T^2 - T^3/38710000
    final jdDiff = jd - JulianDate.j2000Epoch;
    var theta0 = 280.46061837 +
        (360.98564736629 * jdDiff) +
        (0.000387933 * t * t) -
        ((t * t * t) / 38710000.0);

    theta0 = AngleUtils.normalizeDegrees(theta0);
    return AngleUtils.degreesToDecimalHours(theta0);
  }

  /// Computes GMST in decimal hours [0.0, 24.0) directly from a [DateTime].
  static double gmstHoursFromDateTime(DateTime dateTime) {
    final jd = JulianDate.fromDateTime(dateTime);
    return gmstHoursFromJd(jd);
  }

  /// Computes Local Sidereal Time (LST) in decimal hours [0.0, 24.0)
  /// given a [jd] and observer [longitudeDegrees] (East positive, West negative).
  ///
  /// Formula: LST = GMST + (longitude / 15.0)
  static double lstHoursFromJd({
    required double jd,
    required double longitudeDegrees,
  }) {
    final gmst = gmstHoursFromJd(jd);
    final lonHours = AngleUtils.degreesToDecimalHours(longitudeDegrees);
    return AngleUtils.normalizeHours(gmst + lonHours);
  }

  /// Computes Local Sidereal Time (LST) in decimal hours [0.0, 24.0)
  /// given a [dateTime] and observer [longitudeDegrees].
  static double lstHoursFromDateTime({
    required DateTime dateTime,
    required double longitudeDegrees,
  }) {
    final jd = JulianDate.fromDateTime(dateTime);
    return lstHoursFromJd(jd: jd, longitudeDegrees: longitudeDegrees);
  }

  /// Computes the Local Hour Angle ($H$) in decimal hours [-12.0, +12.0)
  /// for a celestial object with [rightAscensionHours] at [lstHours].
  ///
  /// Formula: H = LST - RA
  static double hourAngleHours({
    required double lstHours,
    required double rightAscensionHours,
  }) {
    final rawH = lstHours - rightAscensionHours;
    return AngleUtils.normalizeSignedHours(rawH);
  }

  /// Computes the Local Hour Angle ($H$) in decimal degrees [-180.0, +180.0).
  static double hourAngleDegrees({
    required double lstHours,
    required double rightAscensionHours,
  }) {
    final hHours = hourAngleHours(
      lstHours: lstHours,
      rightAscensionHours: rightAscensionHours,
    );
    return AngleUtils.toHourAngleDegrees(hHours);
  }
}
