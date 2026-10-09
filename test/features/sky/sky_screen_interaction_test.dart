import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/celestial_object.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/celestial_object_type.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/celestial_repository.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/observer/observer.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/time/observation_time.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/visibility/visibility_service.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/visibility/visible_object.dart';
import 'package:cosmic_mythology_ar/features/sky/sky_screen.dart';
import 'package:cosmic_mythology_ar/features/sky/virtual_sky.dart';

class FakeTestRepository implements CelestialRepository {
  final List<CelestialObject> objects;
  FakeTestRepository([this.objects = const []]);

  @override
  Future<CelestialObject?> getById(String id) async =>
      objects.where((o) => o.id == id).firstOrNull;

  @override
  Future<List<CelestialObject>> getByType({required String type}) async => objects;

  @override
  Future<List<CelestialObject>> search(String query) async => objects;

  List<CelestialObject> getAll() => objects;
}

class FakeInteractionVisibilityService extends VisibilityService {
  final List<VisibleObject> Function({
    required Observer observer,
    required ObservationTime observationTime,
    required CelestialRepository repository,
  }) onVisibleObjects;

  const FakeInteractionVisibilityService({required this.onVisibleObjects});

  @override
  List<VisibleObject> visibleObjects({
    required Observer observer,
    required ObservationTime observationTime,
    required CelestialRepository repository,
    double? maxApparentMagnitude,
  }) {
    return onVisibleObjects(
      observer: observer,
      observationTime: observationTime,
      repository: repository,
    );
  }

  @override
  Future<List<VisibleObject>> getVisibleObjects({
    required Observer observer,
    required ObservationTime observationTime,
    required CelestialRepository repository,
    double? maxApparentMagnitude,
  }) async {
    return onVisibleObjects(
      observer: observer,
      observationTime: observationTime,
      repository: repository,
    );
  }
}

void main() {
  group('Phase 3.6B: Interactive Star Selection & Telemetry Tests', () {
    final observer = Observer(latitude: 37.7749, longitude: -122.4194);
    final time1 = ObservationTime(DateTime.utc(2026, 1, 1, 4, 0));
    final time2 = ObservationTime(DateTime.utc(2026, 1, 1, 14, 0));
    final repo = FakeTestRepository();

    // Coordinates:
    // Star 1: azimuth=180°, altitude=72°
    // In VirtualSky: normX = 180 / 360 = 0.5, normY = 1.0 - (72 / 90) = 0.2
    final star1 = VisibleObject(
      id: 'star-alpha',
      name: 'Alpha Centauri',
      type: CelestialObjectType.star,
      altitude: 72.0,
      azimuth: 180.0,
      apparentMagnitude: 0.50,
    );

    // Star 2: azimuth=189°, altitude=72°
    // In VirtualSky: normX = 189 / 360 = 0.525, normY = 0.2
    // (In 400px width: 0.525 * 400 = 210, which is 10px from Star 1 at 200px)
    final star2 = VisibleObject(
      id: 'star-beta',
      name: 'Beta Centauri',
      type: CelestialObjectType.star,
      altitude: 72.0,
      azimuth: 189.0,
      apparentMagnitude: 1.20,
    );

    // Star 3: azimuth=90°, altitude=63°
    // In VirtualSky: normX = 90 / 360 = 0.25, normY = 1.0 - (63 / 90) = 0.3
    final star3 = VisibleObject(
      id: 'star-gamma',
      name: 'Gamma Crucis',
      type: CelestialObjectType.star,
      altitude: 63.0,
      azimuth: 90.0,
      apparentMagnitude: null,
    );

    testWidgets('1. Selecting a star by tapping its projected position in VirtualSky', (tester) async {
      VisibleObject? selected;

      final service = FakeInteractionVisibilityService(
        onVisibleObjects: ({required observer, required observationTime, required repository}) => [star1],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 400,
              child: VirtualSky(
                observer: observer,
                observationTime: time1,
                repository: repo,
                visibilityService: service,
                onSelectObject: (obj) => selected = obj,
              ),
            ),
          ),
        ),
      );

      // Tap projected position of Star 1: (0.5 * 400 = 200, 0.2 * 400 = 80)
      await tester.tapAt(const Offset(200, 80));
      await tester.pump();

      expect(selected, isNotNull);
      expect(selected!.id, 'star-alpha');
      expect(selected!.name, 'Alpha Centauri');
    });

    testWidgets('2. Selecting the nearest star when hit regions overlap', (tester) async {
      VisibleObject? selected;

      final service = FakeInteractionVisibilityService(
        onVisibleObjects: ({required observer, required observationTime, required repository}) => [star1, star2],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 400,
              child: VirtualSky(
                observer: observer,
                observationTime: time1,
                repository: repo,
                visibilityService: service,
                touchRadius: 28.0,
                onSelectObject: (obj) => selected = obj,
              ),
            ),
          ),
        ),
      );

      // Tap at (208, 80).
      // Distance to Star 2 (210, 80) is 2px.
      // Distance to Star 1 (200, 80) is 8px.
      // Both are within touchRadius 28px. Nearest (Star 2) must be chosen.
      await tester.tapAt(const Offset(208, 80));
      await tester.pump();

      expect(selected, isNotNull);
      expect(selected!.id, 'star-beta');
      expect(selected!.name, 'Beta Centauri');
    });

    testWidgets('3. Tapping empty sky does not select an unrelated star', (tester) async {
      VisibleObject? selected = star1;

      final service = FakeInteractionVisibilityService(
        onVisibleObjects: ({required observer, required observationTime, required repository}) => [star1],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 400,
              child: VirtualSky(
                observer: observer,
                observationTime: time1,
                repository: repo,
                visibilityService: service,
                selectedObjectId: selected.id,
                onSelectObject: (obj) => selected = obj,
              ),
            ),
          ),
        ),
      );

      // Tap at (10, 10), far away from star1 at (200, 80)
      await tester.tapAt(const Offset(10, 10));
      await tester.pump();

      // Empty sky tap reconciles to null without selecting any star
      expect(selected, isNull);
    });

    testWidgets('4. HUD details update dynamically when a star is selected in SkyScreen', (tester) async {
      final service = FakeInteractionVisibilityService(
        onVisibleObjects: ({required observer, required observationTime, required repository}) => [star1, star3],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkyScreen(
              observer: observer,
              observationTime: time1,
              repository: repo,
              visibilityService: service,
            ),
          ),
        ),
      );

      // Initially no target is selected
      expect(find.text('AWAITING CELESTIAL TARGET'), findsOneWidget);
      expect(find.text('Tap a star to inspect'), findsOneWidget);
      expect(find.text('SCANNING'), findsOneWidget);

      // Locate VirtualSky in the tree and compute Star 1's exact screen position
      final skyFinder = find.byType(VirtualSky);
      expect(skyFinder, findsOneWidget);
      final skyRect = tester.getRect(skyFinder);

      final star1Pos = Offset(
        skyRect.left + 0.5 * skyRect.width,
        skyRect.top + 0.2 * skyRect.height,
      );
      await tester.tapAt(star1Pos);
      await tester.pump();

      // Telemetry HUD locks onto Star 1
      expect(find.text('LOCKED CELESTIAL TARGET'), findsOneWidget);
      expect(find.text('Alpha Centauri'), findsOneWidget);
      expect(find.text('Altitude: '), findsOneWidget);
      expect(find.text('72.0°'), findsOneWidget);
      expect(find.text('Azimuth: '), findsOneWidget);
      expect(find.text('180.0°'), findsOneWidget);
      expect(find.text('Mag 0.50'), findsOneWidget);

      // Tap Star 3 (normX: 0.25, normY: 0.3)
      final star3Pos = Offset(
        skyRect.left + 0.25 * skyRect.width,
        skyRect.top + 0.3 * skyRect.height,
      );
      await tester.tapAt(star3Pos);
      await tester.pump();

      // Telemetry HUD updates to Star 3 with missing magnitude handled as 'Mag N/A'
      expect(find.text('LOCKED CELESTIAL TARGET'), findsOneWidget);
      expect(find.text('Gamma Crucis'), findsOneWidget);
      expect(find.text('Altitude: '), findsOneWidget);
      expect(find.text('63.0°'), findsOneWidget);
      expect(find.text('Azimuth: '), findsOneWidget);
      expect(find.text('90.0°'), findsOneWidget);
      expect(find.text('Mag N/A'), findsOneWidget);
    });

    testWidgets('5. Selection clearing and reconciliation when a star is no longer visible', (tester) async {
      ObservationTime currentTime = time1;

      final service = FakeInteractionVisibilityService(
        onVisibleObjects: ({required observer, required observationTime, required repository}) {
          if (observationTime.utc == time1.utc) {
            return [star1];
          }
          // At time2, star1 has set below horizon
          return [];
        },
      );

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: SkyScreen(
                  observer: observer,
                  observationTime: currentTime,
                  repository: repo,
                  visibilityService: service,
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

      // Tap Star 1
      final skyFinder = find.byType(VirtualSky);
      final skyRect = tester.getRect(skyFinder);
      final star1Pos = Offset(
        skyRect.left + 0.5 * skyRect.width,
        skyRect.top + 0.2 * skyRect.height,
      );
      await tester.tapAt(star1Pos);
      await tester.pump();
      expect(find.text('LOCKED CELESTIAL TARGET'), findsOneWidget);
      expect(find.text('Alpha Centauri'), findsOneWidget);

      // Advance observation time to time2 where star1 drops below horizon
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      await tester.pump(); // Pump post-frame callback

      // SkyScreen selection clears and reconciles to waiting state
      expect(find.text('AWAITING CELESTIAL TARGET'), findsOneWidget);
      expect(find.text('Tap a star to inspect'), findsOneWidget);
    });

    testWidgets('6. Loading, error, and empty-sky states operate safely', (tester) async {
      final emptyService = FakeInteractionVisibilityService(
        onVisibleObjects: ({required observer, required observationTime, required repository}) => [],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkyScreen(
              observer: observer,
              observationTime: time1,
              repository: repo,
              visibilityService: emptyService,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Empty sky renders gracefully without crashing
      expect(find.text('AWAITING CELESTIAL TARGET'), findsOneWidget);
      expect(find.byKey(const Key('virtual_sky_error')), findsNothing);

      // Tapping empty sky does not throw
      await tester.tapAt(const Offset(100, 100));
      await tester.pump();
      expect(find.text('AWAITING CELESTIAL TARGET'), findsOneWidget);
    });

    testWidgets('7. Compact and expanded layout verification', (tester) async {
      final service = FakeInteractionVisibilityService(
        onVisibleObjects: ({required observer, required observationTime, required repository}) => [star1],
      );

      // Test Compact Layout (390 x 800)
      tester.view.physicalSize = const Size(390, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkyScreen(
              observer: observer,
              observationTime: time1,
              repository: repo,
              visibilityService: service,
            ),
          ),
        ),
      );

      expect(find.byType(SkyScreen), findsOneWidget);
      expect(find.byKey(const Key('virtual_sky_canvas')), findsOneWidget);
      expect(find.text('AWAITING CELESTIAL TARGET'), findsOneWidget);

      // Test Expanded Layout (1200 x 900)
      tester.view.physicalSize = const Size(1200, 900);
      await tester.pump();

      expect(find.byType(SkyScreen), findsOneWidget);
      expect(find.byKey(const Key('virtual_sky_canvas')), findsOneWidget);
      expect(find.text('AWAITING CELESTIAL TARGET'), findsOneWidget);

      tester.view.resetPhysicalSize();
    });
  });
}
