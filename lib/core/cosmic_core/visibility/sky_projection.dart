/// A pure‑Dart utility that maps astronomical altitude/azimuth
/// coordinates to normalized screen positions.
///
/// Altitude ranges from 0° (horizon) to 90° (zenith).
/// Azimuth ranges from 0° (North) clockwise to 360°.
///
/// The mapping used by the virtual sky is:
///   * **x‑coordinate** – proportional to azimuth, where 0° (North) is at the
///     left edge of the screen and 360° wraps back to the left edge. The mapping
///     is linear: `x = (azimuth / 360) * width`.
///   * **y‑coordinate** – proportional to altitude, where 0° (horizon) is at the
///     bottom of the screen and 90° (zenith) is at the top. The mapping is
///     linear: `y = (1 - altitude / 90) * height`.
///
/// This function returns a pair of double values in the range `[0, 1]`
/// representing the relative position within the widget's bounding box.
/// The caller is responsible for scaling the result to the actual pixel size.
class SkyProjection {
  /// Returns a tuple `(x, y)` where each value is between `0.0` and `1.0`.
  ///
  /// * `azimuth` – degrees clockwise from true north (0‑360).
  /// * `altitude` – degrees above the horizon (0‑90).
  ///
  /// The mapping is deterministic and independent of screen size.
  static (double x, double y) toNormalized({required double azimuth, required double altitude}) {
    // Clamp inputs to valid ranges to avoid out‑of‑bounds values.
    final az = azimuth % 360; // wrap around
    final alt = altitude.clamp(0.0, 90.0);

    final x = az / 360.0; // 0.0 (North/left) .. 1.0 (right)
    final y = 1.0 - (alt / 90.0); // 0.0 (top/zenith) .. 1.0 (bottom/horizon)
    return (x, y);
  }
}
