import 'package:flutter/material.dart';
import '../../core/theme/cosmic_colors.dart';
import '../../core/widgets/glass_card.dart';

/// Settings and preferences screen for AR viewport, audio, and celestial display.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _ambientMusic = true;
  bool _audioNarration = true;
  bool _hapticFeedback = true;
  bool _showDeepSky = true;
  bool _redNightVision = false;
  double _starMagnitudeLimit = 5.5;

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
            'Settings & Calibration',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: CosmicColors.starWhite,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Configure your AR viewport, celestial audio, and sky display parameters.',
            style: TextStyle(
              fontSize: 14,
              color: CosmicColors.celestialMuted,
            ),
          ),

          const SizedBox(height: 24),

          // AR & Sky Display
          _buildSectionHeader('AR VIEWPORT & DISPLAY'),
          const SizedBox(height: 10),
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            borderRadius: 20,
            child: Column(
              children: [
                _buildSwitchTile(
                  title: 'Deep Sky Objects (Nebulae & Galaxies)',
                  subtitle: 'Render Messier and NGC deep celestial objects',
                  value: _showDeepSky,
                  onChanged: (val) => setState(() => _showDeepSky = val),
                ),
                const Divider(color: CosmicColors.glassBorder, height: 1),
                _buildSwitchTile(
                  title: 'Astronomer Red Mode',
                  subtitle: 'Preserves dark adaptation under true night skies',
                  value: _redNightVision,
                  onChanged: (val) => setState(() => _redNightVision = val),
                  activeColor: CosmicColors.dangerRed,
                ),
                const Divider(color: CosmicColors.glassBorder, height: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Star Magnitude Limit',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: CosmicColors.starWhite,
                            ),
                          ),
                          Text(
                            'Mag ${_starMagnitudeLimit.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: CosmicColors.etherealCyan,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: CosmicColors.etherealCyan,
                          inactiveTrackColor: CosmicColors.twilightIndigo,
                          thumbColor: CosmicColors.etherealCyan,
                        ),
                        child: Slider(
                          value: _starMagnitudeLimit,
                          min: 1.0,
                          max: 6.5,
                          divisions: 11,
                          onChanged: (val) => setState(() => _starMagnitudeLimit = val),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Audio & Haptics
          _buildSectionHeader('ATMOSPHERE & AUDIO'),
          const SizedBox(height: 10),
          GlassCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            borderRadius: 20,
            child: Column(
              children: [
                _buildSwitchTile(
                  title: 'Cosmic Ambient Soundscapes',
                  subtitle: 'Generative atmospheric music inspired by deep space',
                  value: _ambientMusic,
                  onChanged: (val) => setState(() => _ambientMusic = val),
                ),
                const Divider(color: CosmicColors.glassBorder, height: 1),
                _buildSwitchTile(
                  title: 'Celestial Voiceover Narration',
                  subtitle: 'Oral storytelling for constellation mythologies',
                  value: _audioNarration,
                  onChanged: (val) => setState(() => _audioNarration = val),
                ),
                const Divider(color: CosmicColors.glassBorder, height: 1),
                _buildSwitchTile(
                  title: 'Haptic Feedback',
                  subtitle: 'Tactile pulse upon locking celestial targets',
                  value: _hapticFeedback,
                  onChanged: (val) => setState(() => _hapticFeedback = val),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // About & Architecture Roadmap
          _buildSectionHeader('ABOUT & ARCHITECTURE'),
          const SizedBox(height: 10),
          GlassCard(
            padding: const EdgeInsets.all(18),
            borderRadius: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.hub_rounded, size: 18, color: CosmicColors.etherealCyan),
                    SizedBox(width: 8),
                    Text(
                      'Phase 1 UI Foundation',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: CosmicColors.starWhite,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Version 1.0.0-alpha • Clean Flutter Shell with zero external bloat.',
                  style: TextStyle(
                    fontSize: 12,
                    color: CosmicColors.celestialMuted,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Upcoming Phase 2 Roadmap: AR Foundation camera telemetry, Unity constellation rendering bridge, and cross-cultural celestial mythology datasets.',
                  style: TextStyle(
                    fontSize: 12,
                    color: CosmicColors.stardustSubtle,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: CosmicColors.celestialMuted,
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color activeColor = CosmicColors.etherealCyan,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: CosmicColors.starWhite,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: CosmicColors.stardustSubtle,
                  ),
                ),
              ],
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeThumbColor: activeColor,
            activeTrackColor: activeColor.withValues(alpha: 0.35),
            inactiveThumbColor: CosmicColors.stardustSubtle,
            inactiveTrackColor: CosmicColors.deepSpace,
          ),
        ],
      ),
    );
  }
}
