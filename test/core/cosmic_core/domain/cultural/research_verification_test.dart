import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/cultural/research_verification.dart';

void main() {
  group('ResearchVerification', () {
    test('supports all four VerificationStatus categories', () {
      expect(VerificationStatus.values, contains(VerificationStatus.primarySourceVerified));
      expect(VerificationStatus.values, contains(VerificationStatus.secondaryScholarlyConsensus));
      expect(VerificationStatus.values, contains(VerificationStatus.oralTraditionDocumented));
      expect(VerificationStatus.values, contains(VerificationStatus.underReview));
      expect(VerificationStatus.values.length, 4);
    });

    test('constructs with explicit status and properties', () {
      final date = DateTime.utc(2026, 3, 15);
      final ver = ResearchVerification(
        status: VerificationStatus.primarySourceVerified,
        reviewerNotes: 'Verified against critical edition.',
        lastVerifiedDate: date,
        sensitivityReviewPassed: true,
      );

      expect(ver.status, VerificationStatus.primarySourceVerified);
      expect(ver.reviewerNotes, 'Verified against critical edition.');
      expect(ver.lastVerifiedDate, date);
      expect(ver.sensitivityReviewPassed, isTrue);
    });

    test('underReview factory defaults to underReview status and fallback date', () {
      final ver = ResearchVerification.underReview();

      expect(ver.status, VerificationStatus.underReview);
      expect(ver.reviewerNotes, contains('Awaiting'));
      expect(ver.sensitivityReviewPassed, isTrue);
    });

    test('supports value equality and hashCode', () {
      final d1 = DateTime.utc(2026, 1, 1);
      final v1 = ResearchVerification(
        status: VerificationStatus.secondaryScholarlyConsensus,
        reviewerNotes: 'Note',
        lastVerifiedDate: d1,
        sensitivityReviewPassed: true,
      );
      final v2 = ResearchVerification(
        status: VerificationStatus.secondaryScholarlyConsensus,
        reviewerNotes: 'Note',
        lastVerifiedDate: d1,
        sensitivityReviewPassed: true,
      );
      final v3 = ResearchVerification(
        status: VerificationStatus.underReview,
        reviewerNotes: 'Note',
        lastVerifiedDate: d1,
        sensitivityReviewPassed: true,
      );

      expect(v1, equals(v2));
      expect(v1.hashCode, equals(v2.hashCode));
      expect(v1, isNot(equals(v3)));
    });
  });
}
