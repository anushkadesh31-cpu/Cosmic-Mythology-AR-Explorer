import '../../astronomy/coordinates/geographic_location.dart';
import '../../astronomy/transformations/coordinate_transformer.dart';
import '../celestial/celestial_object.dart';
import '../observer/observer.dart';
import '../time/observation_time.dart';
import 'astronomical_position.dart';

/// Pure-Dart service calculating astronomical positions from celestial coordinates.
class CelestialPositionService {
  const CelestialPositionService();

  /// Calculates geometric horizontal position for a given [celestialObject].
  AstronomicalPosition? calculatePosition({
    required CelestialObject celestialObject,
    required Observer observer,
    required ObservationTime observationTime,
  }) {
    final equatorial = celestialObject.equatorialCoordinate;
    if (equatorial == null) return null;

    final horiz = CoordinateTransformer.equatorialToHorizontal(
      celestial: equatorial,
      observer: GeographicLocation(
        latitudeDegrees: observer.latitude,
        longitudeDegrees: observer.longitude,
        elevationMeters: observer.elevation ?? 0.0,
      ),
      dateTime: observationTime.utc,
      applyAtmosphericRefraction: false,
    );

    return AstronomicalPosition(
      objectId: celestialObject.id,
      observer: observer,
      time: observationTime,
      altitudeDeg: horiz.altitudeDegrees,
      azimuthDeg: horiz.azimuthDegrees,
      isAboveHorizon: horiz.isAboveHorizon,
      horizontal: horiz,
    );
  }
}
