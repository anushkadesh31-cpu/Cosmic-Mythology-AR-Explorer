import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/data/catalog/simple_star_catalog.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/data/cultural/simple_cultural_catalog.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/id_generator.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/cultural/cultural_repository.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/cultural/research_verification.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/cultural/localized_string.dart';

void main() {
  group('SimpleCulturalCatalog - Default Source-Grounded Catalog', () {
    late SimpleCulturalCatalog catalog;
    late SimpleStarCatalog starCatalog;

    setUp(() {
      catalog = SimpleCulturalCatalog();
      starCatalog = SimpleStarCatalog();
    });

    test('implements CulturalRepository / ICulturalKnowledgeRepository interface', () {
      expect(catalog, isA<CulturalRepository>());
      expect(catalog, isA<ICulturalKnowledgeRepository>());
    });

    test('retrieves supported traditions with authentic metadata and attribution', () async {
      final traditions = await catalog.getSupportedTraditions();
      expect(traditions, isNotEmpty);
      expect(traditions.map((t) => t.id), containsAll(['vedic_nakshatras', 'greco_roman']));

      for (final tradition in traditions) {
        expect(tradition.name.defaultText.isNotEmpty, isTrue);
        expect(tradition.region.isNotEmpty, isTrue);
        expect(tradition.historicalEra.isNotEmpty, isTrue);
        expect(tradition.primaryAttribution.authorOrInstitution.isNotEmpty, isTrue);
        expect(tradition.primaryAttribution.publicationTitle.isNotEmpty, isTrue);
        expect(tradition.primaryAttribution.citationSnippet.isNotEmpty, isTrue);
      }
    });

    test('looks up tradition by ID accurately, returns null for non-existent', () async {
      final vedic = await catalog.getTraditionById('vedic_nakshatras');
      expect(vedic, isNotNull);
      expect(vedic!.id, 'vedic_nakshatras');
      expect(vedic.name.resolve(CulturalLocale.hiIn), 'वैदिक नक्षत्र');

      final unknown = await catalog.getTraditionById('non_existent_tradition');
      expect(unknown, isNull);
    });

    test('retrieves asterisms filtered by tradition and looks up by ID', () async {
      final greekAsterisms = await catalog.getAsterismsForTradition(traditionId: 'greco_roman');
      expect(greekAsterisms, isNotEmpty);
      expect(greekAsterisms.first.id, 'asterism_greco_roman_orion');

      final found = await catalog.getAsterismById('asterism_greco_roman_orion');
      expect(found, isNotNull);
      expect(found!.id, 'asterism_greco_roman_orion');
      expect(found.memberStarIds.length, greaterThanOrEqualTo(2));

      final notFound = await catalog.getAsterismById('invalid_id');
      expect(notFound, isNull);
    });

    test('retrieves interpretations for celestial bodies (stars)', () async {
      final betelgeuseId = StableIdGenerator.generate('Betelgeuse');
      final interpretations = await catalog.getInterpretationsForBody(celestialBodyId: betelgeuseId);

      expect(interpretations, isNotEmpty);
      // Betelgeuse has both Classical Greco-Roman and Vedic interpretations
      final traditionIds = interpretations.map((i) => i.traditionId).toList();
      expect(traditionIds, contains('greco_roman'));
      expect(traditionIds, contains('vedic_nakshatras'));

      // Look up specific interpretation by ID
      final ardra = await catalog.getInterpretationById('interp_vedic_ardra');
      expect(ardra, isNotNull);
      expect(ardra!.starId, betelgeuseId);
      expect(ardra.indigenousName.defaultText, 'आर्द्रा');
      expect(ardra.academicSource.publicationTitle, contains('Surya-Siddhanta'));
    });

    test('retrieves verification metadata for asterisms and interpretations', () async {
      final asterismVerification = await catalog.getVerificationMetadata(
        culturalEntityId: 'asterism_greco_roman_orion',
      );
      expect(asterismVerification, isNotNull);
      expect(asterismVerification!.status, VerificationStatus.primarySourceVerified);

      final ardraVerification = await catalog.getVerificationMetadata(
        culturalEntityId: 'interp_vedic_ardra',
      );
      expect(ardraVerification, isNotNull);
      expect(ardraVerification!.status, VerificationStatus.secondaryScholarlyConsensus);

      final nonExistent = await catalog.getVerificationMetadata(
        culturalEntityId: 'unknown_entity',
      );
      expect(nonExistent, isNull);
    });

    test('all member star IDs and line endpoints reference valid stable IDs in SimpleStarCatalog', () async {
      final allStars = starCatalog.getAll();
      final validStarIds = allStars.map((s) => s.id).toSet();

      final asterisms = await catalog.getAllAsterisms();
      for (final asterism in asterisms) {
        for (final starId in asterism.memberStarIds) {
          expect(
            validStarIds.contains(starId),
            isTrue,
            reason: 'Asterism ${asterism.id} references unknown star ID: $starId',
          );
        }
        for (final segment in asterism.lineSegments) {
          expect(
            validStarIds.contains(segment.startStarId),
            isTrue,
            reason: 'Segment startStarId in ${asterism.id} not found in star catalog',
          );
          expect(
            validStarIds.contains(segment.endStarId),
            isTrue,
            reason: 'Segment endStarId in ${asterism.id} not found in star catalog',
          );
        }
      }

      final interpretations = await catalog.getAllInterpretations();
      for (final interpretation in interpretations) {
        expect(
          validStarIds.contains(interpretation.starId),
          isTrue,
          reason: 'Interpretation ${interpretation.id} references unknown star ID: ${interpretation.starId}',
        );
      }
    });

    test('verification statuses distinguish primary sources from scholarly consensus and under review', () async {
      final interpretations = await catalog.getAllInterpretations();
      final statuses = interpretations.map((i) => i.verificationStatus.status).toSet();

      expect(statuses, contains(VerificationStatus.primarySourceVerified));
      expect(statuses, contains(VerificationStatus.secondaryScholarlyConsensus));
    });
  });

  group('SimpleCulturalCatalog - Empty Catalog', () {
    late SimpleCulturalCatalog emptyCatalog;

    setUp(() {
      emptyCatalog = SimpleCulturalCatalog.empty();
    });

    test('returns empty lists for all collection queries', () async {
      expect(await emptyCatalog.getSupportedTraditions(), isEmpty);
      expect(await emptyCatalog.getAllAsterisms(), isEmpty);
      expect(await emptyCatalog.getAllInterpretations(), isEmpty);
      expect(emptyCatalog.allTraditions, isEmpty);
      expect(emptyCatalog.allAsterisms, isEmpty);
      expect(emptyCatalog.allInterpretations, isEmpty);
    });

    test('returns empty list for filtered queries', () async {
      final asterisms = await emptyCatalog.getAsterismsForTradition(traditionId: 'vedic_nakshatras');
      expect(asterisms, isEmpty);

      final interpretations = await emptyCatalog.getInterpretationsForBody(celestialBodyId: 'star_123');
      expect(interpretations, isEmpty);
    });

    test('returns null for individual ID queries', () async {
      expect(await emptyCatalog.getTraditionById('vedic_nakshatras'), isNull);
      expect(await emptyCatalog.getAsterismById('asterism_1'), isNull);
      expect(await emptyCatalog.getInterpretationById('interp_1'), isNull);
      expect(await emptyCatalog.getVerificationMetadata(culturalEntityId: 'any_id'), isNull);
    });
  });
}
