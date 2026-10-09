import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/features/sky/sky_screen.dart';
import 'package:cosmic_mythology_ar/features/sky/virtual_sky.dart';

void main() {
  testWidgets('SkyScreen instantiates and renders VirtualSky', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SkyScreen(),
        ),
      ),
    );

    expect(find.byType(SkyScreen), findsOneWidget);
    expect(find.byType(VirtualSky), findsOneWidget);
  });
}
