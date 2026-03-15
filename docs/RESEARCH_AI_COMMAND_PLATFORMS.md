# Research: AI-Powered Command & Control Platforms (2024-2026)

This document synthesizes publicly available information about modern AI-powered command centers, battlefield management systems, video analytics platforms, and commercial security operations centers. No specific companies are named — capabilities are described generically to inform Tritium's roadmap.

---

## 1. Key Capabilities We Should Emulate

### Unified Operating Picture with Multi-Sensor Fusion

Leading platforms create a single continuously-updated tactical picture that fuses data from every available sensor domain — RF, optical, radar, acoustic, cyber, and signals intelligence. The key architectural patterns are:

- **Sensor-agnostic data normalization**: Every sensor produces events in a common schema. Raw data is transformed at the edge or at ingestion into a standardized format (entity ID, position, time, confidence, source type). This allows the fusion engine to operate independently of sensor type.
- **Real-time correlation engine**: AI-driven data association algorithms resolve conflicting sensor inputs. When a camera sees a person and a BLE scanner detects a phone at the same location, the system automatically creates a single fused entity. Bayesian networks and deep learning improve this over time.
- **Layered information hierarchy**: Operators can toggle layers on/off (RF detections, visual detections, mesh nodes, friendly assets, hostile indicators) without losing the unified picture. The map is the single source of truth, and every sensor feeds into it.
- **Digital twin of the operating area**: Advanced systems maintain a real-time digital twin that tracks and visualizes movement of all entities, enabling commanders to make data-driven decisions based on evolving situations. The twin persists state even when individual sensors go offline.

### AI/ML for Target Classification and Threat Assessment

- **Multi-stage classification pipeline**: Detection → identification → classification → threat scoring. Each stage can use different ML models optimized for that task.
- **Behavioral pattern recognition**: Beyond static classification (phone, vehicle, person), leading platforms detect behavioral patterns — stationary-then-mobile, circling, approach-retreat, coordinated movement of multiple entities.
- **Threat scoring with explainability**: Not just "hostile/friendly" but a numeric score with reasons. "Score 78: Unknown device, unusual hours, repeated zone boundary approach, no matching friendly registry entry." Operators need to understand WHY the AI flagged something.
- **Continuous learning from operator feedback**: When operators tag a target as friendly or dismiss an alert, the system learns. This operator-in-the-loop feedback loop is what makes classification improve over deployment time.

### AI Assistant for Operator Interaction

- **Natural language querying**: Operators can ask "Show me all new devices detected in the last 4 hours near the north perimeter" and get instant filtered views. The AI translates natural language into structured queries across the sensor database.
- **Decision support, not decision making**: AI recommends actions ("Suggest dispatching drone to grid reference X — 3 unidentified targets converging"), but humans retain final authority. The interface presents options with confidence scores, not directives.
- **Event narration**: During active operations, the AI assistant provides running commentary — "New contact bearing 270, classified vehicle, entering monitored zone Alpha" — reducing the cognitive load on operators who are watching multiple feeds.
- **Contextual awareness**: The AI assistant has access to all sensor feeds, historical data, and the current operating picture. It can answer questions like "Has this device been seen before?" or "What was happening in sector 3 at 0200?"

### Kill Chain Automation (Sensor-to-Effector)

Modern platforms demonstrate fully digital, end-to-end workflows where AI handles detection, classification, tracking, and engagement recommendation automatically — with humans approving the final action. Key patterns:

- **Automated threat escalation**: Detection triggers classification, which triggers tracking, which triggers alert, which presents engagement options. Each step is automated but auditable.
- **Modular kill chain components**: The platform supports any sensor, any C2 system, any effector. The kill chain is a pipeline, not a monolith. New capabilities plug in without redesigning the system.
- **Time compression**: The goal is reducing minutes-to-hours decision cycles to seconds. AI processes data at machine speed; humans approve at human speed but with much better information.

---

## 2. UI/UX Patterns Worth Adopting

### Tactical Map as the Central Canvas

- **NATO APP-6 style symbology**: Standardized icons for different entity types (person, vehicle, sensor, friendly asset, hostile, unknown). Color coding by alliance/threat level. Every entity on the map uses a consistent visual language.
- **Layered filtering with quick toggles**: A persistent layer bar lets operators show/hide sensor types, entity classes, zones, routes, and infrastructure with single clicks. The map never becomes overwhelming because operators control what they see.
- **Decluttered zoom levels**: At high zoom, show individual targets with detail labels. At low zoom, cluster targets into density heat maps or aggregate counts. The map must remain readable at every zoom level.
- **Context menus on right-click**: Right-click any map entity to get contextual actions — dispatch asset, create zone, investigate target, set waypoint, mark hostile. This is faster than navigating menus.

### Target Dossier / Entity Profile Card

- **360-degree entity view**: Click any entity and get a comprehensive profile card showing: all sensor sources contributing to this entity, complete timeline of sightings, behavioral analysis, signal history charts, correlated entities, zone history, and operator tags.
- **Network graph visualization**: Show connections between entities — "this phone travels with that vehicle," "these 3 BLE devices are always co-located." Entity relationship graphs are a primary investigation tool.
- **Timeline scrubber**: For any entity, scrub through its history. See where it was at any point in time. See when it entered/exited zones. See what other entities were nearby at each moment.

### Mission Planning and Tasking Interface

- **Timeline-based mission view**: Missions displayed alongside a timeline showing planned phases, current progress, and asset assignments. Each asset's mission is visible in context.
- **Drag-and-drop asset assignment**: Drag a drone/robot/sensor from an asset inventory onto the map to assign it a position or task. Visual feedback shows coverage areas and patrol routes.
- **Multi-mission overlay**: An officer managing multiple concurrent operations can see all missions overlaid on the same map with distinct visual layers, or isolate a single mission.

### Alert and Notification UX

- **Tiered alert system**: Critical (immediate popup + audio), Warning (banner + badge), Info (log entry). Not everything is urgent — alert fatigue is the top complaint in every operations center.
- **Alert triage workflow**: New alert → operator reviews → classify (real threat / false positive / policy violation) → action (respond / dismiss / tune rule) → report. Every alert has a lifecycle.
- **Escalation chains**: If a Level 1 alert is not acknowledged within N seconds, it escalates to Level 2. If Level 2 does not respond, it escalates to a supervisor. Automated escalation prevents missed critical events.

### Cognitive Load Reduction

- **Progressive disclosure**: Show minimal information by default. Details expand on click/hover. Experts can pin expanded views; novices see the simplified version.
- **Color coding consistency**: Across the entire platform — hostile is always the same color, friendly is always the same color, unknown is always the same color. No cognitive translation needed.
- **Audio cues**: Distinct sounds for different alert types. Operators learn to recognize threat levels by sound before reading the alert. Optional, mutable, configurable.

---

## 3. Video Analytics Integration Ideas

### Real-Time Detection on Live Feeds

- **Multi-model inference pipeline**: Run object detection (people, vehicles), pose estimation, license plate recognition, and custom classifiers simultaneously on each feed. Results stream to the unified picture in real-time.
- **Detection-triggered recording**: Cameras can run in low-bandwidth monitoring mode, only recording full-resolution when a detection event occurs. Reduces storage costs dramatically.
- **Bounding box overlay on live view**: When viewing a camera feed in the command center, detections are overlaid in real-time with class labels and confidence scores. Clicking a detection creates a tracked target.
- **Cross-camera handoff**: When a tracked person leaves one camera's FOV, the system predicts which camera they will appear in next and pre-alerts that feed for the operator.

### Historical Video Review and Forensic Search

- **Natural language video search**: "Show me all red cars from yesterday between 2pm and 6pm" — the system returns timestamped clips from all cameras matching the query. This is the transformative capability that collapses investigation time from hours to seconds.
- **Appearance-based search**: Select a person or vehicle in one clip, and the platform searches all cameras across days of footage to find every appearance of that same entity. This is the video equivalent of "track this target across all sensors."
- **AI-indexed video archive**: Every frame is processed by AI and turned into a searchable description. The raw video is stored, but so is a metadata index of every detected object, action, and scene characteristic. Search queries hit the index, not the video.
- **Investigation workspace**: Drag relevant clips into an investigation timeline. Annotate them. Link them to entity dossiers. Export as a case report. The forensic workflow is integrated into the same platform as live monitoring.

### Video-to-Map Integration

- **Camera FOV cones on tactical map**: Each camera's field of view is drawn as a cone on the map. When a detection occurs in a camera, the corresponding map position lights up. Operators can see which cameras cover which areas.
- **Click-to-view from map**: Click a camera icon on the map to pop up its live feed. Click a detection on the map to jump to the camera feed at the moment of detection.
- **3D scene reconstruction**: For overlapping camera fields, reconstruct a 3D view of the monitored area. Place detections in 3D space, not just 2D map coordinates.

---

## 4. Historical Data Review Workflows

### Entity History and Movement Trails

- **Breadcrumb trails**: Show a target's movement over time as a trail on the map. Color-code the trail by time (recent = bright, old = faded) or by speed (moving = one color, stationary = another).
- **Heatmap of activity**: Over hours or days, where has an entity spent the most time? Heat maps reveal patterns — regular routes, frequent stops, unusual deviations.
- **Historical playback**: Scrub a timeline slider to replay the entire operating picture at any past time. See where all targets were at 3am last Tuesday. This is essential for after-action review and incident investigation.

### Forensic Investigation Workflow

1. **Alert triggers investigation**: A zone violation, threat score threshold, or manual flag starts an investigation.
2. **Automatic context gathering**: The system pulls all relevant data — every sighting of the entity, every correlated entity, every camera clip, every zone interaction, every RF signature event.
3. **Investigation timeline**: All evidence is presented on a unified timeline. The investigator can see what happened before, during, and after the triggering event across all sensors.
4. **Collaborative investigation**: Multiple operators can contribute to the same investigation. Notes, tags, and assessments are shared in real-time.
5. **Report generation**: Export the investigation as a structured report with timeline, evidence clips, entity profiles, and operator annotations.

### Audit and Compliance

- **Complete audit trail**: Every operator action, every AI decision, every alert disposition is logged with timestamp and user identity.
- **Retention policies**: Different data types have different retention periods. Video may be 30 days, metadata 1 year, investigation reports permanent.
- **Chain of custody**: For forensic evidence, the platform tracks who accessed what data and when, maintaining evidentiary integrity.

---

## 5. Gaps in Tritium's Current Approach

### Critical Gaps

1. **No historical playback**: Tritium shows the current state of the operating picture but cannot replay past states. An operator cannot answer "what happened here 2 hours ago?" This is a fundamental capability of every competing platform.

2. **No forensic video search**: The YOLO detector processes live frames, but there is no indexed video archive, no natural language search, no appearance-based search. Detected objects are transient — once they leave the frame, the detection is lost unless it became a tracked target.

3. **No investigation workflow**: There is no concept of an "investigation" or "case" that collects evidence from multiple sensors about a specific entity or event. The dossier system exists in backend but has no investigation lifecycle (open → gather evidence → annotate → close → report).

4. **Alert workflow is incomplete**: Geofence zones can be drawn, but the alert → triage → investigate → report pipeline is not wired. There is no alert panel showing pending alerts with disposition buttons. There is no escalation system.

5. **Entity history is ephemeral**: TrackedTargets exist in memory but their full history (every sighting, every RSSI reading, every zone interaction) is not persisted in a queryable way. The dossier enrichment (behavioral profiles, signal history) exists in backend but is not visualized or searchable.

6. **No cross-camera tracking**: Each camera feed is processed independently. There is no re-identification system to track a person or vehicle as they move from one camera to another. The target correlator exists for BLE+camera fusion but not for camera-to-camera identity persistence.

### Moderate Gaps

7. **Amy is not contextually aware during operations**: The AI assistant exists but does not narrate events, answer natural language queries about the operating picture, or provide decision support during active operations. Leading platforms have AI assistants that are deeply integrated into the sensor pipeline.

8. **No detection-triggered recording**: Camera feeds are either always streaming or not. There is no event-driven recording that captures high-resolution clips only when detections occur.

9. **Map lacks progressive disclosure**: The tactical map shows all targets at all zoom levels. There is no clustering at low zoom, no decluttering, no density heatmaps for areas with many targets.

10. **No audio cues for alerts**: The system is entirely visual. Leading platforms use distinct audio signatures for different alert types to reduce cognitive load.

11. **Target dossier lacks network graph**: The entity relationship model exists conceptually (graph ontology document) but the UI has no network visualization showing how entities relate to each other.

12. **No timeline scrubber for entity history**: Even where historical data exists (signal history, zone events), there is no timeline UI component that lets operators scrub through an entity's past.

### Minor Gaps

13. **No collaborative investigation**: Multiple operators cannot work on the same investigation simultaneously.

14. **No report generation**: There is no export function to produce a structured investigation or incident report.

15. **No camera FOV cones on map**: Camera positions exist on the map but their field of view is not visualized.

---

## 6. Specific Features to Add to UX-LOOPS.md

Based on this research, the following new loops and loop steps should be added:

### New Loop: Historical Playback — "What happened here last night?"

Steps:
1. Open timeline scrubber at bottom of map
2. Drag to a past time — map shows operating picture at that moment
3. Press play to watch events unfold at accelerated speed
4. Click any historical target to see its dossier at that point in time
5. Bookmark interesting moments for investigation

Priority: HIGH — This is a fundamental capability gap. Every competing platform has this.

### New Loop: Forensic Video Search — "Find that red car"

Steps:
1. Open forensic search panel
2. Type natural language query: "person with backpack near gate 3 after midnight"
3. See matching video clips from all cameras, ranked by relevance
4. Click a clip to view it with detection overlays
5. Click "Track this entity" to see all appearances across all cameras and time
6. Add clips to an investigation case

Priority: HIGH — This converts cameras from passive monitors to active investigation tools.

### New Loop: Investigate an Incident — "What happened and who was involved?"

Steps:
1. Create investigation from an alert, zone violation, or manual trigger
2. System auto-gathers all relevant sensor data (BLE sightings, camera clips, zone events)
3. View unified evidence timeline across all sources
4. Annotate evidence with notes and tags
5. Link correlated entities into the investigation
6. Generate investigation report with timeline, evidence, and findings
7. Close investigation with disposition (confirmed threat / false alarm / inconclusive)

Priority: MEDIUM — Needed for operational use but can be built incrementally on existing dossier backend.

### Additions to Existing Loops

**Loop 1 (First Boot)** — Add step: Audio confirmation when UI loads (subtle ambient tone or "system online" cue). Add step: Map shows target density heatmap at low zoom, individual targets at high zoom.

**Loop 5 (Monitor Zone)** — Add steps: Alert appears in dedicated Alerts panel with triage buttons (Acknowledge / Dismiss / Investigate). Alert escalates if not acknowledged within configurable timeout. Alert disposition is logged for audit.

**Loop 6 (Investigate Target)** — Add steps: See network graph of related entities (co-located devices, correlated identities). Scrub timeline of entity's complete history. See all camera appearances of this entity (cross-camera re-ID). Export entity report.

**Loop 8 (Connect Camera)** — Add steps: Camera FOV cone visible on tactical map. Detection-triggered recording (only save clips when objects are detected). Click detection on map to jump to camera feed at that timestamp.

### New Loop: Ask Amy — "What should I be worried about?"

Steps:
1. Open Amy chat panel
2. Ask natural language question about the operating picture
3. Amy responds with relevant data, charts, and map highlights
4. Ask Amy to summarize threats in a sector
5. Ask Amy to predict where a target is heading based on movement history
6. Amy proactively alerts operator to anomalies she detects

Priority: MEDIUM — Amy infrastructure exists; needs deep integration with sensor pipeline and natural language query capability.

---

## Summary

The gap between Tritium's current state and leading platforms is primarily in three areas:

1. **Temporal depth**: Tritium shows the present. Competing platforms show past, present, and predicted future. Historical playback, forensic search, and entity timelines are the core capabilities that separate a monitoring tool from an intelligence platform.

2. **Investigation workflow**: Tritium detects and displays. Competing platforms detect, display, investigate, and report. The alert-to-investigation-to-report pipeline is what makes a platform operationally useful for security teams.

3. **AI integration depth**: Tritium has an AI assistant (Amy) and ML classifiers, but they are not deeply integrated into the operator's workflow. Leading platforms have AI that narrates events, answers natural language queries about sensor data, and provides predictive analysis — all within the same interface the operator already uses.

The good news: Tritium's architecture (plugin system, MQTT event bus, target model, dossier backend) is well-suited to add these capabilities incrementally. The sensor fusion and target tracking infrastructure exists. The primary work is in temporal data persistence, forensic indexing, investigation workflow UI, and deeper Amy integration.
