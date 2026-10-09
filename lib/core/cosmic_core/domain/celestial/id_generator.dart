// lib/core/cosmic_core/domain/celestial/id_generator.dart

import 'dart:convert';

/// Simple deterministic stable identifier generator based on input seed.
/// For production you might replace with UUID or database‑generated IDs.
class StableIdGenerator {
  /// Generates a stable identifier string from the provided [seed].
  /// The same seed will always produce the same identifier.
  static String generate(String seed) {
    // Simple deterministic hash algorithm.
    final bytes = utf8.encode(seed);
    int hash = 0;
    const int prime = 31;
    for (var b in bytes) {
      hash = (hash * prime + b) & 0xFFFFFFFF;
    }
    // Convert to hex and ensure at least 10 characters by padding.
    final hex = hash.toRadixString(16).padLeft(10, '0');
    return hex;
  }
}
