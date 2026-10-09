import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/data/catalog/simple_star_catalog.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/celestial_object.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/celestial_object_type.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/celestial_repository.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/observer/observer.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/time/observation_time.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/visibility/visibility_service.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/visibility/visible_object.dart';
import 'package:cosmic_mythology_ar/features/sky/virtual_sky.dart';

/// Fake repository implementing pure-async CelestialRepository.
class FakeAsyncRepository implements CelestialRepository {
  final Future<List<CelestialObject>> Function(String type)? onGetByType;

  FakeAsyncRepository({this.onGetByType});

  @override
  Future<CelestialObject?> getById(String id) async => null;

  @override
  Future<List<CelestialObject>> getByType({required String type}) async {
    if (onGetByType != null) {
      return onGetByType!(type);
    }
    return [];
  }

  @override
  Future<List<CelestialObject>> search(String query) async => [];
}

/// Fake VisibilityService to deterministically control sync and async responses.
class FakeVisibilityService extends VisibilityService {
  final Future<List<VisibleObject>> Function({
    required Observer observer,
    required ObservationTime observationTime,
    required CelestialRepository repository,
  })? onGetVisibleObjects;

  final List<VisibleObject> Function({
    required Observer observer,
    required ObservationTime observationTime,
    required CelestialRepository repository,
  })? onVisibleObjects;

  const FakeVisibilityService({
    this.onGetVisibleObjects,
    this.onVisibleObjects,
  });

  @override
  Future<List<VisibleObject>> getVisibleObjects({
    required Observer observer,
    required ObservationTime observationTime,
    required CelestialRepository repository,
    double? maxApparentMagnitude,
  }) async {
    if (onGetVisibleObjects != null) {
      return onGetVisibleObjects!(
        observer: observer,
        observationTime: observationTime,
        repository: repository,
      );
    }
    return super.getVisibleObjects(
      observer: observer,
      observationTime: observationTime,
      repository: repository,
      maxApparentMagnitude: maxApparentMagnitude,
    );
  }

  @override
  List<VisibleObject> visibleObjects({
    required Observer observer,
    required ObservationTime observationTime,
    required CelestialRepository repository,
    double? maxApparentMagnitude,
  }) {
    if (onVisibleObjects != null) {
      return onVisibleObjects!(
        observer: observer,
        observationTime: observationTime,
        repository: repository,
      );
    }
    return super.visibleObjects(
      observer: observer,
      observationTime: observationTime,
      repository: repository,
      maxApparentMagnitude: maxApparentMagnitude,
    );
  }
}

List<VisibleObject> _extractVisibleStars(WidgetTester tester) {
  final customPaintFinder = find.byKey(const Key('virtual_sky_canvas'));
  expect(customPaintFinder, findsOneWidget);
  final customPaint = tester.widget<CustomPaint>(customPaintFinder);
  final painter = customPaint.painter as SkyPainter;
  return painter.visibleStars;
}

void main() {
  group('VirtualSky Reactive Inputs & Regression Tests', () {
    final catalog = SimpleStarCatalog();
    const visibilityService = VisibilityService();

    final observerNorth = Observer(latitude: 37.7749, longitude: -122.4194);
    final observerSouth = Observer(latitude: -33.8688, longitude: 151.2093);

    final time1 = ObservationTime(DateTime.utc(2026, 1, 1, 4, 0));
    final time2 = ObservationTime(DateTime.utc(2026, 1, 1, 14, 0));

    testWidgets('1. Changing the observer refreshes the visible stars', (tester) async {
      Observer currentObserver = observerNorth;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: VirtualSky(
                  observer: currentObserver,
                  observationTime: time1,
                  repository: catalog,
                  visibilityService: visibilityService,
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      currentObserver = observerSouth;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      final starsNorth = _extractVisibleStars(tester);
      expect(starsNorth, isNotEmpty);

      // Tap to switch observer to Sydney
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      final starsSouth = _extractVisibleStars(tester);
      expect(starsSouth, isNotEmpty);

      // Altitudes and visible set differ between San Francisco and Sydney
      final northAltMap = {for (var s in starsNorth) s.id: s.altitude};
      final southAltMap = {for (var s in starsSouth) s.id: s.altitude};
      expect(northAltMap, isNot(equals(southAltMap)));
    });

    testWidgets('2. Changing observation time refreshes the visible stars', (tester) async {
      ObservationTime currentTime = time1;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: VirtualSky(
                  observer: observerNorth,
                  observationTime: currentTime,
                  repository: catalog,
                  visibilityService: visibilityService,
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      currentTime = time2;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      final starsTime1 = _extractVisibleStars(tester);
      expect(starsTime1, isNotEmpty);

      // Tap to advance observation time by 10 hours
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      final starsTime2 = _extractVisibleStars(tester);
      expect(starsTime2, isNotEmpty);

      final altMap1 = {for (var s in starsTime1) s.id: s.altitude};
      final altMap2 = {for (var s in starsTime2) s.id: s.altitude};
      expect(altMap1, isNot(equals(altMap2)));
    });

    testWidgets('3. Replacing the repository or visibility service triggers the correct refresh', (tester) async {
      const defaultService = VisibilityService();
      final starB = VisibleObject(
        id: 'star-b',
        name: 'Beta B',
        type: CelestialObjectType.star,
        altitude: 60.0,
        azimuth: 90.0,
      );

      final customService = FakeVisibilityService(
        onVisibleObjects: ({required observer, required observationTime, required repository}) => [starB],
      );

      VisibilityService activeService = defaultService;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: VirtualSky(
                  observer: observerNorth,
                  observationTime: time1,
                  repository: catalog,
                  visibilityService: activeService,
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      activeService = customService;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      final initialStars = _extractVisibleStars(tester);
      expect(initialStars, isNotEmpty);
      expect(initialStars.any((s) => s.id == 'star-b'), isFalse);

      // Replace visibilityService
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      final updatedStars = _extractVisibleStars(tester);
      expect(updatedStars.length, 1);
      expect(updatedStars.first.id, 'star-b');
    });

    testWidgets('4. A slower older asynchronous request cannot overwrite a newer request', (tester) async {
      final completer1 = Completer<List<VisibleObject>>();
      final completer2 = Completer<List<VisibleObject>>();
      int callCount = 0;

      final asyncService = FakeVisibilityService(
        onGetVisibleObjects: ({required observer, required observationTime, required repository}) {
          callCount++;
          if (callCount == 1) return completer1.future;
          return completer2.future;
        },
      );

      final fakeRepo = FakeAsyncRepository();
      Observer currentObserver = observerNorth;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: VirtualSky(
                  observer: currentObserver,
                  observationTime: time1,
                  repository: fakeRepo,
                  visibilityService: asyncService,
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      currentObserver = observerSouth;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      // Call 1 is in flight
      expect(callCount, 1);
      expect(find.byKey(const Key('virtual_sky_loading')), findsOneWidget);

      // Trigger request 2 before request 1 finishes
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(callCount, 2);

      final starFromRequest2 = VisibleObject(
        id: 'star-req2',
        name: 'Newer Star',
        type: CelestialObjectType.star,
        altitude: 70.0,
        azimuth: 120.0,
      );
      final starFromRequest1 = VisibleObject(
        id: 'star-req1',
        name: 'Stale Older Star',
        type: CelestialObjectType.star,
        altitude: 20.0,
        azimuth: 40.0,
      );

      // Complete newer request 2 FIRST
      completer2.complete([starFromRequest2]);
      await tester.pump();

      final starsAfterReq2 = _extractVisibleStars(tester);
      expect(starsAfterReq2.length, 1);
      expect(starsAfterReq2.first.id, 'star-req2');

      // Now complete older request 1 LATER
      completer1.complete([starFromRequest1]);
      await tester.pump();

      // Older request must be discarded and MUST NOT overwrite star-req2
      final starsAfterStaleReq1 = _extractVisibleStars(tester);
      expect(starsAfterStaleReq1.length, 1);
      expect(starsAfterStaleReq1.first.id, 'star-req2');
    });

    testWidgets('5. Loading and errors settle correctly after the latest request finishes', (tester) async {
      final errorCompleter = Completer<List<VisibleObject>>();

      final errorService = FakeVisibilityService(
        onGetVisibleObjects: ({required observer, required observationTime, required repository}) =>
            errorCompleter.future,
      );

      final fakeRepo = FakeAsyncRepository();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VirtualSky(
              observer: observerNorth,
              observationTime: time1,
              repository: fakeRepo,
              visibilityService: errorService,
            ),
          ),
        ),
      );

      // Shows loading indicator while future is pending
      expect(find.byKey(const Key('virtual_sky_loading')), findsOneWidget);
      expect(find.byKey(const Key('virtual_sky_error')), findsNothing);

      // Complete with error
      errorCompleter.completeError(Exception('Database offline'));
      await tester.pumpAndSettle();

      // Loading spinner gone, error banner displayed
      expect(find.byKey(const Key('virtual_sky_loading')), findsNothing);
      expect(find.byKey(const Key('virtual_sky_error')), findsOneWidget);
      expect(find.text('Unable to load celestial objects. Please try again.'), findsOneWidget);
    });

    testWidgets('6. An empty catalog is handled safely', (tester) async {
      final emptyRepo = FakeAsyncRepository(
        onGetByType: (type) async => [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VirtualSky(
              observer: observerNorth,
              observationTime: time1,
              repository: emptyRepo,
              visibilityService: visibilityService,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // No crash, no spinner, no error banner
      expect(find.byKey(const Key('virtual_sky_loading')), findsNothing);
      expect(find.byKey(const Key('virtual_sky_error')), findsNothing);
      final stars = _extractVisibleStars(tester);
      expect(stars, isEmpty);
    });

    testWidgets('7. Widget disposal during an asynchronous request does not cause unsafe state updates', (tester) async {
      final pendingCompleter = Completer<List<VisibleObject>>();

      final slowService = FakeVisibilityService(
        onGetVisibleObjects: ({required observer, required observationTime, required repository}) =>
            pendingCompleter.future,
      );

      final fakeRepo = FakeAsyncRepository();
      bool isMounted = true;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: isMounted
                    ? VirtualSky(
                        observer: observerNorth,
                        observationTime: time1,
                        repository: fakeRepo,
                        visibilityService: slowService,
                      )
                    : const SizedBox.shrink(),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    setState(() {
                      isMounted = false;
                    });
                  },
                ),
              );
            },
          ),
        ),
      );

      expect(find.byType(VirtualSky), findsOneWidget);

      // Dispose VirtualSky by removing it from widget tree
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(find.byType(VirtualSky), findsNothing);

      // Now complete the pending async request after disposal
      pendingCompleter.complete([
        VisibleObject(
          id: 'post-dispose',
          name: 'Post Dispose Star',
          type: CelestialObjectType.star,
          altitude: 10.0,
          azimuth: 10.0,
        ),
      ]);

      // Pump to ensure no unhandled exceptions or setState-after-dispose errors
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });
}
