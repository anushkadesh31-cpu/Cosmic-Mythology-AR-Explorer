// lib/core/cosmic_core/domain/story/story_chapter.dart

import '../cultural/localized_string.dart';

/// Represents a single chapter or section of a story.
class StoryChapter {
  /// Stable identifier for the chapter.
  final String id;

  /// Localized title of the chapter.
  final LocalizedString title;

  /// Localized textual content of the chapter.
  final LocalizedString content;

  StoryChapter({
    required this.id,
    required this.title,
    required this.content,
  })  : assert(id.isNotEmpty, 'id cannot be empty'),
        assert(title.defaultText.isNotEmpty, 'title cannot be empty'),
        assert(content.defaultText.isNotEmpty, 'content cannot be empty');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StoryChapter &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          content == other.content;

  @override
  int get hashCode => Object.hash(id, title, content);

  @override
  String toString() => 'StoryChapter(id: $id, title: ${title.defaultText})';
}
