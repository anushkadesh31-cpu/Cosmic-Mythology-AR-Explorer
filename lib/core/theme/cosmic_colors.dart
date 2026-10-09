import 'package:flutter/material.dart';

/// Semantic color palette for Cosmic Mythology AR Explorer.
///
/// Designed to evoke an immersive, mysterious, and cinematic night sky:
/// - Deep space voids and twilight indigo gradients
/// - Ethereal nebular violet and cyan accents
/// - Subtle starlight gold for celestial highlights
/// - Translucent glass surfaces for modern AR HUD aesthetics
abstract final class CosmicColors {
  // Deep Cosmic Backgrounds
  static const Color spaceBlack = Color(0xFF06060D);
  static const Color deepSpace = Color(0xFF0B0A1A);
  static const Color twilightIndigo = Color(0xFF131033);
  static const Color midnightViolet = Color(0xFF1D1445);
  static const Color nebulaGlow = Color(0xFF281858);

  // Ethereal Accents
  static const Color stellarCyan = Color(0xFF48CAE4);
  static const Color etherealCyan = Color(0xFF64DFDF);
  static const Color cosmicViolet = Color(0xFF9D4EDD);
  static const Color nebulaPurple = Color(0xFF7B2CBF);
  static const Color starlightGold = Color(0xFFFFD166);
  static const Color supernovaAmber = Color(0xFFFFAA00);

  // Translucent HUD & Glassmorphism Surfaces
  static const Color glassSurface = Color(0x14FFFFFF); // ~8% white
  static const Color glassSurfaceBright = Color(0x24FFFFFF); // ~14% white
  static const Color glassBorder = Color(0x26FFFFFF); // ~15% white
  static const Color glassBorderGlow = Color(0x4064DFDF); // cyan glow border

  // Text & Starlight
  static const Color starWhite = Color(0xFFF8F9FA);
  static const Color celestialMuted = Color(0xFFA5A8C5);
  static const Color stardustSubtle = Color(0xFF6C6F93);

  // Status & Gamification
  static const Color questGreen = Color(0xFF06D6A0);
  static const Color dangerRed = Color(0xFFEF476F);

  // Sky Horizon Silhouettes
  static const Color mountainSilhouette = Color(0xFF070512);
  static const Color horizonTwilight = Color(0xFF201335);
}
