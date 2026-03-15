# Tritium System Status

Current state of all components as of 2026-03-15 (Wave 127 — Maintenance + Dossier Enrichment).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | 49.9% RAM, 29.4% Flash (within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 2,305 tests passing |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds, diagnostics |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict (radio scheduler wired in Wave 105) |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |
| **Intelligence pipeline** | Active | 7 modules, all learners using BaseLearner ABC, 10-feature model |
| **RL pipeline** | Trained | 10-feature model (expanded Wave 126); auto-retrain scheduler active |
| **Plugin system** | Active | 21 plugins (including AmyCommanderPlugin), auto-discovery with boot report |
| **Collaboration** | Active | Shared workspaces, map drawing, operator chat, WebSocket broadcast |
| **Forensics** | Active | Event reconstruction, incident reports, map replay |
| **Fleet management** | Active | Device lifecycle, health summary, remote diagnostics |
| **Intelligence packages** | Active | Portable inter-site intelligence sharing with chain of custody |
| **Dwell tracking** | Active | Monitors stationary targets >5min, severity classification |
| **Command history** | Active | Fleet command audit log with timeout detection |

## Wave 127 (Maintenance + Dossier Enrichment)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| STATUS.md updated through Wave 126 | docs | - | Complete |
| WiFi probe dossier auto-enrichment — BLE dossiers enriched with probed SSIDs from same observer | tritium-sc | 4 tests | Complete |
| DossierManager handles fleet.wifi_presence events for cross-sensor enrichment | tritium-sc | 38 total | Verified |
| 6-strategy correlator weights verified balanced: sum=1.00 (spatial=0.30, temporal=0.15, signal_pattern=0.14, dossier=0.13, learned=0.13, wifi_probe=0.15) | tritium-sc | - | Verified |
| Feature engineering library in lib: 5 functions (device_type_match, co_movement_score, time_similarity, source_diversity, wifi_probe_temporal_correlation) | tritium-lib | 34 tests | Verified |
| RL model expanded to 10 features (Wave 126) for better correlation accuracy | tritium-sc | - | Verified |
| Lib pytest: 2,305 passing (up from 2,283) | tritium-lib | 2,305 | Verified |
| Edge build: 49.9% RAM, 29.4% Flash, SUCCESS | tritium-edge | - | Verified |
| Changelogs updated | all | - | Complete |

## Wave 126 (Feature: RL Feature Expansion + WiFi Probe Correlation)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| WiFiProbeStrategy — 6th correlation strategy for BLE+WiFi probe temporal matching | tritium-sc | 65 tests | Complete |
| CorrelationLearner expanded from 6 to 10 features | tritium-sc | 12 tests | Complete |
| Feature engineering library — 5 reusable ML feature functions | tritium-lib | 34 tests | Complete |
| DEFAULT_WEIGHTS rebalanced for 6 strategies | tritium-sc | - | Verified |
| Edge WiFi probe timestamps (microsecond + epoch) for SC-side correlation | tritium-edge | - | Build verified |

## Wave 125 (Feature: Acoustic TDoA + RL Prediction Cones)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Acoustic plugin TDoA endpoint with NTP-synced timestamps | tritium-sc/edge | 16 tests | Complete |
| Target prediction cones scaled by RL confidence | tritium-sc | - | Complete |
| RL accuracy dropped to 50.5% — identified as overfitting on small dataset | tritium-sc | - | Analyzed |

## Wave 124 (Maintenance + Agent Refiner)

## Wave 123 (Feature)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| PredictionEllipseManager — directional confidence ellipses on map | tritium-sc | - | Complete |
| FederationPanelDef — site status panel with add/remove, health, sync | tritium-sc | - | Complete |
| Map quick toggle (ELP) for prediction ellipses | tritium-sc | - | Complete |
| Visual re-verification: 26 targets, 20 dossiers, RL model trained at 76.7% | tritium-sc | - | Server-verified |

## Wave 122 (Feature)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| CameraDetectionLink model + CameraTargetLinker | tritium-lib/sc | 26 tests | Complete |
| TargetReappearanceMonitor — returning target detection | tritium-sc | 15 tests | Complete |
| Investigation timeline endpoint | tritium-sc | 4 tests | Complete |
| BLE ScanStats in heartbeat payload | tritium-edge | - | Complete |

## Wave 121 (Feature + Maintenance)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Multi-node BLE trilateration live demo generator | tritium-sc | - | Complete |
| Target handoff visualization (animated arcs on map) | tritium-sc | - | Complete |
| Orphan routers registered: dwell.py, mesh_environment.py | tritium-sc | - | Fixed |
| Lib pytest: 2,272 passing (up from 2,265) | tritium-lib | 2,272 | Verified |

## Waves 119-120 (DONE)

Previously completed waves — feature + maintenance cycles continuing autonomous iteration.

## Wave 118 (Maintenance + Visual Re-verification)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Re-verify: /api/threat-feeds/ returns 200 with 10 indicators | tritium-sc | Live server | VERIFIED |
| Re-verify: /api/dossiers returns 12 dossiers after demo | tritium-sc | Live server | VERIFIED |
| Re-verify: /api/system/readiness shows 21/21 plugins | tritium-sc | Live server | VERIFIED |
| Re-verify: /api/targets/export?format=cot returns valid XML | tritium-sc | Live server | VERIFIED |
| Re-verify: /api/amy/personality returns traits | tritium-sc | Live server | VERIFIED |
| Re-verify: /api/fleet/map/devices returns (empty, no MQTT) | tritium-sc | Live server | VERIFIED |
| Duplicate route prefix audit: 7 shared prefixes, all unique suffixes | tritium-sc | Code review | Complete |
| STATUS.md updated through Wave 118 | docs | - | Complete |
| Agent trigger schedule "Last Run" updated | docs | - | Complete |
| Lib pytest: 2,265 passing (up from 2,247) | tritium-lib | 2,265 | Verified |
| Changelogs updated | all | - | Complete |

## Wave 115 (Maintenance + Re-verification)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Re-verify Wave 114 fixes: /api/threat-feeds returns 200 with 10 indicators | tritium-sc | Live server | VERIFIED |
| Re-verify Wave 114 fixes: /api/dossiers returns 11 dossiers after demo | tritium-sc | Live server | VERIFIED |
| Re-verify Wave 114 fixes: /api/system/readiness shows 21/21 plugins | tritium-sc | Live server | VERIFIED |
| STATUS.md updated through Wave 115 | docs | - | Complete |
| gb10-02 sync via SSH | infra | - | Complete (synced to Wave 114) |
| visual-testing-agent.md updated with current counts | docs | - | Complete |
| Lib pytest: 2,247 passing confirmed | tritium-lib | 2,247 | Verified |
| Changelogs updated | all | - | Complete |

## Wave 113-114 Features

| Feature | Wave | Component | Status |
|---------|------|-----------|--------|
| DwellEvent model + DwellTracker backend | 113 | tritium-lib/sc | Complete |
| Dwell monitor panel with severity badges | 113 | tritium-sc | Complete |
| Weather overlay with mesh environment data | 113 | tritium-sc | Complete |
| Fleet command history panel + audit log | 113 | tritium-sc | Complete |
| CommandHistoryStore with timeout detection | 113 | tritium-sc | 9 tests |
| Edge command ACK (MQTT ack with command_id) | 113 | tritium-edge | Build SUCCESS |
| /api/threat-feeds alias routes fixed | 114 | tritium-sc | 53 tests |
| DossierManager handles demo event types | 114 | tritium-sc | 63 tests |
| Plugin count uses status=="running" | 114 | tritium-sc | 66 tests |
| Playwright headed visual test | 114 | tritium-sc | Import verified |

## Wave 112 (Maintenance + Security)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Security: /api/feedback requires auth (prevents training data poisoning) | tritium-sc | - | Fixed |
| Orphan router: proximity.py registered in main.py (was unlinked since Wave 108) | tritium-sc | - | Fixed |
| 5 orphan panels registered in main.js (acoustic-intelligence, behavioral-intelligence, map-replay, voice-command, wifi-fingerprint) | tritium-sc | - | Fixed |
| Lib pytest: 2,236 passing confirmed | tritium-lib | 2,236 | Verified |

## Wave 107-111 Features

| Feature | Wave | Component | Status |
|---------|------|-----------|--------|
| Security: classify API requires auth, 6 tests | 107 | tritium-sc | Complete |
| Meshtastic chat bridge (operator-to-mesh bidirectional) | 107 | tritium-sc | Complete |
| CoT XML export format for targets | 107 | tritium-sc/lib | Complete |
| Amy daily learning summary endpoint | 107 | tritium-sc | Complete |
| tritium-lib CoT export models (CoTExportEvent, CoTExportPoint) | 107 | tritium-lib | Complete |
| ProximityMonitor engine + REST API /api/proximity/ | 108 | tritium-sc | Complete |
| Investigation auto-close with configurable delay | 108 | tritium-sc | Complete |
| STATUS.md comprehensive update, route audit (88 routers) | 109 | docs | Complete |
| RL pipeline health audit | 109 | tritium-sc | Complete |
| Correlator logs correlation decisions to TrainingStore | 110 | tritium-sc | Complete |
| BLE classifier logs classification decisions to TrainingStore | 110 | tritium-sc | Complete |
| Health endpoint includes rl_training metrics | 110 | tritium-sc | Complete |
| Playwright visual test (dark theme, map, menu bar) | 110 | tritium-sc | Complete |
| Target capacity benchmark (248K ops/s at 10K targets) | 111 | tritium-sc | Complete |
| WebSocket stress test (10/50/100 concurrent connections) | 111 | tritium-sc | Complete |
| Demo mode RL training generator (100+ examples in 5 min) | 111 | tritium-sc | Complete |

## Codebase Metrics (Wave 127)

| Metric | Value |
|--------|-------|
| **Total waves completed** | 127 |
| **Total features shipped** | 340+ |
| **Active plugins** | 21 (including AmyCommanderPlugin) |
| **API routers** | 97 |
| **Frontend panels** | 83 |
| **Visual test files** | 102 |
| **UI test files** | 55 |
| **JS test files** | 97 |
| **Lib model files** | 85 |
| **Lib Pydantic classes** | 242+ |
| **Lib tests** | 2,305 |
| **HAL libraries** | 64 |
| **Correlation strategies** | 6 (spatial=0.30, temporal=0.15, signal_pattern=0.14, dossier=0.13, learned=0.13, wifi_probe=0.15) |
| **Intelligence modules** | 7 (all using BaseLearner ABC) |
| **RL features** | 10 (expanded from 6 in Wave 126) |

## Test Results (Wave 127)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib | 2,305 tests | All passing |
| tritium-sc | 97 router files, 83 panel JS files | Passing |
| tritium-edge build | 49.9% RAM, 29.4% Flash | 0 warnings, SUCCESS |
| Total test files | 818 (623 SC + 116 lib + others) | |

## RL Pipeline Status (Wave 127 — 10-Feature Model)

| Metric | Value |
|--------|-------|
| **TrainingStore DB** | data/training.db |
| **Model path** | data/models/correlation_model.pkl |
| **Feature count** | 10 (expanded from 6 in Wave 126) |
| **Features** | distance, rssi_delta, co_movement, device_type_match, time_gap, signal_pattern, co_movement_duration, time_of_day_similarity, source_diversity_score, wifi_probe_correlation |
| **Static fallback** | Active when model=None (graceful degradation) |
| **Auto-retrain scheduler** | Every 6 hours or 50 new feedback entries |
| **Training threshold** | 10+ confirmed correlation examples needed |
| **Security** | POST /api/feedback requires authentication (Wave 112) |
| **6-strategy weights** | spatial=0.30, wifi_probe=0.15, temporal=0.15, signal_pattern=0.14, dossier=0.13, learned=0.13 (sum=1.00) |
| **Status** | 10-feature model with WiFiProbeStrategy as 6th correlation strategy. Feature engineering library in tritium-lib provides reusable ML feature functions. |

## Architecture

```
  tritium-edge (C++17)     tritium-sc (Python+JS)     tritium-lib (Python)
  ==================       =====================       ===================
  ESP32-S3 firmware        FastAPI :8000               85 model files
  6 board types            21 plugins                  242+ Pydantic classes
  64 HAL libraries         97 routers                  2,283 tests
  MQTT, BLE, WiFi          AI Commander Amy (plugin)   Graph DB, Auth
  LoRa, ESP-NOW            YOLO, WebSocket             Events, MQTT topics
  hal_ble_features         Canvas 2D/3D map            Geo, Notifications
  hal_tinyml, hal_voice    7 intelligence modules      Classifier, COT
  hal_scan_optimizer       82 frontend panels          BaseLearner ABC
  hal_radio_scheduler      Forensics + Collaboration   Intel Packages
  hal_tamper_detect        Operator chat + drawing
  hal_diag_dump            Swarm coordination
  Fleet server :8080       Fleet lifecycle mgmt
                           Remote diagnostics
                           Intel package export/import
                           Proximity monitoring
```

## Plugins (21 active)

| Plugin | Purpose |
|--------|---------|
| edge_tracker | Edge device fleet tracking via MQTT |
| meshtastic | LoRa mesh radio bridge |
| camera_feeds | Multi-source camera management |
| fleet_dashboard | Device registry, fleet overview, lifecycle, group commands, remote diagnostics |
| yolo_detector | Object detection inference pipeline |
| gis_layers | OSM/satellite/terrain map layers |
| tak_bridge | ATAK/CoT military interoperability |
| automation | If-then rule engine |
| graphlings | NPC behavior system |
| npc_thoughts | NPC inner monologue |
| threat_feeds | Known-bad indicator matching |
| rf_motion | Passive RF-based motion detection |
| acoustic | Sound classification, ML MFCC, TDoA localization |
| federation | Multi-site federation + intelligence package sharing |
| wifi_fingerprint | WiFi device fingerprinting |
| behavioral_intelligence | Pattern detection, anomaly alerting |
| floorplan | Indoor floor plan + localization |
| swarm_coordination | Multi-robot formations and waypoints |
| edge_autonomy | Autonomous edge decision processing |
| amy | AI Commander Amy (4-layer cognitive AI, sensorium, instinct dispatch) |

## Security Audit (Wave 112)

| Endpoint | Risk | Status |
|----------|------|--------|
| POST /api/feedback | Training data poisoning via unauthenticated feedback | FIXED — now requires `require_auth` |
| POST /api/targets/{id}/classify | Classification override without auth | Fixed in Wave 106 |
| MQTT topics | Unrestricted pub/sub | ACL template created in Wave 106 |

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
| Intelligence package export/import | Working |
| Edge diagnostic dump via MQTT cmd | Working |
| Remote diagnostics panel | Working |
| Swarm coordination commands | Working |
| Edge autonomy decision pipeline | Working |
| Device lifecycle state machine | Working |
| Fleet health summary aggregation | Working |
| Plugin auto-discovery with boot report | Working |
| Unified event feed | Working |
| Proximity monitoring + alerts | Working |

## Known Blockers

- **NimBLE esp_bt.h not found** -- blocks BLE serial + BLE OTA. WiFi/mesh/SD alternatives work.
- **BLE/WiFi coexistence** -- can't run BLE scanner alongside WiFi. Radio scheduler HAL wired (Wave 105), needs serial verification.
- **RGB parallel display glitches** -- 43C-BOX cosmetic issue when USB connected.
- **gb10-02 sync** -- RESOLVED (Wave 124). Synced to Wave 123 via 192.168.110.2.
