// lib/core/cosmic_core/domain/time/observation_time.dart

import '../../astronomy/time/julian_date.dart';
import '../../astronomy/time/sidereal_time.dart';
import '../observer/observer.dart';

/// Immutable model representing a specific observation moment in UTC.
/// Provides convenient conversions to Julian Date, Modified Julian Date,
/// Greenwich Mean Sidereal Time (GMST) and Local Sidereal Time (LST).
class ObservationTime {
  /// The observation moment in UTC.
  final DateTime utc;

  const ObservationTime._internal(this.utc);

  /// Factory that normalises any DateTime to UTC.
  factory ObservationTime(DateTime dateTime) =>
      ObservationTime._internal(dateTime.toUtc());

  /// Julian Date for this observation.
  double get julianDate => JulianDate.fromDateTime(utc);

  /// Modified Julian Date.
  double get modifiedJulianDate => JulianDate.toMjd(julianDate);

  /// Greenwich Mean Sidereal Time (GMST) in decimal hours.
  double get gmstHours => SiderealTime.gmstHoursFromDateTime(utc);

  /// Local Sidereal Time (LST) for the given [observer].
  double lstHours(Observer observer) =>
      SiderealTime.lstHoursFromDateTime(dateTime: utc, longitudeDegrees: observer.longitude);
}
