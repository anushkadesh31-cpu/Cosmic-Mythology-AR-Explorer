// lib/core/cosmic_core/data/cultural/simple_cultural_catalog.dart

import 'dart:async';

import '../../domain/celestial/constellation_vector_segment.dart';
import '../../domain/celestial/id_generator.dart';
import '../../domain/cultural/attribution.dart';
import '../../domain/cultural/cultural_asterism.dart';
import '../../domain/cultural/cultural_interpretation.dart';
import '../../domain/cultural/cultural_repository.dart';
import '../../domain/cultural/cultural_tradition.dart';
import '../../domain/cultural/localized_string.dart';
import '../../domain/cultural/research_verification.dart';

/// In-memory implementation of [CulturalRepository] providing access to
/// cultural astronomy traditions, asterisms, and star interpretations.
///
/// This catalog is pure Dart, decoupled from Flutter UI, and preserves strict
/// separation between scientific astronomy models and cultural narratives.
class SimpleCulturalCatalog implements CulturalRepository {
  final List<CulturalTradition> _traditions;
  final List<CulturalAsterism> _asterisms;
  final List<CulturalInterpretation> _interpretations;

  /// Default constructor initializes the catalog with source-grounded baseline data
  /// unless explicit custom collections are provided.
  SimpleCulturalCatalog({
    List<CulturalTradition>? traditions,
    List<CulturalAsterism>? asterisms,
    List<CulturalInterpretation>? interpretations,
  })  : _traditions = traditions ?? _buildDefaultTraditions(),
        _asterisms = asterisms ?? _buildDefaultAsterisms(),
        _interpretations = interpretations ?? _buildDefaultInterpretations();

  /// Creates a completely empty cultural catalog containing zero entries.
  factory SimpleCulturalCatalog.empty() {
    return SimpleCulturalCatalog(
      traditions: const [],
      asterisms: const [],
      interpretations: const [],
    );
  }

  // ---------------------------------------------------------------------------
  // Synchronous Accessors
  // ---------------------------------------------------------------------------

  /// Unmodifiable view of all traditions in this catalog.
  List<CulturalTradition> get allTraditions =>
      List<CulturalTradition>.unmodifiable(_traditions);

  /// Unmodifiable view of all asterisms in this catalog.
  List<CulturalAsterism> get allAsterisms =>
      List<CulturalAsterism>.unmodifiable(_asterisms);

  /// Unmodifiable view of all interpretations in this catalog.
  List<CulturalInterpretation> get allInterpretations =>
      List<CulturalInterpretation>.unmodifiable(_interpretations);

  // ---------------------------------------------------------------------------
  // CulturalRepository Implementation
  // ---------------------------------------------------------------------------

  @override
  Future<List<CulturalTradition>> getSupportedTraditions() async {
    return List<CulturalTradition>.unmodifiable(_traditions);
  }

  @override
  Future<CulturalTradition?> getTraditionById(String id) async {
    for (final t in _traditions) {
      if (t.id == id) return t;
    }
    return null;
  }

  @override
  Future<List<CulturalAsterism>> getAsterismsForTradition({
    required String traditionId,
  }) async {
    return List<CulturalAsterism>.unmodifiable(
      _asterisms.where((a) => a.traditionId == traditionId).toList(),
    );
  }

  @override
  Future<CulturalAsterism?> getAsterismById(String id) async {
    for (final a in _asterisms) {
      if (a.id == id) return a;
    }
    return null;
  }

  @override
  Future<List<CulturalAsterism>> getAllAsterisms() async {
    return List<CulturalAsterism>.unmodifiable(_asterisms);
  }

  @override
  Future<List<CulturalInterpretation>> getInterpretationsForBody({
    required String celestialBodyId,
  }) async {
    return List<CulturalInterpretation>.unmodifiable(
      _interpretations.where((i) => i.starId == celestialBodyId).toList(),
    );
  }

  @override
  Future<CulturalInterpretation?> getInterpretationById(String id) async {
    for (final i in _interpretations) {
      if (i.id == id) return i;
    }
    return null;
  }

  @override
  Future<List<CulturalInterpretation>> getAllInterpretations() async {
    return List<CulturalInterpretation>.unmodifiable(_interpretations);
  }

  @override
  Future<ResearchVerification?> getVerificationMetadata({
    required String culturalEntityId,
  }) async {
    for (final a in _asterisms) {
      if (a.id == culturalEntityId) return a.verificationStatus;
    }
    for (final i in _interpretations) {
      if (i.id == culturalEntityId) return i.verificationStatus;
    }
    return null;
  }

  // ---------------------------------------------------------------------------
  // Source-Grounded Default Baseline Data
  // ---------------------------------------------------------------------------

  static List<CulturalTradition> _buildDefaultTraditions() {
    return [
      // 1. Vedic Nakshatras
      const CulturalTradition(
        id: 'vedic_nakshatras',
        name: LocalizedString(
          defaultText: 'Vedic Nakshatras',
          translations: {
            CulturalLocale.hiIn: 'वैदिक नक्षत्र',
            CulturalLocale.mrIn: 'वैदिक नक्षत्र',
            CulturalLocale.taIn: 'வேத நட்சத்திரங்கள்',
            CulturalLocale.teIn: 'వైదిక నక్షత్రాలు',
            CulturalLocale.enUs: 'Vedic Nakshatras',
          },
        ),
        region: 'Ancient India / Indo-Gangetic Plain',
        historicalEra: 'Vedic Period (c. 1500–500 BCE)',
        description: LocalizedString(
          defaultText:
              'Ecliptic lunar mansions and celestial lore documented in Vedic literature, '
              'utilized for sacred calendrical reckoning and cosmology.',
          translations: {
            CulturalLocale.hiIn:
                'वैदिक साहित्य में प्रलेखित चंद्र नक्षत्र और खगोलीय परंपराएं, जिनका उपयोग काल-गणना के लिए किया जाता था।',
          },
        ),
        primaryAttribution: Attribution(
          authorOrInstitution: 'Arthur Anthony Macdonell & Arthur Berriedale Keith',
          publicationTitle: 'Vedic Index of Names and Subjects (Vol. I & II)',
          publicationYear: 1912,
          doiOrIsbn: 'ISBN 978-8120804241',
          archiveUrl: 'https://archive.org/details/vedicindexofname01macduoft',
          citationSnippet: 'Entry on Nakṣatra, Vol. I, pp. 409-431',
        ),
      ),

      // 2. Classical Greco-Roman
      const CulturalTradition(
        id: 'greco_roman',
        name: LocalizedString(
          defaultText: 'Classical Greco-Roman',
          translations: {
            CulturalLocale.enUs: 'Classical Greco-Roman',
            CulturalLocale.hiIn: 'शास्त्रीय ग्रीको-रोमन',
          },
        ),
        region: 'Mediterranean Basin',
        historicalEra: 'Classical Antiquity (c. 8th century BCE – 2nd century CE)',
        description: LocalizedString(
          defaultText:
              'Classical Mediterranean celestial mythology and constellation traditions '
              'codified by Eudoxus, Aratus, and Claudius Ptolemy.',
        ),
        primaryAttribution: Attribution(
          authorOrInstitution: 'Claudius Ptolemy (tr. G. J. Toomer)',
          publicationTitle: "Ptolemy's Almagest",
          publicationYear: 1984,
          doiOrIsbn: 'ISBN 978-0691002606',
          archiveUrl: 'https://archive.org/details/ptolemysalmagest0000ptol',
          citationSnippet: 'Books VII and VIII: The Star Catalogue',
        ),
      ),
    ];
  }

  static List<CulturalAsterism> _buildDefaultAsterisms() {
    String id(String seed) => StableIdGenerator.generate(seed);

    final betelgeuseId = id('Betelgeuse');
    final rigelId = id('Rigel');

    return [
      // Classical Orion Anchor Asterism
      CulturalAsterism(
        id: 'asterism_greco_roman_orion',
        traditionId: 'greco_roman',
        indigenousName: const LocalizedString(
          defaultText: 'Ὠρίων',
          translations: {
            CulturalLocale.enUs: 'Orion',
          },
        ),
        transliteratedName: 'Ōrīōn',
        englishGloss: const LocalizedString(
          defaultText: 'The Hunter',
          translations: {
            CulturalLocale.hiIn: 'शिकारी',
          },
        ),
        memberStarIds: [betelgeuseId, rigelId],
        lineSegments: [
          ConstellationVectorSegment(
            startStarId: betelgeuseId,
            endStarId: rigelId,
            groupId: 'asterism_greco_roman_orion',
          ),
        ],
        mythicSummary: const LocalizedString(
          defaultText:
              'Giant hunter of Boeotian mythology placed among the stars, flanked by the hunting hound Canis Major.',
        ),
        verificationStatus: ResearchVerification(
          status: VerificationStatus.primarySourceVerified,
          reviewerNotes:
              'Attested in Ptolemy Almagest Book VII, ch. 5 (Constellation of Orion, stars 2 and 35).',
          lastVerifiedDate: DateTime.utc(2026, 1, 1),
        ),
        academicSource: const Attribution(
          authorOrInstitution: 'Claudius Ptolemy (tr. G. J. Toomer)',
          publicationTitle: "Ptolemy's Almagest",
          publicationYear: 1984,
          doiOrIsbn: 'ISBN 978-0691002606',
          archiveUrl: 'https://archive.org/details/ptolemysalmagest0000ptol',
          citationSnippet: 'Book VII, chapter 5: Constellation of Orion, stars 2 and 35',
        ),
      ),
    ];
  }

  static List<CulturalInterpretation> _buildDefaultInterpretations() {
    String id(String seed) => StableIdGenerator.generate(seed);

    final siriusId = id('Sirius');
    final betelgeuseId = id('Betelgeuse');

    return [
      // 1. Classical Kyon (Sirius)
      CulturalInterpretation(
        id: 'interp_greco_roman_sirius',
        starId: siriusId,
        traditionId: 'greco_roman',
        indigenousName: const LocalizedString(
          defaultText: 'Κύων',
          translations: {
            CulturalLocale.enUs: 'Kyon',
          },
        ),
        transliteratedName: 'Kýōn',
        englishGloss: const LocalizedString(
          defaultText: 'The Dog Star',
          translations: {
            CulturalLocale.hiIn: 'श्वान तारा',
          },
        ),
        mythicRole: const LocalizedString(
          defaultText: 'Principal hunting hound of Orion',
        ),
        mythicSummary: const LocalizedString(
          defaultText:
              'Scorching summer star whose heliacal rising portended the sweltering dog days of the Mediterranean summer.',
        ),
        verificationStatus: ResearchVerification(
          status: VerificationStatus.primarySourceVerified,
          reviewerNotes:
              'Identified in Ptolemy Almagest Book VIII, ch. 1 as Canis Major star 1.',
          lastVerifiedDate: DateTime.utc(2026, 1, 1),
        ),
        academicSource: const Attribution(
          authorOrInstitution: 'Claudius Ptolemy (tr. G. J. Toomer)',
          publicationTitle: "Ptolemy's Almagest",
          publicationYear: 1984,
          doiOrIsbn: 'ISBN 978-0691002606',
          archiveUrl: 'https://archive.org/details/ptolemysalmagest0000ptol',
          citationSnippet: 'Book VIII, chapter 1: Constellation of Canis Major, Star 1',
        ),
      ),

      // 2. Classical Betelgeuse (Right Shoulder of Orion)
      CulturalInterpretation(
        id: 'interp_greco_roman_betelgeuse',
        starId: betelgeuseId,
        traditionId: 'greco_roman',
        indigenousName: const LocalizedString(
          defaultText: 'Ὠρίωνος ὦμος',
          translations: {
            CulturalLocale.enUs: 'Right Shoulder of Orion',
          },
        ),
        transliteratedName: 'Ōrīōnos ōmos',
        englishGloss: const LocalizedString(
          defaultText: 'Right Shoulder of Orion',
        ),
        mythicRole: const LocalizedString(
          defaultText: 'Right shoulder anchor of the celestial hunter Orion',
        ),
        mythicSummary: const LocalizedString(
          defaultText:
              'Brilliant reddish star marking the right shoulder of the giant hunter Orion.',
        ),
        verificationStatus: ResearchVerification(
          status: VerificationStatus.primarySourceVerified,
          reviewerNotes:
              'Identified in Ptolemy Almagest Book VII, ch. 5 as Orion star 2 (Alpha Orionis).',
          lastVerifiedDate: DateTime.utc(2026, 1, 1),
        ),
        academicSource: const Attribution(
          authorOrInstitution: 'Claudius Ptolemy (tr. G. J. Toomer)',
          publicationTitle: "Ptolemy's Almagest",
          publicationYear: 1984,
          doiOrIsbn: 'ISBN 978-0691002606',
          archiveUrl: 'https://archive.org/details/ptolemysalmagest0000ptol',
          citationSnippet: 'Book VII, chapter 5: Constellation of Orion, Star 2',
        ),
      ),

      // 3. Vedic Ārdrā (Betelgeuse)
      CulturalInterpretation(
        id: 'interp_vedic_ardra',
        starId: betelgeuseId,
        traditionId: 'vedic_nakshatras',
        indigenousName: const LocalizedString(
          defaultText: 'आर्द्रा',
          translations: {
            CulturalLocale.hiIn: 'आर्द्रा',
            CulturalLocale.mrIn: 'आर्द्रा',
            CulturalLocale.enUs: 'Ardra',
          },
        ),
        transliteratedName: 'Ārdrā',
        englishGloss: const LocalizedString(
          defaultText: 'The Moist One / Teardrop',
        ),
        mythicRole: const LocalizedString(
          defaultText:
              'Presided over by Rudra, storm deity of transformative fury and renewal',
        ),
        mythicSummary: const LocalizedString(
          defaultText:
              'Sixth Nakshatra in the classical lunar mansion cycle. The single junction star (Yogatārā) '
              'was identified with Alpha Orionis (Betelgeuse) in nineteenth-century Indological coordinate reconciliations of the Surya Siddhanta.',
        ),
        verificationStatus: ResearchVerification(
          status: VerificationStatus.secondaryScholarlyConsensus,
          reviewerNotes:
              'Identification with Alpha Orionis is established through mathematical coordinates in Burgess & Whitney (1860); distinguished from modern speculative folklore.',
          lastVerifiedDate: DateTime.utc(2026, 1, 1),
        ),
        academicSource: const Attribution(
          authorOrInstitution: 'Ebenezer Burgess & William Dwight Whitney',
          publicationTitle:
              'Translation of the Surya-Siddhanta: A Text-Book of Hindu Astronomy',
          publicationYear: 1860,
          doiOrIsbn: 'ISBN 978-8120806122',
          archiveUrl: 'https://archive.org/details/translationsury00whitgoog',
          citationSnippet:
              'Chapter VIII, Verse 10: "The junction-star of Ardrā is Alpha Orionis"',
        ),
      ),
    ];
  }
}
