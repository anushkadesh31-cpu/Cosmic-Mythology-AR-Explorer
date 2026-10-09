// lib/core/cosmic_core/domain/cultural/research_verification.dart

/// Categorization of academic verification rigor and source authority.
enum VerificationStatus {
  /// Attested in direct historical treatises, epigraphic records, or primary source texts.
  primarySourceVerified,

  /// Established by broad scholarly consensus in critical editions or standard reference works.
  secondaryScholarlyConsensus,

  /// Documented by recognized cultural practitioners, knowledge holders, or tribal authorities.
  oralTraditionDocumented,

  /// Working hypothesis or preliminary entry undergoing research and advisory review.
  underReview,
}

/// Represents the research peer-review status and cultural sensitivity clearance
/// of an entry before public presentation.
class ResearchVerification {
  /// The verified rigor level of the entry.
  final VerificationStatus status;

  /// Reviewer notes, critical commentary, or caveats regarding historical interpretation.
  final String reviewerNotes;

  /// Timestamp when the entry was last verified by advisory review.
  final DateTime lastVerifiedDate;

  /// Whether the entry has passed cultural sensitivity and sacred protocol checks.
  final bool sensitivityReviewPassed;

  const ResearchVerification({
    required this.status,
    this.reviewerNotes = '',
    required this.lastVerifiedDate,
    this.sensitivityReviewPassed = true,
  });

  /// Convenience factory for preliminary unverified entries.
  factory ResearchVerification.underReview({
    String reviewerNotes = 'Awaiting scholarly peer-review verification.',
    DateTime? reviewDate,
  }) {
    return ResearchVerification(
      status: VerificationStatus.underReview,
      reviewerNotes: reviewerNotes,
      lastVerifiedDate: reviewDate ?? DateTime.utc(2026, 1, 1),
      sensitivityReviewPassed: true,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResearchVerification &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          reviewerNotes == other.reviewerNotes &&
          lastVerifiedDate == other.lastVerifiedDate &&
          sensitivityReviewPassed == other.sensitivityReviewPassed;

  @override
  int get hashCode => Object.hash(
        status,
        reviewerNotes,
        lastVerifiedDate,
        sensitivityReviewPassed,
      );

  @override
  String toString() =>
      'ResearchVerification($status, sensitivity: $sensitivityReviewPassed)';
}
