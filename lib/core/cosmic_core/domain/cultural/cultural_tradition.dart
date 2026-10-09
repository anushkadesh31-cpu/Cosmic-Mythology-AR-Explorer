// lib/core/cosmic_core/domain/cultural/cultural_tradition.dart

import 'attribution.dart';
import 'localized_string.dart';

/// Represents a distinct cultural or historical astronomy tradition
/// (e.g., Vedic Nakshatras, Classical Greco-Roman, Polynesian Wayfinding).
class CulturalTradition {
  /// Unique, stable identifier for the tradition (e.g., 'vedic_nakshatras', 'greco_roman').
  final String id;

  /// The culturally authentic name of the tradition.
  final LocalizedString name;

  /// Geographic region of origin (e.g., 'Ancient India / Indo-Gangetic Plain', 'Mediterranean').
  final String region;

  /// Historical era or period (e.g., 'Vedic Period (c. 1500–500 BCE)', 'Hellenistic / Classical').
  final String historicalEra;

  /// Detailed scholarly description of the tradition's celestial cosmology and context.
  final LocalizedString description;

  /// Primary source or authoritative bibliographic attribution for the tradition.
  final Attribution primaryAttribution;

  const CulturalTradition({
    required this.id,
    required this.name,
    required this.region,
    required this.historicalEra,
    required this.description,
    required this.primaryAttribution,
  })  : assert(id.length > 0, 'id cannot be empty'),
        assert(region.length > 0, 'region cannot be empty'),
        assert(historicalEra.length > 0, 'historicalEra cannot be empty');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CulturalTradition &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          region == other.region &&
          historicalEra == other.historicalEra &&
          description == other.description &&
          primaryAttribution == other.primaryAttribution;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        region,
        historicalEra,
        description,
        primaryAttribution,
      );

  @override
  String toString() => 'CulturalTradition(id: $id, name: ${name.defaultText})';
}
