import 'dart:math' as math;
import '../coordinates/angle_utils.dart';
import '../coordinates/equatorial_coordinate.dart';
import '../coordinates/geographic_location.dart';
import '../coordinates/horizontal_coordinate.dart';
import '../time/julian_date.dart';
import '../time/sidereal_time.dart';

/// Pure Dart coordinate transformation engine for astronomical calculations.
///
/// Implements spherical trigonometry to convert between Equatorial (RA, Dec)
/// and Horizontal (Alt, Az) coordinate frames, including Bennett atmospheric refraction.
abstract final class CoordinateTransformer {
  /// Converts an [EquatorialCoordinate] to a [HorizontalCoordinate]
  /// for a given [observer] and [dateTime].
  ///
  /// Set [applyAtmosphericRefraction] to `true` (default) to compute
  /// the apparent altitude incorporating near-horizon atmospheric refraction.
  static HorizontalCoordinate equatorialToHorizontal({
    required EquatorialCoordinate celestial,
    required GeographicLocation observer,
    required DateTime dateTime,
    bool applyAtmosphericRefraction = true,
  }) {
    final jd = JulianDate.fromDateTime(dateTime);
    return equatorialToHorizontalFromJd(
      celestial: celestial,
      observer: observer,
      jd: jd,
      applyAtmosphericRefraction: applyAtmosphericRefraction,
    );
  }

  /// Converts an [EquatorialCoordinate] to a [HorizontalCoordinate]
  /// using an explicit Julian Date [jd].
  static HorizontalCoordinate equatorialToHorizontalFromJd({
    required EquatorialCoordinate celestial,
    required GeographicLocation observer,
    required double jd,
    bool applyAtmosphericRefraction = true,
  }) {
    // 1. Calculate Local Sidereal Time (LST)
    final lstHours = SiderealTime.lstHoursFromJd(
      jd: jd,
      longitudeDegrees: observer.longitudeDegrees,
    );

    // 2. Calculate Local Hour Angle (H) in radians
    final hAngleHours = SiderealTime.hourAngleHours(
      lstHours: lstHours,
      rightAscensionHours: celestial.rightAscensionHours,
    );
    final hRad = AngleUtils.hoursToRadians(hAngleHours);

    // 3. Spherical Trigonometry
    final phiRad = observer.latitudeRadians;
    final deltaRad = celestial.declinationRadians;

    final sinPhi = math.sin(phiRad);
    final cosPhi = math.cos(phiRad);
    final sinDelta = math.sin(deltaRad);
    final cosDelta = math.cos(deltaRad);
    final cosH = math.cos(hRad);
    final sinH = math.sin(hRad);

    // Altitude: sin(h) = sin(phi)*sin(delta) + cos(phi)*cos(delta)*cos(H)
    final sinAltitude = (sinPhi * sinDelta) + (cosPhi * cosDelta * cosH);
    final clampedSinAlt = sinAltitude.clamp(-1.0, 1.0);
    final altitudeRad = math.asin(clampedSinAlt);
    final trueAltitudeDeg = AngleUtils.toDegrees(altitudeRad);

    // Azimuth measured clockwise from True North [0°, 360°):
    // y = -cos(delta) * sin(H)
    // x = sin(delta)*cos(phi) - cos(delta)*sin(phi)*cos(H)
    final y = -cosDelta * sinH;
    final x = (sinDelta * cosPhi) - (cosDelta * sinPhi * cosH);

    final azimuthRad = math.atan2(y, x);
    final azimuthDeg = AngleUtils.normalizeDegrees(AngleUtils.toDegrees(azimuthRad));

    // 4. Atmospheric Refraction (Bennett formula)
    double? apparentAltDeg;
    if (applyAtmosphericRefraction) {
      apparentAltDeg = applyRefraction(trueAltitudeDeg);
    }

    return HorizontalCoordinate.fromRaw(
      altitudeDegrees: trueAltitudeDeg,
      azimuthDegrees: azimuthDeg,
      apparentAltitudeDegrees: apparentAltDeg,
    );
  }

  /// Applies Bennett (1982) empirical atmospheric refraction formula.
  ///
  /// Corrects true geometric altitude for atmospheric bending of light rays.
  /// Returns apparent altitude in decimal degrees.
  static double applyRefraction(double trueAltitudeDegrees) {
    // Only calculate for objects near or above the horizon (h > -0.5°)
    if (trueAltitudeDegrees < -0.5) {
      return trueAltitudeDegrees;
    }

    // Formula: R = 1.02 / tan(h + 10.3 / (h + 5.11)) arcminutes
    final h = trueAltitudeDegrees;
    final argumentDeg = h + (10.3 / (h + 5.11));
    final argumentRad = AngleUtils.toRadians(argumentDeg);
    final tanVal = math.tan(argumentRad);

    if (tanVal <= 0.0) {
      return trueAltitudeDegrees;
    }

    final rArcminutes = 1.02 / tanVal;
    final rDegrees = rArcminutes / 60.0;

    return trueAltitudeDegrees + rDegrees;
  }

  /// Converts Horizontal coordinates (Alt, Az) into a normalized 3D Cartesian
  /// unit direction vector (x, y, z) on the celestial sphere.
  ///
  /// Convention (Unity / standard right-handed AR coordinates):
  /// +X = East, +Y = Zenith (Up), +Z = True North.
  static ({double x, double y, double z}) horizontalToCartesianDirection({
    required double altitudeDegrees,
    required double azimuthDegrees,
  }) {
    final altRad = AngleUtils.toRadians(altitudeDegrees);
    final azRad = AngleUtils.toRadians(azimuthDegrees);

    final cosAlt = math.cos(altRad);
    final sinAlt = math.sin(altRad);
    final sinAz = math.sin(azRad);
    final cosAz = math.cos(azRad);

    return (
      x: cosAlt * sinAz,
      y: sinAlt,
      z: cosAlt * cosAz,
    );
  }

  /// Converts a [HorizontalCoordinate] back to an [EquatorialCoordinate]
  /// given an [observer] and [dateTime].
  static EquatorialCoordinate horizontalToEquatorial({
    required HorizontalCoordinate horizontal,
    required GeographicLocation observer,
    required DateTime dateTime,
  }) {
    final jd = JulianDate.fromDateTime(dateTime);
    final lstHours = SiderealTime.lstHoursFromJd(
      jd: jd,
      longitudeDegrees: observer.longitudeDegrees,
    );

    final altRad = horizontal.altitudeRadians;
    final azRad = horizontal.azimuthRadians;
    final phiRad = observer.latitudeRadians;

    final sinAlt = math.sin(altRad);
    final cosAlt = math.cos(altRad);
    final sinAz = math.sin(azRad);
    final cosAz = math.cos(azRad);
    final sinPhi = math.sin(phiRad);
    final cosPhi = math.cos(phiRad);

    // Declination: sin(delta) = sin(phi)*sin(alt) + cos(phi)*cos(alt)*cos(az)
    final sinDelta = (sinPhi * sinAlt) + (cosPhi * cosAlt * cosAz);
    final deltaRad = math.asin(sinDelta.clamp(-1.0, 1.0));
    final declinationDeg = AngleUtils.toDegrees(deltaRad);

    // Hour angle H:
    // y = -cos(alt)*sin(az)
    // x = sin(alt)*cos(phi) - cos(alt)*sin(phi)*cos(az)
    final y = -cosAlt * sinAz;
    final x = (sinAlt * cosPhi) - (cosAlt * sinPhi * cosAz);
    final hRad = math.atan2(y, x);
    final hHours = AngleUtils.radiansToHours(hRad);

    // RA = LST - H
    final raHours = AngleUtils.normalizeHours(lstHours - hHours);

    return EquatorialCoordinate(
      rightAscensionHours: raHours,
      declinationDegrees: declinationDeg,
    );
  }
}
