// test/features/sky/constellation_linework_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/celestial_object_type.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/celestial_repository.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/constellation_vector_segment.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/observer/observer.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/time/observation_time.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/data/catalog/simple_star_catalog.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/visibility/visibility_service.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/visibility/visible_object.dart';
import 'package:cosmic_mythology_ar/features/sky/virtual_sky.dart';
import 'package:cosmic_mythology_ar/features/sky/sky_screen.dart';

class RecordingCanvas implements Canvas {
  final List<(Offset, Offset)> drawnLines = [];
  final List<(Offset, double)> drawnCircles = [];
  final List<Rect> drawnRects = [];

  @override
  void drawLine(Offset p1, Offset p2, Paint paint) {
    drawnLines.add((p1, p2));
  }

  @override
  void drawCircle(Offset c, double radius, Paint paint) {
    drawnCircles.add((c, radius));
  }

  @override
  void drawRect(Rect rect, Paint paint) {
    drawnRects.add(rect);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeLineworkVisibilityService extends VisibilityService {
  final List<VisibleObject> Function({
    required Observer observer,
    required ObservationTime observationTime,
    required CelestialRepository repository,
  }) onVisibleObjects;

  const FakeLineworkVisibilityService({required this.onVisibleObjects});

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
    return visibleObjects(
      observer: observer,
      observationTime: observationTime,
      repository: repository,
      maxApparentMagnitude: maxApparentMagnitude,
    );
  }
}

void main() {
  group('Phase 3.7: Constellation Vector Linework & Sky Lines Tests', () {
    final observer = Observer(latitude: 12.97, longitude: 77.59);
    final time = ObservationTime(DateTime.utc(2026, 10, 9, 21, 0));
    final repo = SimpleStarCatalog();

    // Star 1 (Vega): azimuth 90°, altitude 45° -> normX = 90/360 = 0.25, normY = 1 - 45/90 = 0.5
    const starVega = VisibleObject(
      id: 'star-vega',
      name: 'Vega',
      type: CelestialObjectType.star,
      altitude: 45.0,
      azimuth: 90.0,
      apparentMagnitude: 0.03,
    );

    // Star 2 (Altair): azimuth 180°, altitude 45° -> normX = 180/360 = 0.5, normY = 1 - 45/90 = 0.5
    const starAltair = VisibleObject(
      id: 'star-altair',
      name: 'Altair',
      type: CelestialObjectType.star,
      altitude: 45.0,
      azimuth: 180.0,
      apparentMagnitude: 0.77,
    );

    // Star 3 (Deneb): azimuth 270°, altitude 72° -> normX = 270/360 = 0.75, normY = 1 - 72/90 = 0.2
    const starDeneb = VisibleObject(
      id: 'star-deneb',
      name: 'Deneb',
      type: CelestialObjectType.star,
      altitude: 72.0,
      azimuth: 270.0,
      apparentMagnitude: 1.25,
    );

    const segmentVegaAltair = ConstellationVectorSegment(
      startStarId: 'star-vega',
      endStarId: 'star-altair',
      groupId: 'summer_triangle',
    );

    const segmentAltairDeneb = ConstellationVectorSegment(
      startStarId: 'star-altair',
      endStarId: 'star-deneb',
      groupId: 'summer_triangle',
    );

    test('1. SkyPainter renders lines when both endpoints are visible', () {
      final canvas = RecordingCanvas();
      final painter = SkyPainter(
        visibleStars: [starVega, starAltair],
        width: 400,
        height: 400,
        showConstellationLines: true,
        lineSegments: [segmentVegaAltair],
      );

      painter.paint(canvas, const Size(400, 400));

      expect(canvas.drawnLines.length, 1);
      final (p1, p2) = canvas.drawnLines.first;
      // Vega (0.25 * 400 = 100, 0.5 * 400 = 200)
      expect(p1.dx, closeTo(100.0, 0.01));
      expect(p1.dy, closeTo(200.0, 0.01));
      // Altair (0.5 * 400 = 200, 0.5 * 400 = 200)
      expect(p2.dx, closeTo(200.0, 0.01));
      expect(p2.dy, closeTo(200.0, 0.01));
    });

    test('2. SkyPainter omits line when either endpoint is missing or below horizon', () {
      final canvas = RecordingCanvas();
      // Only Vega is visible; Altair is below horizon (missing from visibleStars)
      final painter = SkyPainter(
        visibleStars: [starVega],
        width: 400,
        height: 400,
        showConstellationLines: true,
        lineSegments: [segmentVegaAltair],
      );

      painter.paint(canvas, const Size(400, 400));

      // No lines drawn because Altair is not visible
      expect(canvas.drawnLines, isEmpty);
      // But Vega star circle is still drawn
      expect(canvas.drawnCircles.isNotEmpty, isTrue);
    });

    test('3. SkyPainter omits all lines when showConstellationLines is false', () {
      final canvas = RecordingCanvas();
      final painter = SkyPainter(
        visibleStars: [starVega, starAltair, starDeneb],
        width: 400,
        height: 400,
        showConstellationLines: false, // Disabled
        lineSegments: [segmentVegaAltair, segmentAltairDeneb],
      );

      painter.paint(canvas, const Size(400, 400));

      expect(canvas.drawnLines, isEmpty);
      // Star circles are still painted
      expect(canvas.drawnCircles.length, 3);
    });

    test('4. Empty or incomplete line segments do not throw or crash', () {
      final canvas = RecordingCanvas();
      final painter = SkyPainter(
        visibleStars: [starVega],
        width: 400,
        height: 400,
        showConstellationLines: true,
        lineSegments: const [
          ConstellationVectorSegment(startStarId: 'nonexistent-1', endStarId: 'nonexistent-2'),
        ],
      );

      expect(() => painter.paint(canvas, const Size(400, 400)), returnsNormally);
      expect(canvas.drawnLines, isEmpty);
    });

    testWidgets('5. VirtualSky reacts dynamically when showConstellationLines changes', (tester) async {
      bool showLines = true;
      final service = FakeLineworkVisibilityService(
        onVisibleObjects: ({required observer, required observationTime, required repository}) =>
            [starVega, starAltair],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    SizedBox(
                      width: 400,
                      height: 400,
                      child: VirtualSky(
                        observer: observer,
                        observationTime: time,
                        repository: repo,
                        visibilityService: service,
                        showConstellationLines: showLines,
                        lineSegments: const [segmentVegaAltair],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showLines = !showLines;
                        });
                      },
                      child: const Text('Toggle Lines'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.byType(VirtualSky), findsOneWidget);
      final customPaintFinder = find.byKey(const Key('virtual_sky_canvas'));
      expect(customPaintFinder, findsOneWidget);

      CustomPaint customPaint = tester.widget<CustomPaint>(customPaintFinder);
      SkyPainter painter = customPaint.painter as SkyPainter;
      expect(painter.showConstellationLines, isTrue);

      // Toggle off
      await tester.tap(find.text('Toggle Lines'));
      await tester.pump();

      customPaint = tester.widget<CustomPaint>(customPaintFinder);
      painter = customPaint.painter as SkyPainter;
      expect(painter.showConstellationLines, isFalse);
    });

    testWidgets('6. SkyScreen Lines button toggles constellation lines in VirtualSky', (tester) async {
      final service = FakeLineworkVisibilityService(
        onVisibleObjects: ({required observer, required observationTime, required repository}) =>
            [starVega, starAltair],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SkyScreen(
              observer: observer,
              observationTime: time,
              repository: repo,
              visibilityService: service,
            ),
          ),
        ),
      );

      final customPaintFinder = find.byKey(const Key('virtual_sky_canvas'));
      expect(customPaintFinder, findsOneWidget);
      CustomPaint customPaint = tester.widget<CustomPaint>(customPaintFinder);
      SkyPainter painter = customPaint.painter as SkyPainter;
      // Default in SkyScreen is true
      expect(painter.showConstellationLines, isTrue);

      // Tap the 'Lines' toggle button in minimal controls
      final linesButton = find.byTooltip('Lines');
      expect(linesButton, findsOneWidget);
      await tester.tap(linesButton);
      await tester.pump();

      // VirtualSky painter updated to showConstellationLines = false
      customPaint = tester.widget<CustomPaint>(customPaintFinder);
      painter = customPaint.painter as SkyPainter;
      expect(painter.showConstellationLines, isFalse);

      // Tap again to re-enable
      await tester.tap(linesButton);
      await tester.pump();

      customPaint = tester.widget<CustomPaint>(customPaintFinder);
      painter = customPaint.painter as SkyPainter;
      expect(painter.showConstellationLines, isTrue);
    });

    testWidgets('7. Star hit-testing and selection behavior is unaffected by linework', (tester) async {
      VisibleObject? selected;
      final service = FakeLineworkVisibilityService(
        onVisibleObjects: ({required observer, required observationTime, required repository}) =>
            [starVega, starAltair],
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 400,
              child: VirtualSky(
                observer: observer,
                observationTime: time,
                repository: repo,
                visibilityService: service,
                showConstellationLines: true,
                lineSegments: const [segmentVegaAltair],
                onSelectObject: (obj) => selected = obj,
              ),
            ),
          ),
        ),
      );

      // Tap directly on Star Vega at (0.25 * 400 = 100, 0.5 * 400 = 200)
      await tester.tapAt(const Offset(100, 200));
      await tester.pump();

      expect(selected, isNotNull);
      expect(selected!.id, 'star-vega');
      expect(selected!.name, 'Vega');

      // Tap halfway along the line at (150, 200) -> distance to Vega is 50px, distance to Altair is 50px
      // Both exceed touchRadius (28px) -> empty sky behavior, deselects
      await tester.tapAt(const Offset(150, 200));
      await tester.pump();

      expect(selected, isNull);
    });
  });
}
