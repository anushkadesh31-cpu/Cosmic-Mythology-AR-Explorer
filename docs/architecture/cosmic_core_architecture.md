# Cosmic Core Master Architecture Blueprint
**Project:** Cosmic Mythology AR Explorer  
**Document Version:** 1.0.0  
**Phase:** Phase 2 Architecture & Specification  
**Status:** Approved Specification (Pre-Implementation)

---

## 1. Executive Vision & Architectural Mission

The **Cosmic Core** is the central, authoritative engine powering the **Cosmic Mythology AR Explorer**. It is designed as a **pure Dart domain and calculation layer**, completely decoupled from UI widgets, rendering frameworks, and external dependencies.

```
┌─────────────────────────────────────────────────────────────┐
│                       Cosmic Core                           │
│        (Pure Dart • Zero Flutter Widget Dependency)         │
│  ┌───────────────────────┐       ┌───────────────────────┐  │
│  │    Astronomy Engine   │       │ Cultural Intelligence │  │
│  │  Coordinates • Ephem  │       │  Traditions • Lore    │  │
│  └───────────┬───────────┘       └───────────┬───────────┘  │
│              └───────────────┬───────────────┘              │
│                     Celestial Linker Engine                 │
│              ┌───────────────┴───────────────┐              │
│              │ Quests • Progression • Stories│              │
│              └───────────────────────────────┘              │
└──────────────────────────────┬──────────────────────────────┘
                               │
               Abstract Clean Engine Boundary
                               │
       ┌───────────────────────┴───────────────────────┐
       ▼                                               ▼
┌─────────────────────────────┐         ┌─────────────────────────────┐
│     Flutter UI Shell        │         │   Unity / AR Foundation     │
│  HUD • Stories • Navigation │         │   3D Sky Dome • AR Camera   │
└─────────────────────────────┘         └─────────────────────────────┘
```

### Core Architectural Guarantees:
1. **Zero Flutter UI Dependency**: Cosmic Core contains no `Widget`, `BuildContext`, `Color`, or `Canvas` imports. It compiles as pure Dart, allowing execution on mobile, desktop, headless CLI, test runners, or native shared libraries.
2. **Dual-Consumer Architecture**: Designed to serve both the existing Flutter UI (Phase 1) and future 3D/AR runtimes (Unity / AR Foundation) via standard data transfer objects (DTOs).
3. **Strict Scientific vs. Cultural Decoupling**: Astronomical calculations (Right Ascension, Declination, Altitude, Azimuth, Light Travel Time, Magnitude) are strictly separated from cultural stories, asterism interpretations, and mythologies.
4. **Offline-First & Content Pack Ready**: Designed to operate 100% offline from bundled assets or downloadable cultural content packs.
5. **Localization-First**: Core entity models natively accommodate multilingual translations (English, Hindi, Marathi, Tamil, Telugu).

---

## 2. Recommended Directory Structure

The future implementation will structure the codebase under `lib/core/cosmic_core/`:

```
lib/
├── app.dart
├── main.dart
├── core/
│   ├── theme/                              # (Phase 1: Colors, Themes)
│   ├── widgets/                            # (Phase 1: GlassCard, Background)
│   └── cosmic_core/                        # NEW: Pure Dart Cosmic Core
│       ├── cosmic_core.dart                # Public barrel export
│       ├── astronomy/                      # Scientific astronomical engine
│       │   ├── coordinates/                # Coordinate systems & math
│       │   │   ├── equatorial_coordinate.dart
│       │   │   ├── horizontal_coordinate.dart
│       │   │   ├── geographic_location.dart
│       │   │   └── coordinate_transform.dart
│       │   ├── time/                       # Astrodynamics timekeeping
│       │   │   ├── julian_date.dart
│       │   │   └── sidereal_time.dart
│       │   ├── ephemeris/                  # Celestial body positioning
│       │   │   ├── solar_calculator.dart
│       │   │   ├── lunar_calculator.dart
│       │   │   └── planetary_calculator.dart
│       │   └── models/                     # Scientific entities
│       │       ├── celestial_body.dart
│       │       ├── star.dart
│       │       ├── planet.dart
│       │       ├── constellation_boundary.dart
│       │       └── scientific_constellation.dart
│       ├── cultural/                       # Cultural celestial knowledge
│       │   ├── models/
│       │   │   ├── cultural_tradition.dart
│       │   │   ├── cultural_asterism.dart
│       │   │   ├── cultural_interpretation.dart
│       │   │   ├── attribution.dart
│       │   │   └── research_verification.dart
│       │   └── traditions/                 # Pluggable cultural definitions
│       │       ├── vedic_nakshatras.dart
│       │       ├── greco_roman.dart
│       │       ├── indigenous_americas.dart
│       │       ├── polynesian_wayfinding.dart
│       │       └── east_asian_lunar_mansions.dart
│       ├── content/                        # Stories & Lore
│       │   ├── models/
│       │   │   ├── celestial_story.dart
│       │   │   ├── story_chapter.dart
│       │   │   └── audio_metadata.dart
│       │   └── repositories/
│       │       └── story_repository.dart
│       ├── progression/                    # Quests & Gamification
│       │   ├── models/
│       │   │   ├── quest.dart
│       │   │   ├── quest_objective.dart
│       │   │   ├── celestial_badge.dart
│       │   │   └── stargazer_profile.dart
│       │   └── engine/
│       │       └── progression_engine.dart
│       ├── packs/                          # Offline Content Packs
│       │   ├── pack_manifest.dart
│       │   ├── pack_loader.dart
│       │   └── pack_validator.dart
│       ├── localization/                   # Multilingual text resolution
│       │   ├── localized_string.dart
│       │   └── cultural_locale.dart
│       └── bridges/                        # Consumer output adapters
│           ├── flutter_adapter.dart
│           └── ar_telemetry_packet.dart
└── features/                               # Phase 1 UI Feature Shells
    ├── home/
    ├── explore/
    ├── sky/
    ├── stories/
    ├── quests/
    ├── profile/
    └── settings/
```

---

## 3. Layer Breakdown & Clean Responsibilities

### Layer 1: Astronomy Calculation Layer
- **Input**: Observer `GeographicLocation` (latitude, longitude, elevation) and UTC timestamp (`DateTime`).
- **Processing**: Converts UTC to Julian Date & Greenwich Sidereal Time (GST) -> Computes Local Sidereal Time (LST) -> Transforms Equatorial Coordinates $(\alpha, \delta)$ to Horizontal Coordinates $(h, A)$ [Altitude & Azimuth].
- **Output**: Real-time visible coordinates, current altitude, horizon transit times, rise/set azimuths, and angular separation.

### Layer 2: Cultural Knowledge Layer
- **Purpose**: Maps astronomical entities to cultural constructs.
- **Rule**: A star (e.g., *HIP 24436 / Rigel*) is an objective scientific entity. It is linked to multiple cultural interpretations:
  - Greco-Roman: *Left foot of Orion the Hunter*
  - Vedic: *Arrow tip of Rudra / Mrigashira asterism*
  - Norse: *Aurvandill's frozen toe cast into the heavens*
  - Polynesian: *Puanga, herald of the winter harvest*
- **Verification & Attribution**: Each cultural entity carries an `Attribution` object containing academic source references, ethnographic origin, and verification level.

### Layer 3: Linker Engine (Domain Aggregator)
- Resolves cross-domain queries:
  - *"Given the observer's current position and time, which cultural constellations from the Vedic tradition are currently above 20° altitude?"*
  - *"Which mythic stories relate to the stars currently inside the user's field of view?"*

### Layer 4: Content & Progression Engine
- Evaluates quest conditions against observation events (e.g., observer held reticle on Betelgeuse, Rigel, and Sirius for > 3 seconds).
- Emits immutable progression events to update user XP, unlock cultural lore fragments, and grant badges.

---

## 4. Repository & Service Interfaces (Contract Definition)

```dart
/// Core contract for astronomical ephemeris and coordinate transformations.
abstract interface class IAstronomyService {
  HorizontalCoordinate computeHorizontalCoordinate({
    required EquatorialCoordinate celestial,
    required GeographicLocation observer,
    required DateTime timeUtc,
  });

  SkyVisibility checkVisibility({
    required CelestialBody body,
    required GeographicLocation observer,
    required DateTime timeUtc,
    double minAltitudeDegrees = 0.0,
  });

  MoonPhaseData computeMoonPhase(DateTime timeUtc);

  List<VisibleCelestialBody> getVisibleSkyObjects({
    required GeographicLocation observer,
    required DateTime timeUtc,
    double magnitudeThreshold = 6.0,
  });
}

/// Core contract for cultural celestial interpretations.
abstract interface class ICulturalKnowledgeRepository {
  Future<List<CulturalTradition>> getSupportedTraditions();

  Future<List<CulturalAsterism>> getAsterismsForTradition({
    required String traditionId,
  });

  Future<List<CulturalInterpretation>> getInterpretationsForBody({
    required String celestialBodyId,
  });

  Future<ResearchVerification> getVerificationMetadata({
    required String culturalEntityId,
  });
}

/// Core contract for offline content packs.
abstract interface class IContentPackLoader {
  Future<PackManifest> inspectPack(String packId);
  Future<bool> installPack(String packPath);
  Future<bool> verifyPackIntegrity(String packId);
  Future<List<String>> listInstalledPacks();
}
```

---

## 5. Offline & Content-Pack Architecture

To support deep educational and cultural expeditions without internet access, the Cosmic Core implements a **Content Pack Schema**:

1. **Core Base Pack (`core_v1.pack`)**: Bundled in Flutter assets. Contains the Yale Bright Star Catalog subset (~1,500 visible stars up to Mag 5.5), Solar System ephemeris models, and foundational cultural starter lore.
2. **Downloadable Cultural Packs (`vedic_nakshatras.pack`, `polynesian_wayfinding.pack`)**:
   - Packaged as compressed JSON/CBOR bundles.
   - Includes multilingual text assets (`hi_IN`, `mr_IN`, `ta_IN`, `te_IN`, `en_US`), audio narrations, constellation linework vectors, and academic bibliography metadata.
   - Validated via cryptographic SHA-256 hash checksums before ingestion.

---

## 6. Multilingual Localization Architecture

Cultural celestial knowledge has deep linguistic roots. Star names and myths in indigenous and Indian traditions must not simply be machine-translated.

The localization system uses a **Cultural Nomenclature Resolver**:
```dart
class LocalizedString {
  final String defaultText;
  final Map<CulturalLocale, String> translations;

  const LocalizedString({
    required this.defaultText,
    required this.translations,
  });

  String resolve(CulturalLocale locale) => translations[locale] ?? defaultText;
}

enum CulturalLocale {
  enUs, // English (Universal)
  hiIn, // Hindi (हिन्दी)
  mrIn, // Marathi (मराठी)
  taIn, // Tamil (தமிழ்)
  teIn, // Telugu (తెలుగు)
}
```

---

## 7. Recommended Phase 2+ Development Order

```
[Phase 2.1: Astrodynamics Foundations]
  ├── Time & Julian Date Engine
  ├── Equatorial <-> Horizontal Math
  └── Unit Tests verifying against USNO & Astronomical Algorithms (Meeus)
         │
[Phase 2.2: Scientific Data Layer]
  ├── Bright Star Catalog Domain Models & Static In-Memory Datasets
  ├── Constellation Boundary & Vector Linework Models
  └── Visibility & Horizon Altitude Service
         │
[Phase 2.3: Cultural Knowledge Architecture]
  ├── Cultural Tradition & Asterism Domain Entities
  ├── Academic Attribution & Research Verification Schema
  └── Vedic & Greco-Roman Baseline Datasets
         │
[Phase 2.4: Stories & Content System]
  ├── Celestial Story Domain Models
  ├── Cultural Audio & Narrative Metadata
  └── Multilingual Localization Resolvers
         │
[Phase 2.5: Quest & Progression State Machine]
  ├── Quest, Objective, and Badge Entities
  └── Stargazer Progression Engine (Pure Dart)
         │
[Phase 2.6: Flutter UI Integration]
  └── Connect Phase 1 screens (Home, Sky, Explore, Stories, Quests) to Cosmic Core
         │
[Phase 3: AR Foundation / Unity Integration]
  └── Bridge Cosmic Core Telemetry Packets to 3D AR Camera
```
