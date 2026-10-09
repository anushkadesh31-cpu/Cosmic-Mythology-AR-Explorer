import 'package:flutter/material.dart';
import '../../core/theme/cosmic_colors.dart';
import '../../core/widgets/glass_card.dart';

/// Gamified celestial exploration quests & stargazer progression.
class QuestsScreen extends StatelessWidget {
  const QuestsScreen({super.key});

  final List<_QuestItem> _quests = const [
    _QuestItem(
      title: 'Trace Orion\'s Celestial Belt',
      description: 'Align the AR reticle on Alnitak, Alnilam, and Mintaka.',
      xpReward: 150,
      loreReward: 'Unlocks Egyptian "Sah" Lore',
      currentProgress: 2,
      totalProgress: 3,
      isCompleted: false,
    ),
    _QuestItem(
      title: 'Identify the Winter Triangle',
      description: 'Connect Betelgeuse, Sirius, and Procyon in the evening sky.',
      xpReward: 200,
      loreReward: 'Title: "Sky Watcher"',
      currentProgress: 3,
      totalProgress: 3,
      isCompleted: true,
    ),
    _QuestItem(
      title: 'Discover 3 Vedic Nakshatras',
      description: 'Observe Krittika (Pleiades), Rohini (Aldebaran), and Mriga (Orion).',
      xpReward: 300,
      loreReward: 'Vedic Lunar Calendar Art',
      currentProgress: 1,
      totalProgress: 3,
      isCompleted: false,
    ),
  ];

  final List<_BadgeItem> _badges = const [
    _BadgeItem(
      name: 'First Stargaze',
      icon: Icons.auto_awesome,
      unlocked: true,
      color: CosmicColors.starlightGold,
    ),
    _BadgeItem(
      name: 'Mythos Weaver',
      icon: Icons.menu_book_rounded,
      unlocked: true,
      color: CosmicColors.cosmicViolet,
    ),
    _BadgeItem(
      name: 'AR Wayfinder',
      icon: Icons.explore_rounded,
      unlocked: true,
      color: CosmicColors.etherealCyan,
    ),
    _BadgeItem(
      name: 'Solar Zenith',
      icon: Icons.wb_sunny_rounded,
      unlocked: false,
      color: CosmicColors.stardustSubtle,
    ),
  ];

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
            'Celestial Quests',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: CosmicColors.starWhite,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Track your stargazing progress, unlock celestial lore, and earn badges.',
            style: TextStyle(
              fontSize: 14,
              color: CosmicColors.celestialMuted,
            ),
          ),

          const SizedBox(height: 24),

          // Stargazer XP Progress Hero
          _buildProgressionHero(context),

          const SizedBox(height: 24),

          // Unlocked Badges Showcase
          _buildBadgesShowcase(context),

          const SizedBox(height: 24),

          // Active Quests
          const Text(
            'Active Stargazing Challenges',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: CosmicColors.starWhite,
            ),
          ),
          const SizedBox(height: 14),

          ..._quests.map((quest) => _buildQuestCard(quest)),
        ],
      ),
    );
  }

  Widget _buildProgressionHero(BuildContext context) {
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
            CosmicColors.twilightIndigo.withValues(alpha: 0.5),
          ],
        ),
        border: Border.all(
          color: CosmicColors.etherealCyan.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(
                    Icons.military_tech_rounded,
                    size: 20,
                    color: CosmicColors.starlightGold,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'STARGAZER RANK',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                      color: CosmicColors.starlightGold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: CosmicColors.glassSurfaceBright,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '680 / 1000 XP',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: CosmicColors.starWhite,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Level 4 • Adept Astronomer',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: CosmicColors.starWhite,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: const LinearProgressIndicator(
              value: 0.68,
              minHeight: 8,
              backgroundColor: CosmicColors.deepSpace,
              valueColor: AlwaysStoppedAnimation<Color>(CosmicColors.etherealCyan),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '320 XP remaining to unlock "Master of the Celestial Sphere"',
            style: TextStyle(
              fontSize: 12,
              color: CosmicColors.celestialMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesShowcase(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(18),
      borderRadius: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cosmic Badges',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: CosmicColors.starWhite,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _badges.map((badge) {
              return Column(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: badge.unlocked
                          ? badge.color.withValues(alpha: 0.2)
                          : CosmicColors.glassSurface,
                      border: Border.all(
                        color: badge.unlocked
                            ? badge.color.withValues(alpha: 0.6)
                            : CosmicColors.glassBorder,
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      badge.icon,
                      color: badge.unlocked ? badge.color : CosmicColors.stardustSubtle,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    badge.name,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: badge.unlocked
                          ? CosmicColors.starWhite
                          : CosmicColors.stardustSubtle,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestCard(_QuestItem quest) {
    final progressFraction = quest.currentProgress / quest.totalProgress;

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
              Expanded(
                child: Text(
                  quest.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: CosmicColors.starWhite,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: quest.isCompleted
                      ? CosmicColors.questGreen.withValues(alpha: 0.2)
                      : CosmicColors.starlightGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  quest.isCompleted ? 'COMPLETED' : '+${quest.xpReward} XP',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: quest.isCompleted
                        ? CosmicColors.questGreen
                        : CosmicColors.starlightGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            quest.description,
            style: const TextStyle(
              fontSize: 13,
              color: CosmicColors.celestialMuted,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progressFraction,
              minHeight: 6,
              backgroundColor: CosmicColors.deepSpace,
              valueColor: AlwaysStoppedAnimation<Color>(
                quest.isCompleted ? CosmicColors.questGreen : CosmicColors.cosmicViolet,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reward: ${quest.loreReward}',
                style: const TextStyle(
                  fontSize: 11,
                  color: CosmicColors.etherealCyan,
                ),
              ),
              Text(
                '${quest.currentProgress} / ${quest.totalProgress}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: CosmicColors.starWhite,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuestItem {
  final String title;
  final String description;
  final int xpReward;
  final String loreReward;
  final int currentProgress;
  final int totalProgress;
  final bool isCompleted;

  const _QuestItem({
    required this.title,
    required this.description,
    required this.xpReward,
    required this.loreReward,
    required this.currentProgress,
    required this.totalProgress,
    required this.isCompleted,
  });
}

class _BadgeItem {
  final String name;
  final IconData icon;
  final bool unlocked;
  final Color color;

  const _BadgeItem({
    required this.name,
    required this.icon,
    required this.unlocked,
    required this.color,
  });
}
