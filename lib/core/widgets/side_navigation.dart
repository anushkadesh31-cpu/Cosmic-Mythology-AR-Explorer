// lib/core/widgets/side_navigation.dart

import 'package:flutter/material.dart';
import '../../features/navigation/main_scaffold.dart';


/// Simple side navigation rail used on expanded (desktop/web) screens.
/// Mirrors the same 7 destinations defined in [CosmicSection].
class SideNavigation extends StatelessWidget {
  final CosmicSection currentSection;
  final ValueChanged<CosmicSection> onNavigate;

  const SideNavigation({
    super.key,
    required this.currentSection,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: CosmicSection.values.indexOf(currentSection),
      onDestinationSelected: (index) => onNavigate(CosmicSection.values[index]),
      labelType: NavigationRailLabelType.all,
      backgroundColor: Colors.transparent,
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home_rounded),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.travel_explore_rounded),
          label: Text('Explore'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.view_in_ar_rounded),
          label: Text('Sky'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.auto_stories_rounded),
          label: Text('Stories'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.military_tech_rounded),
          label: Text('Quests'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.person_outline_rounded),
          label: Text('Profile'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.tune_rounded),
          label: Text('Settings'),
        ),
      ],
    );
  }
}
