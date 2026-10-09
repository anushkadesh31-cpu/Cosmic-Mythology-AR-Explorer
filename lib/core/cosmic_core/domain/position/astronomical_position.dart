import '../../astronomy/coordinates/horizontal_coordinate.dart';
import '../observer/observer.dart';
import '../time/observation_time.dart';

/// Immutable result model representing calculated astronomical position.
class AstronomicalPosition {
  final String objectId;
  final Observer observer;
  final ObservationTime time;
  final double altitudeDeg;
  final double azimuthDeg;
  final bool isAboveHorizon;
  final HorizontalCoordinate horizontal;

  const AstronomicalPosition({
    required this.objectId,
    required this.observer,
    required this.time,
    required this.altitudeDeg,
    required this.azimuthDeg,
    required this.isAboveHorizon,
    required this.horizontal,
  });
}
