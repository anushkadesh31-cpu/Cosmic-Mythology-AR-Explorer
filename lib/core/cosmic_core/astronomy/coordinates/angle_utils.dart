import 'dart:math' as math;

/// Mathematical and angular utilities for astronomical computations.
///
/// Handles conversions between radians, decimal degrees, and decimal hours,
/// as well as strict modular angle normalizations.
abstract final class AngleUtils {
  static const double pi = math.pi;
  static const double twoPi = 2.0 * math.pi;
  static const double halfPi = math.pi / 2.0;

  /// Radians to degrees multiplication factor.
  static const double radToDeg = 180.0 / math.pi;

  /// Degrees to radians multiplication factor.
  static const double degToRad = math.pi / 180.0;

  /// Hours to degrees factor (1 hour = 15 degrees).
  static const double hoursToDeg = 15.0;

  /// Degrees to hours factor (1 degree = 1/15 hour).
  static const double degToHours = 1.0 / 15.0;

  /// Converts decimal degrees to radians.
  static double toRadians(double degrees) => degrees * degToRad;

  /// Converts radians to decimal degrees.
  static double toDegrees(double radians) => radians * radToDeg;

  /// Converts decimal hours to radians.
  static double hoursToRadians(double hours) => hours * hoursToDeg * degToRad;

  /// Converts radians to decimal hours.
  static double radiansToHours(double radians) => radians * radToDeg * degToHours;

  /// Converts decimal hours to decimal degrees (1h = 15°).
  static double toHourAngleDegrees(double hours) => hours * hoursToDeg;

  /// Converts decimal degrees to decimal hours (15° = 1h).
  static double degreesToDecimalHours(double degrees) => degrees * degToHours;

  /// Normalizes an angle in degrees into the positive range [0.0, 360.0).
  static double normalizeDegrees(double degrees) {
    var result = degrees % 360.0;
    if (result < 0.0) {
      result += 360.0;
    }
    return result == 360.0 ? 0.0 : result;
  }

  /// Normalizes an angle in degrees into the signed range [-180.0, 180.0).
  static double normalizeSignedDegrees(double degrees) {
    var result = normalizeDegrees(degrees);
    if (result >= 180.0) {
      result -= 360.0;
    }
    return result;
  }

  /// Normalizes a time angle in decimal hours into the range [0.0, 24.0).
  static double normalizeHours(double hours) {
    var result = hours % 24.0;
    if (result < 0.0) {
      result += 24.0;
    }
    return result == 24.0 ? 0.0 : result;
  }

  /// Normalizes a time angle in decimal hours into the signed range [-12.0, 12.0).
  static double normalizeSignedHours(double hours) {
    var result = normalizeHours(hours);
    if (result >= 12.0) {
      result -= 24.0;
    }
    return result;
  }

  /// Clamps an altitude in degrees to the physical horizon limits [-90.0, +90.0].
  static double clampAltitude(double degrees) {
    return degrees.clamp(-90.0, 90.0);
  }
}
