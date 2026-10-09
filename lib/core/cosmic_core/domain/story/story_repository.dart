// lib/core/cosmic_core/domain/story/story_repository.dart



import 'story.dart';

/// Abstract repository defining contract for accessing story content.
abstract class StoryRepository {
  /// Retrieves all available stories.
  Future<List<Story>> getAllStories();

  /// Retrieves a specific story by its unique identifier.
  Future<Story?> getStoryById(String id);
}

/// Architectural alias matching the specification in `cosmic_core_architecture.md`.
typedef IStoryRepository = StoryRepository;
