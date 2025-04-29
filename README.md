# AAE6102-Assignment2

```
Gen AI is used in Task 1, 4, and 5
Model: Chatgpt-4o
Chatting history: https://chatgpt.com/share/6810450f-1c64-8007-8813-b779aa655107
```

# Task 1 – Differential GNSS Positioning: Evaluating Advanced GNSS Techniques for Smartphone Applications

## Brief Overall Comparison:

In smartphone navigation, different GNSS techniques offer a trade-off between accuracy, infrastructure requirement, and practical usability.

DGNSS improves basic positioning to meter-level accuracy easily, but doesn’t reach high precision.

RTK offers centimeter-level accuracy, but needs nearby base stations and high-quality signals — challenging for smartphones.

PPP provides global decimeter-level positioning without local stations but has slow convergence.

PPP-RTK combines PPP and RTK advantages to achieve fast, centimeter-level accuracy globally — though it still depends on good signal quality and commercial services, which smartphones struggle with today.
Overall, DGNSS is currently the most practical for smartphones, but PPP-RTK is seen as the future as hardware and correction services improve.

## 1. Differential GNSS (DGNSS)
## How it works:
DGNSS corrects GNSS errors (e.g., atmospheric, clock, orbit errors) using a nearby reference station that knows its true position. The reference sends correction data to the user device.

### Pros:

Simple to implement.

Corrections are small in size (easy over low-bandwidth links).

Good improvement over raw GNSS (~1–3 meters accuracy).

Mature and widely supported.

### Cons:

Still not "high precision" — won't give centimeter-level accuracy.

Requires a reference station network.

Latency and communication links are needed.

In urban environments (smartphone use), performance can still degrade due to multipath and poor satellite visibility.

## 2. Real-Time Kinematic (RTK)
### How it works:
RTK uses carrier-phase measurements and reference station data to resolve position with centimeter-level accuracy.

### Pros:

High accuracy: Centimeter-level positioning in real time.

Already used for surveying, drones, and agriculture.

Good for open-sky environments.

### Cons:

Requires a nearby base station or a dense network (e.g., CORS, NTRIP).

Needs a high-rate communication link for corrections (internet or radio).

Smartphones struggle:

Low-quality GNSS antennas make carrier-phase measurements noisier.

Multipath and signal blockage cause ambiguities to not fix properly.

Short range (~10–30 km) from base station limits usability.

## 3. Precise Point Positioning (PPP)
### How it works:
PPP uses precise satellite orbits and clocks from global services (e.g., IGS) without needing a local base station. Works anywhere globally.

### Pros:

Global coverage — no need for local infrastructure.

No need for nearby base stations.

Works over wider areas (even remote areas).

### Cons:

Long convergence time:

It can take several minutes (10–30 minutes) to reach high accuracy.

Final accuracy is usually decimeter-level, not centimeter (especially in dynamic smartphone conditions).

Smartphones again suffer: phase data is noisy, causing longer convergence or lower precision.

Corrections (satellite clocks/orbits) require data link.

## 4. PPP-RTK (also called Network RTK or PPP with integer ambiguity resolution)
### How it works:
PPP-RTK combines PPP's precise global corrections with RTK-style fast ambiguity fixing using network data. It tries to achieve fast convergence like RTK but with broader area support like PPP.

### Pros:

Fast convergence (seconds to a few minutes).

High accuracy: Potential for centimeter-level even without a close base station.

More scalable over a wide region.

Good potential for smartphones as correction services (e.g., Skylark, u-blox PointPerfect) become available.

### Cons:

Requires access to specialized correction services (often paid).

Still depends on reliable and accurate phase measurements — again, smartphone-grade antennas limit practical performance.

Infrastructure needed to deliver corrections (e.g., internet access).

More complex implementation.

## Summary Table

| Technique | Accuracy | Infrastructure Need | Smartphone Suitability | Other Issues |
|:---|:---|:---|:---|:---|
| **DGNSS** | Meter-level | Local reference station | Moderate | Urban multipath still an issue |
| **RTK** | Centimeter-level | Close base station (few km) | Poor (due to noisy carrier-phase measurements) | Requires stable communication link; urban areas problematic |
| **PPP** | Decimeter-level (after convergence) | Global correction services | Poor to moderate | Long convergence time (10–30 min) |
| **PPP-RTK** | Centimeter-level | Global corrections + network support | Moderate (future potential) | Requires paid services; complexity; smartphone antenna limitations |

---

# Task 2 – GNSS Skymask Application in Urban Environments

## Skymask Application Fundamentals

The skymask information analyzed includes the relationships between directional measurements, specifically focusing on azimuthal coordinates (AZ values ranging from 1 to 360 degrees) and their corresponding minimum elevation thresholds (EL values) that allow for direct visibility. By utilizing Standard Least-squares Estimation techniques, incoming satellite signals can be assessed by identifying their specific azimuthal positions and then checking if the associated elevation meets or exceeds the minimum threshold defined in the skymask dataset. Signals with elevations below these thresholds are deemed obstructed and are thus excluded from positioning calculations. If fewer than four satellites are left after this filtering process, it becomes impossible to determine the position for that specific time.


## Description of Processing Methodology

The framework for executing skymask filtering operates as follows: The system first processes a set of GNSS observations that lack any qualifying line-of-sight transmissions. For each satellite detected, the system computes its elevation and determines its azimuthal orientation. Using this azimuth value, the relevant minimum elevation requirement is retrieved from the skymask dataset. The system then checks if the satellite's actual elevation is below this threshold. If it is, the transmission is marked as non-line-of-sight and excluded; otherwise, it increments the count of valid observations. This procedure is repeated for all detected satellites. Once completed, if the total number of qualifying transmissions is fewer than four, the positioning attempt for that epoch is abandoned; otherwise, the valid satellite data moves on to the positioning computation phase.


## Results of Performance Analysis

An analysis of urban environment data across 839 distinct measurement epochs highlighted significant differences between standard estimation methods and those that utilize skymask filtering. The use of skymask filtering led to marked improvements in positioning accuracy by removing low-quality non-line-of-sight transmissions. However, the numerical evaluation indicated a complex effect on overall accuracy metrics. The standard estimation method yielded a three-dimensional root-mean-square error of 85.13 meters with a standard deviation of 35.33 meters across all 839 epochs. In comparison, the skymask-enhanced method resulted in a higher root-mean-square error of 100.36 meters but achieved a slightly better standard deviation of 33.18 meters, maintaining full availability throughout all epochs.


This finding indicates a significant tradeoff: while filtering improves precision by controlling signal quality, it may also reduce accuracy by limiting the geometric diversity of satellite signals, especially in the vertical dimension. The decrease in satellite count after filtering, while removing problematic signals, also weakens the vertical positioning geometry, which may account for the decline in three-dimensional positioning performance despite enhanced precision metrics. Theoretically, this filtering method could lead to insufficient satellite availability during certain measurement periods; however, in this dataset, solutions remained accessible for all epochs, regardless of the methodology used. The result graph is displayed below.

Result Graph:  
**[Insert Skymask Filtering Result Image Here]**  

<p align="center">
  <img src="images/1.png" alt=" " width="500" />
</p>

---

# Task 3 – RAIM (Receiver Autonomous Integrity Monitoring) for GPS

## Overview of Dataset and Methodology

This analysis utilizes the "OpenSky" dataset, which includes 926 unique temporal measurements. Each measurement epoch reliably captures 9 satellite signal receptions. The methodology incorporates RAIM protocols, beginning with fault detection followed by isolation procedures. Once a single erroneous measurement is identified, the system isolates that specific observation and recalculates the positioning parameters accordingly.

## Implementation Details

- For WLS mode: set `settings.sys.ls_type = 1` in `42.m`.
- Weighted RAIM algorithms are found  `detection.m` and `pl_computation.m`.

## Key Equations

The weighted position estimation $\boldsymbol{X}$ is determined through the expression:

$\boldsymbol{X} = (G^T W G)^{-1} G^T W \boldsymbol{Y}, \tag{1}$

with the WSSE (Weighted Sum of Squared Errors) statistical metric formulated as:

$WSSE = \sqrt{\boldsymbol{Y}^T W (I - P) \boldsymbol{Y}}, \tag{2}$

where the detection threshold $T$ is established by:

$T(N, P_{FA}) = \sqrt{Q_{\chi^2, N-4}(1 - P_{FA})}, \tag{3}$

with $Q_{\chi^2, N-4}(\cdot)$ representing the quantile function for Chi-square distributions having $N-4$ degrees of freedom. The three-dimensional Protection slope parameter for each satellite $i$ is calculated using:

$\text{Pslope} = \frac{\sqrt{(K^2_{1,i} + K^2_{2,i} + K^2_{3,i})}}{\sqrt{W_{ii}(1 - P_{ii})}}. \tag{4}$

Integration of equations $(3)$ and $(4)$ enables computation of the three-dimensional Protection Level (PL):

$\text{PL} = max[\text{Pslope}] T(N, P_{FA}) + k(P_{MD})\sigma, \tag{5}$

where $\sigma = 3\text{m}$, and $k(P_{MD}) = Q_N (1 - \frac{P_{MD}}{2})$ with $Q_N(\cdot)$ denoting the standard normal distribution quantile function.


## Performance Insights

The standard RAIM approach indicated that certain epochs produced test statistics (illustrated in performance charts) that surpassed the calculated thresholds, suggesting possible measurement irregularities. Further examination during the isolation phases consistently uncovered two potentially faulty measurements among the nine received signals during these problematic epochs. This scenario hindered the successful isolation of individual faults, leading to the abandonment of positioning attempts during the affected epochs and the suspension of Protection Level calculations. Nevertheless, all successfully computed Protection Levels remained below the established Alert Limit of 50 meters, demonstrating the efficacy of the RAIM methodology in detecting and excluding compromised or low-quality measurements.


On the other hand, the weighted RAIM approach showed that test statistics for all 926 epochs stayed below the calculated thresholds. The weighting mechanism effectively prevented the identification of potentially faulty measurements, thus avoiding the need for isolation procedures. Protection Levels were successfully computed for every measurement epoch, with verification charts confirming that all PL values remained within the acceptable Alert Limits.

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

In recent years, Low Earth Orbit (LEO) satellites have gained tremendous attention for their potential role in navigation, especially in supplementing or even partially replacing traditional Medium Earth Orbit (MEO) GNSS systems. However, LEO-based navigation is not without significant challenges. Four key factors — fast satellite motion, short visibility time, weaker geometric diversity, and the need for a massive constellation — fundamentally complicate real-world applications. Let’s discuss each point carefully.

## 1. Fast Satellite Motion
LEO satellites typically orbit at altitudes between 500 km and 2000 km above Earth’s surface, completing one full orbit in about 90 to 120 minutes. This means from the perspective of a ground user, a LEO satellite moves across the sky at a much faster rate than GNSS satellites in MEO (~12,000–20,000 km altitude).

### Implications:

For navigation, fast satellite motion causes rapid changes in satellite-receiver geometry.

The Doppler shift experienced is much larger compared to traditional GNSS (~kHz range instead of Hz), requiring more sophisticated tracking loops in the receiver hardware and software.

Satellite signal links can be broken or degraded quickly if the receiver cannot adapt fast enough.

Frequent updating of satellite orbital data (ephemeris) is necessary to maintain accurate positioning.

### Real Application Highlight:
In real-world deployments like Starlink’s positioning experiments, fast motion means that receivers must constantly and quickly switch satellites. Traditional GNSS receivers cannot handle this without significant upgrades. This increases power consumption, computational burden, and hardware complexity on smartphones or IoT devices.

## 2. Short Visibility Time
Due to their low altitude and fast movement, any given LEO satellite remains visible to a ground user for only a few minutes — typically between 5 and 15 minutes — before disappearing below the horizon.

### Implications:

Navigation systems must frequently reacquire new satellites, often before completing a full positioning solution.

Any interruption (e.g., due to buildings, trees) becomes more disruptive, because the user has less time to benefit from each satellite pass.

High-frequency handovers between satellites increase the chance of signal loss, temporary outages, or positioning errors if the handover process is not seamless.

### Real Application Highlight:
In urban environments (where smartphones are heavily used), skyscrapers or dense foliage can block signals. Since LEO satellites only remain in view for minutes, any temporary obstruction can cause loss of critical positioning links, leading to degraded or interrupted navigation service, especially in dynamic environments like driving or walking.

## 3. Weaker Geometric Diversity
Good satellite geometry — where satellites are spread widely across the sky — is essential for achieving low Position Dilution of Precision (PDOP), which translates to more accurate position solutions. Traditional GNSS constellations achieve this by placing satellites in specific orbital planes optimized for global coverage.

In contrast, a small or medium-sized LEO constellation tends to cluster satellites in narrow "bands" or specific sky sectors.

### Implications:

If there are not enough satellites spread out overhead, the user may experience poor satellite geometry even if multiple satellites are technically visible.

High PDOP values mean that even with strong signals, positioning accuracy will suffer.

Navigation systems must compensate with more satellites, better signal processing, or augmented solutions (e.g., using ground stations or inertial sensors).

### Real Application Highlight:
Early attempts to use LEO satellites for positioning, like some Iridium experiments, demonstrated that while signal tracking was possible, the geometric configuration often led to positioning errors much larger than expected. Even if signals are strong and reliable, bad geometry = bad positioning.

## 4. Need for a Massive Constellation
Because of short visibility and weak geometric spread, a practical LEO navigation system requires a huge number of satellites to ensure continuous, high-quality coverage.

### Implications:

To provide service comparable to GPS, hundreds to thousands of satellites are needed.

Building, launching, and maintaining such a large constellation requires massive investment — both in the satellites themselves and the ground control infrastructure.

Coordination between satellites (for clock synchronization, orbit updates, etc.) becomes extremely complex.

Signal congestion and cross-satellite interference management become critical at such scales.

### Real Application Highlight:
Projects like Starlink and OneWeb are already planning or operating mega-constellations for communications, not specifically for navigation. However, their dense satellite networks offer an opportunity for positioning — but only if positioning-grade signals, tight clock control, and user-accessible corrections are properly implemented. Even then, providing global continuous centimeter-level navigation would still require additional investments beyond communications.

## Conclusion
While LEO satellites offer advantages like stronger signals, lower latency, and better anti-jamming properties compared to MEO GNSS satellites, their use for navigation introduces serious technical challenges.
Fast motion, short visibility, weaker geometry, and the need for massive constellations make real-world application complex and expensive.

Nevertheless, with the growing deployment of LEO mega-constellations and advances in receiver design, LEO-based navigation may become a valuable augmentation to traditional GNSS, especially for challenging environments like urban canyons or remote areas.

---

# Task 5 – The Impact of GNSS Radio Occultation in Remote Sensing Applications

## 1. Overview of GNSS-RO: Foundations and Rise

Global Navigation Satellite System Radio Occultation (GNSS-RO) is a satellite-based remote sensing technique that measures the Earth's atmosphere with high precision and vertical resolution. It operates by recording changes in GNSS signals (such as those from GPS, GLONASS, Galileo, and BeiDou) as they are occulted — that is, pass tangentially through the Earth's atmosphere — as seen from a Low Earth Orbit (LEO) satellite.

Originally proposed in the 1990s, GNSS-RO rose to prominence with the launch of missions like GPS/MET in 1995, which demonstrated its feasibility for atmospheric sounding. Its significance stems from its unique advantages: GNSS-RO provides **all-weather, day-and-night global coverage**, **high vertical resolution**, **long-term stability**, and **self-calibrating measurements** independent of local calibration sources. As such, it rapidly evolved into a critical tool in numerical weather prediction (NWP), climate monitoring, and ionospheric research.

## 2. Technical Mechanics and Underlying Physics

At the heart of GNSS-RO is the principle of **atmospheric refractive bending**. As GNSS radio signals (typically at L-band frequencies, around 1.2–1.5 GHz) traverse the Earth's atmosphere at low elevation angles, they experience:
- **Bending** due to gradients in atmospheric refractivity.
- **Delay** as the speed of radio wave propagation is reduced in the denser layers of the atmosphere.

**Operational Mechanics:**
- A GNSS receiver on a LEO satellite tracks the phase and amplitude of GNSS signals as they rise or set behind the Earth's limb.
- The measured **phase delays** are converted into **bending angles** as a function of the impact parameter.
- Through an **Abel inversion**, the bending angle profiles are inverted to yield vertical profiles of **atmospheric refractivity**.
- From refractivity, profiles of **temperature**, **pressure**, **humidity**, and **ionospheric electron density** can be derived.

Because the L-band signals are relatively insensitive to clouds and precipitation, GNSS-RO provides robust data even under severe weather conditions — a major advantage over optical or infrared sensing techniques.

## 3. Applications and Impact on Atmospheric Science

### Weather Forecasting
GNSS-RO data significantly improve the skill of numerical weather prediction (NWP) models. Their ability to provide high-vertical-resolution temperature and moisture profiles in the upper troposphere and lower stratosphere (UTLS) — a region critical for weather dynamics — makes them highly valuable.

- **Example**: The **COSMIC/FORMOSAT-3** mission, launched in 2006, delivered tens of thousands of profiles per day and had one of the highest per-profile impacts among all observation types assimilated into weather models.

### Climate Monitoring
For climate studies, the long-term stability and precise vertical measurements of GNSS-RO are particularly critical. Unlike most remote sensing instruments that suffer from calibration drift, GNSS-RO measurements are fundamentally tied to atomic clock standards.

- **Example**: **COSMIC-2/FORMOSAT-7**, launched in 2019, improved tropical coverage and enhanced monitoring of lower atmospheric layers, important for studying tropical convection and climate feedback processes.

### Other Applications
- **Ionospheric Science**: Profiling ionospheric electron density for space weather monitoring.
- **Tropopause Studies**: Detecting tropopause height to study stratosphere-troposphere exchange processes.

## 4. Challenges and Limitations

Despite its strengths, GNSS-RO faces several limitations:

- **Coverage Density**: The number of daily occultations is limited (~20,000–30,000), needing denser constellations for finer-scale features.
- **Lower Troposphere Challenges**: Moist lower troposphere conditions lead to strong refractivity gradients and multipath effects, complicating signal retrieval.
- **Spherical Symmetry Assumption**: The Abel inversion assumes horizontal homogeneity, causing potential errors in regions with strong horizontal gradients.
- **High Costs and Mission Lifespan**: Building and maintaining constellations like COSMIC require substantial investment.

## 5. Future Advancements and Emerging Applications

The future of GNSS-RO is highly promising:

- **Mega-constellations**: Commercial networks like Starlink could dramatically increase the number of occultations.
- **New GNSS Signals**: Use of Galileo and BeiDou signals for redundancy and multi-frequency observations.
- **Advanced Retrieval Algorithms**: Non-spherical inversion methods and machine learning approaches could reduce retrieval errors.
- **Surface Remote Sensing (GNSS-R)**: Reflected GNSS signals can infer ocean surface roughness, soil moisture, and ice characteristics, expanding GNSS-RO applications beyond atmospheric sounding.

Ultimately, as GNSS-RO networks grow denser and retrieval techniques mature, this method will play an increasingly central role not only in weather and climate science but also in hydrology, agriculture, and disaster monitoring.

