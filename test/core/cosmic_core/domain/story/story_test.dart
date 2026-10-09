// test/core/cosmic_core/domain/story/story_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/story/story_chapter.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/story/story.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/cultural/localized_string.dart';

import 'package:cosmic_mythology_ar/core/cosmic_core/data/story/simple_story_catalog.dart';

void main() {
  group('StoryChapter', () {
    test('equality and hashCode', () {
      const title = LocalizedString(defaultText: 'Chapter Title', translations: {});
      const content = LocalizedString(defaultText: 'Chapter content.', translations: {});
      final chapterA = StoryChapter(id: 'ch1', title: title, content: content);
      final chapterB = StoryChapter(id: 'ch1', title: title, content: content);
      expect(chapterA, equals(chapterB));
      expect(chapterA.hashCode, equals(chapterB.hashCode));
    });
  });

  group('Story', () {
    test('equality includes ordered chapters', () {
      const title = LocalizedString(defaultText: 'Myth Title', translations: {});
      const summary = LocalizedString(defaultText: 'A short summary.', translations: {});
      final chapter1 = StoryChapter(id: 'c1', title: title, content: title);
      final chapter2 = StoryChapter(id: 'c2', title: title, content: title);
      final storyA = Story(
        id: 's1',
        traditionId: 'greco_roman',
        title: title,
        summary: summary,
        chapters: [chapter1, chapter2],
      );
      final storyB = Story(
        id: 's1',
        traditionId: 'greco_roman',
        title: title,
        summary: summary,
        chapters: [chapter1, chapter2],
      );
      expect(storyA, equals(storyB));
      expect(storyA.hashCode, equals(storyB.hashCode));
    });
  });

  group('SimpleStoryCatalog', () {
    test('default catalog returns deterministic story', () async {
      final catalog = SimpleStoryCatalog();
      final all = await catalog.getAllStories();
      expect(all, hasLength(1));
      final story = all.first;
      // Verify fields are non‑empty and consistent
      expect(story.id, isNotEmpty);
      expect(story.traditionId, isNotEmpty);
      expect(story.title.defaultText, isNotEmpty);
      expect(story.summary.defaultText, isNotEmpty);
      // Retrieval by same id returns identical object
      final fetched = await catalog.getStoryById(story.id);
      expect(fetched, equals(story));
    });

    test('unknown id returns null', () async {
      final catalog = SimpleStoryCatalog();
      final result = await catalog.getStoryById('nonexistent-id');
      expect(result, isNull);
    });

    test('empty catalog returns empty list and null', () async {
      final catalog = SimpleStoryCatalog.empty();
      final all = await catalog.getAllStories();
      expect(all, isEmpty);
      final story = await catalog.getStoryById('any');
      expect(story, isNull);
    });

    test('returned list is unmodifiable', () async {
      final catalog = SimpleStoryCatalog();
      final all = await catalog.getAllStories();
      expect(() => all.add(all.first), throwsA(isA<UnsupportedError>()));
    });
  });
}
