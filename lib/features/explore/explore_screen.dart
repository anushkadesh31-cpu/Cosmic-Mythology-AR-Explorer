import 'package:flutter/material.dart';
import '../../core/theme/cosmic_colors.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/responsive/responsive_utils.dart';

/// Celestial discovery catalog with search and cultural filters.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCulture = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _cultures = [
    'All',
    'Greco-Roman',
    'Vedic Nakshatra',
    'Indigenous',
    'Norse',
    'East Asian',
  ];

  final List<_ConstellationItem> _constellations = const [
    _ConstellationItem(
      name: 'Orion (The Hunter)',
      mythology: 'Slain by the scorpion in Greek lore; depicted as Sah, father of gods, in Ancient Egypt.',
      culture: 'Greco-Roman / Egyptian',
      brightestStar: 'Rigel (Mag 0.12)',
      season: 'Winter Evening',
      starsCount: 7,
      accentColor: CosmicColors.etherealCyan,
    ),
    _ConstellationItem(
      name: 'Ursa Major (The Great Bear)',
      mythology: 'Callisto transformed by Hera in Greece; The Seven Sages (Saptarishi) in Vedic astronomy.',
      culture: 'Greco-Roman / Vedic',
      brightestStar: 'Alioth (Mag 1.76)',
      season: 'Circumpolar (Year-round)',
      starsCount: 7,
      accentColor: CosmicColors.starlightGold,
    ),
    _ConstellationItem(
      name: 'Krittika (The Pleiades)',
      mythology: 'The six foster mothers of Lord Kartikeya in Vedic tradition; The Seven Sisters in Greek lore.',
      culture: 'Vedic Nakshatra',
      brightestStar: 'Alcyone (Mag 2.87)',
      season: 'Autumn / Winter',
      starsCount: 6,
      accentColor: CosmicColors.cosmicViolet,
    ),
    _ConstellationItem(
      name: 'Cassiopeia (The Queen)',
      mythology: 'Boastful queen bound to her celestial throne; known as The Elk Horns in Sami tradition.',
      culture: 'Greco-Roman / Norse',
      brightestStar: 'Schedar (Mag 2.24)',
      season: 'Autumn',
      starsCount: 5,
      accentColor: CosmicColors.stellarCyan,
    ),
    _ConstellationItem(
      name: 'Scorpius (The Scorpion)',
      mythology: 'Maui\'s Fishhook in Polynesian navigation; the adversary of Orion across the celestial sphere.',
      culture: 'Indigenous',
      brightestStar: 'Antares (Mag 1.06)',
      season: 'Summer Evening',
      starsCount: 18,
      accentColor: CosmicColors.dangerRed,
    ),
    _ConstellationItem(
      name: 'Vega & Altair (The Sky River)',
      mythology: 'The Weaver Maiden (Zhinü) and the Cowherd (Niulang) separated by the Silver River (Milky Way).',
      culture: 'East Asian',
      brightestStar: 'Vega (Mag 0.03)',
      season: 'Summer / Autumn',
      starsCount: 2,
      accentColor: CosmicColors.etherealCyan,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _constellations.where((item) {
      final matchesCulture =
          _selectedCulture == 'All' || item.culture.contains(_selectedCulture);
      final query = _searchController.text.toLowerCase().trim();
      final matchesQuery = query.isEmpty ||
          item.name.toLowerCase().contains(query) ||
          item.mythology.toLowerCase().contains(query) ||
          item.culture.toLowerCase().contains(query);
      return matchesCulture && matchesQuery;
    }).toList();

    final screenSize = getScreenSize(context);
    EdgeInsets padding = EdgeInsets.zero;
    final scrollContent = SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Text(
            'Explore Celestial Lore',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: CosmicColors.starWhite,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Search constellations, ancient asterisms, and living cultural sky maps.',
            style: TextStyle(
              fontSize: 14,
              color: CosmicColors.celestialMuted,
            ),
          ),

          const SizedBox(height: 20),

          // Search Bar
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            borderRadius: 18,
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: CosmicColors.celestialMuted,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    style: const TextStyle(
                      color: CosmicColors.starWhite,
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Search stars, constellations, myths...',
                      hintStyle: TextStyle(
                        color: CosmicColors.stardustSubtle,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.close_rounded,
                      color: CosmicColors.celestialMuted,
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Cultural Filter Pills
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: _cultures.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final culture = _cultures[index];
                final isSelected = culture == _selectedCulture;
                return ChoiceChip(
                  label: Text(culture),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCulture = culture;
                      });
                    }
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Constellations List
          if (filtered.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'No constellations match your search criteria.',
                  style: TextStyle(color: CosmicColors.celestialMuted),
                ),
              ),
            )
          else
            ...filtered.map((item) => _buildConstellationCard(item)),
        ],
      ),
    );

    switch (screenSize) {
      case ResponsiveScreenSize.compact:
        return scrollContent;
      case ResponsiveScreenSize.medium:
        padding = const EdgeInsets.fromLTRB(32, 16, 32, 120);
        return Padding(padding: padding, child: scrollContent);
      case ResponsiveScreenSize.expanded:
        padding = const EdgeInsets.symmetric(horizontal: 48, vertical: 16);
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(padding: padding, child: scrollContent),
          ),
        );
    }
  }

  Widget _buildConstellationCard(_ConstellationItem item) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: 16),
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
                  item.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: CosmicColors.starWhite,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: item.accentColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: item.accentColor.withValues(alpha: 0.4),
                    width: 0.8,
                  ),
                ),
                child: Text(
                  item.culture,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: item.accentColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            item.mythology,
            style: const TextStyle(
              fontSize: 13,
              color: CosmicColors.celestialMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 14,
                color: CosmicColors.starlightGold,
              ),
              const SizedBox(width: 6),
              Text(
                item.brightestStar,
                style: const TextStyle(
                  fontSize: 12,
                  color: CosmicColors.starWhite,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.calendar_month_outlined,
                size: 14,
                color: CosmicColors.stardustSubtle,
              ),
              const SizedBox(width: 4),
              Text(
                item.season,
                style: const TextStyle(
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
}

class _ConstellationItem {
  final String name;
  final String mythology;
  final String culture;
  final String brightestStar;
  final String season;
  final int starsCount;
  final Color accentColor;

  const _ConstellationItem({
    required this.name,
    required this.mythology,
    required this.culture,
    required this.brightestStar,
    required this.season,
    required this.starsCount,
    required this.accentColor,
  });
}
