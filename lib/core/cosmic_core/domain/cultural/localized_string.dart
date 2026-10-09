// lib/core/cosmic_core/domain/cultural/localized_string.dart

/// Supported cultural and regional linguistic locales for nomenclature resolution.
enum CulturalLocale {
  enUs, // English (Universal)
  hiIn, // Hindi (हिन्दी)
  mrIn, // Marathi (मराठी)
  taIn, // Tamil (தமிழ்)
  teIn, // Telugu (తెలుగు)
}

/// A pure-Dart cultural nomenclature resolver that maps traditional names
/// to supported regional languages, falling back to canonical default text.
class LocalizedString {
  /// The canonical default text (typically in primary scholarly language or transliteration).
  final String defaultText;

  /// Map of regional locale translations.
  final Map<CulturalLocale, String> translations;

  const LocalizedString({
    required this.defaultText,
    this.translations = const {},
  }) : assert(defaultText.length > 0, 'defaultText cannot be empty');

  /// Resolves the string for a given [locale], falling back to [defaultText].
  String resolve(CulturalLocale locale) => translations[locale] ?? defaultText;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LocalizedString || runtimeType != other.runtimeType) {
      return false;
    }
    if (defaultText != other.defaultText ||
        translations.length != other.translations.length) {
      return false;
    }
    for (final entry in translations.entries) {
      if (other.translations[entry.key] != entry.value) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        defaultText,
        Object.hashAllUnordered(
          translations.entries.map((e) => Object.hash(e.key, e.value)),
        ),
      );

  @override
  String toString() => defaultText;
}
