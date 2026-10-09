// lib/core/cosmic_core/domain/story/story.dart

import '../cultural/attribution.dart';
import '../cultural/localized_string.dart';
import '../cultural/research_verification.dart';
import 'story_chapter.dart';
/// Immutable domain model representing a cultural story linked to a tradition.
class Story {
  /// Stable identifier for the story.
  final String id;

  /// Identifier of the associated cultural tradition.
  final String traditionId;

  /// Localized title of the story.
  final LocalizedString title;

  /// Localized summary or description of the story.
  final LocalizedString summary;

  /// Ordered list of chapters that compose the story.
  final List<StoryChapter> chapters;

  /// Optional scholarly attribution for the story source.
  final Attribution? attribution;

  /// Optional verification metadata (e.g., primary source verified).
  final ResearchVerification? verificationStatus;

  Story({
    required this.id,
    required this.traditionId,
    required this.title,
    required this.summary,
    required this.chapters,
    this.attribution,
    this.verificationStatus,
  })  : assert(id.isNotEmpty, 'id cannot be empty'),
        assert(traditionId.isNotEmpty, 'traditionId cannot be empty'),
        assert(chapters.isNotEmpty, 'Story must contain at least one chapter');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Story &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          traditionId == other.traditionId &&
          title == other.title &&
          summary == other.summary &&
          _listEquals(chapters, other.chapters) &&
          attribution == other.attribution &&
          verificationStatus == other.verificationStatus;

  @override
  int get hashCode => Object.hash(
        id,
        traditionId,
        title,
        summary,
        Object.hashAll(chapters),
        attribution,
        verificationStatus,
      );

  @override
  String toString() =>
      'Story(id: $id, traditionId: $traditionId, title: ${title.defaultText})';
  static bool _listEquals(List<StoryChapter> a, List<StoryChapter> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

}
