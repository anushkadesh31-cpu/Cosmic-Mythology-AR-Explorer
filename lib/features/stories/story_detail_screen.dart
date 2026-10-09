// lib/features/stories/story_detail_screen.dart

import 'package:flutter/material.dart';
import '../../core/theme/cosmic_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/cosmic_core/domain/story/story.dart';
import '../../core/cosmic_core/domain/story/story_chapter.dart';
import '../../core/cosmic_core/domain/cultural/attribution.dart';
import '../../core/cosmic_core/domain/cultural/research_verification.dart';

/// Screen that displays a single [Story] with its chapters.
class StoryDetailScreen extends StatelessWidget {
  const StoryDetailScreen({super.key, required this.story});

  final Story story;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(story.title.defaultText),
        backgroundColor: CosmicColors.midnightViolet,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary
            Text(
              story.summary.defaultText,
              style: const TextStyle(
                fontSize: 16,
                color: CosmicColors.celestialMuted,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            // Attribution (if present)
            if (story.attribution != null) _buildAttribution(story.attribution!),
            if (story.verificationStatus != null)
              _buildVerification(story.verificationStatus!),
            const SizedBox(height: 24),
            // Chapters
            ...story.chapters.map(_buildChapterCard),
          ],
        ),
      ),
    );
  }

  Widget _buildAttribution(Attribution attr) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      borderRadius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Source Attribution', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('Author/Institution: ${attr.authorOrInstitution}'),
          Text('Publication: ${attr.publicationTitle} (${attr.publicationYear})'),
          if (attr.doiOrIsbn != null && attr.doiOrIsbn!.isNotEmpty) Text('DOI/ISBN: ${attr.doiOrIsbn}'),
          if (attr.archiveUrl != null && attr.archiveUrl!.isNotEmpty) Text('Archive: ${attr.archiveUrl}'),
          if (attr.citationSnippet.isNotEmpty) Text('Citation: ${attr.citationSnippet}'),
        ],
      ),
    );
  }

  Widget _buildVerification(ResearchVerification verification) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      borderRadius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Research Verification', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('Status: ${verification.status.name}'),
          if (verification.reviewerNotes.isNotEmpty) Text('Notes: ${verification.reviewerNotes}'),
          Text('Last verified: ${verification.lastVerifiedDate.toUtc().toIso8601String().split('T').first}'),
        ],
      ),
    );
  }

  Widget _buildChapterCard(StoryChapter chapter) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chapter.title.defaultText,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: CosmicColors.starWhite),
          ),
          const SizedBox(height: 8),
          Text(
            chapter.content.defaultText,
            style: const TextStyle(fontSize: 14, color: CosmicColors.celestialMuted, height: 1.4),
          ),
        ],
      ),
    );
  }
}
