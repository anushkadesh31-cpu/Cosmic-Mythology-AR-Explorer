// lib/core/cosmic_core/domain/cultural/attribution.dart

/// Represents academic bibliographic attribution and scholarly provenance
/// for cultural astronomy constructs, star identifications, and mythic lore.
class Attribution {
  /// Primary author, scholar, translator, or cultural institution.
  final String authorOrInstitution;

  /// Title of historical manuscript, critical edition, or peer-reviewed publication.
  final String publicationTitle;

  /// Year of publication or scholarly translation (if known).
  final int? publicationYear;

  /// Persistent scholarly identifier (e.g., DOI or ISBN).
  final String? doiOrIsbn;

  /// URL to archival digital repository or open-access scholarly scan.
  final String? archiveUrl;

  /// Precise section, chapter, verse, or hymn reference (e.g., "Taittiriya Samhita 4.4.10").
  final String citationSnippet;

  const Attribution({
    required this.authorOrInstitution,
    required this.publicationTitle,
    this.publicationYear,
    this.doiOrIsbn,
    this.archiveUrl,
    required this.citationSnippet,
  })  : assert(authorOrInstitution.length > 0, 'authorOrInstitution cannot be empty'),
        assert(publicationTitle.length > 0, 'publicationTitle cannot be empty'),
        assert(citationSnippet.length > 0, 'citationSnippet cannot be empty');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Attribution &&
          runtimeType == other.runtimeType &&
          authorOrInstitution == other.authorOrInstitution &&
          publicationTitle == other.publicationTitle &&
          publicationYear == other.publicationYear &&
          doiOrIsbn == other.doiOrIsbn &&
          archiveUrl == other.archiveUrl &&
          citationSnippet == other.citationSnippet;

  @override
  int get hashCode => Object.hash(
        authorOrInstitution,
        publicationTitle,
        publicationYear,
        doiOrIsbn,
        archiveUrl,
        citationSnippet,
      );

  @override
  String toString() =>
      'Attribution($authorOrInstitution, "$publicationTitle", $citationSnippet)';
}
