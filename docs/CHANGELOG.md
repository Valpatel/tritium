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

## 2026-03-14 — Wave 38: Multi-Camera, Target Merge, Amy Monologue, Power Saver, Sensor Config

### Shared Library (tritium-lib)
- Added `models/sensor_config.py` — SensorPlacement, SensorArray, SensorType, MountingType, SensorStatus (Unit Tested, 19 tests)
- Standardized sensor description across edge and SC: position, height, FOV, rotation, coverage radius, mounting type

### Command Center (tritium-sc)
- Multi-Camera View panel — 2x2/3x3 grid of camera feeds with per-camera detection overlays, click-to-expand (Build Verified)
- Target Merge Workflow panel — side-by-side comparison, preview merge, confirm merge to combine dossiers (Build Verified)
- Amy Conversation panel — full inner monologue stream, cognitive layer activity bars, tactical Q&A (Build Verified)
- Data Export Scheduler panel — configure hourly/daily/weekly automatic exports of targets, dossiers, reports (Build Verified)
- CSS styles for all four new panels

### Edge Firmware (tritium-edge)
- `hal_power_saver` — automatic power-saving when battery <20%: reduces scan intervals, dims display to 10%, resumes on charging (Build Verified)
- Three power states: NORMAL, POWER_SAVE, CRITICAL (<10%), with hysteresis to prevent oscillation

---

## 2026-03-14 — Wave 36: Maintenance — Docs, Quality, Features

### Shared Library (tritium-lib)
- Fixed `datetime.utcnow()` DeprecationWarning in `models/mission.py` — use `datetime.now(timezone.utc)` (Unit Tested)
- Fixed JWT `InsecureKeyLengthWarning` in test keys — padded to 32+ bytes (Unit Tested)
- Added pytest filterwarnings config in `pyproject.toml` to catch all warnings as errors (Unit Tested)
- **Quality pass: 1357 passed, 29 skipped, 0 warnings** (was 51 warnings)

### Command Center (tritium-sc)
- Added `GET /api/docs` — auto-generated JSON catalog of all API endpoints from FastAPI OpenAPI schema (Build Verified)
  - `/api/docs` — full catalog with parameters and request body schemas
  - `/api/docs/summary` — compact method + path + summary listing
  - `/api/docs/tags` — endpoints grouped by tag
- Added investigation map layer overlay — `GET /api/investigations/{id}/map-entities` returns positioned entities for tactical map rendering (Build Verified)
  - `GET /api/investigations/active/map-overlay` — aggregated overlay for all open investigations
  - Entities enriched from TargetTracker positions and DossierStore metadata

### Edge Firmware (tritium-edge)
- Added startup chime on boot completion — C5-E5-G5 ascending major triad (Build Verified)
  - Conditional on `HAS_AUDIO_CODEC` — only plays on boards with ES8311 codec
  - Plays after `boot_sequence::showReady()` and `services_init()` complete

### Documentation
- Updated `docs/STATUS.md` — 27 capabilities, 1357+ lib tests, Wave 36 additions
- Updated `plugins/README.md` — 14 plugins with descriptions
- Rule system redundancy analysis: 3 rule types (AutomationRule, AlertRule, NotificationRule) serve distinct layers; shared fields documented but base class not warranted

---

## 2026-03-14 — Wave 33: Maintenance — Docs, Redundancy, Features

### Shared Library (tritium-lib)
- Added `models/mission.py` — Mission, MissionObjective, MissionType, MissionStatus, GeofenceZone (Unit Tested)
  - Lifecycle methods: start, pause, complete, abort with timestamp tracking
  - Objective tracking with progress calculation
  - Geofence zones (polygon or circle) for area of operations
  - 16 tests, all passing

### Command Center (tritium-sc)
- WebSocket reconnection with exponential backoff (Build Verified)
  - Backoff: 1s -> 2s -> 4s -> 8s -> 16s cap (was 2s with 1.5x)
  - Fixed magenta DISCONNECTED banner at viewport top when connection drops
  - Auto-clears on reconnect with full state refresh
- Target pinning via right-click context menu (Build Verified)
  - Pin/Unpin toggle in context menu for selected targets
  - Pinned targets persist to localStorage across reloads
  - Pinned targets protected from stale-target pruning in store
  - Yellow pin icon rendered on map next to pinned targets

### Edge Firmware (tritium-edge)
- Boot diagnostics summary on serial output (Build Verified)
  - ASCII table showing board type, display resolution, firmware version
  - Heap/PSRAM/flash usage at boot
  - Status of all subsystems: WiFi, BLE, MQTT, LoRa, ESP-NOW, CoT, webserver, diag
  - Firmware: 47.9% RAM, 29.1% Flash (within budget)

### Documentation & Redundancy
- Updated iteration queue: Waves 29-32 marked DONE, Waves 34-36 planned
- Updated STATUS.md with Wave 33 baseline (1364+ lib tests, 26 capabilities)
- Redundancy audit: all 8 stores use BaseStore, geo re-export verified clean, no duplicate JSON helpers
- Updated CHANGELOG.md with Wave 33 entries

---

## 2026-03-14 — Wave 32: Security + Skepticism Audit

### Command Center (tritium-sc)
- Fixed 6 innerHTML XSS injection points across map tooltip, targets, assets, analytics, zones, war HUD (Unit Tested)
- Upgraded `_escFx()` escape function to handle `&` and `"` characters
- Replaced raw URL injection in assets.js with DOM API + protocol whitelist
- Added `_esc()` to analytics.js and zones.js (legacy) which lacked it
- 5 rate limiter HTTP tests proving 429 responses after limit exceeded (Unit Tested)
- 5 demo mode E2E tests proving synthetic data -> targets -> dossiers pipeline works (Unit Tested)
- 6 WebSocket load tests proving 10 concurrent connections handle 500 messages without degradation (Unit Tested)
- Audited all 43 frontend panels: all have real API backends (36 via routers/plugins, 7 via EventBus/Store)

## 2026-03-14 — Wave 31: Target Filtering, Command Palette, WiFi Probes, API Versioning

### Shared Library (tritium-lib)
- Added `store/config_store.py` — ConfigStore for system-level key-value configuration (Unit Tested)
  - Namespaced key-value store backed by SQLite WAL
  - JSON serialization support for complex values
  - Batch writes, namespace operations, count queries
  - 16 tests passing

### Command Center (tritium-sc)
- Target filter overlay on tactical map (Build Verified)
  - Filter visible targets by source (BLE/WiFi/Camera/Mesh/RF/Sim)
  - Filter by alliance (Friendly/Hostile/Unknown)
  - Filter by asset type (Person/Vehicle/Drone/Rover/etc.)
  - Client-side filtering integrated into map renderer
- API versioning with /api/version endpoint (Unit Tested)
  - GET /api/version returns API version info and supported namespaces
  - GET /api/v1/version establishes v1 namespace
  - 3 tests passing
- Command palette with Ctrl+K or / shortcut (Build Verified)
  - VS Code-style fuzzy searchable command palette
  - All actions: panel toggles, map layers, map modes, game controls, demo mode
  - Arrow keys + Enter navigation, escape to close
- Target comparison panel for side-by-side analysis (Build Verified)
  - Select 2+ targets, compare all properties
  - Highlights differences between targets
  - Calculates similarity score for merge candidates
  - Distance calculation between compared targets

### Edge Firmware (tritium-edge)
- WiFi probe request capture HAL (Build Verified)
  - ESP32 promiscuous mode passively captures WiFi probes
  - Extracts device MAC and probed SSIDs for fingerprinting
  - Detects MAC randomization (locally administered bit)
  - Tracks RSSI range, probe count, multiple SSIDs per device
  - Service adapter publishes wifi_probe sightings via MQTT
  - Optional channel hopping for broader coverage

---

## 2026-03-14 — Wave 30: Maintenance — Docs, Redundancy Audit, Features

### Shared Library (tritium-lib)
- Added `models/summary.py` — SystemSummary, TargetCounts, FleetSummary (Unit Tested)
  - Point-in-time system state snapshot for /api/health and dashboards
  - Target counts by alliance (friendly/hostile/unknown) and source (ble/yolo/mesh/wifi/rf_motion)
  - Fleet summary, plugin status, alert counts, investigation counts
  - 12 tests, all passing
  - 1348 total tests passing

### Command Center (tritium-sc)
- Real-time target counter widget in header bar (Build Verified)
  - Live count of total targets with alliance breakdown (friendly/hostile/unknown)
  - Color-coded chips: green=friendly, red=hostile, yellow=unknown
  - Updates via TritiumStore subscription with requestAnimationFrame debounce
- Dark/light theme toggle (Build Verified)
  - Toggle button in header bar, persisted to localStorage
  - Light theme: slate/teal color palette for outdoor visibility
  - Removes scanline overlay and grid background in light mode

### Edge Firmware (tritium-edge)
- Diagnostic self-test: `run_self_test()` and `/api/diag/selftest` endpoint (Build Verified)
  - 7 checks: WiFi connectivity, MQTT reachability, NTP sync, SD card, free heap, PSRAM, uptime/reboot info
  - JSON output with per-check pass/fail and detail strings
  - Firmware: 47.9% RAM, 29.1% Flash (within budget)

### Documentation
- Updated `docs/STATUS.md` — current state at Wave 29 (24 capabilities, 14 plugins, 1348 tests)
- Updated `CLAUDE.md` feature roadmap — 60 completed items through Wave 29
- Added `docs/RULE_TYPES.md` — redundancy analysis of AlertRule vs AutomationRule vs NotificationRule
  - Three types serve distinct pipeline stages: action execution, alert generation, notification routing
  - Shared base not recommended yet due to different responsibilities

---

## 2026-03-14 — Wave 29: Coverage Layers, Target Detail, Alert Rules, Mesh Sighting Relay

### Shared Library (tritium-lib)
- Added `models/alert_rules.py` — AlertRule, AlertCondition, AlertTrigger, ConditionOperator (Unit Tested)
  - Event-driven alert generation with trigger matching, condition evaluation, cooldown, severity
  - 10 condition operators (eq, neq, gt, lt, gte, lte, contains, not_contains, in, regex)
  - Zone and target alliance filters
  - 5 default alert rules (hostile detected, geofence breach, device offline, battery critical, target loiter)
  - 22 tests, all passing

### Command Center (tritium-sc)
- Map: BLE/WiFi coverage layer for edge nodes — dual-ring display with BLE ~30m cyan inner ring and WiFi ~50m blue outer ring (Build Verified)
- Map: Target detail modal on double-click — rich modal with all identifiers, signal stats (RSSI/confidence), position trail mini-map (SVG), enrichments, dossier link, and action buttons (Build Verified)
- API: `GET /api/targets/export?format=csv|json|geojson` — export all targets in standard formats for external tools (Unit Tested)
- API: `GET /api/investigations/{id}/graph` — returns nodes+edges for investigation link chart visualization (Build Verified)

### Edge Firmware (tritium-edge)
- Mesh protocol: `MESH_EX_SIGHTING` message type with `MeshSightingPayload` for compact BLE/WiFi sighting relay (Build Verified)
- MeshManager: `relaySighting()` and `relaySightingBatch()` for forwarding sightings from leaf/sensor nodes to gateway via TTL-based mesh routing (Build Verified)
- Gateway nodes deliver received sightings to callback for MQTT publishing
- Firmware: 47.9% RAM, 29.1% Flash (within budget)

---

## 2026-03-14 — Wave 28: Measurement Tools, Export/Import, MAC Randomization

### Shared Library (tritium-lib)
- Added `models/export.py` — ExportManifest, ExportPackage, ExportSection, ImportResult (Unit Tested)
- 12 export section types for portable system state bundles
- `create_export_manifest()`, `validate_import_compatibility()` utilities
- 12 new tests, all passing

### Command Center (tritium-sc)
- Map measurement tool: press X to toggle, click two points to measure distance in meters/km (Unit Tested)
  - ESC cancels active measurement, Delete clears all measurements
  - Dashed yellow lines with labeled distance at midpoint
- Automation rule export/import: GET /api/automation/export, POST /api/automation/import (Unit Tested)
  - JSON package format with metadata and overwrite option
  - 3 new tests for export format, roundtrip, and field preservation
- Fleet dashboard sparklines: target count history per device recorded on heartbeat (Unit Tested)
  - GET /api/fleet/devices/{id}/sparkline and GET /api/fleet/sparklines endpoints
  - 60-point history (1 per minute = 1 hour of data)
- Added READMEs to 6 engine subdirectories: actions, inference, nodes, perception, plugins, units
- Redundancy audit: haversine already re-exported from tritium_lib.geo, no duplicate logic found

### Edge Firmware (tritium-edge)
- BLE MAC randomization detection: locally administered bit detection on first octet (Build Verified)
- Timing correlation: departed random-MAC devices correlated with new arrivals within 5s at similar RSSI
- Rotation groups: devices that rotate MACs are linked by group ID
- JSON output includes `random_mac` and `rotation_group` fields

---

## 2026-03-14 — Wave 26: WS Compression, Clustering, Event Schemas, RSSI History

### Shared Library (tritium-lib)
- Added `models/event_schema.py` — 41 typed event schemas across 17 domains (Unit Tested)
- All EventBus event types now have dataclass schemas with descriptions
- `validate_event_type()`, `get_event_schema()`, `list_event_types()` helpers
- 1273 tests passing

### Command Center (tritium-sc)
- WebSocket TargetUpdateBatcher: deduplicates target updates by target_id, 5-10x bandwidth reduction (Unit Tested)
- Target clustering: `GET /api/targets/clusters?zoom=N` — grid-based spatial grouping for map readability (Unit Tested)
- Frontend TargetClusterer module: client-side clustering with zoom-adaptive cell sizes
- Ontology schema endpoint: `GET /api/v1/ontology/schema` — full JSON export of entity types, actions, events (Unit Tested)
- Map bookmark system: `GET/POST/PUT/DELETE /api/bookmarks` with frontend panel (Unit Tested)
- 2319 Python tests passing, 92 JS test tiers passing

### Edge Firmware (tritium-edge)
- BLE RSSI history: circular buffer of 30 readings per device with trend analysis (Build Verified)
- Trend detection: approaching/departing/stable (3dBm threshold)
- New serial command: `BLE_RSSI AA:BB:CC:DD:EE:FF`
- Fleet server: `GET /api/ble/devices/{mac}/rssi_history` endpoint

---

## 2026-03-14 — Wave 25: Maintenance & Quality

### Shared Library (tritium-lib)
- Migrated BleStore, TargetStore, ReIDStore to BaseStore base class
- Removed dead `oui_lookup` import from DeviceClassifier
- Added READMEs for `web/` and `config/` modules
- All 1273 tests passing (29 skipped)

### Command Center (tritium-sc)
- Added System Health panel: plugin statuses, targets, dossiers, notifications, Amy, demo, tests
- Added Quick Start panel: new user orientation with demo launch and panel links
- Enhanced edge_tracker: Apple Continuity device types now flow from edge through to TargetTracker
- Removed dead `oui_lookup` import from enrichment module
- Added READMEs for federation plugin, motion-sensor demo, swarm-drone demo
- Updated plugins/README.md with federation plugin entry
- Satellite imagery toggle already fully implemented (verified: Esri World Imagery tiles,
  toggleSatellite in map-maplibre.js, satellite layer in layers panel and menu bar)

### Edge Firmware (tritium-edge)
- Added READMEs for 5 HAL libraries: hal_rf_monitor, hal_config_sync,
  hal_radio_scheduler, hal_sighting_buffer, hal_cot
- Verified Apple Continuity data (device_type, class fields) already present
  in BLE sighting JSON output via get_devices_json()

**Verification:**
- tritium-lib: 1273/1273 tests pass (BaseStore migration verified)
- tritium-sc: 50/50 plugin tests pass
- Dead imports removed, redundant boilerplate eliminated

---

## 2026-03-14 — Wave 24: Advanced Correlation & Behavior

### Shared Library
- Behavior models: `BehaviorPattern`, `BehaviorAnomaly`, `TargetRoutine`,
  `CorrelationScore`, `PositionSample`, anomaly severity classification
- Correlation scoring function with temporal, spatial, and co-movement weighting
- 16 behavior model tests passing

### Command Center (SC)
- Behavior API at `/api/behavior/` with pattern, anomaly, correlate, and stats endpoints
- Target correlation scoring for sensor fusion (should_fuse threshold)
- 11 behavior router tests passing

**Verification:**
- tritium-lib: 16/16 behavior tests pass (1249 total)
- tritium-sc: 11/11 behavior tests pass

---

## 2026-03-14 — Wave 23: Geospatial Intelligence

### Shared Library
- Terrain models: `ElevationPoint`, `ElevationProfile`, `CoverageAnalysis`, `CoverageCell`,
  `SensorPlacement`, `WeatherConditions`, `TerrainType`
- RF propagation functions: `free_space_path_loss_db`, `terrain_path_loss_db`, `estimate_signal_strength`
- 19 terrain model tests passing

### Command Center (SC)
- Terrain API at `/api/terrain/` with propagation, coverage, line-of-sight, terrain types
- Coverage grid computation with cell-level signal strength estimates (capped at 10K cells)
- 9 terrain router tests passing

**Verification:**
- tritium-lib: 19/19 terrain tests pass (1233 total)
- tritium-sc: 9/9 terrain tests pass

---

## 2026-03-14 — Wave 22: Security & Performance Audit

### Command Center (SC)
- Security audit tests: input validation, SQL injection resistance, info leakage, edge cases
- Verified: no hardcoded secrets, parameterized SQL queries, clean error responses
- 15 security audit tests passing

### Findings
- SQL queries use parameterized placeholders (safe)
- Auth module uses ephemeral keys when no secret configured (acceptable for dev)
- innerHTML usage is widespread in frontend (408 occurrences) — no immediate risk since
  data comes from trusted APIs, but should be audited for user-supplied content rendering
- No hardcoded credentials found in source

**Verification:** Unit Tested (15/15 security tests pass)

---

## 2026-03-14 — Wave 21: Deep Sensing & Recognition

### Shared Library
- LPR models: `PlateDetection`, `PlateWatchlist`, `PlateRecord`, `PlateWatchEntry`, `LPRStats`
- Acoustic event models: `AcousticEvent`, `AcousticSpectrum`, `AcousticSensorConfig`, `classify_event_severity`
- 29 new tests (13 LPR + 16 acoustic event)

### Command Center (SC)
- LPR plugin at `/api/lpr/` with detect, search, watchlist CRUD, stats
- AIS/ADS-B transponder plugin at `/api/transponders/` with ADS-B flights, AIS vessels,
  emergency squawk detection, combined stats
- 18 new tests (8 LPR + 10 transponders)

### Edge Firmware
- Acoustic HAL: rule-based sound classifier, event counting, MQTT event callback
- Configurable confidence threshold for event publishing
- BUILD SUCCESS — 47.9% RAM, 29.0% Flash

**Verification:**
- tritium-lib: 29/29 new tests pass (1214 total)
- tritium-sc: 18/18 new tests pass, 96 tiers all clear
- tritium-edge: 47.9% RAM, 29.0% Flash

---

## 2026-03-14 — Wave 20 Validation (Test Runner)

### Test Baselines
- tritium-lib: 1185 passed, 29 skipped, 31 warnings
- tritium-sc: 96 tiers passed, 0 failed (390s)
- tritium-edge: BUILD SUCCESS — 47.9% RAM, 29.0% Flash

---

## 2026-03-14 — Wave 20: Maintenance & Cleanup

### Command Center (SC)
- Added `EventDrainPlugin` base class to eliminate ~30 lines of boilerplate per plugin
  (event queue subscribe/drain/unsubscribe lifecycle now handled by base class)
- Migrated fleet_dashboard and threat_feeds plugins to use `EventDrainPlugin`
- Replaced `engine.tactical.geo` with thin re-export from `tritium_lib.geo`
  (with fallback stub if lib not installed)
- Removed 8 unused imports across engine and routers (dead code cleanup)

### Documentation
- Updated `docs/STATUS.md` with current state (19 waves, 14 plugins, 18 capabilities)
- Updated `docs/CHANGELOG.md` with Waves 17-19 entries and test baselines

**Verification:** Syntax checked, imports validated

---

## 2026-03-14 — Wave 19: Federation & Multi-Site

### Command Center (SC)
- Federation plugin for multi-site Tritium installations via MQTT bridge
- Site discovery, target sharing, dossier sync, alert forwarding
- Federation models in tritium-lib (FederatedSite, FederationMessage, SharedTarget)
- Submodule updates across all repos

**Verification:** Unit Tested

---

## 2026-03-14 — Wave 18: Advanced Sensing

### Command Center (SC)
- Acoustic classification plugin (`engine/audio/acoustic_classifier.py`)
  with rule-based classifier: gunshot, voice, vehicle, siren, glass_break, alarm, explosion
- Acoustic API at `/api/acoustic/` with classify, events, and stats endpoints
- Video recording API at `/api/recordings/` with start, stop, list, delete, status
- Routers wired into main app

### Shared Library
- Drone/UAV models: `DroneState`, `DroneTelemetry`, `DroneCommand`, `DroneMission`,
  `Waypoint`, `DroneRegistration`, `DroneType`
- MQTT topic design for drone integration

**Verification:**
- 11/11 acoustic classifier tests pass
- 11/11 drone model tests pass

---

## 2026-03-14 — Wave 17: Production Hardening

### Command Center (SC)
- Rate limiting middleware with sliding window per-IP counters
  (exempt: /ws, /static, /health, /api/auth/status)
- Database migration system with 4 numbered migrations
  (schema_version, auth_users, api_keys, audit_log)
- Backup/restore API at `/api/backup/` (export/import ZIP archives)
- Updated Dockerfile to Python 3.12 with health check
- Updated docker-compose.yml with auth, TLS, and rate limit env vars
- Migrations run automatically on startup

**Verification:**
- 19/19 tests pass (rate_limit, backup, migrations, auth)

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

| Suite | Start (Wave 1) | Current (Wave 33) | Status |
|-------|----------------|-------------------|--------|
| tritium-lib pytest | 833 passed | 1364+ passed, 29 skipped | All passing |
| tritium-sc fast (tiers 1-3+8) | 81 tiers | 96 tiers (375s) | All passing |
| tritium-edge build | 45.9% RAM, 28.8% Flash | 47.9% RAM, 29.1% Flash | 0 warnings |

---

## Known Issues

| Issue | Status | Impact |
|-------|--------|--------|
| BLE scanner disabled (WiFi/BLE coexistence) | Open | No real BLE data flows; MQTT pipeline ready |
| NimBLE esp_bt.h not found | Open | Blocks BLE serial + BLE OTA |
| RGB parallel display glitches (43C-BOX + USB) | Cosmetic | Memory bus contention |
| 18 tests in `test_websocket.py` fail | Pre-existing | Missing asyncio event loop |
