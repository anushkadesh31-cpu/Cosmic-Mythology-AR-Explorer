import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/data/catalog/simple_star_catalog.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/observer/observer.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/time/observation_time.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/visibility/visibility_service.dart';

void main() {
  group('VisibilityService', () {
    const visibilityService = VisibilityService();
    final catalog = SimpleStarCatalog();

    final observer = Observer(
      latitude: 37.7749,
      longitude: -122.4194,
    );

    final observationTime = ObservationTime(DateTime.utc(2026, 1, 1, 4, 0));

    test('returns visible objects from catalog ordered by altitude descending', () {
      final visible = visibilityService.visibleObjects(
        observer: observer,
        observationTime: observationTime,
        repository: catalog,
      );

      expect(visible, isNotEmpty);
      for (int i = 0; i < visible.length - 1; i++) {
        expect(visible[i].altitude >= visible[i + 1].altitude, isTrue);
      }
    });

    test('filters objects by maximum apparent magnitude', () {
      final allVisible = visibilityService.visibleObjects(
        observer: observer,
        observationTime: observationTime,
        repository: catalog,
      );

      final brightVisible = visibilityService.visibleObjects(
        observer: observer,
        observationTime: observationTime,
        repository: catalog,
        maxApparentMagnitude: 0.5,
      );

      expect(brightVisible.length <= allVisible.length, isTrue);
      for (final star in brightVisible) {
        expect(star.apparentMagnitude, isNotNull);
        expect(star.apparentMagnitude! <= 0.5, isTrue);
      }
    });
  });
}
