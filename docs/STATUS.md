# Tritium System Status

Current state of all components as of 2026-03-14 (Wave 115 — Maintenance + Re-verification).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | 49.9% RAM, 29.4% Flash (within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 2,247 tests passing |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds, diagnostics |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict (radio scheduler wired in Wave 105) |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |
| **Intelligence pipeline** | Active | 7 modules, all learners using BaseLearner ABC |
| **RL pipeline** | Wired | Correlator + BLE classifier now log decisions; demo mode RL generator produces training data; feedback endpoint secured with auth (Wave 112) |
| **Plugin system** | Active | 21 plugins (including AmyCommanderPlugin), auto-discovery with boot report |
| **Collaboration** | Active | Shared workspaces, map drawing, operator chat, WebSocket broadcast |
| **Forensics** | Active | Event reconstruction, incident reports, map replay |
| **Fleet management** | Active | Device lifecycle, health summary, remote diagnostics |
| **Intelligence packages** | Active | Portable inter-site intelligence sharing with chain of custody |
| **Dwell tracking** | Active | Monitors stationary targets >5min, severity classification |
| **Command history** | Active | Fleet command audit log with timeout detection |

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

## Codebase Metrics (Wave 115)

| Metric | Value |
|--------|-------|
| **Total waves completed** | 115 |
| **Total features shipped** | 300+ |
| **Active plugins** | 21 (including AmyCommanderPlugin) |
| **API routers** | 90+ |
| **Frontend panels** | 82 |
| **Visual test files** | 105 |
| **UI test files** | 56 |
| **Lib model files** | 82 |
| **Lib tests** | 2,247 |
| **HAL libraries** | 64 |
| **Correlation strategies** | 5 (spatial, temporal, signal_pattern, dossier, learned) |
| **Intelligence modules** | 7 (all using BaseLearner ABC) |

## Test Results (Wave 115)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib | 2,247 tests | All passing |
| tritium-sc | 90+ router files, 82 panel JS files | Passing |
| tritium-edge build | 49.9% RAM, 29.4% Flash | 0 warnings, SUCCESS |

## RL Pipeline Status (Wave 112 Audit)

| Metric | Value |
|--------|-------|
| **TrainingStore DB** | data/training.db |
| **Correlation decisions** | Now logged by correlator (Wave 110) |
| **Classification decisions** | Now logged by BLE classifier (Wave 110) |
| **Operator feedback entries** | 54+ (auth required as of Wave 112) |
| **Demo RL generator** | Produces 100+ training examples in 5 min (Wave 111) |
| **Auto-retrain scheduler** | Code ready, starts via `start_retrain_scheduler()` |
| **Training threshold** | 10+ confirmed correlation examples needed |
| **Retrain interval** | Every 6 hours or 50 new feedback entries |
| **Security** | POST /api/feedback now requires authentication (Wave 112 fix) |
| **Status** | WIRED — correlator and classifier now log decisions. Demo mode can generate training data. Auth prevents poisoning. |

## Architecture

```
  tritium-edge (C++17)     tritium-sc (Python+JS)     tritium-lib (Python)
  ==================       =====================       ===================
  ESP32-S3 firmware        FastAPI :8000               82 model files
  6 board types            21 plugins                  370+ dataclasses
  64 HAL libraries         90+ routers                 2,247 tests
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
- **gb10-02 sync** -- RESOLVED (Wave 115). SSH key accepted, synced to Wave 114.
