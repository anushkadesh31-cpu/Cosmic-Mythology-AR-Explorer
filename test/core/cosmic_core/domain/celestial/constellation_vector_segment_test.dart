// test/core/cosmic_core/domain/celestial/constellation_vector_segment_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/constellation_vector_segment.dart';

void main() {
  group('ConstellationVectorSegment', () {
    test('instantiates with valid start and end IDs', () {
      const segment = ConstellationVectorSegment(
        startStarId: 'star-vega',
        endStarId: 'star-altair',
        groupId: 'summer_triangle',
      );

      expect(segment.startStarId, 'star-vega');
      expect(segment.endStarId, 'star-altair');
      expect(segment.groupId, 'summer_triangle');
    });

    test('equality and hashCode match for identical properties', () {
      const seg1 = ConstellationVectorSegment(
        startStarId: 'star-a',
        endStarId: 'star-b',
        groupId: 'grp-1',
      );
      const seg2 = ConstellationVectorSegment(
        startStarId: 'star-a',
        endStarId: 'star-b',
        groupId: 'grp-1',
      );
      const seg3 = ConstellationVectorSegment(
        startStarId: 'star-a',
        endStarId: 'star-c',
        groupId: 'grp-1',
      );

      expect(seg1, equals(seg2));
      expect(seg1.hashCode, equals(seg2.hashCode));
      expect(seg1, isNot(equals(seg3)));
    });

    test('empty endpoint IDs throw assertion error', () {
      expect(
        () => ConstellationVectorSegment(
          startStarId: '',
          endStarId: 'star-b',
        ),
        throwsAssertionError,
      );

      expect(
        () => ConstellationVectorSegment(
          startStarId: 'star-a',
          endStarId: '',
        ),
        throwsAssertionError,
      );
    });

    test('toString formats meaningfully', () {
      const seg = ConstellationVectorSegment(
        startStarId: 'star-1',
        endStarId: 'star-2',
        groupId: 'orion',
      );
      expect(seg.toString(), contains('star-1 -> star-2'));
      expect(seg.toString(), contains('orion'));
    });
  });
}
