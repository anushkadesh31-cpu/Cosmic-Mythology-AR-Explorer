import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cosmic_mythology_ar/features/sky/sky_screen.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/data/catalog/simple_star_catalog.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/observer/observer.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/time/observation_time.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/visibility/visibility_service.dart';

void main() {
  testWidgets('search overlay appears and finds Sirius', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: SkyScreen(
        observer: Observer(latitude: 0, longitude: 0),
        observationTime: ObservationTime(DateTime.utc(2026, 1, 1, 4, 0)),
        repository: SimpleStarCatalog(),
        visibilityService: const VisibilityService(),
      ),
    ));

    await tester.pumpAndSettle();

    // Tap the search button (icon search)
    final Finder searchButton = find.byIcon(Icons.search);
    expect(searchButton, findsOneWidget);
    await tester.tap(searchButton);
    await tester.pumpAndSettle();

    // Verify overlay's TextField appears
    expect(find.byType(TextField), findsOneWidget);

    // Enter query "Sirius"
    await tester.enterText(find.byType(TextField), 'Sirius');
    await tester.pumpAndSettle();

    // Result list should contain Sirius
    expect(find.widgetWithText(ListTile, 'Sirius'), findsOneWidget);

    // Tap the result
    await tester.tap(find.widgetWithText(ListTile, 'Sirius'));
    await tester.pumpAndSettle();

    // Overlay should be dismissed
    expect(find.byType(TextField), findsNothing);
  });
}
