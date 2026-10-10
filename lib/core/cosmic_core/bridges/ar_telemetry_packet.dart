// lib/core/cosmic_core/bridges/ar_telemetry_packet.dart
// Immutable data contract for AR telemetry packets. Captures minimal state for future AR integration.

import '../domain/observer/observer.dart';
import '../domain/time/observation_time.dart';

class ArTelemetryPacket {
  /// Geographic observer information.
  final Observer observer;

  /// Observation moment – always stored in UTC.
  final ObservationTime observationTime;

  /// Identifier of the selected celestial object, if any.
  final String? selectedObjectId;

  /// Immutable list of visible object identifiers.
  final List<String> visibleObjectIds;

  ArTelemetryPacket({
    required this.observer,
    required this.observationTime,
    this.selectedObjectId,
    required List<String> visibleObjectIds,
  }) : visibleObjectIds = List.unmodifiable(visibleObjectIds);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArTelemetryPacket &&
          observer == other.observer &&
          observationTime.utc == other.observationTime.utc &&
          selectedObjectId == other.selectedObjectId &&
          _listEquals(visibleObjectIds, other.visibleObjectIds);

  @override
  int get hashCode =>
      observer.hashCode ^
      observationTime.utc.hashCode ^
      (selectedObjectId?.hashCode ?? 0) ^
      Object.hashAll(visibleObjectIds);

  @override
  String toString() =>
      'ArTelemetryPacket(observer: $observer, utc: ${observationTime.utc.toIso8601String()}, selectedObjectId: $selectedObjectId, visibleObjectIds: $visibleObjectIds)';

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
