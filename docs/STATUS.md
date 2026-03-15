# Tritium System Status

Current state of all components as of 2026-03-14 (Wave 99 — Maintenance, Wave 100 Prep).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | 49.7% RAM, 29.3% flash (within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 2,120 tests passing, 29 skipped |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds, diagnostics |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict (radio scheduler HAL ready) |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |
| **Intelligence pipeline** | Active | 7 modules, all learners using BaseLearner ABC |
| **Plugin system** | Active | 20 plugins (including AmyCommanderPlugin), auto-discovery with boot report |
| **Collaboration** | Active | Shared workspaces, map drawing, operator chat, WebSocket broadcast |
| **Forensics** | Active | Event reconstruction, incident reports, map replay |
| **Fleet management** | Active | Device lifecycle (provisioning/active/maintenance/retired/error), health summary |

## Wave 97-98 Features

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Multi-source confidence boosting (1.3x per additional source) | tritium-sc | 895 tactical | Complete |
| Sensor health monitoring (EMA baseline, deviation detection) | tritium-sc | 11 tests | Complete |
| Target velocity consistency (teleportation detection >50 m/s) | tritium-sc | 4 tests | Complete |
| SensorHealthMetrics model | tritium-lib | 20 tests | Complete |
| Edge sensor self-test (hourly WiFi/BLE/heap checks) | tritium-edge | Build verified | Complete |
| Fleet health summary API (GET /api/fleet/health-summary) | tritium-sc | 4 tests | Complete |
| Device lifecycle management (state machine + history) | tritium-sc | 10 tests | Complete |
| AmyCommanderPlugin (amy-as-plugin refactor phase 1) | tritium-sc | 10 tests | Complete |
| DeviceState/DeviceLifecycleEvent models | tritium-lib | 14 tests | Complete |
| Edge lifecycle state reporting (NVS + MQTT heartbeat) | tritium-edge | Build verified | Complete |

## Codebase Metrics (Wave 99 Baseline)

| Metric | Value |
|--------|-------|
| **Total waves completed** | 99 |
| **Total features shipped** | 250+ |
| **Active plugins** | 20 (including AmyCommanderPlugin) |
| **API routes** | 703+ |
| **Frontend JS files** | 144 |
| **Lib model files** | 75 |
| **HAL libraries** | 64 |
| **Correlation strategies** | 5 (spatial, temporal, signal_pattern, dossier, learned) |
| **Intelligence modules** | 7 (all using BaseLearner ABC) |
| **Total test files** | 787 (599 SC + 107 lib + others) |

## Test Results (Wave 99 Baseline)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib pytest | 2,120 passed, 29 skipped | All passing (3.2s) |
| tritium-lib on gb10-02 | 2,149 passed | All passing (22s) |
| tritium-sc tactical tests | 895 passed, 3 skipped | All passing (48s) |
| tritium-sc fleet_dashboard | 38 passed | All passing |
| tritium-sc amy_plugin | 10 passed | All passing |
| tritium-edge build | 49.7% RAM, 29.3% Flash | 0 warnings, SUCCESS |

## Architecture

```
  tritium-edge (C++17)     tritium-sc (Python+JS)     tritium-lib (Python)
  ==================       =====================       ===================
  ESP32-S3 firmware        FastAPI :8000               75 model files
  6 board types            20 plugins                  360+ dataclasses
  64 HAL libraries         703+ routes                 107 test files
  MQTT, BLE, WiFi          AI Commander Amy (plugin)   Graph DB, Auth
  LoRa, ESP-NOW            YOLO, WebSocket             Events, MQTT topics
  hal_ble_features         Canvas 2D/3D map            Geo, Notifications
  hal_tinyml, hal_voice    7 intelligence modules      Classifier, COT
  hal_scan_optimizer       144 frontend JS files       BaseLearner ABC
  hal_diag_dump            Forensics + Collaboration   2,120 tests
  Fleet server :8080       Operator chat + drawing
                           Swarm coordination
                           Fleet lifecycle mgmt
```

## Plugins (20 active)

| Plugin | Purpose |
|--------|---------|
| edge_tracker | Edge device fleet tracking via MQTT |
| meshtastic | LoRa mesh radio bridge |
| camera_feeds | Multi-source camera management |
| fleet_dashboard | Device registry, fleet overview, lifecycle, group commands |
| yolo_detector | Object detection inference pipeline |
| gis_layers | OSM/satellite/terrain map layers |
| tak_bridge | ATAK/CoT military interoperability |
| automation | If-then rule engine |
| graphlings | NPC behavior system |
| npc_thoughts | NPC inner monologue |
| threat_feeds | Known-bad indicator matching |
| rf_motion | Passive RF-based motion detection |
| acoustic | Sound classification, ML MFCC, TDoA localization |
| federation | Multi-site Tritium federation |
| wifi_fingerprint | WiFi device fingerprinting |
| behavioral_intelligence | Pattern detection, anomaly alerting |
| floorplan | Indoor floor plan + localization |
| swarm_coordination | Multi-robot formations and waypoints |
| edge_autonomy | Autonomous edge decision processing |
| amy | AI Commander Amy (4-layer cognitive AI, sensorium, instinct dispatch) |

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
| Edge feature extraction to SC aggregation | Working |
| SC classification feedback to edge via MQTT | Working |
| Fleet coordination commands to device groups | Working |
| Plugin auto-discovery with boot report | Working |
| Operational readiness checklist | Working |
| Unified event feed | Working |
| Fusion dashboard + metrics | Working |
| Operator collaboration (workspaces + chat + drawing) | Working |
| Forensic reconstruction + incident reports | Working |
| Edge diagnostic dump via MQTT cmd | Working |
| Swarm coordination commands | Working |
| Edge autonomy decision pipeline | Working |
| Device lifecycle state machine | Working |
| Fleet health summary aggregation | Working |

## Infrastructure Health

| Host | Disk | RAM Free | Status |
|------|------|----------|--------|
| gb10-01 (primary) | 72% (246G free) | 50GB | Active development |
| gb10-02 (backup) | 77% (204G free) | 88GB | Synced, 2,149 lib tests passing |

## Known Blockers

- **NimBLE esp_bt.h not found** -- blocks BLE serial + BLE OTA. WiFi/mesh/SD alternatives work.
- **BLE/WiFi coexistence** -- can't run BLE scanner alongside WiFi. Radio scheduler HAL ready for testing.
- **RGB parallel display glitches** -- 43C-BOX cosmetic issue when USB connected.
