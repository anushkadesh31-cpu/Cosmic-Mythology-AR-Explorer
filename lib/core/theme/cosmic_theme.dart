import 'package:flutter/material.dart';
import 'cosmic_colors.dart';

/// Central theme definition for Cosmic Mythology AR Explorer.
class CosmicTheme {
  CosmicTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: CosmicColors.spaceBlack,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: CosmicColors.etherealCyan,
        onPrimary: CosmicColors.spaceBlack,
        secondary: CosmicColors.cosmicViolet,
        onSecondary: CosmicColors.starWhite,
        tertiary: CosmicColors.starlightGold,
        onTertiary: CosmicColors.spaceBlack,
        error: CosmicColors.dangerRed,
        onError: CosmicColors.starWhite,
        surface: CosmicColors.deepSpace,
        onSurface: CosmicColors.starWhite,
        surfaceContainerHighest: CosmicColors.twilightIndigo,
      ),
      fontFamily: 'Roboto',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: CosmicColors.starWhite,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          color: CosmicColors.starWhite,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        headlineLarge: TextStyle(
          color: CosmicColors.starWhite,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
        headlineMedium: TextStyle(
          color: CosmicColors.starWhite,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: TextStyle(
          color: CosmicColors.starWhite,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
        titleMedium: TextStyle(
          color: CosmicColors.starWhite,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: CosmicColors.starWhite,
          fontSize: 16,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          color: CosmicColors.celestialMuted,
          fontSize: 14,
          height: 1.4,
        ),
        bodySmall: TextStyle(
          color: CosmicColors.stardustSubtle,
          fontSize: 12,
        ),
        labelLarge: TextStyle(
          color: CosmicColors.starWhite,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.1,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: CosmicColors.starWhite,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: CosmicColors.starWhite),
      ),
      cardTheme: CardThemeData(
        color: CosmicColors.glassSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: CosmicColors.glassBorder, width: 1),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: CosmicColors.glassSurface,
        disabledColor: Colors.transparent,
        selectedColor: CosmicColors.cosmicViolet.withValues(alpha: 0.35),
        secondarySelectedColor: CosmicColors.cosmicViolet,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        labelStyle: const TextStyle(
          color: CosmicColors.celestialMuted,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        secondaryLabelStyle: const TextStyle(
          color: CosmicColors.starWhite,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: CosmicColors.glassBorder, width: 1),
        ),
      ),
    );
  }
}
