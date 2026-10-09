import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/star.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/planet.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/sun.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/cultural/cultural_interpretation.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/cultural/cultural_asterism.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/astronomy/coordinates/equatorial_coordinate.dart';

void main() {
  group('Scientific / Cultural Separation Boundary', () {
    test('Scientific Star must never be a CulturalInterpretation or CulturalAsterism', () {
      final star = Star(
        id: 'star-001',
        name: 'Betelgeuse',
        equatorialCoordinate: const EquatorialCoordinate(
          rightAscensionHours: 5.919,
          declinationDegrees: 7.407,
        ),
        apparentMagnitude: 0.42,
        distanceLy: 642.5,
        spectralClass: 'M2Iab',
      );

      // Verify strict type separation
      expect(star, isNot(isA<CulturalInterpretation>()));
      expect(star, isNot(isA<CulturalAsterism>()));
    });

    test('Scientific Planet and Sun must never be cultural models', () {
      final sun = Sun(
        id: 'sun-001',
        name: 'Sun',
        equatorialCoordinate: const EquatorialCoordinate(
          rightAscensionHours: 0.0,
          declinationDegrees: 0.0,
        ),
        apparentMagnitude: -26.74,
      );

      final planet = Planet(
        id: 'planet-001',
        name: 'Mars',
        equatorialCoordinate: const EquatorialCoordinate(
          rightAscensionHours: 1.0,
          declinationDegrees: 2.0,
        ),
        apparentMagnitude: -1.5,
        distanceAu: 1.524,
      );

      expect(sun, isNot(isA<CulturalInterpretation>()));
      expect(planet, isNot(isA<CulturalInterpretation>()));
    });

    test('All Cosmic Core files must be pure Dart without importing package:flutter', () {
      final cosmicCoreDir = Directory('lib/core/cosmic_core');
      expect(cosmicCoreDir.existsSync(), isTrue);

      final dartFiles = cosmicCoreDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'));

      for (final file in dartFiles) {
        final content = file.readAsStringSync();
        expect(
          content.contains("import 'package:flutter/"),
          isFalse,
          reason: 'File ${file.path} violates pure-Dart boundary by importing package:flutter',
        );
      }
    });
  });
}
