import 'package:flutter/material.dart';
import '../theme/cosmic_colors.dart';

/// An immersive background widget rendering a deep night sky gradient,
/// procedural stars, and subtle horizon landscape silhouette.
class CelestialBackground extends StatelessWidget {
  final Widget child;
  final bool showHorizon;

  const CelestialBackground({
    super.key,
    required this.child,
    this.showHorizon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Deep cosmic gradient base
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                CosmicColors.spaceBlack,
                CosmicColors.deepSpace,
                CosmicColors.twilightIndigo,
                CosmicColors.midnightViolet,
              ],
              stops: [0.0, 0.35, 0.75, 1.0],
            ),
          ),
        ),

        // 2. Nebula atmospheric glow patches
        Positioned(
          top: -80,
          right: -60,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  CosmicColors.nebulaPurple.withValues(alpha: 0.22),
                  CosmicColors.cosmicViolet.withValues(alpha: 0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 240,
          left: -100,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  CosmicColors.stellarCyan.withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // 3. Custom painted starfield and horizon silhouette
        Positioned.fill(
          child: CustomPaint(
            painter: _StarFieldAndHorizonPainter(showHorizon: showHorizon),
          ),
        ),

        // 4. Foreground content
        Positioned.fill(child: child),
      ],
    );
  }
}

class _StarFieldAndHorizonPainter extends CustomPainter {
  final bool showHorizon;

  _StarFieldAndHorizonPainter({required this.showHorizon});

  // Fixed pseudo-random seed points for consistent, elegant star distribution
  static final List<_StarPoint> _stars = _generateStars();

  static List<_StarPoint> _generateStars() {
    final list = <_StarPoint>[];
    var seed = 42;
    int next() {
      seed = (seed * 1103515245 + 12345) & 0x7fffffff;
      return seed;
    }

    for (var i = 0; i < 90; i++) {
      final x = (next() % 1000) / 1000.0;
      final y = (next() % 1000) / 1000.0;
      final radius = 0.6 + ((next() % 14) / 10.0);
      final opacity = 0.25 + ((next() % 65) / 100.0);
      final isGlowing = (next() % 8) == 0;
      list.add(_StarPoint(x, y, radius, opacity, isGlowing));
    }
    return list;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Draw Stars
    final starPaint = Paint()..style = PaintingStyle.fill;
    final glowPaint = Paint()..style = PaintingStyle.fill;

    for (final star in _stars) {
      final dx = star.x * size.width;
      final dy = star.y * size.height * (showHorizon ? 0.82 : 1.0);

      if (star.isGlowing) {
        glowPaint.color = CosmicColors.etherealCyan.withValues(alpha: star.opacity * 0.45);
        canvas.drawCircle(Offset(dx, dy), star.radius * 2.8, glowPaint);
      }

      starPaint.color = Colors.white.withValues(alpha: star.opacity);
      canvas.drawCircle(Offset(dx, dy), star.radius, starPaint);
    }

    // Draw Mountain Silhouette at the bottom horizon
    if (showHorizon) {
      final horizonPaint = Paint()
        ..color = CosmicColors.mountainSilhouette
        ..style = PaintingStyle.fill;

      final path = Path();
      final h = size.height;
      final w = size.width;

      path.moveTo(0, h);
      path.lineTo(0, h * 0.91);
      path.lineTo(w * 0.15, h * 0.88);
      path.lineTo(w * 0.28, h * 0.90);
      path.lineTo(w * 0.42, h * 0.86);
      path.lineTo(w * 0.58, h * 0.89);
      path.lineTo(w * 0.74, h * 0.85);
      path.lineTo(w * 0.88, h * 0.88);
      path.lineTo(w, h * 0.87);
      path.lineTo(w, h);
      path.close();

      canvas.drawPath(path, horizonPaint);

      // Subtle atmospheric twilight haze right above mountains
      final hazeRect = Rect.fromLTRB(0, h * 0.80, w, h * 0.92);
      final hazePaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            CosmicColors.horizonTwilight.withValues(alpha: 0.35),
          ],
        ).createShader(hazeRect);
      canvas.drawRect(hazeRect, hazePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarFieldAndHorizonPainter oldDelegate) => false;
}

class _StarPoint {
  final double x;
  final double y;
  final double radius;
  final double opacity;
  final bool isGlowing;

  const _StarPoint(this.x, this.y, this.radius, this.opacity, this.isGlowing);
}
