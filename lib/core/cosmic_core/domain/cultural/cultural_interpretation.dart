// lib/core/cosmic_core/domain/cultural/cultural_interpretation.dart

import 'attribution.dart';
import 'localized_string.dart';
import 'research_verification.dart';

/// Represents a culturally authentic narrative interpretation, traditional
/// nomenclature, or mythic role associated with an individual celestial object
/// (e.g., an individual star or planet) within a specific cultural tradition.
///
/// This model maintains strict separation from scientific astronomical models:
/// it references celestial objects solely by their stable identifier ([starId]).
class CulturalInterpretation {
  /// Unique identifier for this cultural interpretation (e.g., 'interp_vedic_ardra').
  final String id;

  /// Stable scientific identifier of the referenced celestial object (e.g., [Star.id]).
  final String starId;

  /// Foreign key identifying the parent [CulturalTradition].
  final String traditionId;

  /// Culturally authentic name in indigenous script or language.
  final LocalizedString indigenousName;

  /// Transliterated pronunciation (e.g., 'Ārdrā', 'Kýōn').
  final String? transliteratedName;

  /// English gloss or descriptive translation (e.g., 'The Moist One', 'The Dog Star').
  final LocalizedString? englishGloss;

  /// Associated deity, ancestral figure, or mythic personification (e.g., 'Rudra').
  final LocalizedString? mythicRole;

  /// Scholarly summary of associated celestial lore, mythos, or seasonal significance.
  final LocalizedString mythicSummary;

  /// Academic peer-review and sensitivity clearance state.
  final ResearchVerification verificationStatus;

  /// Direct academic attribution supporting this cultural association.
  final Attribution academicSource;

  const CulturalInterpretation({
    required this.id,
    required this.starId,
    required this.traditionId,
    required this.indigenousName,
    this.transliteratedName,
    this.englishGloss,
    this.mythicRole,
    required this.mythicSummary,
    required this.verificationStatus,
    required this.academicSource,
  })  : assert(id.length > 0, 'id cannot be empty'),
        assert(starId.length > 0, 'starId cannot be empty'),
        assert(traditionId.length > 0, 'traditionId cannot be empty');

  /// Alias for [starId] to maintain compatibility with generic celestial body queries.
  String get celestialBodyId => starId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CulturalInterpretation &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          starId == other.starId &&
          traditionId == other.traditionId &&
          indigenousName == other.indigenousName &&
          transliteratedName == other.transliteratedName &&
          englishGloss == other.englishGloss &&
          mythicRole == other.mythicRole &&
          mythicSummary == other.mythicSummary &&
          verificationStatus == other.verificationStatus &&
          academicSource == other.academicSource;

  @override
  int get hashCode => Object.hash(
        id,
        starId,
        traditionId,
        indigenousName,
        transliteratedName,
        englishGloss,
        mythicRole,
        mythicSummary,
        verificationStatus,
        academicSource,
      );

  @override
  String toString() =>
      'CulturalInterpretation(id: $id, starId: $starId, name: ${indigenousName.defaultText})';
}
