// test/core/cosmic_core/bridges/ar_telemetry_packet_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/bridges/ar_telemetry_packet.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/observer/observer.dart';
import 'package:cosmic_mythology_ar/core/cosmic_core/domain/time/observation_time.dart';

void main() {
  group('ArTelemetryPacket', () {
    final observer = Observer(latitude: 0.0, longitude: 0.0);
    final time = ObservationTime(DateTime.utc(2023, 1, 1, 0, 0, 0));
    final visibleIds = ['star1', 'star2'];

    test('constructs with required fields', () {
      final packet = ArTelemetryPacket(
        observer: observer,
        observationTime: time,
        visibleObjectIds: visibleIds,
      );
      expect(packet.observer, observer);
      expect(packet.observationTime, time);
      expect(packet.selectedObjectId, isNull);
      expect(packet.visibleObjectIds, visibleIds);
    });

    test('list is immutable', () {
      final packet = ArTelemetryPacket(
        observer: observer,
        observationTime: time,
        visibleObjectIds: visibleIds,
      );
      expect(() => packet.visibleObjectIds.add('star3'), throwsUnsupportedError);
    });

    test('equality and hashCode', () {
      final packet1 = ArTelemetryPacket(
        observer: observer,
        observationTime: time,
        selectedObjectId: 'star1',
        visibleObjectIds: visibleIds,
      );
      final packet2 = ArTelemetryPacket(
        observer: observer,
        observationTime: time,
        selectedObjectId: 'star1',
        visibleObjectIds: List.from(visibleIds),
      );
      expect(packet1, equals(packet2));
      expect(packet1.hashCode, equals(packet2.hashCode));
    });
  });
}
