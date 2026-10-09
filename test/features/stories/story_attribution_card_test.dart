// test/features/stories/story_attribution_card_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/data/story/simple_story_catalog.dart';
import 'package:cosmic_mythology_ar/features/stories/story_detail_screen.dart';

void main() {
  testWidgets('Attribution card hides DOI/ISBN and Archive when null', (WidgetTester tester) async {
    // Get default story (has null DOI/ISBN and archiveUrl)
    final catalog = SimpleStoryCatalog();
    final story = (await catalog.getAllStories()).first;

    await tester.pumpWidget(
      MaterialApp(
        home: StoryDetailScreen(story: story),
      ),
    );
    await tester.pumpAndSettle();

    // Verify attribution card title appears
    expect(find.text('Source Attribution'), findsOneWidget);
    // Ensure no lines for DOI/ISBN or Archive are rendered
    expect(find.textContaining('DOI/ISBN:'), findsNothing);
    expect(find.textContaining('Archive:'), findsNothing);
  });
}
