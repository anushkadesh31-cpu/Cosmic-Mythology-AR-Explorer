import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/app.dart';

void main() {
  testWidgets('Cosmic Mythology AR Explorer smoke test', (WidgetTester tester) async {
    // Build the app and trigger a frame
    await tester.pumpWidget(const CosmicMythologyApp());

    // Verify that the brand and key navigation sections exist
    expect(find.text('Cosmic Mythology'), findsWidgets);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.text('SKY'), findsOneWidget);
    expect(find.text('Stories'), findsOneWidget);
    expect(find.text('Quests'), findsOneWidget);
  });
}
