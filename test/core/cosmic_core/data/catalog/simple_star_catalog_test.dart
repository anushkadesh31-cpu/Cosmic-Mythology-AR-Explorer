// test/core/cosmic_core/data/catalog/simple_star_catalog_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/data/catalog/simple_star_catalog.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/star.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/id_generator.dart';

void main() {
  final catalog = SimpleStarCatalog();

  group('SimpleStarCatalog', () {
    test('returns correct star by stable id', () async {
      final id = StableIdGenerator.generate('Sirius');
      final star = await catalog.getById(id);
      expect(star, isA<Star>());
      expect(star?.name, 'Sirius');
    });

    test('ids are stable', () async {
      final id1 = StableIdGenerator.generate('Vega');
      final id2 = StableIdGenerator.generate('Vega');
      expect(id1, equals(id2));
    });

    test('getByType returns all stars', () async {
      final stars = await catalog.getByType(type: 'star');
      expect(stars, isA<List<Star>>());
      expect(stars.length, 7);
    });

    test('search finds by name and alternate name', () async {
      final results1 = await catalog.search('Polaris');
      expect(results1.length, 1);
      expect(results1.first.name, 'Polaris');

      final results2 = await catalog.search('Dog'); // part of alternate name for Sirius
      expect(results2.length, 1);
      expect(results2.first.name, 'Sirius');
    });

    test('unknown id returns null', () async {
      final star = await catalog.getById('nonexistent-id');
      expect(star, isNull);
    });

    test('getLineSegments returns segments where all endpoint IDs exist in catalog', () async {
      final segments = catalog.getLineSegments();
      expect(segments, isNotEmpty);
      expect(segments.length, 4);

      for (final seg in segments) {
        final startStar = await catalog.getById(seg.startStarId);
        final endStar = await catalog.getById(seg.endStarId);
        expect(startStar, isNotNull, reason: 'startStarId ${seg.startStarId} must exist');
        expect(endStar, isNotNull, reason: 'endStarId ${seg.endStarId} must exist');
      }

      final asyncSegments = await catalog.getLineSegmentsAsync();
      expect(asyncSegments, equals(segments));
    });
  });
}
