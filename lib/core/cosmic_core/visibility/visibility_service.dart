import '../domain/celestial/celestial_object.dart';
import '../domain/celestial/celestial_repository.dart';
import '../domain/celestial/star.dart';
import '../domain/observer/observer.dart';
import '../domain/position/position_service.dart';
import '../domain/time/observation_time.dart';
import '../data/catalog/simple_star_catalog.dart';
import 'visible_object.dart';

/// Pure-Dart service that determines which catalog objects are currently visible.
class VisibilityService {
  final CelestialPositionService _positionService;

  const VisibilityService([this._positionService = const CelestialPositionService()]);

  /// Computes visible objects for an observer at an observation time synchronously.
  List<VisibleObject> visibleObjects({
    required Observer observer,
    required ObservationTime observationTime,
    required CelestialRepository repository,
    double? maxApparentMagnitude,
  }) {
    final List<CelestialObject> objects;
    if (repository is SimpleStarCatalog) {
      objects = repository.getAll();
    } else {
      List<CelestialObject> fetched = const [];
      try {
        fetched = (repository as dynamic).getAll() as List<CelestialObject>;
      } catch (_) {}
      objects = fetched;
    }

    return filterVisible(
      objects: objects,
      observer: observer,
      observationTime: observationTime,
      maxApparentMagnitude: maxApparentMagnitude,
    );
  }

  /// Asynchronously queries the [CelestialRepository] adhering to the domain contract
  /// and determines which objects are visible.
  Future<List<VisibleObject>> getVisibleObjects({
    required Observer observer,
    required ObservationTime observationTime,
    required CelestialRepository repository,
    double? maxApparentMagnitude,
  }) async {
    try {
      final objects = await repository.getByType(type: 'star');
      return filterVisible(
        objects: objects,
        observer: observer,
        observationTime: observationTime,
        maxApparentMagnitude: maxApparentMagnitude,
      );
    } catch (_) {
      return const [];
    }
  }

  /// Core pure-Dart filtering and positioning engine.
  List<VisibleObject> filterVisible({
    required Iterable<CelestialObject> objects,
    required Observer observer,
    required ObservationTime observationTime,
    double? maxApparentMagnitude,
  }) {
    final results = <VisibleObject>[];

    for (final obj in objects) {
      final position = _positionService.calculatePosition(
        celestialObject: obj,
        observer: observer,
        observationTime: observationTime,
      );

      if (position == null) continue;
      if (!position.horizontal.isAboveHorizon) continue;

      final double? mag = obj is Star ? obj.apparentMagnitude : null;
      if (maxApparentMagnitude != null && (mag ?? double.infinity) > maxApparentMagnitude) {
        continue;
      }

      results.add(
        VisibleObject(
          id: obj.id,
          name: obj.name,
          type: obj.type,
          altitude: position.horizontal.altitudeDegrees,
          azimuth: position.horizontal.azimuthDegrees,
          apparentMagnitude: mag,
        ),
      );
    }

    // Deterministic ordering: highest altitude first, then stable tie-break by id
    results.sort((a, b) {
      final altCmp = b.altitude.compareTo(a.altitude);
      if (altCmp != 0) return altCmp;
      return a.id.compareTo(b.id);
    });

    return results;
  }
}
