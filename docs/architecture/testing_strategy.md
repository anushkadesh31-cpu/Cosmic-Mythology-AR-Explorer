# Verification & Testing Strategy Specification
**Project:** Cosmic Mythology AR Explorer  
**Document Version:** 1.0.0  
**Phase:** Phase 2 Architecture Specification

---

## 1. Testing Philosophy for Cosmic Core

Because the **Cosmic Core** implements high-precision astronomical mathematics and sensitive cultural heritage data, testing must satisfy two distinct criteria:
1. **Mathematical Determinism**: Astronomy formulas must be tested against published USNO / Jean Meeus standard benchmark tables.
2. **Schema & Attribution Integrity**: Cultural lore must be strictly validated against attribution and sensitivity schemas to prevent unverified or culturally inaccurate records.

```
┌────────────────────────────────────────────────────────┐
│                   Testing Matrix                       │
├─────────────────────────┬──────────────────────────────┤
│ 1. Astrodynamics Tests  │ Benchmark reference ephemeris│
│ 2. Coordinate Tests     │ Invariant checks & transforms│
│ 3. Cultural Schema Tests│ Mandatory attribution rules  │
│ 4. State Machine Tests  │ Quest progression & XP logic │
│ 5. Boundary Tests       │ Zero Flutter imports audit   │
│ 6. UI Regression Tests  │ Phase 1 screens uninterrupted│
└─────────────────────────┴──────────────────────────────┘
```

---

## 2. Astronomical Test Cases (Reference Benchmarks)

### Test 2.1: Julian Day Number Benchmark
- **Input**: Date `2000-01-01 12:00:00 UTC`
- **Expected JD**: $2451545.0$
- **Input**: Date `1987-04-10 19:21:00 UTC` (Meeus Example 7.a)
- **Expected JD**: $2446896.30625$
- **Tolerance**: $\pm 0.000001$

### Test 2.2: Sidereal Time Calculation Benchmark
- **Input**: Date `1987-04-10 00:00:00 UTC` (Meeus Example 12.a)
- **Expected GMST**: $13^{\text{h}} 10^{\text{m}} 46.3668^{\text{s}}$
- **Tolerance**: $\pm 0.1\text{ seconds}$

### Test 2.3: Equatorial to Horizontal Coordinate Transformation
- **Observer**: Latitude $+38^\circ 55' 17''$ (US Naval Observatory, Washington DC), Longitude $-77^\circ 03' 56''$
- **Object**: Star Venus / Aldebaran with known RA $\alpha$, Dec $\delta$
- **Expected**: Computed Altitude $h$ and Azimuth $A$ matching USNO MICA output within $0.01^\circ$ (36 arcseconds).

---

## 3. Cultural Knowledge & Attribution Tests

```dart
test('Every cultural asterism must possess valid academic attribution', () {
  for (final asterism in sampleVedicAsterisms) {
    expect(asterism.academicSource.publicationTitle.isNotEmpty, isTrue);
    expect(asterism.academicSource.authorOrInstitution.isNotEmpty, isTrue);
    expect(asterism.verificationStatus.status, isNot(equals(VerificationStatus.underReview)));
  }
});

test('Scientific stars must never contain cultural myth properties directly', () {
  final star = Star(
    id: 'HIP_24436',
    standardScientificName: 'Rigel',
    equatorialCoordinate: EquatorialCoordinate(rightAscensionHours: 5.24, declinationDegrees: -8.2, distanceLightYears: 860),
    apparentMagnitude: 0.12,
    absoluteMagnitude: -7.0,
    spectralType: 'B8Ia',
    bVColorIndex: -0.03,
  );

  // Verifies that scientific star class has no myth or cultural fields
  expect(star, isNot(isA<CulturalInterpretation>()));
});
```

---

## 4. Pure Dart Boundary Audit Test

To ensure that the Cosmic Core never inadvertently imports Flutter UI or creates coupling:

```dart
test('Cosmic Core files must not import package:flutter', () {
  final coreDirectory = Directory('lib/core/cosmic_core');
  final dartFiles = coreDirectory.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));

  for (final file in dartFiles) {
    final contents = file.readAsStringSync();
    expect(
      contents.contains("import 'package:flutter/"),
      isFalse,
      reason: 'File ${file.path} violates pure Dart architecture by importing Flutter UI!',
    );
  }
});
```

---

## 5. UI Regression & Test Protection

- Existing tests in [`test/widget_test.dart`](file:///c:/Users/Anushka/OneDrive/Desktop/Cosmic-Mythology-AR-Explorer/test/widget_test.dart) will continue to run and verify that `CosmicMythologyApp` renders and navigates without error.
- All Phase 1 widgets remain functional without disruption during Phase 2 development.
