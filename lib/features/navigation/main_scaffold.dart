import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/cosmic_colors.dart';
import '../../core/widgets/celestial_background.dart';
import '../../core/widgets/side_navigation.dart';
import '../../core/responsive/responsive_utils.dart';
import '../home/home_screen.dart';
import '../explore/explore_screen.dart';
import '../sky/sky_screen.dart';
import '../stories/stories_screen.dart';
import '../quests/quests_screen.dart';
import '../profile/profile_screen.dart';
import '../settings/settings_screen.dart';
import '../../core/cosmic_core/domain/time/observation_time.dart';


/// Enum representing the 7 application sections.
enum CosmicSection {
  home,
  explore,
  sky,
  stories,
  quests,
  profile,
  settings,
}

/// Main application shell housing the modern cosmic bottom navigation bar
/// and header controls.
class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  CosmicSection _currentSection = CosmicSection.home;

  void _navigateTo(CosmicSection section) {
    if (_currentSection != section) {
      setState(() {
        _currentSection = section;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = getScreenSize(context);
    final showHorizon = _currentSection != CosmicSection.sky;

    if (screenSize == ResponsiveScreenSize.expanded) {
      return Scaffold(
        backgroundColor: CosmicColors.spaceBlack,
        extendBody: true,
        appBar: _buildTopBar(context),
        body: Row(
          children: [
            SideNavigation(
              currentSection: _currentSection,
              onNavigate: _navigateTo,
            ),
            Expanded(
              child: CelestialBackground(
                showHorizon: showHorizon,
                child: SafeArea(
                  bottom: false,
                  child: _buildCurrentView(),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        backgroundColor: CosmicColors.spaceBlack,
        extendBody: true,
        appBar: _buildTopBar(context),
        body: CelestialBackground(
          showHorizon: showHorizon,
          child: SafeArea(
            bottom: false,
            child: _buildCurrentView(),
          ),
        ),
        bottomNavigationBar: _buildModernBottomNav(context),
      );
    }
  }

  PreferredSizeWidget _buildTopBar(BuildContext context) {
    final title = switch (_currentSection) {
      CosmicSection.home => 'Cosmic Mythology',
      CosmicSection.explore => 'Explore Stars',
      CosmicSection.sky => 'Celestial AR Sky',
      CosmicSection.stories => 'Mythic Lore',
      CosmicSection.quests => 'Stargazer Quests',
      CosmicSection.profile => 'Observer Profile',
      CosmicSection.settings => 'Settings',
    };

    final isSky = _currentSection == CosmicSection.sky;

    return AppBar(
      titleSpacing: 20,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [CosmicColors.etherealCyan, CosmicColors.cosmicViolet],
              ),
              boxShadow: [
                BoxShadow(
                  color: CosmicColors.etherealCyan.withValues(alpha: 0.4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 16,
              color: CosmicColors.spaceBlack,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: CosmicColors.starWhite,
            ),
          ),
        ],
      ),
      actions: [
        // Profile Quick Button
        _buildHeaderIconButton(
          icon: Icons.person_outline_rounded,
          isSelected: _currentSection == CosmicSection.profile,
          tooltip: 'Profile',
          onTap: () => _navigateTo(CosmicSection.profile),
        ),
        const SizedBox(width: 4),

        // Settings Quick Button
        _buildHeaderIconButton(
          icon: Icons.tune_rounded,
          isSelected: _currentSection == CosmicSection.settings,
          tooltip: 'Settings',
          onTap: () => _navigateTo(CosmicSection.settings),
        ),
        const SizedBox(width: 16),
      ],
      backgroundColor: isSky
          ? CosmicColors.spaceBlack.withValues(alpha: 0.3)
          : Colors.transparent,
    );
  }

  Widget _buildHeaderIconButton({
    required IconData icon,
    required bool isSelected,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isSelected
                  ? CosmicColors.cosmicViolet.withValues(alpha: 0.35)
                  : CosmicColors.glassSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected
                    ? CosmicColors.etherealCyan.withValues(alpha: 0.8)
                    : CosmicColors.glassBorder,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isSelected
                  ? CosmicColors.etherealCyan
                  : CosmicColors.celestialMuted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    return switch (_currentSection) {
      CosmicSection.home => HomeScreen(
          onExploreSky: () => _navigateTo(CosmicSection.sky),
          onOpenStories: () => _navigateTo(CosmicSection.stories),
          onOpenQuests: () => _navigateTo(CosmicSection.quests),
        ),
      CosmicSection.explore => ExploreScreen(),
             CosmicSection.sky => SkyScreen(observationTime: ObservationTime(DateTime.utc(2026, 1, 1, 4, 0))),
      CosmicSection.stories => StoriesScreen(),
      CosmicSection.quests => QuestsScreen(),
      CosmicSection.profile => ProfileScreen(),
      CosmicSection.settings => SettingsScreen(),
    };
  }

  Widget _buildModernBottomNav(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: CosmicColors.deepSpace.withValues(alpha: 0.75),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: CosmicColors.glassBorder,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  section: CosmicSection.home,
                  icon: Icons.home_rounded,
                  label: 'Home',
                ),
                _buildNavItem(
                  section: CosmicSection.explore,
                  icon: Icons.travel_explore_rounded,
                  label: 'Explore',
                ),

                // Visually Emphasized Center SKY AR Button
                _buildEmphasizedSkyNav(),

                _buildNavItem(
                  section: CosmicSection.stories,
                  icon: Icons.auto_stories_rounded,
                  label: 'Stories',
                ),
                _buildNavItem(
                  section: CosmicSection.quests,
                  icon: Icons.military_tech_rounded,
                  label: 'Quests',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required CosmicSection section,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentSection == section;

    return GestureDetector(
      onTap: () => _navigateTo(section),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? CosmicColors.cosmicViolet.withValues(alpha: 0.25)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isSelected
                  ? CosmicColors.etherealCyan
                  : CosmicColors.celestialMuted,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? CosmicColors.etherealCyan
                    : CosmicColors.stardustSubtle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmphasizedSkyNav() {
    final isSelected = _currentSection == CosmicSection.sky;

    return GestureDetector(
      onTap: () => _navigateTo(CosmicSection.sky),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isSelected
                    ? [CosmicColors.etherealCyan, CosmicColors.cosmicViolet]
                    : [CosmicColors.cosmicViolet, CosmicColors.midnightViolet],
              ),
              border: Border.all(
                color: isSelected
                    ? CosmicColors.starWhite
                    : CosmicColors.etherealCyan.withValues(alpha: 0.6),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? CosmicColors.etherealCyan.withValues(alpha: 0.6)
                      : CosmicColors.cosmicViolet.withValues(alpha: 0.4),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              Icons.view_in_ar_rounded,
              color: isSelected ? CosmicColors.spaceBlack : CosmicColors.starWhite,
              size: 24,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'SKY',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
              color: isSelected
                  ? CosmicColors.etherealCyan
                  : CosmicColors.starWhite,
            ),
          ),
        ],
      ),
    );
  }
}
