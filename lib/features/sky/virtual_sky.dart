import 'package:flutter/material.dart';
import '../../core/cosmic_core/domain/observer/observer.dart';
import '../../core/cosmic_core/domain/time/observation_time.dart';
import '../../core/cosmic_core/domain/celestial/celestial_repository.dart';
import '../../core/cosmic_core/domain/celestial/constellation_vector_segment.dart';
import '../../core/cosmic_core/visibility/visibility_service.dart';
import '../../core/cosmic_core/visibility/visible_object.dart';
import '../../core/cosmic_core/visibility/sky_projection.dart';
import '../../core/cosmic_core/data/catalog/simple_star_catalog.dart';

/// A Flutter widget that renders a virtual sky.
///
/// It uses the pure‑Dart [VisibilityService] to obtain visible [VisibleObject]s
/// for the supplied [observer] and [observationTime].
/// The stars are drawn with a [CustomPaint] whose [SkyPainter] maps the
/// altitude/azimuth of each star to screen coordinates using [SkyProjection].
///
/// It reacts to changes in [observer], [observationTime], and [repository]
/// via [didUpdateWidget] and safely handles synchronous and asynchronous
/// repository data states.
class VirtualSky extends StatefulWidget {
  final Observer observer;
  final ObservationTime observationTime;
  final CelestialRepository repository;
  final VisibilityService visibilityService;
  final String? selectedObjectId;
  final ValueChanged<VisibleObject?>? onSelectObject;
  final double touchRadius;
  final Color? selectionColor;
  final bool showConstellationLines;
  final List<ConstellationVectorSegment>? lineSegments;
  final Color? constellationLineColor;

  const VirtualSky({
    super.key,
    required this.observer,
    required this.observationTime,
    required this.repository,
    required this.visibilityService,
    this.selectedObjectId,
    this.onSelectObject,
    this.touchRadius = defaultTouchRadius,
    this.selectionColor,
    this.showConstellationLines = true,
    this.lineSegments,
    this.constellationLineColor,
  });

  /// Standard touch radius in logical pixels for star tap targets.
  static const double defaultTouchRadius = 28.0;

  @override
  State<VirtualSky> createState() => VirtualSkyState();
}

class VirtualSkyState extends State<VirtualSky> {
  int _currentRequestId = 0;
  // Camera offsets in degrees (azimuth 0‑360, altitude +/- any). They are applied before projection.
  double _azimuthOffset = 0.0;
  double _altitudeOffset = 0.0;
  List<VisibleObject>? _visibleStars;
  // Expose a method to programmatically center the view on a given VisibleObject.
  void centerOn(VisibleObject target) {
    // Desired normalized center is (0.5, 0.5).
    // Compute offsets that map target's az/alt to that centre.
    // Azimuth offset (degrees) = (180 - target.azimuth) modulo 360.
    // Altitude offset (degrees) = 45 - target.altitude (clamped to -90..90).
    final double newAzOffset = (180.0 - target.azimuth) % 360.0;
    final double newAltOffset = (45.0 - target.altitude).clamp(-90.0, 90.0);
    setState(() {
      _azimuthOffset = newAzOffset;
      _altitudeOffset = newAltOffset;
    });
  }

  /// Retrieves a visible object by its stable identifier, if currently rendered.
  VisibleObject? getVisibleObjectById(String id) {
    if (_visibleStars == null) return null;
    for (final obj in _visibleStars!) {
      if (obj.id == id) return obj;
    }
    return null;
  }
  bool _isLoading = false;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _loadStars();
  }

  @override
  void dispose() {
    _currentRequestId++;
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant VirtualSky oldWidget) {
    super.didUpdateWidget(oldWidget);
    final observerChanged = widget.observer.latitude != oldWidget.observer.latitude ||
        widget.observer.longitude != oldWidget.observer.longitude ||
        widget.observer.elevation != oldWidget.observer.elevation;
    final timeChanged = widget.observationTime.utc != oldWidget.observationTime.utc;
    final repoChanged = widget.repository != oldWidget.repository;
    final serviceChanged = widget.visibilityService != oldWidget.visibilityService;

    if (observerChanged || timeChanged || repoChanged || serviceChanged) {
      _loadStars();
    } else if (widget.selectedObjectId != oldWidget.selectedObjectId ||
        widget.showConstellationLines != oldWidget.showConstellationLines ||
        widget.lineSegments != oldWidget.lineSegments ||
        widget.constellationLineColor != oldWidget.constellationLineColor ||
        widget.selectionColor != oldWidget.selectionColor) {
      setState(() {});
    }
  }

  void _reconcileSelection(List<VisibleObject>? stars) {
    if (widget.selectedObjectId == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (stars == null || stars.isEmpty) {
        widget.onSelectObject?.call(null);
        return;
      }
      VisibleObject? matched;
      for (final s in stars) {
        if (s.id == widget.selectedObjectId) {
          matched = s;
          break;
        }
      }
      if (matched == null) {
        // The selected star has set below horizon or was removed from catalog
        widget.onSelectObject?.call(null);
      } else {
        // Update with new topocentric coordinates if moved
        widget.onSelectObject?.call(matched);
      }
    });
  }

  void _onStarsLoaded(List<VisibleObject> stars) {
    setState(() {
      _visibleStars = stars;
      _isLoading = false;
      _error = null;
    });

    _reconcileSelection(stars);
  }

  void _handlePanUpdate(DragUpdateDetails details, double width, double height) {
    // Convert pixel drag to angular offsets.
    // Horizontal drag changes azimuth (0-360).
    // Vertical drag changes altitude offset (clamped to reasonable range).
    final delta = details.delta;
    // proportion of the drag relative to widget size
    final azimuthDelta = (delta.dx / width) * 360.0;
    final altitudeDelta = -(delta.dy / height) * 90.0; // dragging up raises altitude
    setState(() {
      _azimuthOffset = (_azimuthOffset + azimuthDelta) % 360.0;
      _altitudeOffset = (_altitudeOffset + altitudeDelta).clamp(-90.0, 90.0);
    });
  }

  void _loadStars() {

    final requestId = ++_currentRequestId;
    // 1. Synchronous path: if repository supports immediate access without frame delay
    bool isSync = widget.repository is SimpleStarCatalog;
    if (!isSync) {
      try {
        isSync = (widget.repository as dynamic).getAll != null;
      } catch (_) {
        isSync = false;
      }
    }

    if (isSync) {
      try {
        final syncStars = widget.visibilityService.visibleObjects(
          observer: widget.observer,
          observationTime: widget.observationTime,
          repository: widget.repository,
        );
        if (!mounted || requestId != _currentRequestId) return;
        _onStarsLoaded(syncStars);
        return;
      } catch (err) {
        if (!mounted || requestId != _currentRequestId) return;
        setState(() {
          _visibleStars = null;
          _isLoading = false;
          _error = err;
        });
        _reconcileSelection(null);
        return;
      }
    }

    // 2. Asynchronous path adhering to CelestialRepository contract
    setState(() {
      _isLoading = true;
      _error = null;
    });

    widget.visibilityService.getVisibleObjects(
      observer: widget.observer,
      observationTime: widget.observationTime,
      repository: widget.repository,
    ).then((stars) {
      if (!mounted || requestId != _currentRequestId) return;
      _onStarsLoaded(stars);
    }).catchError((err) {
      if (!mounted || requestId != _currentRequestId) return;
      setState(() {
        _visibleStars = null;
        _isLoading = false;
        _error = err;
      });
      _reconcileSelection(null);
    });
  }

  void _handleTap(Offset tapPosition, double width, double height) {
    final stars = _visibleStars;
    if (stars == null || stars.isEmpty) {
      widget.onSelectObject?.call(null);
      return;
    }

    VisibleObject? nearestStar;
    double minDistanceSq = widget.touchRadius * widget.touchRadius;

    for (final star in stars) {
      final (normX, normY) = SkyProjection.toNormalized(
        azimuth: (star.azimuth + _azimuthOffset) % 360,
        altitude: star.altitude + _altitudeOffset,
      );
      final dx = normX * width;
      final dy = normY * height;

      final distSq = (tapPosition.dx - dx) * (tapPosition.dx - dx) +
          (tapPosition.dy - dy) * (tapPosition.dy - dy);

      if (distSq <= minDistanceSq) {
        minDistanceSq = distSq;
        nearestStar = star;
      }
    }

    widget.onSelectObject?.call(nearestStar);
  }

  List<ConstellationVectorSegment> _getSegments() {
    if (widget.lineSegments != null) return widget.lineSegments!;
    if (widget.repository is SimpleStarCatalog) {
      return (widget.repository as SimpleStarCatalog).getLineSegments();
    }
    try {
      final dyn = widget.repository as dynamic;
      final res = dyn.getLineSegments?.call();
      if (res is List<ConstellationVectorSegment>) return res;
    } catch (_) {}
    return const [];
  }

  @override
  Widget build(BuildContext context) {
    final stars = _visibleStars ?? const [];

    final activeSelectionColor = widget.selectionColor ?? const Color(0xFF64FFDA);

    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
                     behavior: HitTestBehavior.translucent,
          onTapUp: (details) => _handleTap(
            details.localPosition,
            constraints.maxWidth,
            constraints.maxHeight,
          ),
          onPanUpdate: (details) => _handlePanUpdate(details, constraints.maxWidth, constraints.maxHeight),
          child: Stack(
            children: [
              CustomPaint(
                key: const Key('virtual_sky_canvas'),
                size: Size(constraints.maxWidth, constraints.maxHeight),
                painter: SkyPainter(
                  visibleStars: stars,
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  selectedObjectId: widget.selectedObjectId,
                  selectionColor: activeSelectionColor,
                  azimuthOffset: _azimuthOffset,
                  altitudeOffset: _altitudeOffset,
                  showConstellationLines: widget.showConstellationLines,
                  lineSegments: _getSegments(),
                  constellationLineColor: widget.constellationLineColor ??
                      const Color(0x5564FFDA),
                ),
              ),
              if (_error != null)
                Center(
                  key: const Key('virtual_sky_error'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      color: const Color(0xDD1B121A),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x66FF5252), width: 1),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Color(0xFFFF5252), size: 18),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Unable to load celestial objects. Please try again.',
                            style: TextStyle(
                              color: Color(0xFFFFD1D1),
                              fontSize: 12,
                              letterSpacing: 0.2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_isLoading)
                const Center(
                  key: Key('virtual_sky_loading'),
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF64FFDA),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class SkyPainter extends CustomPainter {
  final List<VisibleObject> visibleStars;
  final double width;
  final double height;
  final String? selectedObjectId;
  final Color selectionColor;
  final bool showConstellationLines;
  final List<ConstellationVectorSegment> lineSegments;
  final Color constellationLineColor;
  // Camera offsets in degrees
  final double azimuthOffset;
  final double altitudeOffset;

  SkyPainter({
    required this.visibleStars,
    required this.width,
    required this.height,
    this.selectedObjectId,
    this.selectionColor = const Color(0xFF64FFDA),
    this.showConstellationLines = true,
    this.lineSegments = const [],
    this.constellationLineColor = const Color(0x5564FFDA),
    this.azimuthOffset = 0.0,
    this.altitudeOffset = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {

    final backgroundPaint = Paint()..color = const Color(0xFF0A0A1A);
    canvas.drawRect(Rect.fromLTWH(0, 0, width, height), backgroundPaint);

    // 1. Render constellation vector linework beneath star nodes
    if (showConstellationLines && lineSegments.isNotEmpty) {
      final Map<String, VisibleObject> visibleMap = {
        for (final star in visibleStars) star.id: star,
      };

      final linePaint = Paint()
        ..color = constellationLineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0
        ..isAntiAlias = true;

      for (final segment in lineSegments) {
        final starA = visibleMap[segment.startStarId];
        final starB = visibleMap[segment.endStarId];

        // Segment renders only if BOTH endpoints are currently above the horizon
        if (starA == null || starB == null) continue;

        final (normXa, normYa) = SkyProjection.toNormalized(
          azimuth: (starA.azimuth + azimuthOffset) % 360,
          altitude: starA.altitude + altitudeOffset,
        );
        final (normXb, normYb) = SkyProjection.toNormalized(
          azimuth: (starB.azimuth + azimuthOffset) % 360,
          altitude: starB.altitude + altitudeOffset,
        );

        if (normXa.isNaN || normYa.isNaN || normXb.isNaN || normYb.isNaN) continue;

        // Seam protection: if endpoints span across the 360°/0° border (>180° / 0.5 normX),
        // skip painting an incorrect chord across the entire width of the screen.
        if ((normXa - normXb).abs() > 0.5) continue;

        final p1 = Offset(normXa * width, normYa * height);
        final p2 = Offset(normXb * width, normYb * height);

        if (p1.dx.isFinite && p1.dy.isFinite && p2.dx.isFinite && p2.dy.isFinite) {
          canvas.drawLine(p1, p2, linePaint);
        }
      }
    }

    // 2. Render visible star nodes
    for (final star in visibleStars) {
      final (normX, normY) = SkyProjection.toNormalized(
        azimuth: (star.azimuth + azimuthOffset) % 360,
        altitude: star.altitude + altitudeOffset,
      );
      final dx = normX * width;
      final dy = normY * height;

      double radius;
      if (star.apparentMagnitude != null) {
        radius = (6 - star.apparentMagnitude!.clamp(-1.0, 6.0)) * 0.5;
        radius = radius.clamp(0.5, 4.0);
      } else {
        radius = 1.0;
      }

      final isSelected = star.id == selectedObjectId;

      final starPaint = Paint()
        ..color = isSelected ? selectionColor : Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dx, dy), radius, starPaint);

      if (isSelected) {
        // Selection reticle ring
        final reticlePaint = Paint()
          ..color = selectionColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;
        final reticleRadius = (radius + 8.0).clamp(8.0, 24.0);
        canvas.drawCircle(Offset(dx, dy), reticleRadius, reticlePaint);

        // Subtle glowing halo
        final haloPaint = Paint()
          ..color = selectionColor.withValues(alpha: 0.25)
          ..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(dx, dy), reticleRadius, haloPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SkyPainter oldDelegate) =>
      oldDelegate.visibleStars != visibleStars ||
      oldDelegate.width != width ||
      oldDelegate.height != height ||
      oldDelegate.selectedObjectId != selectedObjectId ||
      oldDelegate.selectionColor != selectionColor ||
      oldDelegate.showConstellationLines != showConstellationLines ||
      oldDelegate.lineSegments != lineSegments ||
      oldDelegate.constellationLineColor != constellationLineColor;
}
