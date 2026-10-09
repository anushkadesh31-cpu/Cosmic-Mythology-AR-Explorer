import 'package:flutter/material.dart';
import '../../core/theme/cosmic_colors.dart';
import '../../core/responsive/responsive_utils.dart';
import '../../core/widgets/glass_card.dart';

/// Cultural Celestial Storytelling Library.
class StoriesScreen extends StatelessWidget {
  StoriesScreen({super.key});

  final List<_StoryItem> _stories = [
    _StoryItem(
      title: 'The Seven Mothers of Kartikeya',
      culture: 'Vedic Astronomy',
      tradition: 'Nakshatra Krittika',
      readTime: '4 min read',
      hasAudio: true,
      summary:
          'How the cluster of Krittika (the Pleiades) nurtured the warrior deity of wisdom and light, protecting the cosmic balance.',
      tagColor: CosmicColors.cosmicViolet,
    ),
    _StoryItem(
      title: 'The Silver River of Star-Crossed Lovers',
      culture: 'East Asian Mythos',
      tradition: 'Qixi / Tanabata',
      readTime: '6 min read',
      hasAudio: true,
      summary:
          'Zhinü the Weaver Star and Niulang the Cowherd separated by the celestial Milky Way, united once a year by a bridge of magpies.',
      tagColor: CosmicColors.etherealCyan,
    ),
    _StoryItem(
      title: 'The Great Bear and the Celestial Hunters',
      culture: 'Indigenous Americas',
      tradition: 'Haudenosaunee / Iroquois',
      readTime: '5 min read',
      hasAudio: false,
      summary:
          'Three hunters track the immortal Great Bear across the northern sky; in autumn, its blood turns the forest leaves scarlet.',
      tagColor: CosmicColors.starlightGold,
    ),
    _StoryItem(
      title: 'Maui\'s Magic Fishhook',
      culture: 'Polynesian Navigators',
      tradition: 'Wayfinding Celestial Lore',
      readTime: '5 min read',
      hasAudio: true,
      summary:
          'How demigod Maui pulled the Pacific islands from the oceanic depths using the celestial hook immortalized as Scorpius.',
      tagColor: CosmicColors.stellarCyan,
    ),
    _StoryItem(
      title: 'The Charioteer and the Solar Steeds',
      culture: 'Greco-Roman',
      tradition: 'Hellenic Astromythology',
      readTime: '7 min read',
      hasAudio: false,
      summary:
          'Phaethon\'s fateful flight in Apollo\'s celestial chariot, scorching the heavens and creating the desert wastes of the Earth.',
      tagColor: CosmicColors.supernovaAmber,
    ),
  ];

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

          // Story Catalog List
          ..._stories.map((story) => _buildStoryCard(story)),
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

  Widget _buildStoryCard(_StoryItem story) {
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
                  color: story.tagColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: story.tagColor.withValues(alpha: 0.35),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  story.culture,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: story.tagColor,
                  ),
                ),
              ),
              Row(
                children: [
                  if (story.hasAudio) ...[
                    const Icon(
                      Icons.headphones_rounded,
                      size: 14,
                      color: CosmicColors.celestialMuted,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    story.readTime,
                    style: const TextStyle(
                      fontSize: 12,
                      color: CosmicColors.stardustSubtle,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            story.title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: CosmicColors.starWhite,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            story.tradition,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: CosmicColors.etherealCyan,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            story.summary,
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

class _StoryItem {
  final String title;
  final String culture;
  final String tradition;
  final String readTime;
  final bool hasAudio;
  final String summary;
  final Color tagColor;

  const _StoryItem({
    required this.title,
    required this.culture,
    required this.tradition,
    required this.readTime,
    required this.hasAudio,
    required this.summary,
    required this.tagColor,
  });
}
