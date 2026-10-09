import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/cultural/attribution.dart';

void main() {
  group('Attribution', () {
    test('constructs with valid parameters', () {
      const attr = Attribution(
        authorOrInstitution: 'Claudius Ptolemy (tr. G. J. Toomer)',
        publicationTitle: "Ptolemy's Almagest",
        publicationYear: 1984,
        doiOrIsbn: 'ISBN 978-0691002606',
        archiveUrl: 'https://archive.org/details/ptolemysalmagest0000ptol',
        citationSnippet: 'Book VII, chapter 5',
      );

      expect(attr.authorOrInstitution, 'Claudius Ptolemy (tr. G. J. Toomer)');
      expect(attr.publicationTitle, "Ptolemy's Almagest");
      expect(attr.publicationYear, 1984);
      expect(attr.doiOrIsbn, 'ISBN 978-0691002606');
      expect(attr.archiveUrl, 'https://archive.org/details/ptolemysalmagest0000ptol');
      expect(attr.citationSnippet, 'Book VII, chapter 5');
    });

    test('validates non-empty required fields via assertions', () {
      expect(
        () => Attribution(
          authorOrInstitution: '',
          publicationTitle: 'Title',
          citationSnippet: 'Snippet',
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => Attribution(
          authorOrInstitution: 'Author',
          publicationTitle: '',
          citationSnippet: 'Snippet',
        ),
        throwsA(isA<AssertionError>()),
      );

      expect(
        () => Attribution(
          authorOrInstitution: 'Author',
          publicationTitle: 'Title',
          citationSnippet: '',
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('supports value equality and hashCode', () {
      const a1 = Attribution(
        authorOrInstitution: 'Author A',
        publicationTitle: 'Book 1',
        citationSnippet: 'Page 10',
      );
      const a2 = Attribution(
        authorOrInstitution: 'Author A',
        publicationTitle: 'Book 1',
        citationSnippet: 'Page 10',
      );
      const a3 = Attribution(
        authorOrInstitution: 'Author B',
        publicationTitle: 'Book 1',
        citationSnippet: 'Page 10',
      );

      expect(a1, equals(a2));
      expect(a1.hashCode, equals(a2.hashCode));
      expect(a1, isNot(equals(a3)));
    });
  });
}
