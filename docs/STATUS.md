# Tritium System Status

Current state of all components as of 2026-03-14 (Wave 57).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | ~48% RAM, ~29% flash (within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 1584 tests passing, 0 failures |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict (radio scheduler HAL ready) |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |

## Test Results (Wave 57 Baseline)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib pytest | 1584 passed | All passing |
| tritium-sc Python | 13,432 collected | All passing |
| tritium-sc JS | 95 test suites | All passing |
| tritium-edge build | ~48% RAM, ~29% Flash | 0 warnings |
| **Total test files** | 1,983 across all repos | -- |

## Codebase Metrics (Wave 57 Baseline)

| Metric | Value |
|--------|-------|
| **Total waves completed** | 57 |
| **Total lines of code** | ~266,000 across 3 repos |
| **SC Python tests** | 13,432 |
| **Lib tests** | 1,584 |
| **JS test suites** | 95 |
| **Total test files** | 1,983 |
| **Frontend panels** | 64 registered (7 categories) |
| **Active plugins** | 14 |
| **API routes** | 460+ across 66 router files |
| **Edge HALs** | 45 hardware abstraction layers |
| **Edge boards** | 6 Waveshare ESP32-S3 (3 HW-verified) |
| **Intelligence capabilities** | 40+ operational |
| **Lib model exports** | 250+ from 42+ model files |
| **Correlation strategies** | 5 (spatial, temporal, signal_pattern, dossier, learned) |
| **Test-to-code ratio** | ~1 test per 18 LOC |

## LOC Breakdown

| Component | Language | Lines of Code |
|-----------|----------|---------------|
| tritium-sc Python | Python | ~95,000 |
| tritium-sc JS | JavaScript | ~67,000 |
| tritium-edge firmware | C++/H | ~59,500 |
| tritium-edge fleet server | Python | ~25,000 |
| tritium-lib | Python | ~19,000 |
| **Total** | **All** | **~266,000** |

## Firmware (tritium-edge)

**Build target:** `pio run -e touch-lcd-43c-box-os`

**HAL count:** 45 hardware abstraction layers

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

**Frontend:** Vanilla JS command center with tactical map, 64 floating panels, categorized panel menu, panel search

**AI Commander Amy:** 4-layer cognitive AI (reflex, instinct, awareness, deliberation)
- Instinct layer: automatic threat response rules
- Autonomous dispatch: threat response, asset selection, fusion narration
- Full Sense-Decide-Act pipeline
- Voice synthesis (Piper TTS) available via API
- RF anomaly awareness: Amy narrates RF environment deviations

**Simulation:** 10Hz battle engine, 10-wave combat, 16 unit types

**Intelligence subsystem:**
- CorrelationLearner: RL-based logistic regression from operator feedback
- BLEClassificationLearner: ML-based device type classification (19 device types)
- AnomalyBaselineCollector: background RF environment baselining with 2-sigma detection
- TrainingStore: SQLite-backed ML training data collection
- LearnedStrategy: 5th correlator strategy integrating learned scorer
- Auto-retrain scheduler (6h interval, 50-entry threshold)

**Test suite:** 7 tiers (syntax, unit, JS, infrastructure, integration, visual quality, visual E2E)

**API routes:** 460+ across 66 router files

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

### Frontend Panels (64 registered, 7 categories)

**Categories:** Tactical (14), Intelligence (12), Sensors (8), Fleet (4), AI & Comms (6), Simulation (4), System (12+)

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
| grid-overlay | Tactical | Military grid reference overlay |
| annotations | Tactical | Map drawing annotations |
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
| watchlist | Intelligence | Target watch list |
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
| game-hud | Simulation | Battle game HUD |
| replay | Simulation | Event replay |
| scenarios | Simulation | Scenario runner |
| stats | Simulation | Battle statistics |
| system | System | Infrastructure panel |
| system-health | System | System health overview |
| testing | System | Testing dashboard |
| training-dashboard | System | ML training data dashboard |
| export-scheduler | System | Data export scheduling |
| events | System | Events timeline |
| videos | System | Video playback |
| quick-start | System | Getting started guide |
| setup-wizard | System | First-launch configuration wizard |
| activity-feed | System | Live target event feed |
| mqtt-inspector | System | MQTT message debugger |
| map-screenshot | System | Tactical map capture |
| map-share | System | Map state sharing |
| keyboard-macros | System | Custom keyboard shortcuts |
| operator-activity | System | Operator session tracking |
| operator-cursors | System | Multi-user cursor sharing |

### Intelligence Capabilities (40+)
| Capability | Status |
|------------|--------|
| Multi-sensor target correlation (5 strategies) | Active |
| BLE threat classification | Active |
| BLE classification learning (ML, 19 device types) | Active |
| Target enrichment pipeline (OUI, WiFi, BLE) | Active |
| Geofencing with enter/exit alerts | Active |
| Target position history and trails | Active |
| Target search and filtering | Active |
| Dossier management (persistent entity intelligence) | Active |
| Graph ontology (KuzuDB, 10 entity types) | Active |
| Investigation workflows with escalation | Active |
| Patrol pattern system | Active |
| Target timeline | Active |
| Demo mode with multi-sensor fusion scenarios | Active |
| RF motion detection (RSSI variance) | Active |
| RF anomaly baseline detection (2-sigma, 24h baseline) | Active |
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
| Target position prediction (velocity extrapolation) | Active |
| Investigation report generator | Active |
| Communication link map layer (network topology) | Active |
| System runtime metrics endpoint | Active |
| SITREP generator (JSON + text) | Active |
| Multi-select bulk actions on map | Active |
| Map annotations (text, arrow, circle, freehand, polygon) | Active |
| Target watch list with movement alerts | Active |
| Inter-plugin messaging bus | Active |
| RL correlation learning (logistic regression from operator feedback) | Active |
| Auto-retrain scheduler (6h interval, 50-entry threshold) | Active |
| LearnedStrategy as 5th correlator strategy | Active |
| Training data dashboard (model status, retrain trigger) | Active |
| Ollama-powered anomaly description | Active |
| Amy model accuracy awareness (narrates retrain results) | Active |
| Amy RF anomaly awareness (narrates environment deviations) | Active |
| Target handoff between nodes | Active |
| Investigation escalation workflow | Active |

## Shared Library (tritium-lib)

**Tests:** 1,584 passing (0 failures)

**Models:** 250+ exports from 42+ model files covering device, firmware, mesh, BLE, CoT, alerts, topology, diagnostics, transport, sensor, acoustic, seed, provision, correlation, timeseries, trilateration, dossier, ontology, federation, drone/UAV, radio scheduler, camera MQTT, behavior, terrain, event schemas, export/import, alert rules, notification rules, system summary, mission management, intelligence reports, sensor configuration, LPR, AIS/ADS-B, operational periods, device capabilities, communication channels, tactical scenarios, network topology

**Intelligence ABCs:**
- AnomalyDetector (SimpleThresholdDetector, AutoencoderDetector)
- CorrelationScorer (StaticScorer, LearnedScorer)

**Graph:** KuzuDB embedded graph store with formal ontology schema

**Stores:** SQLite-backed DossierStore, BleStore, TargetStore, ReIDStore, AuditStore, ConfigStore (all using BaseStore)

**MQTT:** Standardized topic hierarchy `tritium/{site}/{domain}/{device}/{type}`

**Geo:** Coordinate transforms, camera projection, haversine distance (shared with SC)

**Classifier:** Multi-signal BLE/WiFi device classifier with 11 fingerprint databases

**Web:** HTML sanitization, JSON safety, filename sanitization

**Packages:** models, mqtt, events, auth, config, store, cot, web, testing, graph, ontology, geo, notifications, classifier, intelligence

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
| 37 | RF environment mapping | Done (RF motion + monitor HALs) |
| 38 | TAK/CoT bridge | Done (Wave 8) |
| 39 | Video recording/playback | Done (Wave 18) |
| 40 | Multi-site federation | Done (Wave 14+) |

## Redundancy Analysis (Wave 57)

### Intelligence Package Overlap
- **tritium-lib `intelligence/anomaly.py`**: ABC with SimpleThresholdDetector and AutoencoderDetector. Stateless, takes baseline list + current metrics, returns anomalies.
- **tritium-sc `intelligence/anomaly_baseline.py`**: Stateful AnomalyBaselineCollector with background thread, running stats, LLM describer integration. Uses its own BaselineStats, not the lib ABC.
- **Recommendation**: The lib ABC is a clean contract for pluggable detectors. The SC collector is an application-layer service that should USE the lib detectors internally rather than reimplementing threshold logic. The Anomaly dataclasses overlap but serve different granularities (lib is simpler, SC adds IDs and timestamps). Low priority to refactor since both work and SC intentionally extends.

### Shared Patterns in SC Intelligence
- `CorrelationLearner` and `BLEClassificationLearner` both: load/save pickle models, use sklearn, have train/predict cycles, store accuracy metrics.
- Potential extraction: A `BaseLearner` ABC could be added to tritium-lib with common train/save/load/accuracy patterns. Medium priority.
- `TrainingStore` is SC-specific (SQLite, operator feedback). No overlap with lib stores.

## Security (Wave 42-57 Audits)

| Area | Status | Details |
|------|--------|---------|
| Annotation XSS | Hardened | HTML tags stripped, entities escaped, text length limits |
| Watchlist XSS | Hardened | HTML tags stripped, tag count limits, notes length limits |
| WebSocket auth | Hardened | Optional token via WS_AUTH_TOKEN env var, 4003 reject |
| WebSocket heartbeat | Hardened | Server ping every 30s, stale connections closed after 90s |
| API input validation | Hardened | All user inputs sanitized across all routers |
| System metrics | Active | Runtime monitoring: memory, connections, targets, uptime |
| Secrets audit | Clean | No secrets in git history across all 3 repos |

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
| Anomaly baseline to Amy sensorium | Working (Wave 57) |
| RL correlation to LearnedStrategy | Working |

## Development Velocity

57 waves completed across autonomous sessions:
- **~266,000 lines of code** across 3 repos (Python + JS + C++)
- **13,432 SC Python tests** collected
- **1,584 tests** in tritium-lib (0 failures)
- **95 JS test suites** in tritium-sc
- **1,983 total test files** across all repos
- **64 floating panels** in the command center frontend (7 categories)
- **45 HALs** in tritium-edge firmware
- **14 plugins** active in tritium-sc
- **460+ API routes** across 66 router files
- **40+ intelligence capabilities** operational
- **250+ model exports** in tritium-lib
- **5 correlation strategies** (spatial, temporal, signal_pattern, dossier, learned)
- **3 submodules** coordinated with shared models and MQTT topics
