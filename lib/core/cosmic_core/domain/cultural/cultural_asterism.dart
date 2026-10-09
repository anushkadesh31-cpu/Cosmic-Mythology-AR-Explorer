// lib/core/cosmic_core/domain/cultural/cultural_asterism.dart

import '../celestial/constellation_vector_segment.dart';
import 'attribution.dart';
import 'localized_string.dart';
import 'research_verification.dart';

/// Represents a culturally recognized multi-star grouping, constellation outline,
/// or asterism belonging to a specific cultural tradition.
///
/// An asterism links multiple scientific stars by their stable identifiers
/// without embedding cultural claims inside the scientific star models.
class CulturalAsterism {
  /// Unique identifier for this cultural asterism (e.g., 'asterism_summer_triangle', 'nakshatra_krittika').
  final String id;

  /// Foreign key identifying the parent [CulturalTradition].
  final String traditionId;

  /// Culturally authentic name in indigenous script or language.
  final LocalizedString indigenousName;

  /// Transliterated pronunciation (e.g., 'Kṛttikā', 'Pleias').
  final String? transliteratedName;

  /// English translation or gloss (e.g., 'The Seven Sages', 'The Great Bear').
  final LocalizedString englishGloss;

  /// Stable scientific identifiers of member stars (from Star.id).
  /// Must contain 2 or more stars for a valid asterism grouping.
  final List<String> memberStarIds;

  /// Cultural vector linework segments connecting member stars for sky rendering.
  final List<ConstellationVectorSegment> lineSegments;

  /// Scholarly summary of associated cultural symbolism, deities, or seasonal role.
  final LocalizedString mythicSummary;

  /// Research peer-review and sensitivity clearance state.
  final ResearchVerification verificationStatus;

  /// Direct academic attribution supporting this traditional star grouping.
  final Attribution academicSource;

  CulturalAsterism({
    required this.id,
    required this.traditionId,
    required this.indigenousName,
    this.transliteratedName,
    required this.englishGloss,
    required this.memberStarIds,
    this.lineSegments = const [],
    required this.mythicSummary,
    required this.verificationStatus,
    required this.academicSource,
  })  : assert(id.isNotEmpty, 'id cannot be empty'),
        assert(traditionId.isNotEmpty, 'traditionId cannot be empty'),
        assert(memberStarIds.toSet().length >= 2, 'CulturalAsterism requires at least 2 distinct member stars');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CulturalAsterism &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          traditionId == other.traditionId &&
          indigenousName == other.indigenousName &&
          transliteratedName == other.transliteratedName &&
          englishGloss == other.englishGloss &&
          Object.hashAll(memberStarIds) == Object.hashAll(other.memberStarIds) &&
          Object.hashAll(lineSegments) == Object.hashAll(other.lineSegments) &&
          mythicSummary == other.mythicSummary &&
          verificationStatus == other.verificationStatus &&
          academicSource == other.academicSource;

  @override
  int get hashCode => Object.hash(
        id,
        traditionId,
        indigenousName,
        transliteratedName,
        englishGloss,
        Object.hashAll(memberStarIds),
        Object.hashAll(lineSegments),
        mythicSummary,
        verificationStatus,
        academicSource,
      );

  @override
  String toString() =>
      'CulturalAsterism(id: $id, name: ${indigenousName.defaultText}, stars: ${memberStarIds.length})';
}
