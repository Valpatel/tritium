# Tritium System Status

Current state of all components as of 2026-03-14 (Wave 66 — maintenance + consolidation).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | ~48% RAM, ~29% flash (within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 1,584 tests passing, 0 failures |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict (radio scheduler HAL ready) |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |

## Wave 66 Milestone Summary

| Milestone Metric | Value |
|------------------|-------|
| **Total waves completed** | 66 |
| **Total features shipped** | 136+ |
| **Total lines of code** | ~646,000 across 3 repos |
| **Active plugins** | 14 |
| **Frontend panels** | 66 registered (7 categories) |
| **API routes** | 440+ across 71 router files |
| **Agent definition files** | 11 |
| **Edge HALs** | 48 HAL directories, 190 header files |
| **Edge boards** | 6 Waveshare ESP32-S3 (3 HW-verified) |
| **Intelligence capabilities** | 40+ operational |
| **Correlation strategies** | 5 (spatial, temporal, signal_pattern, dossier, learned) |

## Test Results (Wave 66 Baseline)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib pytest | 1,584 passed | All passing |
| tritium-sc Python | 1,400+ unit tests | All passing |
| tritium-sc JS | 95 test suites | All passing |
| tritium-sc test files | 565 | -- |
| tritium-lib test files | 81 | -- |
| tritium-edge build | ~48% RAM, ~29% Flash | 0 warnings |
| **Total test files** | 822 across all repos | -- |

## Codebase Metrics (Wave 66 Baseline)

| Metric | Value |
|--------|-------|
| **Total waves completed** | 66 |
| **Total features shipped** | 136+ |
| **Total lines of code** | ~646,000 across 3 repos |
| **Source code (excl tests)** | ~300,000 |
| **Test code** | ~346,000 |
| **SC Python tests** | 1,400+ unit (API tier) |
| **Lib tests** | 1,584 |
| **JS test suites** | 95 |
| **Frontend JS files** | 127 |
| **Frontend panels** | 66 registered (7 categories) |
| **Active plugins** | 14 |
| **Plugin route files** | 14 |
| **Edge HAL directories** | 48 |
| **Edge HAL headers** | 190 |
| **Edge boards** | 6 Waveshare ESP32-S3 (3 HW-verified) |
| **Intelligence capabilities** | 40+ operational |
| **Lib model exports** | 313 classes from 53 model files |
| **Correlation strategies** | 5 (spatial, temporal, signal_pattern, dossier, learned) |
| **Agent definition files** | 11 |

## LOC Breakdown

| Component | Language | Lines of Code |
|-----------|----------|---------------|
| tritium-sc Python (src) | Python | ~97,000 |
| tritium-sc Python (plugins) | Python | ~15,500 |
| tritium-sc Python (tests) | Python | ~251,000 |
| tritium-sc Python (scripts) | Python | ~5,400 |
| tritium-sc Python (examples) | Python | ~16,000 |
| tritium-sc JS (frontend) | JavaScript | ~68,000 |
| tritium-sc JS (tests) | JavaScript | ~63,000 |
| tritium-edge firmware (src+lib) | C++/H | ~62,000 |
| tritium-edge fleet server | Python | ~10,000 |
| tritium-lib (src) | Python | ~20,500 |
| tritium-lib (tests) | Python | ~17,000 |
| **Total** | **All** | **~646,000** |

## Disk Usage (Wave 66)

| Directory | Size | Notes |
|-----------|------|-------|
| tritium-edge (with .pio) | 6.6 GB | .pio/libdeps = 6.3 GB |
| tritium-sc | 1.4 GB | Includes .venv |
| tritium-lib | 203 MB | |
| **Total repo** | ~8.1 GB | Excluding .git |

Host disk: 916 GB total, 89% used (97 GB free). Wave 60 cleanup freed ~1 GB from caches.

## Firmware (tritium-edge)

**Build target:** `pio run -e touch-lcd-43c-box-os`

**HAL count:** 140 header files across src/lib/include

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

### Frontend Panels (66 registered, 7 categories)

**Categories:** Tactical (14), Intelligence (12), Sensors (9), Fleet (4), AI & Comms (6), Simulation (4), System (13+)

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
| voice-command | AI & Comms | Voice command input |
| wifi-fingerprint | Sensors | WiFi device fingerprinting |

## Shared Library (tritium-lib)

**Tests:** 1,584 passing (0 failures)

**Models:** 250+ exports from 42+ model files covering device, firmware, mesh, BLE, CoT, alerts, topology, diagnostics, transport, sensor, acoustic, seed, provision, correlation, timeseries, trilateration, dossier, ontology, federation, drone/UAV, radio scheduler, camera MQTT, behavior, terrain, event schemas, export/import, alert rules, notification rules, system summary, mission management, intelligence reports, sensor configuration, LPR, AIS/ADS-B, operational periods, device capabilities, communication channels, tactical scenarios, network topology

**Intelligence ABCs:**
- AnomalyDetector (SimpleThresholdDetector, AutoencoderDetector)
- CorrelationScorer (StaticScorer, LearnedScorer)

**Graph:** KuzuDB embedded graph store with formal ontology schema

**Stores:** SQLite-backed DossierStore, BleStore, TargetStore, ReIDStore, AuditStore, ConfigStore, ScreenshotStore (all using BaseStore)

**MQTT:** Standardized topic hierarchy `tritium/{site}/{domain}/{device}/{type}`

**Geo:** Coordinate transforms, camera projection, haversine distance (shared with SC)

**Classifier:** Multi-signal BLE/WiFi device classifier with 11 fingerprint databases

**Web:** HTML sanitization, JSON safety, filename sanitization

**Packages:** models, mqtt, events, auth, config, store, cot, web, testing, graph, ontology, geo, notifications, classifier, intelligence

## Agent Definition Files (11)

| Agent | File | Lines | Purpose |
|-------|------|-------|---------|
| Agent Refiner | agent-refiner.md | 118 | Metacognition — optimizes the development loop |
| Edge Agent | edge-agent.md | 53 | ESP32-S3 firmware, HALs, sensors |
| Feature Agent | feature-agent.md | 42 | Cross-submodule feature building |
| Lib Agent | lib-agent.md | 52 | Shared library — models, stores |
| Maintenance Agent | maintenance-agent.md | 51 | Docs, cleanup, test baselines |
| Quality Agent | quality-agent.md | 53 | Testing, gap finding, verification |
| RL Agent | rl-agent.md | 62 | Reinforcement learning, LLM integration |
| SC Agent | sc-agent.md | 57 | Command center — plugins, Amy, panels |
| Security Agent | security-agent.md | 55 | Adversarial security review |
| Self-Preservation Agent | self-preservation-agent.md | 430 | Replication, backup, watchdog |
| Visual Testing Agent | visual-testing-agent.md | 58 | UI verification via OpenCV/llava |
| **Total** | **11 files** | **1,031 lines** | -- |

## Replication Status (Wave 66)

| Host | Tailscale IP | Status | Last Check |
|------|-------------|--------|------------|
| gb10-01 (primary) | 100.93.184.1 | Active (this host) | Live |
| eng-mvalancy-macmini | 100.98.72.95 | Unreachable (SSH timeout) | 2026-03-14 |
| vps-1 | 100.79.60.48 | Unreachable (SSH timeout) | 2026-03-14 |
| GitHub | git@github.com:Valpatel/tritium.git | Pushed | Current |
| mv-yoga | 100.83.248.77 | Offline (1d ago) | 2026-03-14 |

## Security (Wave 42-65 Audits)

| Area | Status | Details |
|------|--------|---------|
| Annotation XSS | Hardened | HTML tags stripped, entities escaped, text length limits |
| Watchlist XSS | Hardened | HTML tags stripped, tag count limits, notes length limits |
| WebSocket auth | Hardened | Optional token via WS_AUTH_TOKEN env var, 4003 reject |
| WebSocket heartbeat | Hardened | Server ping every 30s, stale connections closed after 90s |
| API input validation | Hardened | All user inputs sanitized across all routers |
| System metrics | Active | Runtime monitoring: memory, connections, targets, uptime |
| Meshtastic bridge | Hardened | MQTT topic injection prevention, input sanitization, type validation |
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
| Anomaly baseline to Amy sensorium | Working |
| RL correlation to LearnedStrategy | Working |

## Development Velocity

66 waves completed across autonomous sessions:
- **~646,000 lines of code** across 3 repos
- **136+ features shipped**
- **1,400+ SC Python unit tests** passing (API tier)
- **1,584 tests** in tritium-lib (0 failures)
- **95 JS test suites** in tritium-sc
- **822 test files** across all repos
- **66 floating panels** in the command center frontend (7 categories)
- **190 HAL headers** across 48 HAL directories in tritium-edge firmware
- **14 plugins** active in tritium-sc
- **440+ API routes** across 71 router files
- **40+ intelligence capabilities** operational
- **313 model classes** from 53 model files in tritium-lib
- **5 correlation strategies** (spatial, temporal, signal_pattern, dossier, learned)
- **11 agent definition files** (1,031 lines of agent instructions)
- **3 submodules** coordinated with shared models and MQTT topics
