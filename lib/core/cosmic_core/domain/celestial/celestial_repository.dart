// lib/core/cosmic_core/domain/celestial/celestial_repository.dart

import 'celestial_object.dart';

/// Abstract repository defining contract for accessing celestial objects.
///
/// Implementations may fetch data from a local cache, remote API, or database.
/// This interface purposefully avoids any Flutter dependencies to keep the
/// core pure‑Dart.
abstract class CelestialRepository {
  /// Retrieve a [CelestialObject] by its stable identifier.
  Future<CelestialObject?> getById(String id);

  /// Retrieve all objects of a given [type].
  Future<List<CelestialObject>> getByType({
    required String type, // type name, e.g. 'star', 'planet', etc.
  });

  /// Search objects by a free‑text query against name and alternateNames.
  Future<List<CelestialObject>> search(String query);
}
