# Tritium System Status

Current state of all components as of 2026-03-14 (post Wave 44 maintenance).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | ~48% RAM, ~29% flash (within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 1433 tests passing, 29 skipped, 0 failures |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict (radio scheduler HAL ready) |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |

## Test Results (Wave 44 Baseline)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib pytest | 1433 passed, 29 skipped | All passing |
| tritium-sc Python | 3726 passed, 72 skipped, 1 known failure | 1 Ollama connectivity test (requires running LLM) |
| tritium-sc JS | 92 test suites, 0 failures | All passing |
| tritium-edge build | ~48% RAM, ~29% Flash | 0 warnings |

## Codebase Metrics (Wave 44)

| Component | Language | Lines of Code |
|-----------|----------|---------------|
| tritium-sc Python | Python | ~89,000 |
| tritium-sc JS | JavaScript | ~64,000 |
| tritium-edge firmware | C++/H | ~71,000 |
| tritium-edge fleet server | Python | ~25,000 |
| tritium-lib | Python | ~17,000 |
| **Total** | **All** | **~266,000** |

| Metric | Value |
|--------|-------|
| Total test files | 820+ (SC + lib + edge) |
| Total SC Python tests | 3,726 |
| Total lib tests | 1,433 |
| Total JS test suites | 92 |
| Test-to-code ratio (SC Python) | 1 test file per ~140 LOC |

## Firmware (tritium-edge)

**Build target:** `pio run -e touch-lcd-43c-box-os`

**HAL count:** 43 hardware abstraction layers

**Launcher apps:** Settings, Monitor, Mesh, Storage, BLE, Terminal

**Status bar:** WiFi RSSI, BLE count, Mesh peers, Battery/USB, Clock (1s updates)

**Settings tabs:** Display, WiFi, Power, Screensaver, System, Clock, Developer

**Screensaver:** Starfield with 500 stars, parallax drift, clock overlay, NVS-persisted settings

**Notification shade:** Quick settings toggles, dismiss gestures

**Remote API:** Click simulation, screensaver control, settings access, diagnostic self-test

**Supported boards:** 6 Waveshare ESP32-S3 (3 hardware-verified, 1 pin-verified, 2 need verification)

### Known Blockers

- **NimBLE esp_bt.h not found** -- blocks BLE serial + BLE OTA. WiFi/mesh/SD alternatives work.
- **BLE/WiFi coexistence** -- can't run BLE scanner alongside WiFi. Radio scheduler HAL ready for testing.
- **RGB parallel display glitches** -- 43C-BOX cosmetic issue when USB connected.

## Command Center (tritium-sc)

**Server:** FastAPI on :8000

**Frontend:** Vanilla JS command center with tactical map, 55 floating panels, categorized panel menu, panel search

**AI Commander Amy:** 4-layer cognitive AI (reflex, instinct, awareness, deliberation)
- Instinct layer: automatic threat response rules
- Autonomous dispatch: threat response, asset selection, fusion narration
- Full Sense-Decide-Act pipeline

**Simulation:** 10Hz battle engine, 10-wave combat, 16 unit types

**Test suite:** 7 tiers (syntax, unit, JS, infrastructure, integration, visual quality, visual E2E)

**API endpoints:** 417+ routes across 56 router files

### Plugins (14 active)
| Plugin | Purpose |
|--------|---------|
| edge_tracker | Edge device fleet tracking via MQTT |
| meshtastic | LoRa mesh radio bridge |
| camera_feeds | Multi-source camera management |
| fleet_dashboard | Device registry and fleet overview |
| yolo_detector | Object detection inference pipeline |
| gis_layers | OSM/satellite/terrain map layers |
| tak_bridge | ATAK/CoT military interoperability |
| automation | If-then rule engine |
| graphlings | NPC behavior system |
| npc_thoughts | NPC inner monologue |
| threat_feeds | Known-bad indicator matching |
| rf_motion | Passive RF-based motion detection |
| acoustic | Sound classification (gunshot, voice, vehicle) |
| federation | Multi-site Tritium federation via MQTT |

### Frontend Panels (55 registered, 7 categories)

**Categories:** Tactical (12), Intelligence (11), Sensors (8), Fleet (4), AI & Comms (6), Simulation (4), System (8)

| Panel | Category | Purpose |
|-------|----------|---------|
| ops-dashboard | Tactical | War room at a glance |
| units | Tactical | Unit list with detail |
| unit-inspector | Tactical | Deep unit detail inspector |
| alerts | Tactical | Alert feed |
| escalation | Tactical | Threat level display |
| missions | Tactical | Mission coordination |
| patrol | Tactical | Patrol route management |
| geofence | Tactical | Polygon zone management |
| zones | Tactical | Zone management |
| minimap | Tactical | Tactical overview minimap |
| layers | Tactical | Map layer browser (43 layers) |
| bookmarks | Tactical | Map position bookmarks |
| search | Intelligence | Full intel search |
| dossiers | Intelligence | Persistent entity intelligence |
| dossier-groups | Intelligence | Dossier group management |
| graph-explorer | Intelligence | Force-directed entity graph |
| timeline | Intelligence | Target timeline |
| target-search | Intelligence | Target search/filter |
| target-compare | Intelligence | Side-by-side comparison |
| target-merge | Intelligence | Target merge workflow |
| heatmap | Intelligence | Target density heatmap |
| heatmap-timeline | Intelligence | Temporal heatmap playback |
| automation | Intelligence | If-then rule CRUD |
| edge-tracker | Sensors | Edge device sighting monitor |
| camera-feeds | Sensors | Live camera feed grid (MJPEG) |
| cameras | Sensors | Synthetic camera PIP |
| multi-camera | Sensors | Multi-camera grid view |
| rf-motion | Sensors | RF-based motion events |
| mesh | Sensors | Meshtastic LoRa client |
| sensors | Sensors | Sensor network view |
| tak | Sensors | TAK server management |
| fleet | Fleet | Fleet node monitoring |
| fleet-dashboard | Fleet | Aggregated fleet dashboard |
| device-manager | Fleet | Remote OTA, reboot, config |
| assets | Fleet | Asset placement on map |
| amy | AI & Comms | Amy AI commander chat + status |
| amy-conversation | AI & Comms | Full inner monologue timeline |
| graphlings | AI & Comms | NPC behavior observer |
| audio | AI & Comms | Audio controls |
| notifications | AI & Comms | Notification feed |
| notification-prefs | AI & Comms | Notification preferences |
| game | Simulation | Battle game HUD |
| battle-stats | Simulation | Battle statistics |
| replay | Simulation | Event replay |
| scenarios | Simulation | Scenario runner |
| system | System | Infrastructure panel |
| system-health | System | System health overview |
| testing | System | Testing dashboard |
| export-scheduler | System | Data export scheduling |
| events | System | Events timeline |
| videos | System | Video playback |
| quick-start | System | Getting started guide |
| setup-wizard | System | First-launch configuration wizard |

### Intelligence Capabilities (28)
| Capability | Status |
|------------|--------|
| Multi-sensor target correlation | Active |
| BLE threat classification | Active |
| Target enrichment pipeline (OUI, WiFi, BLE) | Active |
| Geofencing with enter/exit alerts | Active |
| Target position history and trails | Active |
| Target search and filtering | Active |
| Dossier management (persistent entity intelligence) | Active |
| Graph ontology (KuzuDB, 10 entity types) | Active |
| Investigation workflows | Active |
| Patrol pattern system | Active |
| Target timeline | Active |
| Demo mode with multi-sensor fusion scenarios | Active |
| RF motion detection (RSSI variance) | Active |
| Acoustic classification | Active |
| JWT authentication | Active |
| Rate limiting | Active |
| Database migrations | Active |
| Backup/restore | Active |
| Behavior pattern analysis | Active |
| Terrain/RF propagation modeling | Active |
| Target export (CSV/JSON/GeoJSON) | Active |
| BLE/WiFi coverage visualization | Active |
| Target clustering for map readability | Active |
| Event-driven alert rules | Active |
| Target pinning (persistent, prune-protected) | Active |
| WebSocket auto-reconnect with exponential backoff | Active |
| Investigation map overlay (entities on tactical map) | Active |
| Panel search with keyboard shortcut (Ctrl+/) | Active |

## Shared Library (tritium-lib)

**Models:** 250+ exports from 42+ model files covering device, firmware, mesh, BLE, CoT, alerts, topology, diagnostics, transport, sensor, acoustic, seed, provision, correlation, timeseries, trilateration, dossier, ontology, federation, drone/UAV, radio scheduler, camera MQTT, behavior, terrain, event schemas, export/import, alert rules, notification rules, system summary, mission management, intelligence reports, sensor configuration, LPR, AIS/ADS-B, operational periods, device capabilities

**Graph:** KuzuDB embedded graph store with formal ontology schema

**Stores:** SQLite-backed DossierStore, BleStore, TargetStore, ReIDStore, AuditStore, ConfigStore (all using BaseStore)

**MQTT:** Standardized topic hierarchy `tritium/{site}/{domain}/{device}/{type}`

**Geo:** Coordinate transforms, camera projection, haversine distance (shared with SC)

**Classifier:** Multi-signal BLE/WiFi device classifier with 11 fingerprint databases

**Web:** HTML sanitization, JSON safety, filename sanitization

**Packages:** models, mqtt, events, auth, config, store, cot, web, testing, graph, ontology, geo, notifications, classifier

## Feature Roadmap Status

| # | Feature | Status |
|---|---------|--------|
| 1-14 | Core OS features | Done |
| 15 | Meshtastic BLE bridge | Blocked (WiFi/BLE coex) |
| 16-31 | Full tactical intelligence platform | Done |
| 32 | WiFi probe request tracking | Done (Wave 31) |
| 33 | Multi-node trilateration | Done (Wave 13) |
| 34 | Geofencing alerts | Done (Wave 6) |
| 35 | Target history/trails | Done (Wave 6) |
| 36 | Acoustic classification | Done (Wave 18) |
| 37 | RF environment mapping | Partial (RF motion done) |
| 38 | TAK/CoT bridge | Done (Wave 8) |
| 39 | Video recording/playback | Done (Wave 18) |
| 40 | Multi-site federation | Done (Wave 14+) |

## Panel Redundancy (Wave 44 Cleanup)

All 42 panels with inlined `_esc()` and `_timeAgo()` have been migrated to import from shared `panel-utils.js`. Only 8 panels were using panel-utils prior to Wave 44.

**After cleanup:**
- 0 panels with inlined `_esc()` (was 42)
- 0 panels with inlined `_timeAgo()` (was 6)
- All 50 panel files import from `panel-utils.js`

## Panel Categories (Wave 44)

The VIEW menu now groups 55 panels into 7 collapsible categories:
- **Tactical** (12 panels): Core situation awareness
- **Intelligence** (11 panels): Analysis, search, dossiers
- **Sensors** (8 panels): Camera, BLE, RF, mesh, TAK
- **Fleet** (4 panels): Device management and placement
- **AI & Comms** (6 panels): Amy, NPC, notifications, audio
- **Simulation** (4 panels): Battle, replay, scenarios
- **System** (8 panels): Config, health, testing, export

## Setup Wizard (Wave 44)

First-launch configuration wizard with 6 steps:
1. Welcome
2. Map center (with city presets)
3. Demo mode toggle
4. MQTT broker configuration
5. Default layout selection (Commander/Observer/Tactical)
6. Completion

Settings stored in `ConfigStore` (localStorage-backed). Wizard auto-opens when no config exists. Can be reopened from VIEW > System > Setup Wizard.

## Security (Wave 42 Audit)

| Area | Status | Details |
|------|--------|---------|
| Annotation XSS | Hardened | HTML tags stripped, entities escaped, text length limits |
| Watchlist XSS | Hardened | HTML tags stripped, tag count limits, notes length limits |
| Annotation type validation | Hardened | Enum validation (6 valid types only) |
| Lat/lng range validation | Hardened | -90..90 lat, -180..180 lng |
| Collection DoS | Hardened | Max 10,000 annotations, 5,000 watch entries |
| WebSocket auth | Hardened | Optional token via WS_AUTH_TOKEN env var, 4003 reject |
| WebSocket heartbeat | Hardened | Server ping every 30s, stale connections closed after 90s |
| SQL injection | N/A | In-memory stores (no SQL), user text HTML-escaped |

## Integration Points

| Flow | Status |
|------|--------|
| Edge MQTT heartbeat to SC fleet tracker | Working |
| Edge MQTT sighting to SC display | Working |
| Edge MQTT chat to SC dashboard | Working |
| SC MQTT cmd to Edge execute | Working |
| Camera MQTT to YOLO pipeline | Working (synthetic) |
| Amy MQTT to Edge autonomous commands | Working |
| Correlator to Graph store (entity relationships) | Working |
| TAK/CoT bridge to ATAK | Working |
| Geofence alerts via EventBus | Working |
| DossierManager periodic flush to SQLite | Working |
| Federation MQTT bridge to remote sites | Working |
| Mesh sighting relay (leaf to gateway) | Working |

## Development Velocity

44 waves completed across autonomous sessions:
- **~266,000 lines of code** across 3 repos (Python + JS + C++)
- **820+ test files** with 5,200+ test assertions
- **1,433 tests** in tritium-lib (0 failures)
- **3,726 tests** in tritium-sc Python (0 failures, 1 known Ollama-dependent)
- **92 JS test suites** in tritium-sc (0 failures)
- **55 floating panels** in the command center frontend (7 categories)
- **43 HALs** in tritium-edge firmware
- **14 plugins** active in tritium-sc
- **417+ API endpoints** across 56 router files
- **28 intelligence capabilities** operational
- **250+ model exports** in tritium-lib
- **3 submodules** coordinated with shared models and MQTT topics
