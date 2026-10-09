// lib/core/cosmic_core/domain/celestial/constellation_vector_segment.dart

/// Represents an immutable vector line connection between two celestial stars
/// identified by their stable catalog identifiers.
///
/// Used for rendering illustrative constellation line-art and asterisms
/// in sky visualizations. This pure-Dart model does not contain rendering
/// or platform dependencies.
class ConstellationVectorSegment {
  /// Stable catalog identifier of the starting star node.
  final String startStarId;

  /// Stable catalog identifier of the ending star node.
  final String endStarId;

  /// Optional identifier of the parent constellation or asterism group
  /// (e.g., 'summer_triangle', 'orion').
  final String? groupId;

  const ConstellationVectorSegment({
    required this.startStarId,
    required this.endStarId,
    this.groupId,
  })  : assert(startStarId.length > 0, 'startStarId cannot be empty'),
        assert(endStarId.length > 0, 'endStarId cannot be empty');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConstellationVectorSegment &&
          runtimeType == other.runtimeType &&
          startStarId == other.startStarId &&
          endStarId == other.endStarId &&
          groupId == other.groupId;

  @override
  int get hashCode => Object.hash(startStarId, endStarId, groupId);

  @override
  String toString() =>
      'ConstellationVectorSegment($startStarId -> $endStarId, group: $groupId)';
}
