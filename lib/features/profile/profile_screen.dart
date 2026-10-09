import 'package:flutter/material.dart';
import '../../core/theme/cosmic_colors.dart';
import '../../core/widgets/glass_card.dart';

/// Stargazer Profile & Observation Journal.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Text(
            'Stargazer Profile',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: CosmicColors.starWhite,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Personal celestial journey, cultural interests, and observation history.',
            style: TextStyle(
              fontSize: 14,
              color: CosmicColors.celestialMuted,
            ),
          ),

          const SizedBox(height: 24),

          // User Avatar & Identity Card
          _buildIdentityCard(context),

          const SizedBox(height: 20),

          // Stargazing Statistics Grid
          _buildStatsGrid(context),

          const SizedBox(height: 24),

          // Cultural Heritage Affiliations
          _buildCulturalInterests(context),

          const SizedBox(height: 24),

          // Recent Celestial Observations
          _buildRecentObservations(context),
        ],
      ),
    );
  }

  Widget _buildIdentityCard(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      borderRadius: 22,
      borderColor: CosmicColors.glassBorderGlow,
      child: Row(
        children: [
          // Celestial Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [CosmicColors.etherealCyan, CosmicColors.cosmicViolet],
              ),
              boxShadow: [
                BoxShadow(
                  color: CosmicColors.etherealCyan.withValues(alpha: 0.3),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: CosmicColors.spaceBlack,
              size: 32,
            ),
          ),
          const SizedBox(width: 18),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aria Thorne',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: CosmicColors.starWhite,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Celestial Lorekeeper • Level 4',
                  style: TextStyle(
                    fontSize: 13,
                    color: CosmicColors.etherealCyan,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Observer coordinates: 37.77° N, 122.41° W',
                  style: TextStyle(
                    fontSize: 11,
                    color: CosmicColors.stardustSubtle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem('18', 'Constellations', Icons.timeline_rounded),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem('14', 'Myths Read', Icons.auto_stories_rounded),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatItem('6', 'Quests Done', Icons.military_tech_rounded),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      borderRadius: 18,
      child: Column(
        children: [
          Icon(icon, size: 20, color: CosmicColors.etherealCyan),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: CosmicColors.starWhite,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: CosmicColors.stardustSubtle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCulturalInterests(BuildContext context) {
    final cultures = [
      'Vedic Astronomy',
      'Polynesian Wayfinding',
      'Greco-Roman Lore',
      'Indigenous Star Stories',
      'Maya Calendar',
    ];

    return GlassCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cultural Heritage Interests',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: CosmicColors.starWhite,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: cultures.map((culture) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: CosmicColors.cosmicViolet.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: CosmicColors.cosmicViolet.withValues(alpha: 0.35),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  culture,
                  style: const TextStyle(
                    fontSize: 12,
                    color: CosmicColors.starWhite,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentObservations(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent AR Observations',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: CosmicColors.starWhite,
            ),
          ),
          const SizedBox(height: 12),
          _buildObservationRow('Betelgeuse & Orion Belt', 'Locked on target', 'Tonight'),
          const Divider(color: CosmicColors.glassBorder, height: 18),
          _buildObservationRow('Krittika / Pleiades', 'Vedic story listened', 'Yesterday'),
          const Divider(color: CosmicColors.glassBorder, height: 18),
          _buildObservationRow('Ursa Major (Saptarishi)', 'Horizon tracking', '3 days ago'),
        ],
      ),
    );
  }

  Widget _buildObservationRow(String title, String subtitle, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: CosmicColors.starWhite,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: CosmicColors.celestialMuted,
              ),
            ),
          ],
        ),
        Text(
          time,
          style: const TextStyle(
            fontSize: 11,
            color: CosmicColors.stardustSubtle,
          ),
        ),
      ],
    );
  }
}
