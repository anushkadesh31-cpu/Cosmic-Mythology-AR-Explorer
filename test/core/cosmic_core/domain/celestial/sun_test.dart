// test/core/cosmic_core/domain/celestial/sun_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/sun.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/id_generator.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/celestial/celestial_object_type.dart';

void main() {
  test('Sun model creates with stable ID', () {
    final id = StableIdGenerator.generate('Sun');
    final sun = Sun(
      id: id,
      name: 'Sun',
    );
    expect(sun.id, id);
    expect(sun.name, 'Sun');
    expect(sun.apparentMagnitude, -26.74);
    expect(sun.radiusKm, 696340);
    expect(sun.type, CelestialObjectType.sun);
  });
}
