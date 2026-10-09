// lib/core/cosmic_core/domain/cultural/cultural_repository.dart

import 'dart:async';

import 'cultural_asterism.dart';
import 'cultural_interpretation.dart';
import 'cultural_tradition.dart';
import 'research_verification.dart';

/// Abstract repository defining the contract for accessing cultural astronomy
/// traditions, asterisms, and celestial object interpretations.
///
/// This contract is pure Dart and completely independent of Flutter UI,
/// rendering systems, and scientific astronomy calculations.
abstract class CulturalRepository {
  /// Retrieves all supported cultural traditions.
  Future<List<CulturalTradition>> getSupportedTraditions();

  /// Retrieves a specific [CulturalTradition] by its unique [id].
  Future<CulturalTradition?> getTraditionById(String id);

  /// Retrieves all cultural asterisms belonging to a specific [traditionId].
  Future<List<CulturalAsterism>> getAsterismsForTradition({
    required String traditionId,
  });

  /// Retrieves a specific [CulturalAsterism] by its unique [id].
  Future<CulturalAsterism?> getAsterismById(String id);

  /// Retrieves all cultural asterisms across all traditions in the repository.
  Future<List<CulturalAsterism>> getAllAsterisms();

  /// Retrieves all cultural interpretations associated with a specific celestial object
  /// (such as a star) identified by its stable [celestialBodyId] (or star ID).
  Future<List<CulturalInterpretation>> getInterpretationsForBody({
    required String celestialBodyId,
  });

  /// Retrieves a specific [CulturalInterpretation] by its unique [id].
  Future<CulturalInterpretation?> getInterpretationById(String id);

  /// Retrieves all cultural interpretations in the repository.
  Future<List<CulturalInterpretation>> getAllInterpretations();

  /// Retrieves the [ResearchVerification] metadata for any cultural entity
  /// (tradition, asterism, or interpretation) identified by [culturalEntityId].
  Future<ResearchVerification?> getVerificationMetadata({
    required String culturalEntityId,
  });
}

/// Architectural alias matching the specification in `cosmic_core_architecture.md`.
typedef ICulturalKnowledgeRepository = CulturalRepository;
