// lib/core/cosmic_core/data/catalog/simple_star_catalog.dart

import 'dart:async';

import '../../domain/celestial/celestial_repository.dart';
import '../../domain/celestial/star.dart';
import '../../domain/celestial/id_generator.dart';
import '../../domain/celestial/constellation_vector_segment.dart';
import '../../astronomy/coordinates/equatorial_coordinate.dart';

/// In‑memory implementation of [CelestialRepository] that provides a small,
/// static catalog of well‑known stars. This is pure‑Dart and contains no Flutter
/// dependencies, making it suitable for the Cosmic Core.
class SimpleStarCatalog implements CelestialRepository {
  // --------------------------------------------------------------------------
  // Private static data
  // --------------------------------------------------------------------------
  static final List<Star> _stars = _buildStars();
  static final List<ConstellationVectorSegment> _lineSegments = _buildLineSegments();

  static List<Star> _buildStars() {
    // Helper to generate a stable ID from a seed (e.g., the common name).
    String id(String seed) => StableIdGenerator.generate(seed);

    // Constellation IDs – generated once for reuse.
    final constIdCanisMajor = id('Canis Major');
    final constIdOrion = id('Orion');
    final constIdUrsaMinor = id('Ursa Minor');
    final constIdLyra = id('Lyra');
    final constIdAquila = id('Aquila');
    final constIdCygnus = id('Cygnus');

    return [
      // Sirius (Alpha Canis Majoris)
      Star(
        id: id('Sirius'),
        name: 'Sirius',
        alternateNames: ['Alpha Canis Majoris', 'Dog Star'],
        equatorialCoordinate: const EquatorialCoordinate(
          rightAscensionHours: 6.752472,
          declinationDegrees: -16.716111,
        ),
        apparentMagnitude: -1.46,
        distanceLy: 8.6,
        spectralClass: 'A1V',
        constellationId: constIdCanisMajor,
      ),
      // Betelgeuse (Alpha Orionis)
      Star(
        id: id('Betelgeuse'),
        name: 'Betelgeuse',
        alternateNames: ['Alpha Orionis'],
        equatorialCoordinate: const EquatorialCoordinate(
          rightAscensionHours: 5.919529,
          declinationDegrees: 7.407064,
        ),
        apparentMagnitude: 0.42,
        distanceLy: 642.5,
        spectralClass: 'M2Iab',
        constellationId: constIdOrion,
      ),
      // Rigel (Beta Orionis)
      Star(
        id: id('Rigel'),
        name: 'Rigel',
        alternateNames: ['Beta Orionis'],
        equatorialCoordinate: const EquatorialCoordinate(
          rightAscensionHours: 5.242298,
          declinationDegrees: -8.201639,
        ),
        apparentMagnitude: 0.13,
        distanceLy: 860.0,
        spectralClass: 'B8Ia',
        constellationId: constIdOrion,
      ),
      // Polaris (Alpha Ursae Minoris)
      Star(
        id: id('Polaris'),
        name: 'Polaris',
        alternateNames: ['Alpha Ursae Minoris', 'North Star'],
        equatorialCoordinate: const EquatorialCoordinate(
          rightAscensionHours: 2.530301,
          declinationDegrees: 89.264109,
        ),
        apparentMagnitude: 1.98,
        distanceLy: 433.0,
        spectralClass: 'F7Ib',
        constellationId: constIdUrsaMinor,
      ),
      // Vega (Alpha Lyrae)
      Star(
        id: id('Vega'),
        name: 'Vega',
        alternateNames: ['Alpha Lyrae'],
        equatorialCoordinate: const EquatorialCoordinate(
          rightAscensionHours: 18.615649,
          declinationDegrees: 38.783689,
        ),
        apparentMagnitude: 0.03,
        distanceLy: 25.0,
        spectralClass: 'A0V',
        constellationId: constIdLyra,
      ),
      // Altair (Alpha Aquilae)
      Star(
        id: id('Altair'),
        name: 'Altair',
        alternateNames: ['Alpha Aquilae'],
        equatorialCoordinate: const EquatorialCoordinate(
          rightAscensionHours: 19.846389,
          declinationDegrees: 8.868322,
        ),
        apparentMagnitude: 0.77,
        distanceLy: 16.7,
        spectralClass: 'A7V',
        constellationId: constIdAquila,
      ),
      // Deneb (Alpha Cygni)
      Star(
        id: id('Deneb'),
        name: 'Deneb',
        alternateNames: ['Alpha Cygni'],
        equatorialCoordinate: const EquatorialCoordinate(
          rightAscensionHours: 20.690531,
          declinationDegrees: 45.280338,
        ),
        apparentMagnitude: 1.25,
        distanceLy: 2600.0,
        spectralClass: 'A2Ia',
        constellationId: constIdCygnus,
      ),
    ];
  }

  static List<ConstellationVectorSegment> _buildLineSegments() {
    String id(String seed) => StableIdGenerator.generate(seed);

    final constIdOrion = id('Orion');
    final asterismIdSummerTriangle = id('Summer Triangle');

    return [
      // Summer Triangle Asterism (Vega - Altair - Deneb)
      // Note: An iconic astronomical asterism connecting prominent bright stars,
      // not an official IAU constellation boundary.
      ConstellationVectorSegment(
        startStarId: id('Vega'),
        endStarId: id('Altair'),
        groupId: asterismIdSummerTriangle,
      ),
      ConstellationVectorSegment(
        startStarId: id('Altair'),
        endStarId: id('Deneb'),
        groupId: asterismIdSummerTriangle,
      ),
      ConstellationVectorSegment(
        startStarId: id('Deneb'),
        endStarId: id('Vega'),
        groupId: asterismIdSummerTriangle,
      ),

      // Orion Primary Anchor Baseline (Betelgeuse - Rigel)
      // Note: Illustrative linework connecting Orion's primary catalog anchors;
      // not an official IAU constellation boundary.
      ConstellationVectorSegment(
        startStarId: id('Betelgeuse'),
        endStarId: id('Rigel'),
        groupId: constIdOrion,
      ),
    ];
  }

  // Quick lookup map by stable ID.
  final Map<String, Star> _byId = {for (var s in _stars) s.id: s};

  /// Synchronous access to all catalog stars.
  static List<Star> get allStars => List<Star>.unmodifiable(_stars);

  /// Synchronous access to all defined line segments.
  static List<ConstellationVectorSegment> get allLineSegments =>
      List<ConstellationVectorSegment>.unmodifiable(_lineSegments);

  /// Returns all stars in the catalog synchronously.
  List<Star> getAll() => List<Star>.unmodifiable(_stars);

  /// Returns all constellation and asterism line segments synchronously.
  List<ConstellationVectorSegment> getLineSegments() =>
      List<ConstellationVectorSegment>.unmodifiable(_lineSegments);

  /// Returns all constellation and asterism line segments asynchronously.
  Future<List<ConstellationVectorSegment>> getLineSegmentsAsync() async =>
      List<ConstellationVectorSegment>.unmodifiable(_lineSegments);

  @override
  Future<Star?> getById(String id) async => _byId[id];

  @override
  Future<List<Star>> getByType({required String type}) async {
    if (type.toLowerCase() == 'star') {
      return List<Star>.unmodifiable(_stars);
    }
    return [];
  }

  @override
  Future<List<Star>> search(String query) async {
    final lower = query.toLowerCase();
    return _stars.where((s) {
      final nameMatch = s.name.toLowerCase().contains(lower);
      final altMatch = s.alternateNames?.any((a) => a.toLowerCase().contains(lower)) ?? false;
      return nameMatch || altMatch;
    }).toList();
  }
}
