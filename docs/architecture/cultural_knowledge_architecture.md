# Cultural Celestial Knowledge Architecture
**Project:** Cosmic Mythology AR Explorer  
**Document Version:** 1.0.0  
**Phase:** Phase 2 Architecture Specification

---

## 1. Principles of Cultural Astronomy Architecture

Cultural celestial knowledge embodies humanity's collective heritage: oral histories, agricultural calendars, navigational wayfinding systems, and mythic cosmologies.

### Golden Rules:
1. **Strict Separation of Science and Lore**: Scientific data (mass, luminosity, distance, spectral type, celestial coordinates) is objective astrophysics. Cultural narratives and asterisms are human cultural interpretations. **Mythology is never presented as scientific fact, nor is scientific reality allowed to erase cultural heritage.**
2. **Attribution & Provenance**: Every cultural asterism, story, or traditional name must carry explicit academic or community attribution.
3. **Equitable Representation**: World traditions are treated with equal rigor and respect, avoiding Eurocentric default bias.
4. **Scholarly Verification Workflow**: Entries pass through defined editorial review states before public inclusion.

---

## 2. Cultural Taxonomy & Supported Traditions

The schema defines a canonical hierarchy:

```
Cultural Tradition (e.g., Vedic Nakshatras)
  ├── Cultural Context & Attribution (Rigveda, Taittiriya Samhita, Surya Siddhanta)
  ├── Cultural Asterisms (e.g., Krittika, Rohini, Mrigashira)
  │     ├── Traditional Name & Pronunciation
  │     ├── Member Star Links (e.g., Pleiades cluster / η Tauri)
  │     ├── Cultural Linework Geometry
  │     └── Associated Deities & Symbology (Agni, Prajapati, Soma)
  └── Cultural Stories & Oral Traditions
        ├── Narrative Text & Audio
        ├── Cultural Season / Festival Association
        └── Primary Bibliographical References
```

### Initial Core Traditions Catalog:

| Tradition ID | Origin / Region | Key Celestial Constructs | Historical Context | Primary Scholarly Reference |
| :--- | :--- | :--- | :--- | :--- |
| `vedic_nakshatras` | Ancient India (Vedic Period) | 27/28 Nakshatras, Saptarishi (Ursa Major), Trishanku (Southern Cross), Mriga (Orion) | Ecliptic lunar mansions used for timekeeping, ritual cycles, and philosophy | *Surya Siddhanta*, *Taittiriya Samhita*, Subhash Kak: *The Astronomical Code of the Rgveda* |
| `greco_roman` | Mediterranean / Hellenistic | 48 Classical Ptolemaic Constellations (Orion, Ursa Major, Cassiopeia) | Hero cycles, metamorphic myths recorded by Aratus, Eratosthenes, Ovid | *Phaenomena* (Aratus), *Catasterismi*, Ptolemy's *Almagest* |
| `polynesian_wayfinding` | Central & South Pacific | Star compass (*Kāpehu Whetū*), Maui's Fishhook (Scorpius), Hokule'a (Arcturus) | Non-instrument open-ocean navigation across the Polynesian Triangle | Nainoa Thompson: *Polynesian Voyaging Society*, Finney: *Voyage of Rediscovery* |
| `indigenous_americas` | North & South America | Lakota Sacred Hoop, Navajo Constellations, Haudenosaunee Celestial Bear | Seasonal cycles, moral instruction, ecological coexistence | *Lakota Star Knowledge* (Goodman), *Navajo Night Sky* (Maryboy & Begay) |
| `east_asian_mansions` | China, Korea, Japan | Four Symbols (Azure Dragon, Vermilion Bird), 28 Xiu (Lunar Mansions), Silver River | Imperial astrometry, agricultural civil administration | Needham: *Science and Civilisation in China Vol. 3*, Sun & Kistemaker |

---

## 3. Strict Separation Schema

To prevent accidental conflation of science and folklore, the data model strictly isolates properties:

```
                        ┌──────────────────────────────┐
                        │   Scientific Star (HIP 27989)│
                        │   Name: Betelgeuse           │
                        │   Type: M1-2 Ia-Iab Supergiant│
                        │   Distance: 642.5 ly         │
                        │   Coords: RA 05h 55m, +07° 24'│
                        └──────────────┬───────────────┘
                                       │ (Referenced by ID)
               ┌───────────────────────┴───────────────────────┐
               ▼                                               ▼
┌──────────────────────────────┐               ┌──────────────────────────────┐
│  Cultural Interpretation A   │               │  Cultural Interpretation B   │
│  Tradition: Vedic Nakshatra  │               │  Tradition: Greco-Roman Lore │
│  Name: Ardra (आर्द्रा)       │               │  Name: Right Shoulder of Orion│
│  Deity: Rudra (Storm Lord)   │               │  Mythos: Slain by Skorpios    │
│  Attribution: Rigveda 2.33   │               │  Attribution: Hyginus, Poet. │
└──────────────────────────────┘               └──────────────────────────────┘
```

---

## 4. Academic Attribution & Peer-Review Workflow

Every cultural entry stored in the database or content pack includes an `Attribution` and `ResearchVerification` record:

```json
{
  "asterism_id": "nakshatra_krittika",
  "tradition_id": "vedic_nakshatras",
  "indigenous_name": {
    "default_text": "Krittika",
    "translations": {
      "hi_IN": "कृत्तिका",
      "mr_IN": "कृत्तिका",
      "ta_IN": "கிருத்திகை",
      "te_IN": "కృత్తిక"
    }
  },
  "member_star_ids": ["HIP_17702", "HIP_17440", "HIP_17847"],
  "attribution": {
    "primary_source": "Taittiriya Samhita 4.4.10",
    "scholarly_edition": "Keith, A.B. (1914) The Veda of the Black Yajus School",
    "secondary_analysis": "Kak, S. (2000) Birth and Early Development of Indian Astronomy",
    "archival_doi": "10.1007/978-94-010-0620-0_43"
  },
  "verification": {
    "status": "primarySourceVerified",
    "verified_by": "Academic Advisory Board / Cultural Panel",
    "verification_timestamp": "2026-03-15T00:00:00Z",
    "sensitivity_review_passed": true
  }
}
```

---

## 5. Cultural Sensitivity & Living Traditions

1. **Sacred Knowledge Restrictions**: Certain indigenous celestial traditions have sacred constraints (e.g., stories that may only be told in winter or specific gender traditions). The engine supports a `seasonalRestriction` flag to respect cultural protocols.
2. **Community Co-Design**: Cultural content packs for living communities (e.g., Australian Aboriginal, Māori, Native American nations) require direct partnership with designated tribal or cultural authorities.
