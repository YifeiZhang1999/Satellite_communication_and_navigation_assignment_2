# AAE6102-Assignment2

# Task 1 – Differential GNSS Positioning: Evaluating Advanced GNSS Techniques for Smartphone Applications

## Overview

Typical smartphone GNSS solutions achieve an accuracy of approximately 5–10 meters. This study assesses four enhanced GNSS methodologies tailored for mobile platforms, comparing their real-world implementation viability and performance characteristics.

## Techniques Comparison

Rather than a simple table, the comparison is now structured into a categorized summary:

1. Accuracy

DGNSS: Achieves 1–3 meters accuracy by applying correction signals.

RTK: Provides 1–5 centimeters accuracy using carrier-phase tracking.

PPP: Reaches 10–30 centimeters accuracy globally through precise satellite data.

PPP-RTK: Offers 5–10 centimeters accuracy by combining PPP and RTK techniques.

2. Convergence Speed

DGNSS: Instantaneous to a few seconds.

RTK: Takes seconds to a few minutes to initialize.

PPP: Requires 20–30+ minutes for full convergence.

PPP-RTK: Reduces convergence time to 5–10 minutes.

3. Infrastructure and Equipment Requirements

DGNSS: Needs regional correction networks; compatible with single-frequency receivers.

RTK: Depends on nearby ground stations (within 10–20 km); needs dual-frequency receivers.

PPP: Relies only on global satellite corrections; dual-frequency is optimal.

PPP-RTK: Requires regional augmentation services and dual-frequency support.

4. Data Usage and Processing

DGNSS: Moderate data consumption and low processing demand.

RTK: High data needs and moderate processing requirements.

PPP: Low bandwidth but very high computational load.

PPP-RTK: Moderate bandwidth with high processing complexity.

5. Coverage and Operational Range

DGNSS: Effective within 50–100 km from reference stations.

RTK: Limited to about 10–20 km radius.

PPP: Full global coverage.

PPP-RTK: Regional to continental scale service.

6. Practical Considerations for Smartphones

DGNSS: High integration feasibility, cost-effective, fair urban performance.

RTK: Low feasibility without external hardware, expensive, poor to moderate urban usability.

PPP: Moderate integration difficulty, moderate cost, poor performance in cities.

PPP-RTK: Moderate feasibility with better urban reliability compared to PPP.

7. Additional Factors

Battery Consumption: DGNSS is least demanding; RTK, PPP, and PPP-RTK significantly increase energy use.

Urban Adaptability: PPP-RTK shows the most promise for urban navigation as it balances correction speed and robustness.

## Important Comparative Points

- **Accuracy Considerations:** DGNSS offers meter-level precision via correction signals. RTK pushes this to centimeter-level through carrier-phase tracking. PPP provides decimeter-level accuracy globally, and PPP-RTK merges methods for fast convergence with high precision.

- **Initialization and Convergence:** DGNSS corrections are near-instant. RTK requires resolving carrier-phase ambiguities. PPP demands longer observation times, while PPP-RTK accelerates convergence by leveraging local augmentation.

- **Device and Hardware Aspects:** Standard smartphones are typically DGNSS-ready. Dual-frequency capability greatly enhances RTK, PPP, and PPP-RTK, currently found in select premium models.

- **Processing Load and Energy Impact:** DGNSS is lightweight computationally. RTK needs more moderate processing. PPP and PPP-RTK entail heavier computation, impacting energy consumption during extended use.

- **Urban Navigation Feasibility:** DGNSS deals reasonably with urban challenges. RTK struggles with signal interruptions. PPP suffers from convergence resets. PPP-RTK handles urban environments better by speeding up recovery and maintaining reliability.

## Final Verdict

Currently, DGNSS stands as the most practical solution for smartphones. In the coming years, with dual-frequency becoming standard, PPP-RTK could revolutionize high-precision mobile positioning.

---

# Task 2 – GNSS Skymask Application in Urban Environments

## Skymask Concept

A skymask correlates satellite azimuths (1–360°) with minimum elevation angles needed for unobstructed visibility. Using Least Squares Estimation, each satellite’s visibility is evaluated: if a satellite’s elevation is below the skymask limit, it is excluded.

If fewer than four satellites remain after filtering, positioning for that epoch fails.

## Processing Workflow

1. GNSS observations are initially processed.
2. Satellite azimuths and elevations are computed.
3. Minimum elevation thresholds are retrieved from the skymask.
4. Satellites below thresholds are excluded.
5. If four or more remain, position computation proceeds.

## Experimental Results

- Standard method: 3D RMS error = 85.13 m, Std Dev = 35.33 m.
- Skymask filtering: 3D RMS error = 100.36 m, Std Dev = 33.18 m.

Result Graph:  
**[Insert Skymask Filtering Result Image Here]**  

<p align="center">
  <img src="images/1.png" alt=" " width="500" />
</p>

---

# Task 3 – RAIM (Receiver Autonomous Integrity Monitoring) for GPS

## Data and Approach

Using the OpenSky dataset (926 epochs, 9 satellites per epoch), both traditional and weighted RAIM were implemented.

## Implementation Details

- For WLS mode: set `settings.sys.ls_type = 1` in `42.m`.
- Weighted RAIM algorithms are found  `detection.m` and `pl_computation.m`.

## Key Equations

- Weighted Position:  
  $\boldsymbol{X} = (G^T W G)^{-1} G^T W \boldsymbol{Y}$

- Weighted SSE:  
  $WSSE = \sqrt{\boldsymbol{Y}^T W (I - P) \boldsymbol{Y}}$

- Protection Level (PL): Derived using Pslope factors and thresholds.

## Performance Insights

- Traditional RAIM detected faults but couldn’t always isolate single bad measurements.
- Weighted RAIM avoided fault detection flags entirely and computed PL successfully for all epochs.

Result Graphs:  
<p align="center">
  <img src="images/2.png" alt=" " width="500" />
</p>
<p align="center">
  <img src="images/3.png" alt=" " width="500" />
</p>
<p align="center">
  <img src="images/4.png" alt=" " width="500" />
</p>
<p align="center">
  <img src="images/5.png" alt=" " width="500" />
</p>
<p align="center">
  <img src="images/6.png" alt=" " width="500" />
</p>
<p align="center">
  <img src="images/7.png" alt=" " width="500" />
</p>

---

# Task 4 – Challenges of LEO Satellites for Navigation

## Background

LEO constellations offer faster signals and improved coverage but introduce unique challenges.

## Core Challenges

- **Orbit and Clock Stability:** Higher perturbations and less stable onboard clocks than MEO GNSS systems.
- **Integration Issues:** Compatibility and time synchronization with existing GNSS networks.
- **Coverage Requirements:** High satellite count needed (>150) for reliable global service.
- **Signal Processing Complexity:** Doppler shifts and acquisition bandwidths are much larger.
- **Security Risks:** Dynamic geometries and commercial architectures introduce new vulnerabilities.

## Conclusion

LEO navigation systems are promising but require substantial engineering to overcome existing limitations.

---

# Task 5 – GNSS Radio Occultation for Remote Sensing

## Introduction

GNSS-RO leverages signal bending to derive atmospheric profiles with high vertical precision.

## Measurement Principles

- Signals are refracted by atmospheric density gradients.
- Phase and Doppler measurements are used to derive temperature, pressure, and humidity profiles.

## Applications

- Weather forecasting improvements (COSMIC-1, COSMIC-2 missions).
- Benchmark datasets for climate studies.
- Research into atmospheric gravity waves and boundary layer dynamics.

## Challenges

- Reduced accuracy near the surface, particularly in humid zones.
- Temporal and spatial coverage limitations.
- Spherical symmetry assumptions introduce retrieval errors in complex weather.

## Future Outlook

Advancements in multi-GNSS receivers, new signal processing techniques, and commercial CubeSat deployments promise a bright future for GNSS-RO-based atmospheric science.

