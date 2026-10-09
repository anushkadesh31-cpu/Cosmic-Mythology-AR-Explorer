# Astronomy Calculation Engine Architecture
**Project:** Cosmic Mythology AR Explorer  
**Document Version:** 1.0.0  
**Phase:** Phase 2 Architecture Specification

---

## 1. Overview of the Astronomical Calculation Engine

The Astronomical Calculation Engine provides verified, real-time mathematical calculations for:
- Precision time transformations (UTC -> Julian Date -> Greenwich Mean Sidereal Time -> Local Sidereal Time).
- Spatial coordinate transformations (Equatorial J2000 -> Topocentric Horizontal Altitude/Azimuth).
- Low-overhead Solar, Lunar, and Major Planetary ephemeris approximations (Meeus algorithm subsets).
- Local visibility, horizon transits, and atmospheric refraction correction.

All formulas are based on established astronomical standards (*Jean Meeus: Astronomical Algorithms* and *US Naval Observatory Circulars*).

---

## 2. Coordinate Systems & Math Pipeline

```
[Observer Location (Lat φ, Lon λ)] + [UTC Timestamp (T)]
                          │
                          ▼
            [Julian Day Calculation (JD)]
                          │
                          ▼
        [Greenwich Mean Sidereal Time (GMST)]
                          │
                          ▼
         [Local Sidereal Time (LST = GMST + λ)]
                          │
       ┌──────────────────┴──────────────────┐
       │                                     │
[Star / Target RA (α), Dec (δ)]              │
       │                                     │
       ▼                                     ▼
 [Hour Angle: H = LST - α] ─────────► [Spherical Trigonometry Transform]
                                             │
                                             ▼
                             ┌───────────────────────────────┐
                             │ Altitude (h):                 │
                             │ sin(h) = sin(φ)sin(δ) +       │
                             │          cos(φ)cos(δ)cos(H)   │
                             ├───────────────────────────────┤
                             │ Azimuth (A):                  │
                             │ cos(A) = (sin(δ) - sin(φ)sin(h)) / │
                             │          (cos(φ)cos(h))       │
                             └───────────────┬───────────────┘
                                             │
                                             ▼
                               [Atmospheric Refraction R]
                                             │
                                             ▼
                           [Final Apparent Topocentric (h, A)]
```

---

## 3. Core Equations

### 3.1 Julian Day Calculation (UTC)
Given year $Y$, month $M$, day $D$, and decimal day fraction:
$$\text{If } M \leq 2 \implies Y = Y - 1, \, M = M + 12$$
$$A = \lfloor Y / 100 \rfloor, \quad B = 2 - A + \lfloor A / 4 \rfloor$$
$$\text{JD} = \lfloor 365.25(Y + 4716) \rfloor + \lfloor 30.6001(M + 1) \rfloor + D + B - 1524.5$$

Centuries from J2000.0:
$$T = \frac{\text{JD} - 2451545.0}{36525.0}$$

### 3.2 Greenwich Mean Sidereal Time (GMST)
$$\theta_0 = 280.46061837 + 360.98564736629 \cdot (\text{JD} - 2451545.0) + 0.000387933 \cdot T^2 - \frac{T^3}{38710000}$$
Reduced modulo $360^\circ$ and converted into hours ($/ 15.0$).

### 3.3 Local Sidereal Time (LST)
$$\text{LST} = \text{GMST} + \frac{\lambda_{\text{observer}}}{15.0} \pmod{24.0\text{ hours}}$$

### 3.4 Local Hour Angle ($H$)
$$H = \text{LST} - \alpha$$
*(where $\alpha$ is the object's Right Ascension in hours. Converted to degrees: $H^\circ = H \times 15.0^\circ$)*.

### 3.5 Altitude ($h$) & Azimuth ($A$)
$$\sin(h) = \sin(\phi)\sin(\delta) + \cos(\phi)\cos(\delta)\cos(H)$$
$$h = \arcsin(\sin(h))$$

$$\tan(A) = \frac{\sin(H)}{\cos(H)\sin(\phi) - \tan(\delta)\cos(\phi)}$$
*Using standard quadrant resolution (`atan2`) to ensure $A \in [0^\circ, 360^\circ)$ clockwise from True North.*

---

## 4. Atmospheric Refraction Correction
For objects near the horizon ($h < 15^\circ$), atmospheric refraction shifts apparent altitude upward.
The engine applies Bennett's empirical correction:
$$R = \frac{1.02}{\tan\left(h + \frac{10.3}{h + 5.11}\right)} \text{ arcminutes}$$
$$h_{\text{apparent}} = h_{\text{true}} + \frac{R}{60.0}^\circ$$

---

## 5. Ephemeris Subsystems

1. **Sun**: Low-precision Keplerian orbital elements (sufficient for solar noon, twilight determination, and day/night transitions, accuracy within 1 arcminute).
2. **Moon**: Simplified Brown's lunar theory truncated to major periodic terms for lunar longitude, latitude, distance, and topocentric phase calculation (illumination fraction $k \in [0.0, 1.0]$).
3. **Major Planets**: Keplerian orbital elements with secular variations for Mercury, Venus, Mars, Jupiter, and Saturn.

---

## 6. Performance & Real-Time Considerations

- **Frame Budget**: Mobile AR viewport requires 60 FPS update of camera matrices, but **celestial coordinates move at only $15^\circ/\text{hour}$** ($0.00416^\circ/\text{second}$).
- **Tiered Cache Strategy**:
  - *Tier 1 (High Rate - 60 Hz)*: Device gyroscope orientation & AR Camera transform matrix.
  - *Tier 2 (Medium Rate - 1 Hz)*: Local Sidereal Time and horizontal coordinates $(h, A)$ for top 150 visible stars.
  - *Tier 3 (Low Rate - Every 60s)*: Planetary ephemerides and Moon phase calculations.
