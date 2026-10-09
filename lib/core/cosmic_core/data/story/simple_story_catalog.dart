// lib/core/cosmic_core/data/story/simple_story_catalog.dart

import '../../domain/story/story.dart';
import '../../domain/story/story_repository.dart';
import '../../domain/celestial/id_generator.dart';
import '../../domain/cultural/localized_string.dart';
import '../../domain/cultural/attribution.dart';
import '../../domain/cultural/research_verification.dart';
import '../../domain/story/story_chapter.dart';

/// In-memory implementation of [StoryRepository] providing deterministic story data.
class SimpleStoryCatalog implements StoryRepository {
  final List<Story> _stories;

  /// Creates a catalog with optional custom story list.
  /// If [stories] is omitted, a minimal default story set is provided.
  SimpleStoryCatalog({List<Story>? stories}) : _stories = stories ?? _buildDefaultStories();

  /// Factory for an empty catalog (no stories).
  factory SimpleStoryCatalog.empty() => SimpleStoryCatalog(stories: const []);

  static List<Story> _buildDefaultStories() {
    // Deterministic IDs using StableIdGenerator.
    final storyId = StableIdGenerator.generate('sample_story');
    final chapterId = StableIdGenerator.generate('sample_chapter');

    final chapter = StoryChapter(
      id: chapterId,
      title: const LocalizedString(
        defaultText: 'Prologue',
        translations: {},
      ),
      content: const LocalizedString(
        defaultText: 'In the beginning, the stars gazed upon the earth.',
        translations: {},
      ),
    );

    final story = Story(
      id: storyId,
      traditionId: 'greco_roman',
      title: const LocalizedString(
        defaultText: 'The Dawn of Orion',
        translations: {},
      ),
      summary: const LocalizedString(
        defaultText: 'A mythic tale of the hunter placed among the heavens.',
        translations: {},
      ),
      chapters: [chapter],
      attribution: const Attribution(
        authorOrInstitution: 'Ptolemy',
        publicationTitle: "Almagest",
        publicationYear: 150,
        doiOrIsbn: '',
        archiveUrl: '',
        citationSnippet: 'Almagest Book VII, chapter 5',
      ),
      verificationStatus: ResearchVerification(
        status: VerificationStatus.primarySourceVerified,
        reviewerNotes: 'Verified in Almagest Book VII, chapter 5.',
        lastVerifiedDate: DateTime.utc(2026, 1, 1),
      ),
    );
    return [story];
  }

  @override
  Future<List<Story>> getAllStories() async => List<Story>.unmodifiable(_stories);

  @override
  Future<Story?> getStoryById(String id) async {
    try {
      return _stories.firstWhere((s) => s.id == id);
    } catch (e) {
      return null;
    }
  }
}

// Architectural alias matching the specification.
typedef IStoryCatalog = SimpleStoryCatalog;
