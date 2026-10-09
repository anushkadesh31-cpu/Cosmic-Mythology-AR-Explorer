import 'package:flutter/material.dart';
import '../../core/theme/cosmic_colors.dart';
import '../../core/responsive/responsive_utils.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/cosmic_core/domain/story/story.dart';
import '../../core/cosmic_core/data/story/simple_story_catalog.dart';
import '../../core/cosmic_core/domain/story/story_repository.dart';
import 'story_detail_screen.dart';

/// Cultural Celestial Storytelling Library.
class StoriesScreen extends StatelessWidget {
  StoriesScreen({super.key, StoryRepository? repository})
      : _repository = repository ?? SimpleStoryCatalog();

  // Repository providing story data.
  final StoryRepository _repository;

      @override
Widget build(BuildContext context) {
  final screenSize = getScreenSize(context);
  EdgeInsets padding = EdgeInsets.zero;
  final bodyContent = SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
// Duplicate block removed - retained outer definitions
          // Section Header
          const Text(
            'Celestial Storytelling',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: CosmicColors.starWhite,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Mythologies, oral traditions, and cultural heritage written across the constellations.',
            style: TextStyle(
              fontSize: 14,
              color: CosmicColors.celestialMuted,
            ),
          ),

          const SizedBox(height: 24),

          // Featured Story Hero Banner
          _buildFeaturedStoryBanner(context),

          const SizedBox(height: 24),

          // Story Catalog List loaded asynchronously
          FutureBuilder<List<Story>>(
            future: _repository.getAllStories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Failed to load stories'));
              }
              final stories = snapshot.data ?? const [];
              if (stories.isEmpty) {
                return const Center(child: Text('No stories available'));
              }
              return Column(
                children: stories
                    .map((story) => GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      StoryDetailScreen(story: story))),
                          child: _buildStoryCardFromStory(story),
                        ))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );

    switch (screenSize) {
      case ResponsiveScreenSize.compact:
        return bodyContent;
      case ResponsiveScreenSize.medium:
        padding = const EdgeInsets.fromLTRB(32, 16, 32, 120);
        return Padding(padding: padding, child: bodyContent);
      case ResponsiveScreenSize.expanded:
        padding = const EdgeInsets.symmetric(horizontal: 48, vertical: 16);
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(padding: padding, child: bodyContent),
          ),
        );
    }
}

  Widget _buildFeaturedStoryBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CosmicColors.cosmicViolet.withValues(alpha: 0.35),
            CosmicColors.midnightViolet.withValues(alpha: 0.6),
            CosmicColors.twilightIndigo.withValues(alpha: 0.4),
          ],
        ),
        border: Border.all(
          color: CosmicColors.cosmicViolet.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_stories_rounded,
                size: 14,
                color: CosmicColors.starlightGold,
              ),
              const SizedBox(width: 6),
              Text(
                'FEATURED CULTURAL MYTH',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: CosmicColors.starlightGold.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'The Celestial Serpent & The Cosmic Tree',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: CosmicColors.starWhite,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Comparative cosmologies connecting Mayan skies, Nordic Yggdrasil, and the Aboriginal Milky Way Dreamtime.',
            style: TextStyle(
              fontSize: 13,
              color: CosmicColors.celestialMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          const Row(
            children: [
              Icon(
                Icons.headphones_rounded,
                size: 15,
                color: CosmicColors.etherealCyan,
              ),
              SizedBox(width: 6),
              Text(
                'Includes Immersive Audio Lore',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: CosmicColors.etherealCyan,
                ),
              ),
              Spacer(),
              Text(
                '8 min listen',
                style: TextStyle(
                  fontSize: 12,
                  color: CosmicColors.stardustSubtle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCardFromStory(Story story) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: CosmicColors.cosmicViolet.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: CosmicColors.cosmicViolet.withValues(alpha: 0.35),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  story.traditionId,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: CosmicColors.cosmicViolet,
                  ),
                ),
              ),
              const SizedBox(), // placeholder for read time/audio indicator
            ],
          ),
          const SizedBox(height: 10),
          Text(
            story.title.defaultText,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: CosmicColors.starWhite,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            story.summary.defaultText,
            style: const TextStyle(
              fontSize: 13,
              color: CosmicColors.celestialMuted,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// Removed the previous hard‑coded _StoryItem model; data now comes from the domain Story model.
