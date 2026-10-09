// test/features/stories/stories_screen_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:cosmic_mythology_ar/features/stories/stories_screen.dart';
import 'package:cosmic_mythology_ar/features/stories/story_detail_screen.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/story/story.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/story/story_chapter.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/cultural/localized_string.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/story/story_repository.dart';

// Simple deterministic data for tests
Story _makeStory({required String id, required String title, required String summary, List<StoryChapter>? chapters}) {
  return Story(
    id: id,
    traditionId: 'tradition_$id',
    title: LocalizedString(defaultText: title),
    summary: LocalizedString(defaultText: summary),
    chapters: chapters ?? [
      StoryChapter(
        id: 'c1',
        title: LocalizedString(defaultText: 'Chapter 1'),
        content: LocalizedString(defaultText: 'Content 1'),
      ),
      StoryChapter(
        id: 'c2',
        title: LocalizedString(defaultText: 'Chapter 2'),
        content: LocalizedString(defaultText: 'Content 2'),
      ),
    ],
  );
}

class _FakeRepository implements StoryRepository {
  final List<Story> _stories;
  final bool _shouldThrow;
  final Duration? delay;

  _FakeRepository({required this._stories, this._shouldThrow = false, this.delay});
  @override
  Future<List<Story>> getAllStories() async {
    if (delay != null) await Future.delayed(delay!);
    if (_shouldThrow) throw Exception('Repository failure');
    return _stories;
  }

  @override
  Future<Story?> getStoryById(String id) async {
    if (delay != null) await Future.delayed(delay!);
    if (_shouldThrow) throw Exception('Repository failure');
    for (final s in _stories) {
      if (s.id == id) return s;
    }
    return null;
  }
}

void main() {
  group('StoriesScreen widget tests', () {
    testWidgets('displays stories from repository', (WidgetTester tester) async {
      final repo = _FakeRepository(stories: [
        _makeStory(id: 's1', title: 'Story One', summary: 'First story'),
        _makeStory(id: 's2', title: 'Story Two', summary: 'Second story'),
      ]);

      await tester.pumpWidget(MaterialApp(home: StoriesScreen(repository: repo)));
      // Wait for FutureBuilder
      await tester.pumpAndSettle();

      expect(find.text('Story One'), findsOneWidget);
      expect(find.text('Story Two'), findsOneWidget);
    });

    testWidgets('tapping a story opens detail screen', (WidgetTester tester) async {
      final story = _makeStory(id: 's1', title: 'Epic Tale', summary: 'An epic story');
      final repo = _FakeRepository(stories: [story]);

      await tester.pumpWidget(MaterialApp(home: StoriesScreen(repository: repo)));
      await tester.pumpAndSettle();

      // Tap the story card (the first GestureDetector child)
      await tester.tap(find.text('Epic Tale'));
      await tester.pumpAndSettle();

      // Detail screen should show the title
      expect(find.text('Epic Tale'), findsOneWidget);
      expect(find.text('An epic story'), findsOneWidget);
    });

    testWidgets('detail screen shows ordered chapters', (WidgetTester tester) async {
      final story = _makeStory(
        id: 's1',
        title: 'Chronicles',
        summary: 'A multi‑chapter story',
        chapters: [
          StoryChapter(
            id: 'c1',
            title: LocalizedString(defaultText: 'Alpha'),
            content: LocalizedString(defaultText: 'First'),
          ),
          StoryChapter(
            id: 'c2',
            title: LocalizedString(defaultText: 'Beta'),
            content: LocalizedString(defaultText: 'Second'),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp(home: StoryDetailScreen(story: story)));
      await tester.pumpAndSettle();

      // Verify chapter titles appear in order
      final alphaFinder = find.text('Alpha');
      final betaFinder = find.text('Beta');
      expect(alphaFinder, findsOneWidget);
      expect(betaFinder, findsOneWidget);
      // Ensure order by checking widget tree positions
      final alphaIndex = tester.getTopLeft(alphaFinder).dy;
      final betaIndex = tester.getTopLeft(betaFinder).dy;
      expect(alphaIndex, lessThan(betaIndex));
    });

    testWidgets('empty catalog shows empty state', (WidgetTester tester) async {
      final repo = _FakeRepository(stories: []);
      await tester.pumpWidget(MaterialApp(home: StoriesScreen(repository: repo)));
      await tester.pumpAndSettle();

      expect(find.text('No stories available'), findsOneWidget);
    });

    testWidgets('repository error shows error state', (WidgetTester tester) async {
      final repo = _FakeRepository(stories: [], shouldThrow: true);
      await tester.pumpWidget(MaterialApp(home: StoriesScreen(repository: repo)));
      await tester.pumpAndSettle();

      expect(find.text('Failed to load stories'), findsOneWidget);
    });

    testWidgets('loading indicator appears while fetching', (WidgetTester tester) async {
      final repo = _FakeRepository(stories: [_makeStory(id: 's1', title: 'Loading Test', summary: '...')], delay: const Duration(milliseconds: 200));
      await tester.pumpWidget(MaterialApp(home: StoriesScreen(repository: repo)));
      // At this point the Future is not resolved yet
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      // Let the future complete
      await tester.pumpAndSettle();
      expect(find.text('Loading Test'), findsOneWidget);
    });
  });
}
