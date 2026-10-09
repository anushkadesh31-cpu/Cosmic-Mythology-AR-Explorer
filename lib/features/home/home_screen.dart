import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/theme/cosmic_colors.dart';
import '../../core/responsive/responsive_utils.dart';


/// Cinematic, astronomy-focused Home screen.
///
/// Refined to let the night sky and living constellations be the visual hero:
/// - Open, spacious celestial layout
/// - Thin, elegant vector constellation linework for Orion
/// - Integrated, ethereal AR Sky action
/// - Low-profile, minimalist secondary controls for Stories and Quests
/// - Clean astronomical telemetry ribbon
class HomeScreen extends StatelessWidget {
  final VoidCallback onExploreSky;
  final VoidCallback onOpenStories;
  final VoidCallback onOpenQuests;

  const HomeScreen({
    super.key,
    required this.onExploreSky,
    required this.onOpenStories,
    required this.onOpenQuests,
  });

  @override
Widget build(BuildContext context) {
    final screenSize = getScreenSize(context);
    EdgeInsets padding;
    final bodyContent = SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Cinematic Brand Header
          _buildCinematicHeader(),

          const SizedBox(height: 20),

          // 2. Visual Hero: Elegant Celestial Constellation Showcase (Orion)
          _buildOrionHeroView(),

          const SizedBox(height: 24),

          // 3. Primary Integrated AR Action
          _buildIntegratedSkyAction(),

          const SizedBox(height: 20),

          // 4. Secondary Portals: Stories & Quests (Refined Low-Profile Capsules)
          _buildSecondaryCapsules(),

          const SizedBox(height: 20),

          // 5. Minimal Sky Telemetry Ribbon
          _buildTelemetryRibbon(),
        ],
      ),
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

  Widget _buildCinematicHeader() {
    return Column(
      children: [
        // Ethereal Celestial Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: CosmicColors.cosmicViolet.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: CosmicColors.etherealCyan.withValues(alpha: 0.3),
              width: 0.8,
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome,
                size: 11,
                color: CosmicColors.etherealCyan,
              ),
              SizedBox(width: 6),
              Text(
                'CELESTIAL AR OBSERVATORY',
                style: TextStyle(
                  color: CosmicColors.etherealCyan,
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.4,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Brand Title
        const Text(
          'Cosmic Mythology',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
            color: CosmicColors.starWhite,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'AR Explorer',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w300,
            letterSpacing: 2.2,
            color: CosmicColors.etherealCyan,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),

        // Subtle Tagline
        const Text(
          'Where ancient cultural mythologies awaken across the living night sky.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.5,
            color: CosmicColors.celestialMuted,
            height: 1.35,
          ),
        ),
      ],
    );
  }

  Widget _buildOrionHeroView() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 220),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 0.95,
          colors: [
            CosmicColors.midnightViolet.withValues(alpha: 0.35),
            CosmicColors.deepSpace.withValues(alpha: 0.15),
            Colors.transparent,
          ],
        ),
        border: Border.all(
          color: CosmicColors.glassBorder.withValues(alpha: 0.25),
          width: 0.8,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              children: [
                // Minimalist Alignment Label
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.radar_rounded,
                          size: 13,
                          color: CosmicColors.starlightGold,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'TONIGHT\'S CELESTIAL ALIGNMENT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.1,
                            color: CosmicColors.starlightGold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: CosmicColors.glassSurface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Az 184° • Alt 48°',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: CosmicColors.celestialMuted,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Constellation Line-Art Canvas
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: _HomeOrionPainter(),
                  ),
                ),

                const SizedBox(height: 8),

                // Constellation Identification & Cultural Badges
                const Text(
                  'Orion • The Celestial Hunter',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                    color: CosmicColors.starWhite,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Egyptian Sah • Vedic Mriga • Greco-Roman Giant',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w400,
                    color: CosmicColors.etherealCyan,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntegratedSkyAction() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CosmicColors.cosmicViolet.withValues(alpha: 0.4),
            CosmicColors.midnightViolet.withValues(alpha: 0.65),
            CosmicColors.twilightIndigo.withValues(alpha: 0.45),
          ],
        ),
        border: Border.all(
          color: CosmicColors.etherealCyan.withValues(alpha: 0.5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: CosmicColors.cosmicViolet.withValues(alpha: 0.3),
            blurRadius: 22,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(28),
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          splashColor: CosmicColors.etherealCyan.withValues(alpha: 0.2),
          onTap: onExploreSky,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                // Glowing Celestial Pulse Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        CosmicColors.etherealCyan,
                        CosmicColors.cosmicViolet,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: CosmicColors.etherealCyan.withValues(alpha: 0.5),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.view_in_ar_rounded,
                    color: CosmicColors.spaceBlack,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),

                // CTA Description
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Explore the Sky in AR',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: CosmicColors.starWhite,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 16,
                            color: CosmicColors.etherealCyan,
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Point device to identify stars, constellations & living mythos.',
                        style: TextStyle(
                          fontSize: 11,
                          color: CosmicColors.celestialMuted,
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryCapsules() {
    return Row(
      children: [
        // Mythic Stories Capsule
        Expanded(
          child: _buildSubtleCapsule(
            icon: Icons.auto_stories_rounded,
            title: 'Mythic Stories',
            subtitle: '8 Cultural Traditions',
            accentColor: CosmicColors.cosmicViolet,
            onTap: onOpenStories,
          ),
        ),
        const SizedBox(width: 12),

        // Active Quests Capsule
        Expanded(
          child: _buildSubtleCapsule(
            icon: Icons.military_tech_rounded,
            title: 'Active Quests',
            subtitle: '3 Challenges Ready',
            accentColor: CosmicColors.starlightGold,
            onTap: onOpenQuests,
          ),
        ),
      ],
    );
  }

  Widget _buildSubtleCapsule({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color accentColor,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: CosmicColors.glassSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: CosmicColors.glassBorder.withValues(alpha: 0.6),
          width: 0.8,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: accentColor, size: 16),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
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
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 10,
                          color: CosmicColors.celestialMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTelemetryRibbon() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: CosmicColors.spaceBlack.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CosmicColors.glassBorder.withValues(alpha: 0.25),
          width: 0.8,
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TelemetryItem(
            icon: Icons.brightness_3_rounded,
            label: 'Moon 72%',
          ),
          _TelemetryDivider(),
          _TelemetryItem(
            icon: Icons.remove_red_eye_rounded,
            label: 'Seeing: Pristine',
          ),
          _TelemetryDivider(),
          _TelemetryItem(
            icon: Icons.public_rounded,
            label: 'Jupiter • Mars',
          ),
        ],
      ),
    );
  }
}

class _TelemetryItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _TelemetryItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: CosmicColors.celestialMuted),
        const SizedBox(width: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: CosmicColors.celestialMuted,
          ),
        ),
      ],
    );
  }
}

class _TelemetryDivider extends StatelessWidget {
  const _TelemetryDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 12,
      color: CosmicColors.glassBorder.withValues(alpha: 0.3),
    );
  }
}

/// Custom vector painter rendering an elegant, delicate Orion constellation line-art.
class _HomeOrionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Constellation Coordinates within bounds
    final betelgeuse = Offset(w * 0.30, h * 0.20);
    final bellatrix = Offset(w * 0.70, h * 0.16);
    final alnitak = Offset(w * 0.44, h * 0.52);
    final alnilam = Offset(w * 0.50, h * 0.50);
    final mintaka = Offset(w * 0.56, h * 0.48);
    final saiph = Offset(w * 0.34, h * 0.85);
    final rigel = Offset(w * 0.72, h * 0.80);

    // Delicate Constellation Linework
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.25)
      ..strokeWidth = 0.9
      ..style = PaintingStyle.stroke;

    canvas.drawLine(betelgeuse, bellatrix, linePaint);
    canvas.drawLine(betelgeuse, alnitak, linePaint);
    canvas.drawLine(bellatrix, mintaka, linePaint);
    canvas.drawLine(alnitak, alnilam, linePaint);
    canvas.drawLine(alnilam, mintaka, linePaint);
    canvas.drawLine(alnitak, saiph, linePaint);
    canvas.drawLine(mintaka, rigel, linePaint);
    canvas.drawLine(saiph, rigel, linePaint);

    // Subtle faint geometric aura
    final auraPaint = Paint()
      ..color = CosmicColors.cosmicViolet.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;
    final auraPath = Path()
      ..moveTo(betelgeuse.dx, betelgeuse.dy)
      ..lineTo(bellatrix.dx, bellatrix.dy)
      ..lineTo(rigel.dx, rigel.dy)
      ..lineTo(saiph.dx, saiph.dy)
      ..close();
    canvas.drawPath(auraPath, auraPaint);

    // Star Nodes
    _drawStar(canvas, betelgeuse, 4.0, CosmicColors.supernovaAmber, 'Betelgeuse (α)');
    _drawStar(canvas, bellatrix, 2.5, CosmicColors.starWhite, null);
    _drawStar(canvas, alnitak, 2.2, CosmicColors.etherealCyan, null);
    _drawStar(canvas, alnilam, 2.2, CosmicColors.etherealCyan, 'Belt');
    _drawStar(canvas, mintaka, 2.2, CosmicColors.etherealCyan, null);
    _drawStar(canvas, saiph, 2.6, CosmicColors.starWhite, null);
    _drawStar(canvas, rigel, 3.8, CosmicColors.stellarCyan, 'Rigel (β)');
  }

  void _drawStar(
    Canvas canvas,
    Offset pos,
    double radius,
    Color color,
    String? label,
  ) {
    // Star Glow
    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pos, radius * 2.2, glowPaint);

    // Star Core
    final corePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pos, radius, corePaint);

    // Star Center White Dot
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(pos, radius * 0.45, centerPaint);

    // Celestial Star Label
    if (label != null) {
      final textSpan = TextSpan(
        text: label,
        style: TextStyle(
          color: CosmicColors.celestialMuted.withValues(alpha: 0.85),
          fontSize: 8.5,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.4,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      )..layout();

      final labelOffset = Offset(pos.dx + radius + 4, pos.dy - (textPainter.height / 2));
      textPainter.paint(canvas, labelOffset);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
