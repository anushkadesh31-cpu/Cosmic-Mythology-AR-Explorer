# Cosmic Core Domain Models & Entities Specification
**Project:** Cosmic Mythology AR Explorer  
**Document Version:** 1.0.0  
**Phase:** Phase 2 Architecture Specification

---

## 1. Scientific Astronomical Domain Models

All scientific astronomical models are **strictly immutable**, holding verifiable empirical astronomical data.

```dart
/// Represents standard celestial coordinates (J2000 epoch).
class EquatorialCoordinate {
  /// Right Ascension in decimal degrees [0.0, 360.0) or hours [0h, 24h).
  final double rightAscensionHours;

  /// Declination in decimal degrees [-90.0, +90.0].
  final double declinationDegrees;

  /// Proper motion in RA (milliarcseconds per year).
  final double properMotionRa;

  /// Proper motion in Dec (milliarcseconds per year).
  final double properMotionDec;

  /// Radial distance in light-years.
  final double distanceLightYears;

  const EquatorialCoordinate({
    required this.rightAscensionHours,
    required this.declinationDegrees,
    this.properMotionRa = 0.0,
    this.properMotionDec = 0.0,
    required this.distanceLightYears,
  });
}

/// Represents the observer's local horizontal coordinates at an instant.
class HorizontalCoordinate {
  /// Altitude angle above the ideal horizon [-90.0, +90.0] degrees.
  final double altitudeDegrees;

  /// True Azimuth angle measured clockwise from True North [0.0, 360.0) degrees.
  final double azimuthDegrees;

  /// Whether the object is above the astronomical horizon (altitude > 0).
  bool get isAboveHorizon => altitudeDegrees > 0.0;

  const HorizontalCoordinate({
    required this.altitudeDegrees,
    required this.azimuthDegrees,
  });
}

/// Base abstract entity for all celestial objects.
abstract class CelestialBody {
  final String id;
  final String standardScientificName;
  final EquatorialCoordinate equatorialCoordinate;
  final double apparentMagnitude;
  final double absoluteMagnitude;

  const CelestialBody({
    required this.id,
    required this.standardScientificName,
    required this.equatorialCoordinate,
    required this.apparentMagnitude,
    required this.absoluteMagnitude,
  });
}

/// Star entity with spectral classification and catalog identifiers.
class Star extends CelestialBody {
  final String? bayerFlamsteed;
  final String? hipId; // Hipparcos Catalog ID
  final String? hdId;  // Henry Draper Catalog ID
  final String spectralType; // e.g. "M1-M2Ia-Iab" for Betelgeuse, "B8Ia" for Rigel
  final double bVColorIndex;  // Color temperature indicator (B-V)
  final bool isVariable;

  const Star({
    required super.id,
    required super.standardScientificName,
    this.bayerFlamsteed,
    this.hipId,
    this.hdId,
    required super.equatorialCoordinate,
    required super.apparentMagnitude,
    required super.absoluteMagnitude,
    required this.spectralType,
    required this.bVColorIndex,
    this.isVariable = false,
  });
}

/// Planet / Solar System body with dynamic ephemeris orbit calculation.
class Planet extends CelestialBody {
  final PlanetType type;
  final double semiMajorAxisAu;
  final double orbitalPeriodDays;
  final double angularDiameterArcsec;

  const Planet({
    required super.id,
    required super.standardScientificName,
    required super.equatorialCoordinate,
    required super.apparentMagnitude,
    required super.absoluteMagnitude,
    required this.type,
    required this.semiMajorAxisAu,
    required this.orbitalPeriodDays,
    required this.angularDiameterArcsec,
  });
}

enum PlanetType { terrestrial, gasGiant, iceGiant, dwarfPlanet, naturalSatellite }
```

---

## 2. Cultural Celestial Domain Models

Cultural data is encapsulated in models that explicitly document origin, ethnological tradition, and academic attribution.

```dart
/// Represents a cultural astronomy tradition.
class CulturalTradition {
  final String id; // e.g. "vedic_nakshatras", "greco_roman", "polynesian_wayfinding"
  final LocalizedString name;
  final String region;
  final String historicalEra;
  final LocalizedString description;
  final Attribution primaryAttribution;

  const CulturalTradition({
    required this.id,
    required this.name,
    required this.region,
    required this.historicalEra,
    required this.description,
    required this.primaryAttribution,
  });
}

/// Represents a cultural star pattern or constellation.
/// Notice: An asterism in culture X can link to completely different stars
/// than culture Y, or reuse the same stars under different lore.
class CulturalAsterism {
  final String id;
  final String traditionId;
  final LocalizedString indigenousName;
  final String? transliteratedName;
  final LocalizedString englishGloss; // e.g. "The Great Bear" or "The Seven Sages"
  final List<String> memberStarIds; // References Star.id
  final List<ConstellationVectorSegment> lineSegments;
  final LocalizedString mythicSummary;
  final ResearchVerification verificationStatus;
  final Attribution academicSource;

  const CulturalAsterism({
    required this.id,
    required this.traditionId,
    required this.indigenousName,
    this.transliteratedName,
    required this.englishGloss,
    required this.memberStarIds,
    required this.lineSegments,
    required this.mythicSummary,
    required this.verificationStatus,
    required this.academicSource,
  });
}

/// Line connection between two member stars for rendering the celestial outline.
class ConstellationVectorSegment {
  final String startStarId;
  final String endStarId;

  const ConstellationVectorSegment({
    required this.startStarId,
    required this.endStarId,
  });
}

/// Academic verification and attribution model.
class Attribution {
  final String authorOrInstitution;
  final String publicationTitle;
  final int? publicationYear;
  final String? doiOrIsbn;
  final String? archiveUrl;
  final String citationSnippet;

  const Attribution({
    required this.authorOrInstitution,
    required this.publicationTitle,
    this.publicationYear,
    this.doiOrIsbn,
    this.archiveUrl,
    required this.citationSnippet,
  });
}

enum VerificationStatus {
  primarySourceVerified, // Found in direct historical texts / ethnographic fieldwork
  secondaryScholarlyConsensus, // Well attested in standard historical compendiums
  oralTraditionDocumented, // Verified community elder / cultural practitioner documentation
  underReview, // Preliminary entry requiring peer validation
}

class ResearchVerification {
  final VerificationStatus status;
  final String reviewerNotes;
  final DateTime lastVerifiedDate;

  const ResearchVerification({
    required this.status,
    required this.reviewerNotes,
    required this.lastVerifiedDate,
  });
}
```

---

## 3. Story & Narrative Domain Models

```dart
class CelestialStory {
  final String id;
  final String traditionId;
  final LocalizedString title;
  final LocalizedString narrativeSummary;
  final List<StoryChapter> chapters;
  final List<String> associatedAsterismIds;
  final List<String> associatedStarIds;
  final int estimatedReadTimeMinutes;
  final AudioMetadata? audioNarration;
  final Attribution sourceAttribution;

  const CelestialStory({
    required this.id,
    required this.traditionId,
    required this.title,
    required this.narrativeSummary,
    required this.chapters,
    required this.associatedAsterismIds,
    required this.associatedStarIds,
    required this.estimatedReadTimeMinutes,
    this.audioNarration,
    required this.sourceAttribution,
  });
}

class StoryChapter {
  final int chapterIndex;
  final LocalizedString heading;
  final LocalizedString bodyMarkdown;
  final String? focusCelestialBodyId; // Triggers AR viewport camera lock during narrative

  const StoryChapter({
    required this.chapterIndex,
    required this.heading,
    required this.bodyMarkdown,
    this.focusCelestialBodyId,
  });
}

class AudioMetadata {
  final String audioAssetUri;
  final int durationSeconds;
  final String narratorName;
  final CulturalLocale spokenLanguage;

  const AudioMetadata({
    required this.audioAssetUri,
    required this.durationSeconds,
    required this.narratorName,
    required this.spokenLanguage,
  });
}
```

---

## 4. Quests & Progression Domain Models

```dart
class Quest {
  final String id;
  final LocalizedString title;
  final LocalizedString description;
  final QuestType type;
  final List<QuestObjective> objectives;
  final int xpReward;
  final String? unlockedStoryId;
  final String? unlockedBadgeId;

  const Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.objectives,
    required this.xpReward,
    this.unlockedStoryId,
    this.unlockedBadgeId,
  });
}

enum QuestType {
  constellationIdentification,
  culturalTraditionExploration,
  astronomyObservationEvent,
  mythologyNarrativeCompletion,
}

class QuestObjective {
  final String id;
  final LocalizedString label;
  final String targetEntityId; // CelestialBody.id or CulturalAsterism.id
  final int requiredCount;
  final int currentProgress;

  bool get isSatisfied => currentProgress >= requiredCount;

  const QuestObjective({
    required this.id,
    required this.label,
    required this.targetEntityId,
    required this.requiredCount,
    this.currentProgress = 0,
  });
}

class CelestialBadge {
  final String id;
  final LocalizedString name;
  final LocalizedString description;
  final String iconKey;
  final String tier; // e.g. "Bronze", "Silver", "Gold", "Celestial"

  const CelestialBadge({
    required this.id,
    required this.name,
    required this.description,
    required this.iconKey,
    required this.tier,
  });
}
```
