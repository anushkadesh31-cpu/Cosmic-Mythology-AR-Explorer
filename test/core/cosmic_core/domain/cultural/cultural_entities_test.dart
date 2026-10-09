import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/constellation_vector_segment.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/cultural/attribution.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/cultural/cultural_asterism.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/cultural/cultural_interpretation.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/cultural/cultural_tradition.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/cultural/localized_string.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/cultural/research_verification.dart';

void main() {
  const sampleAttribution = Attribution(
    authorOrInstitution: 'Subhash Kak',
    publicationTitle: 'The Astronomical Code of the Rgveda',
    publicationYear: 2000,
    citationSnippet: 'Section 4, pp. 45-52',
  );

  final sampleVerification = ResearchVerification(
    status: VerificationStatus.primarySourceVerified,
    reviewerNotes: 'Verified against text.',
    lastVerifiedDate: DateTime.utc(2026, 1, 1),
  );

  group('CulturalTradition', () {
    test('constructs and asserts non-empty identifiers', () {
      const tradition = CulturalTradition(
        id: 'vedic_nakshatras',
        name: LocalizedString(defaultText: 'Vedic Nakshatras'),
        region: 'Ancient India',
        historicalEra: 'Vedic Period',
        description: LocalizedString(defaultText: 'Lunar mansions system.'),
        primaryAttribution: sampleAttribution,
      );

      expect(tradition.id, 'vedic_nakshatras');
      expect(tradition.name.defaultText, 'Vedic Nakshatras');
      expect(tradition.region, 'Ancient India');
      expect(tradition.historicalEra, 'Vedic Period');
      expect(tradition.primaryAttribution, sampleAttribution);
    });

    test('validates non-empty fields with assertions', () {
      expect(
        () => CulturalTradition(
          id: '',
          name: const LocalizedString(defaultText: 'Name'),
          region: 'Region',
          historicalEra: 'Era',
          description: const LocalizedString(defaultText: 'Desc'),
          primaryAttribution: sampleAttribution,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => CulturalTradition(
          id: 'trad_id',
          name: const LocalizedString(defaultText: 'Name'),
          region: '',
          historicalEra: 'Era',
          description: const LocalizedString(defaultText: 'Desc'),
          primaryAttribution: sampleAttribution,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('CulturalAsterism', () {
    test('accepts two distinct star IDs', () {
      final asterism = CulturalAsterism(
        id: 'asterism_orion',
        traditionId: 'greco_roman',
        indigenousName: const LocalizedString(defaultText: 'Ὠρίων'),
        transliteratedName: 'Ōrīōn',
        englishGloss: const LocalizedString(defaultText: 'The Hunter'),
        memberStarIds: const ['star_betelgeuse', 'star_rigel'],
        lineSegments: const [
          ConstellationVectorSegment(startStarId: 'star_betelgeuse', endStarId: 'star_rigel'),
        ],
        mythicSummary: const LocalizedString(defaultText: 'The Boeotian giant.'),
        verificationStatus: sampleVerification,
        academicSource: sampleAttribution,
      );

      expect(asterism.id, 'asterism_orion');
      expect(asterism.memberStarIds.length, 2);
      expect(asterism.lineSegments.length, 1);
    });

    test('rejects a single star ID with assertion error', () {
      expect(
        () => CulturalAsterism(
          id: 'single_star_asterism',
          traditionId: 'vedic_nakshatras',
          indigenousName: const LocalizedString(defaultText: 'SingleStar'),
          englishGloss: const LocalizedString(defaultText: 'SingleStar'),
          memberStarIds: const ['star_single'],
          mythicSummary: const LocalizedString(defaultText: 'Invalid single star asterism.'),
          verificationStatus: sampleVerification,
          academicSource: sampleAttribution,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('rejects two repeated copies of the same star ID', () {
      expect(
        () => CulturalAsterism(
          id: 'duplicate_star_asterism',
          traditionId: 'greco_roman',
          indigenousName: const LocalizedString(defaultText: 'DuplicateStar'),
          englishGloss: const LocalizedString(defaultText: 'DuplicateStar'),
          memberStarIds: const ['star_sirius', 'star_sirius'],
          mythicSummary: const LocalizedString(defaultText: 'Invalid duplicate star asterism.'),
          verificationStatus: sampleVerification,
          academicSource: sampleAttribution,
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('accepts a valid list containing three or more distinct star IDs', () {
      final asterism = CulturalAsterism(
        id: 'asterism_summer_triangle',
        traditionId: 'greco_roman',
        indigenousName: const LocalizedString(defaultText: 'Summer Triangle'),
        englishGloss: const LocalizedString(defaultText: 'Summer Triangle'),
        memberStarIds: const ['star_vega', 'star_altair', 'star_deneb'],
        mythicSummary: const LocalizedString(defaultText: 'Prominent navigational asterism.'),
        verificationStatus: sampleVerification,
        academicSource: sampleAttribution,
      );

      expect(asterism.memberStarIds.length, 3);
      expect(asterism.memberStarIds.toSet().length, 3);
    });
  });

  group('CulturalInterpretation', () {
    test('constructs for individual celestial object', () {
      final interp = CulturalInterpretation(
        id: 'interp_vedic_ardra',
        starId: 'star_betelgeuse',
        traditionId: 'vedic_nakshatras',
        indigenousName: const LocalizedString(defaultText: 'आर्द्रा'),
        transliteratedName: 'Ārdrā',
        englishGloss: const LocalizedString(defaultText: 'The Moist One'),
        mythicRole: const LocalizedString(defaultText: 'Rudra'),
        mythicSummary: const LocalizedString(defaultText: 'Sixth Nakshatra.'),
        verificationStatus: sampleVerification,
        academicSource: sampleAttribution,
      );

      expect(interp.id, 'interp_vedic_ardra');
      expect(interp.starId, 'star_betelgeuse');
      expect(interp.celestialBodyId, 'star_betelgeuse');
      expect(interp.traditionId, 'vedic_nakshatras');
      expect(interp.indigenousName.defaultText, 'आर्द्रा');
      expect(interp.mythicRole?.defaultText, 'Rudra');
    });

    test('validates non-empty fields with assertions', () {
      expect(
        () => CulturalInterpretation(
          id: '',
          starId: 'star_1',
          traditionId: 'trad_1',
          indigenousName: const LocalizedString(defaultText: 'Name'),
          mythicSummary: const LocalizedString(defaultText: 'Summary'),
          verificationStatus: sampleVerification,
          academicSource: sampleAttribution,
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => CulturalInterpretation(
          id: 'id_1',
          starId: '',
          traditionId: 'trad_1',
          indigenousName: const LocalizedString(defaultText: 'Name'),
          mythicSummary: const LocalizedString(defaultText: 'Summary'),
          verificationStatus: sampleVerification,
          academicSource: sampleAttribution,
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}
