/// High-precision astronomical Julian Date calculator.
///
/// Implements Jean Meeus: Astronomical Algorithms (2nd Edition, Chapter 7).
/// All calculations operate on Coordinated Universal Time (UTC) or Terrestrial Time.
abstract final class JulianDate {
  /// Standard J2000.0 epoch Julian Date (2000 January 1.5 TD / UTC).
  static const double j2000Epoch = 2451545.0;

  /// Standard Modified Julian Date offset.
  static const double mjdOffset = 2400000.5;

  /// Days per Julian century.
  static const double daysPerCentury = 36525.0;

  /// Computes the Julian Date from a Dart [DateTime].
  ///
  /// Automatically converts the given [dateTime] to UTC before evaluation.
  static double fromDateTime(DateTime dateTime) {
    final utc = dateTime.toUtc();
    final dayFraction = (utc.hour / 24.0) +
        (utc.minute / 1440.0) +
        (utc.second / 86400.0) +
        (utc.millisecond / 86400000.0) +
        (utc.microsecond / 86400000000.0);

    return fromYmd(
      year: utc.year,
      month: utc.month,
      dayWithFraction: utc.day + dayFraction,
    );
  }

  /// Computes the Julian Date from calendar year, month, and day fraction.
  ///
  /// Implements Meeus Formula 7.1.
  /// For January and February, the month is treated as 13 or 14 of the previous year.
  static double fromYmd({
    required int year,
    required int month,
    required double dayWithFraction,
  }) {
    var y = year;
    var m = month;

    if (m <= 2) {
      y -= 1;
      m += 12;
    }

    // Gregorian calendar reform cutoff (October 15, 1582)
    final isGregorian = year > 1582 ||
        (year == 1582 && (month > 10 || (month == 10 && dayWithFraction >= 15.0)));

    final a = (y / 100).floor();
    final b = isGregorian ? (2 - a + (a / 4).floor()) : 0;

    final jd = (365.25 * (y + 4716)).floor() +
        (30.6001 * (m + 1)).floor() +
        dayWithFraction +
        b -
        1524.5;

    return jd;
  }

  /// Converts a Julian Date to Modified Julian Date (MJD).
  static double toMjd(double jd) => jd - mjdOffset;

  /// Converts a Modified Julian Date (MJD) back to Julian Date (JD).
  static double fromMjd(double mjd) => mjd + mjdOffset;

  /// Calculates the time interval measured in Julian centuries of 36,525 ephemeris days
  /// from the standard epoch J2000.0 ($T$).
  static double centuriesSinceJ2000(double jd) {
    return (jd - j2000Epoch) / daysPerCentury;
  }

  /// Converts a Julian Date back to a UTC [DateTime].
  static DateTime toDateTime(double jd) {
    final jdPlus = jd + 0.5;
    final z = jdPlus.floor();
    final f = jdPlus - z;

    int a;
    if (z < 2299161) {
      a = z;
    } else {
      final alpha = ((z - 1867216.25) / 36524.25).floor();
      a = z + 1 + alpha - (alpha / 4).floor();
    }

    final b = a + 1524;
    final c = ((b - 122.1) / 365.25).floor();
    final d = (365.25 * c).floor();
    final e = ((b - d) / 30.6001).floor();

    final day = b - d - (30.6001 * e).floor() + f;
    final month = e < 14 ? e - 1 : e - 13;
    final year = month > 2 ? c - 4716 : c - 4715;

    final dayInt = day.floor();
    final dayFrac = day - dayInt;

    final totalSeconds = (dayFrac * 86400.0).round();
    final hours = totalSeconds ~/ 3600;
    final remainderSeconds = totalSeconds % 3600;
    final minutes = remainderSeconds ~/ 60;
    final seconds = remainderSeconds % 60;

    return DateTime.utc(year, month, dayInt, hours, minutes, seconds);
  }
}
