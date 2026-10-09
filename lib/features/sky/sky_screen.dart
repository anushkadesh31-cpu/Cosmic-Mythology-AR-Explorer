import 'package:flutter/material.dart';
import '../../core/theme/cosmic_colors.dart';
import '../../core/responsive/responsive_utils.dart';
import '../../core/widgets/glass_card.dart';
import '../../core/cosmic_core/domain/observer/observer.dart';
import '../../core/cosmic_core/domain/time/observation_time.dart';
import '../../core/cosmic_core/domain/celestial/celestial_repository.dart';
import '../../core/cosmic_core/data/catalog/simple_star_catalog.dart';
import '../../core/cosmic_core/visibility/visibility_service.dart';
import '../../core/cosmic_core/visibility/visible_object.dart';
import 'virtual_sky.dart';

/// Visually emphasized Sky & AR celestial exploration screen.
///
/// Simulates the cinematic AR viewport:
/// - Real-time celestial compass & coordinates HUD
/// - Thin, elegant constellation linework and glowing star nodes
/// - Celestial telemetry labels (distance, magnitude, mythology)
/// - Minimalist AR controls overlay
class SkyScreen extends StatefulWidget {
  final Observer? observer;
  final ObservationTime? observationTime;
  final CelestialRepository? repository;
  final VisibilityService? visibilityService;
  final VisibleObject? initialSelectedObject;

  const SkyScreen({
    super.key,
    this.observer,
    this.observationTime,
    this.repository,
    this.visibilityService,
    this.initialSelectedObject,
  });

  @override
  State<SkyScreen> createState() => _SkyScreenState();
}

class _SkyScreenState extends State<SkyScreen> {
  late Observer _observer;
  late ObservationTime _observationTime;
  late CelestialRepository _repository;
  late VisibilityService _visibilityService;
  VisibleObject? _selectedObject;

  bool _showConstellationLines = true;
  bool _showMythologyArt = false;
  bool _nightVisionMode = false;

  @override
  void initState() {
    super.initState();
    _observer = widget.observer ?? Observer(latitude: 37.7749, longitude: -122.4194);
    _observationTime = widget.observationTime ?? ObservationTime(DateTime.now());
    _repository = widget.repository ?? SimpleStarCatalog();
    _visibilityService = widget.visibilityService ?? const VisibilityService();
    _selectedObject = widget.initialSelectedObject;
  }

  @override
  void didUpdateWidget(covariant SkyScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.observer != null &&
        (widget.observer!.latitude != oldWidget.observer?.latitude ||
            widget.observer!.longitude != oldWidget.observer?.longitude ||
            widget.observer!.elevation != oldWidget.observer?.elevation)) {
      setState(() {
        _observer = widget.observer!;
      });
    }
    if (widget.observationTime != null &&
        widget.observationTime!.utc != oldWidget.observationTime?.utc) {
      setState(() {
        _observationTime = widget.observationTime!;
      });
    }
    if (widget.repository != null && widget.repository != oldWidget.repository) {
      setState(() {
        _repository = widget.repository!;
      });
    }
    if (widget.visibilityService != null &&
        widget.visibilityService != oldWidget.visibilityService) {
      setState(() {
        _visibilityService = widget.visibilityService!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = getScreenSize(context);
    final Color accentColor = _nightVisionMode ? CosmicColors.dangerRed : CosmicColors.questGreen;
    EdgeInsets padding = EdgeInsets.zero;
    final bodyContent = Stack(
      children: [
        // 1. Pure-Dart Virtual Sky Rendering with Real Catalog Selection
        Positioned.fill(
          child: VirtualSky(
            observer: _observer,
            observationTime: _observationTime,
            repository: _repository,
            visibilityService: _visibilityService,
            selectedObjectId: _selectedObject?.id,
            selectionColor: accentColor,
            showConstellationLines: _showConstellationLines,
            onSelectObject: (obj) {
              setState(() {
                _selectedObject = obj;
              });
            },
          ),
        ),

        // 2. Top HUD: Celestial Compass & Bearing Tape
        Positioned(
          top: 8,
          left: 16,
          right: 16,
          child: _buildCompassHud(accentColor),
        ),

        // 3. Minimal Viewport Floating Controls (Right side)
        Positioned(
          top: 80,
          right: 16,
          child: _buildMinimalControls(accentColor),
        ),

        // 4. Bottom HUD: Target Telemetry & Mythology Card
        Positioned(
          left: 16,
          right: 16,
          bottom: 110,
          child: _buildTargetCard(_selectedObject, accentColor),
        ),
      ],
    );

    switch (screenSize) {
      case ResponsiveScreenSize.compact:
        return bodyContent;
      case ResponsiveScreenSize.medium:
        padding = const EdgeInsets.fromLTRB(32, 12, 32, 110);
        return Padding(padding: padding, child: bodyContent);
      case ResponsiveScreenSize.expanded:
        padding = const EdgeInsets.symmetric(horizontal: 48, vertical: 12);
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(padding: padding, child: bodyContent),
          ),
        );
    }
  }
   

  Widget _buildCompassHud(Color accentColor) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      borderRadius: 16,
      surfaceColor: CosmicColors.spaceBlack.withValues(alpha: 0.55),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _nightVisionMode ? CosmicColors.dangerRed : CosmicColors.questGreen,
                    boxShadow: [
                      BoxShadow(
                        color: (_nightVisionMode ? CosmicColors.dangerRed : CosmicColors.questGreen)
                            .withValues(alpha: 0.6),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'AR VIEWPORT • 60 FPS',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.1,
                      color: accentColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.explore_rounded, size: 14, color: CosmicColors.celestialMuted),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    _selectedObject != null
                        ? 'AZ ${_selectedObject!.azimuth.toStringAsFixed(0)}° • Alt ${_selectedObject!.altitude.toStringAsFixed(0)}°'
                        : 'NW 318° • Alt 44°',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: CosmicColors.starWhite,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalControls(Color accentColor) {
    return Column(
      children: [
        _buildHudIconButton(
          icon: _showConstellationLines ? Icons.timeline_rounded : Icons.lens_blur_rounded,
          label: 'Lines',
          isActive: _showConstellationLines,
          accentColor: accentColor,
          onTap: () {
            setState(() {
              _showConstellationLines = !_showConstellationLines;
            });
          },
        ),
        const SizedBox(height: 10),
        _buildHudIconButton(
          icon: Icons.auto_awesome,
          label: 'Mythos',
          isActive: _showMythologyArt,
          accentColor: accentColor,
          onTap: () {
            setState(() {
              _showMythologyArt = !_showMythologyArt;
            });
          },
        ),
        const SizedBox(height: 10),
        _buildHudIconButton(
          icon: Icons.remove_red_eye_rounded,
          label: 'Night Red',
          isActive: _nightVisionMode,
          accentColor: CosmicColors.dangerRed,
          onTap: () {
            setState(() {
              _nightVisionMode = !_nightVisionMode;
            });
          },
        ),
      ],
    );
  }

  Widget _buildHudIconButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: isActive
                  ? accentColor.withValues(alpha: 0.25)
                  : CosmicColors.spaceBlack.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isActive ? accentColor.withValues(alpha: 0.8) : CosmicColors.glassBorder,
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isActive ? accentColor : CosmicColors.celestialMuted,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTargetCard(VisibleObject? target, Color accentColor) {
    final hasTarget = target != null;
    final magText = hasTarget
        ? (target.apparentMagnitude != null
            ? 'Mag ${target.apparentMagnitude!.toStringAsFixed(2)}'
            : 'Mag N/A')
        : 'SCANNING';

    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      surfaceColor: CosmicColors.deepSpace.withValues(alpha: 0.8),
      borderColor: accentColor.withValues(alpha: 0.4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasTarget ? accentColor : CosmicColors.celestialMuted,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        hasTarget ? 'LOCKED CELESTIAL TARGET' : 'AWAITING CELESTIAL TARGET',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: hasTarget ? accentColor : CosmicColors.celestialMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: CosmicColors.glassSurfaceBright,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  magText,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: CosmicColors.starlightGold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            hasTarget ? target.name : 'Tap a star to inspect',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: CosmicColors.starWhite,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            hasTarget
                ? 'Type: ${target.type.name.toUpperCase()}'
                : 'Select any visible catalog star to view real-time telemetry.',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: hasTarget ? accentColor : CosmicColors.celestialMuted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            hasTarget
                ? 'Real-time topocentric horizontal coordinates calculated for the current observer and observation time.'
                : 'Explore the virtual sky above your local horizon. Tap any projected star node to lock coordinates.',
            style: const TextStyle(
              fontSize: 12,
              color: CosmicColors.celestialMuted,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildMetricChip(
                label: 'Altitude',
                value: hasTarget ? '${target.altitude.toStringAsFixed(1)}°' : '--',
              ),
              const SizedBox(width: 8),
              _buildMetricChip(
                label: 'Azimuth',
                value: hasTarget ? '${target.azimuth.toStringAsFixed(1)}°' : '--',
              ),
              if (hasTarget && target.apparentMagnitude != null) ...[
                const SizedBox(width: 8),
                _buildMetricChip(
                  label: 'Mag',
                  value: target.apparentMagnitude!.toStringAsFixed(2),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricChip({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: CosmicColors.glassSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: CosmicColors.glassBorder, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 11,
              color: CosmicColors.stardustSubtle,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: CosmicColors.starWhite,
            ),
          ),
        ],
      ),
    );
  }
}
