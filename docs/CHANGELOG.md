# Tritium Changelog

Changes tracked with verification status. All changes on `dev` branch.

## Verification Levels

| Level | Meaning |
|-------|---------|
| **Unit Tested** | Passes automated unit tests (pytest, JS tests) |
| **Integration Tested** | Passes ./test.sh fast (tiers 1-3 + 8) |
| **Build Verified** | Firmware compiles, RAM/Flash within budget |
| **Human Verified** | Manually tested by a human on real hardware or browser |
| **Deployed** | Running on real hardware in the field |

---

## 2026-03-14 — Wave 16: Hardware Enablement

### Edge Firmware
- Radio scheduler HAL (`hal_radio_scheduler`) — BLE/WiFi time-division multiplexing
  with configurable slot durations, transition management, and os_events integration
- Camera MQTT publisher (`camera_mqtt_publisher`) — captures JPEG frames from CameraHAL
  and publishes to `tritium/{device_id}/camera/frame` for SC consumption
- MQTT SC bridge accessor for binary frame publishing

### Command Center (SC)
- JWT authentication middleware (`app/auth.py`) with login, refresh, and user info endpoints
- Auth router at `/api/auth/` with login, refresh, status endpoints
- Config additions: `auth_enabled`, `auth_secret_key`, `tls_enabled`, `rate_limit_enabled`
- Default admin user initialization on startup

### Shared Library
- Radio scheduler models: `RadioMode`, `RadioSchedulerConfig`, `RadioSchedulerStatus`
- Camera MQTT models: `CameraMqttConfig`, `CameraMqttStats`
- 13 new tests for radio models, 8 new tests for auth module

**Verification:**
- tritium-lib: 13/13 radio model tests pass
- tritium-sc: 8/8 auth tests pass
- tritium-edge: BUILD SUCCESS — 47.4% RAM, 28.9% Flash

---

## 2026-03-14 — Wave 15 Validation

### Wave 15: Complete the Stack — VALIDATED
- Edge OTA push via MQTT, frontend audit (automation rules, patrol drawing, geofence tools)
- Map visualization (trails, FOV cones, fused targets, RF motion rendering)
- Simulation realism (fake BLE/WiFi sightings during battle)
- Lib quality audit (stores, error handling, missing tests)

**Verification:**
- tritium-lib: 1049 passed, 29 skipped
- tritium-sc: 96 test tiers passed, 0 failed
- tritium-edge: BUILD SUCCESS — 47.4% RAM, 28.9% Flash

---

## 2026-03-13 — 10 Waves of Autonomous Development

### Summary

Ten waves of autonomous development transformed Tritium from a firmware OS with basic MQTT bridging into a full-spectrum cybernetic intelligence platform. The system now features multi-sensor fusion, graph-based entity ontology, autonomous threat response, and a comprehensive plugin architecture spanning three coordinated submodules.

---

### Wave 1-2: Infrastructure & Core Plugins

**Focus:** Documentation, licensing, core plugin architecture, tactical map rendering.

#### Parent Repo
- AGPL-3.0 licensing across all submodules
- `docs/ARCHITECTURE.md` — system diagram, component map, data flow
- `docs/STATUS.md` — component health dashboard
- `.claude/` workspace configuration and context-switching commands

#### tritium-edge
- WiFi network priority reordering
- MQTT SC bridge (`mqtt_sc_bridge.cpp/h`) — heartbeat, sighting, command topics
- MQTT AI bridge stub for future audio pipeline

#### tritium-sc
- Meshtastic LoRa mesh bridge plugin (serial/TCP, GPS, waypoints)
- Camera feeds plugin (synthetic/RTSP/MJPEG/MQTT/USB sources)
- EdgeTrackerPlugin BLE-to-TargetTracker integration
- BLE + mesh radio rendering on tactical map (cyan dots, green radio arcs)
- Asset placement panel (camera, sensor, mesh_radio, gateway types)
- ROS2 camera node example with MQTT detection pipeline

#### tritium-lib
- Meshtastic models (Node, Message, Waypoint, Status)
- Camera models (Source, Frame, Detection, BoundingBox)
- MQTT topic constants for Meshtastic + camera feeds
- Lazy imports for optional testing dependencies

**Verification:** Unit Tested + Integration Tested

---

### Wave 3-4: Pipeline Integration & Fleet Dashboard

**Focus:** End-to-end data flow, synthetic testing, fleet management.

#### tritium-sc
- MQTT camera integration wired through MQTTBridge
- MQTT edge sighting subscription for `tritium/+/sighting`
- Synthetic data generators (BLE, Meshtastic, camera pipeline)
- WebSocket broadcast for BLE and mesh targets via `/ws/live`
- Live camera feeds panel (MJPEG grid, status indicators, detection overlay)
- Fleet dashboard plugin with device registry and REST API
- Demo mode exercising full pipeline with synthetic data

**Verification:** Integration Tested (81 tiers passing)

---

### Wave 5-6: Perception & Tracking

**Focus:** Multi-sensor correlation, threat classification, geofencing, search.

#### tritium-sc
- Target correlation engine for multi-sensor fusion (BLE + camera + mesh)
- BLE device threat classification (known/unknown/new/suspicious levels)
- YOLO detector plugin with modular inference pipeline
- Target position history and movement trail rendering
- Target search and filter API with command panel
- Geofencing engine with zone management, enter/exit alerts, and map panel

**Verification:** Integration Tested

---

### Wave 7: Data Providers, Dossiers & Enrichment

**Focus:** Modular data architecture, persistent entity intelligence, GIS layers.

#### tritium-sc
- DataProviderPlugin interface and LayerRegistry for modular data sources
- Target enrichment pipeline (OUI, WiFi, BLE provider chaining)
- GIS layers plugin (OSM, satellite, building, terrain providers)
- Target Dossier panel and API for persistent entity intelligence

#### tritium-lib
- Target Dossier model for persistent entity intelligence
- SQLite-backed DossierStore for target intelligence persistence

**Verification:** Integration Tested + Unit Tested

---

### Wave 8: Smart Correlation, TAK Bridge & Fusion Demo

**Focus:** Identity resolution, military interoperability, multi-sensor showcase.

#### tritium-sc
- Smart correlator with pluggable strategy pattern:
  - SpatialStrategy (distance-based proximity scoring)
  - TemporalStrategy (co-movement detection from position history)
  - SignalPatternStrategy (appearance/disappearance timing)
  - DossierStrategy (known prior associations)
  - Weighted multi-strategy fusion engine
- DossierManager bridging TargetTracker (real-time) and DossierStore (persistent)
- TAK/CoT bridge plugin for ATAK interoperability (geochat, spot reports, video feeds)
- Multi-sensor fusion demo scenario (person patrol, vehicle road path, geofence intrusion)

**Verification:** Integration Tested

---

### Wave 9: Graph Ontology & Investigations

**Focus:** Knowledge graph, entity relationships, investigation workflows.

#### tritium-sc
- Graph Explorer panel with force-directed entity relationship visualization
- Ontology REST API (`/api/ontology/entities`, links, actions)
- Investigation workflow engine (create, add leads, analyze, resolve)
- Automation engine plugin with if-then rules and action executors
- Amy autonomous dispatch (threat response, asset selection, fusion narration)
- Target timeline API and panel with chronological event view
- Patrol pattern system with waypoint routes
- Correlator-to-graph integration (CARRIES/DETECTED_WITH edges)

#### tritium-lib
- KuzuDB embedded graph database for ontology layer
- Formal ontology schema: 10 entity types, 12 relationships, 3 interfaces
- DossierStore `_update_json_field` helper for atomic updates

**Verification:** Integration Tested + Unit Tested

---

### Wave 10: Autonomy & Instinct Layer

**Focus:** Autonomous threat response, Sense-Decide-Act pipeline.

#### tritium-sc
- Amy instinct layer: automatic threat response rules
- Full Sense-Decide-Act pipeline integration test
- Correlator graph store integration tests

**Verification:** Integration Tested

---

### Wave 11: Code Audit & Integration Test

**Focus:** Quality audit, missing test registration, JS test alignment.

#### tritium-sc
- Registered 15 missing JS test files in test.sh tier 3
- Fixed JS test assertions to match refactored source code
- Full integration test suite validation

**Verification:** Integration Tested

---

### Wave 12: Intelligence Enrichment

**Focus:** Geolocation, re-identification, threat feeds, trilateration, notifications.

#### tritium-sc
- WiFi BSSID geolocation enrichment provider with local cache
- Threat intelligence feed plugin with known-bad indicator matching

#### tritium-lib
- ReID embedding store for cross-camera re-identification
- Geo and notifications modules extracted from tritium-sc

**Verification:** Integration Tested + Unit Tested

---

### Wave 13: RF Motion Detection & Analytics

**Focus:** RF-based motion sensing, density heatmaps, quality audit, test reporting.

#### tritium-sc
- RF motion detection plugin — RSSI variance monitoring between stationary radios for cameraless motion detection
- Multi-node BLE trilateration engine wired to edge tracker (3+ node position computation)
- Motion heatmap layer with activity density visualization on tactical map
- Unified test reporting system with coverage gap analysis and trend tracking
- Heatmap, RF motion, and test reporting wired into main app

**Verification:** Integration Tested (96 tiers passing, 0 failures)

---

### tritium-edge (across all waves)

| Change | Verification |
|--------|-------------|
| Remote control click API | Build Verified |
| Screensaver dismiss fix for remote API | Build Verified |
| Developer settings tab with FreeRTOS tasks, I2C scan | Build Verified |
| Notification shade with quick settings and dismiss | Build Verified |
| NTP diagnostics provider fix | Build Verified |
| WiFi network priority reordering | Build Verified |
| MQTT SC bridge (heartbeat/sighting/cmd) | Build Verified |
| MQTT AI bridge stub | Build Verified |

---

## Test Baselines

| Suite | Start (Wave 1) | Final (Wave 13) | Status |
|-------|----------------|-----------------|--------|
| tritium-lib pytest | 833 passed | 1024 passed, 20 skipped | All passing |
| tritium-sc fast (tiers 1-3+8) | 81 tiers | 96 tiers | All passing |
| tritium-edge build | 45.9% RAM, 28.8% Flash | 44.7% RAM, 28.5% Flash | 0 warnings |

---

## Known Issues

| Issue | Status | Impact |
|-------|--------|--------|
| BLE scanner disabled (WiFi/BLE coexistence) | Open | No real BLE data flows; MQTT pipeline ready |
| NimBLE esp_bt.h not found | Open | Blocks BLE serial + BLE OTA |
| RGB parallel display glitches (43C-BOX + USB) | Cosmetic | Memory bus contention |
| 18 tests in `test_websocket.py` fail | Pre-existing | Missing asyncio event loop |
