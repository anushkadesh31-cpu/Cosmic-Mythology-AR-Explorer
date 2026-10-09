# End-to-End Data Flow Architecture
**Project:** Cosmic Mythology AR Explorer  
**Document Version:** 1.0.0  
**Phase:** Phase 2 Architecture Specification

---

## 1. Unified Application Data Pipeline

The data flow connects physical reality (time, location, sensors) to mathematical abstraction (Cosmic Core) and finally to user presentation (Phase 1 Screens and AR Viewport).

```
                      [Physical Reality]
                  GPS Coordinates • UTC Clock
                              │
                              ▼
                 [Observer Context Provider]
            Latitude • Longitude • Elevation • Time
                              │
                              ▼
                 ┌───────────────────────────┐
                 │    Cosmic Core Engine     │
                 │ ┌───────────────────────┐ │
                 │ │  Astrodynamics Math   │ │
                 │ └──────────┬────────────┘ │
                 │            ▼              │
                 │ ┌───────────────────────┐ │
                 │ │ Cultural Linker Engine│ │
                 │ └──────────┬────────────┘ │
                 │            ▼              │
                 │ ┌───────────────────────┐ │
                 │ │   Progression Engine  │ │
                 │ └───────────────────────┘ │
                 └─────────────┬─────────────┘
                               │
               Immutable View Models & Streams
                               │
       ┌───────────────────────┴───────────────────────┐
       ▼                                               ▼
┌─────────────────────────────┐         ┌─────────────────────────────┐
│    Phase 1 Flutter UI       │         │      AR Viewport HUD        │
│  - Home Screen Highlights   │         │  - Real-time 60fps reticle  │
│  - Explore Catalog Search   │         │  - Star nodes & labels      │
│  - Stories Library          │         │  - Constellation linework   │
│  - Quests & XP Indicators   │         │  - Cultural mythos overlay  │
│  - Profile Journal          │         │  - Night vision color grade │
└─────────────────────────────┘         └─────────────────────────────┘
```

---

## 2. Screen-by-Screen Consumption of Cosmic Core

Here is how each existing Phase 1 screen will transition from mock data to real Cosmic Core services:

### 2.1 Home Screen (`HomeScreen`)
- **Current Mock**: Hardcoded Orion summary and static condition chips (*Waxing 72%, Pristine seeing*).
- **Cosmic Core Target**:
  - `IAstronomyService.computeMoonPhase(now)` -> Injects real lunar fraction, waxing/waning status, and illumination.
  - `ICatalogService.getTonightHighlight(observer, now)` -> Selects the highest-altitude prominent cultural constellation visible tonight from the user's specific location.
  - `IProgressionService.watchSummary()` -> Dynamically displays active quest count and user level.

### 2.2 Sky Screen (`SkyScreen`)
- **Current Mock**: Static Orion vector coordinates and 3 hardcoded star tap targets.
- **Cosmic Core Target**:
  - Listens to `Stream<ArSkyTelemetryFrame>` updated every frame/second.
  - Renders true calculated altitude and azimuth for all visible stars up to magnitude 5.5.
  - Draws dynamic constellation line segments matching the user's selected cultural tradition (e.g., switches seamlessly between Greek Orion and Vedic Mrigashira).
  - Emits `onTargetFocused(starId)` when reticle aligns within threshold.

### 2.3 Explore Screen (`ExploreScreen`)
- **Current Mock**: In-memory static list of 6 constellations.
- **Cosmic Core Target**:
  - `ICatalogService.search(query, traditionFilter)` -> Queries the unified celestial database.
  - Automatically calculates each constellation's current elevation above the local horizon and marks objects as *Currently Visible* or *Below Horizon*.

### 2.4 Stories Screen (`StoriesScreen`)
- **Current Mock**: Static mock story list.
- **Cosmic Core Target**:
  - `IStoryRepository.getStoriesForTradition(traditionId)` -> Loads verified academic cultural narratives from installed content packs.
  - Tapping a story allows cross-linking: *"Show this constellation in AR Sky Viewport"*.

### 2.5 Quests Screen (`QuestsScreen`)
- **Current Mock**: Hardcoded progress numbers (`680 / 1000 XP`, `2 / 3 progress`).
- **Cosmic Core Target**:
  - `IProgressionEngine.getActiveQuests()` -> Real reactive state machine tracking verified observation events.
  - When the user locks onto required stars in AR Sky mode, the engine automatically increments progress and issues completion notifications.

### 2.6 Profile Screen (`ProfileScreen`)
- **Current Mock**: Hardcoded discovery stats (`18 Constellations, 14 Myths`).
- **Cosmic Core Target**:
  - `IUserProfileRepository.getProfile()` -> Aggregates real user discoveries, logged observation journals, and unlocked cultural badges stored in local SQLite / Hive storage.

### 2.7 Settings Screen (`SettingsScreen`)
- **Current Mock**: Local UI `setState` toggles.
- **Cosmic Core Target**:
  - Connects to `IUserSettingsService` -> Persists magnitude limiting threshold, preferred cultural tradition, active locale, and night vision mode.

---

## 3. Offline Content Loading Lifecycle

```
[App Initialization]
        │
        ▼
[Check Local Content Directory]
        │
        ├── Pack exists? ──► [Verify SHA-256 Checksum] ──► [Load into In-Memory Indices]
        │                                                           │
        └── Missing?                                                ▼
                │                                       [Ready for Instant Queries]
                ▼
  [Extract Bundled 'core_v1.pack' Asset]
```
