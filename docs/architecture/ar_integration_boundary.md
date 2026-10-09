# AR & Unity Integration Boundary Specification
**Project:** Cosmic Mythology AR Explorer  
**Document Version:** 1.0.0  
**Phase:** Phase 2 Architecture Specification

---

## 1. Architectural Independence Principle

A foundational requirement of the **Cosmic Mythology AR Explorer** is that:
1. **The Cosmic Core contains zero UI, AR, Unity, or Flutter rendering code.**
2. **The 3D AR Engine (Unity or AR Foundation) contains zero astronomical calculation logic.**

The 3D AR engine acts strictly as a **presentation renderer**. The Cosmic Core acts strictly as the **source of truth and math authority**.

```
┌────────────────────────────────────────────────────────┐
│                   Cosmic Core Engine                   │
│          (Calculates Celestial Ephemeris & Lore)       │
└───────────────────────────┬────────────────────────────┘
                            │
              Binary / Serialized DTO Protocol
             (Normalized 3D Celestial Unit Vectors)
                            │
       ┌────────────────────┴────────────────────┐
       ▼                                         ▼
┌───────────────────────────┐      ┌───────────────────────────┐
│     Flutter UI Shell      │      │    Unity / AR Foundation  │
│  - Frosted HUD Controls   │      │  - Gyroscope Camera Sync  │
│  - Story Overlays         │◄────►│  - 3D Sky Dome Rendering  │
│  - Quest Progress Cards   │ (IPC)│  - Constellation Shaders  │
│  - Observation Journal    │      │  - Volumetric Nebula Art  │
└───────────────────────────┘      └───────────────────────────┘
```

---

## 2. Spatial Coordinate Boundary (Celestial to AR 3D World)

### 2.1 The Celestial Unit Sphere
In the 3D rendering engine, the sky is modeled as an infinitely distant **Celestial Sphere** of arbitrary radius $R$ (typically $R = 1000$ world units).

The Cosmic Core transforms topocentric horizontal coordinates $(h, A)$ [Altitude and Azimuth] into normalized Cartesian direction vectors $\vec{v} = (x, y, z)$:

$$\text{Right-handed World Space (Unity convention: } +X = \text{East}, +Y = \text{Up}, +Z = \text{North}):$$

$$x = \cos(h) \cdot \sin(A)$$
$$y = \sin(h)$$
$$z = \cos(h) \cdot \cos(A)$$

*This isolates Unity/AR Foundation from spherical astronomy trigonometry: the renderer simply places star particles and line vertices at $\vec{P} = R \cdot \vec{v}$.*

---

## 3. Communication Contract (Telemetry DTO Packet)

The Cosmic Core periodically broadcasts an immutable telemetry frame to the AR consumer:

```dart
/// Data Transfer Object passed from Cosmic Core to AR Renderer.
class ArSkyTelemetryFrame {
  /// UTC timestamp of calculation.
  final int timestampMillis;

  /// Local Sidereal Time in hours.
  final double localSiderealTimeHours;

  /// Visible stars with 3D unit vectors and rendering styles.
  final List<ArStarNode> visibleStars;

  /// Constellation line segments for the active cultural tradition.
  final List<ArConstellationLine> activeLines;

  /// Active celestial target reticle lock (if any).
  final ArTargetLock? lockedTarget;

  const ArSkyTelemetryFrame({
    required this.timestampMillis,
    required this.localSiderealTimeHours,
    required this.visibleStars,
    required this.activeLines,
    this.lockedTarget,
  });
}

class ArStarNode {
  final String starId;
  final double x; // Normalized 3D direction vector
  final double y;
  final double z;
  final double apparentMagnitude;
  final int colorRgba; // Spectral color approximation (e.g. Betelgeuse red-amber, Rigel cyan-white)
  final double visualSizeFactor;

  const ArStarNode({
    required this.starId,
    required this.x,
    required this.y,
    required this.z,
    required this.apparentMagnitude,
    required this.colorRgba,
    required this.visualSizeFactor,
  });
}

class ArConstellationLine {
  final String asterismId;
  final ArStarNode startNode;
  final ArStarNode endNode;
  final int lineRgba;
  final double lineWidth;

  const ArConstellationLine({
    required this.asterismId,
    required this.startNode,
    required this.endNode,
    required this.lineRgba,
    required this.lineWidth,
  });
}
```

---

## 4. Reticle Raycasting & Target Locking Protocol

When the user points their device at a region of the sky:
1. **Device Sensor Fusion**: AR Foundation / Unity tracks device rotation matrix $\mathbf{R}_{\text{device}}$ using hardware IMU (gyroscope, accelerometer, magnetometer).
2. **Camera Forward Vector**: A ray $\vec{r}_{\text{forward}} = \mathbf{R}_{\text{device}} \cdot (0, 0, 1)$ is cast into the virtual celestial sphere.
3. **Angular Proximity Query**:
   For each candidate star with direction vector $\vec{v}_i$:
   $$\theta = \arccos(\vec{r}_{\text{forward}} \cdot \vec{v}_i)$$
4. If $\theta < \theta_{\text{threshold}}$ (e.g., $2.5^\circ$), a `TargetLockedEvent` is emitted to the Flutter UI layer with star ID, triggering the telemetry sheet and associated mythic story fragments.

---

## 5. Technology Bridge Roadmap

| Approach | Technology | Pros | Cons | Phase Target |
| :--- | :--- | :--- | :--- | :--- |
| **Stage 1 (Current Phase 1/2)** | Pure Flutter `CustomPainter` | Zero dependencies, instant compilation, 100% stable on emulator | 2D vector HUD only | Phase 1 & 2 |
| **Stage 2** | Flutter Native AR (ARKit / ARCore via platform channels) | Light footprint, pure Flutter UI overlay | Custom 3D shaders required | Phase 3a |
| **Stage 3** | Flutter-Unity Widget Bridge | Cinematic 3D volumetric effects, AAA visual quality | Larger binary size, dual build pipeline | Phase 3b |

By preserving the `ArSkyTelemetryFrame` boundary, swapping from Stage 1 to Stage 2 or 3 requires **zero changes** to the Cosmic Core engine.
