# Tritium System Status

Current state of all components as of 2026-03-14 (Wave 109 — Maintenance).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | 49.8% RAM, 29.4% Flash (within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 2,236 tests passing |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds, diagnostics |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict (radio scheduler wired in Wave 105) |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |
| **Intelligence pipeline** | Active | 7 modules, all learners using BaseLearner ABC |
| **RL pipeline** | Idle | TrainingStore has 54 feedback entries, 0 correlation/classification data; model not yet trained (needs 10+ confirmed correlations) |
| **Plugin system** | Active | 20 plugins (including AmyCommanderPlugin), auto-discovery with boot report |
| **Collaboration** | Active | Shared workspaces, map drawing, operator chat, WebSocket broadcast |
| **Forensics** | Active | Event reconstruction, incident reports, map replay |
| **Fleet management** | Active | Device lifecycle, health summary, remote diagnostics |
| **Intelligence packages** | Active | Portable inter-site intelligence sharing with chain of custody |

## Wave 109 (Maintenance)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| STATUS.md update to Wave 109 | docs | - | Complete |
| RL pipeline health audit (54 feedback, 0 correlations, model not trained) | tritium-sc | - | Audited |
| Edge firmware build verification: 49.8% RAM, 29.4% Flash | tritium-edge | Build Verified | Complete |
| Route redundancy audit: 88 routers, no collisions | tritium-sc | - | Audited |
| Agent trigger schedule updated | docs | - | Complete |

## Wave 105-108 Features

| Feature | Wave | Component | Status |
|---------|------|-----------|--------|
| Radio scheduler (hal_radio_scheduler) wired into main.cpp | 105 | tritium-edge | Complete |
| Tamper detection (hal_tamper_detect) wired with conditional compilation | 105 | tritium-edge | Complete |
| Threat level history — 24h ring buffer + GET /api/threat-level/history | 105 | tritium-sc | Complete |
| Amy Commander Plugin verified (Phase 4) | 105 | tritium-sc | Complete |
| STATUS.md comprehensive update | 106 | docs | Complete |
| Waves 104-108 feature delivery + quality | 104-108 | all | Complete |

## Wave 103 Features

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| IntelligencePackage model (portable intel sharing) | tritium-lib | 32 tests | Complete |
| Intelligence package export/import API (7 routes) | tritium-sc | 18 tests | Complete |
| Edge device remote diagnostics (3 routes) | tritium-sc | 11 tests | Complete |
| Edge diagnostics frontend panel | tritium-sc | JS panel | Complete |

## Codebase Metrics (Wave 109)

| Metric | Value |
|--------|-------|
| **Total waves completed** | 109 |
| **Total features shipped** | 280+ |
| **Active plugins** | 20 (including AmyCommanderPlugin) |
| **API routers** | 88 |
| **Frontend JS files** | 145 |
| **Lib model files** | 82 |
| **Lib tests** | 2,236 |
| **HAL libraries** | 64 |
| **Correlation strategies** | 5 (spatial, temporal, signal_pattern, dossier, learned) |
| **Intelligence modules** | 7 (all using BaseLearner ABC) |

## Test Results (Wave 109)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib | 2,236 tests | All passing |
| tritium-sc | 88 router files, 145 JS files | Passing |
| tritium-edge build | 49.8% RAM, 29.4% Flash | 0 warnings, SUCCESS |

## RL Pipeline Status (Wave 109 Audit)

| Metric | Value |
|--------|-------|
| **TrainingStore DB** | data/training.db (45 KB) |
| **Correlation decisions logged** | 0 |
| **Correlation decisions with outcome** | 0 |
| **Classification decisions logged** | 0 |
| **Operator feedback entries** | 54 |
| **Saved model** | None (no correlation_model.pkl) |
| **Auto-retrain scheduler** | Code ready, starts via `start_retrain_scheduler()` |
| **Training threshold** | 10+ confirmed correlation examples needed |
| **Retrain interval** | Every 6 hours or 50 new feedback entries |
| **sklearn available** | Yes |
| **Status** | IDLE — collecting feedback but no correlation/classification decisions being logged to train on. The correlator needs to call `training_store.log_correlation()` during operation to populate training data. |

## Architecture

```
  tritium-edge (C++17)     tritium-sc (Python+JS)     tritium-lib (Python)
  ==================       =====================       ===================
  ESP32-S3 firmware        FastAPI :8000               82 model files
  6 board types            20 plugins                  370+ dataclasses
  64 HAL libraries         88 routers                  2,236 tests
  MQTT, BLE, WiFi          AI Commander Amy (plugin)   Graph DB, Auth
  LoRa, ESP-NOW            YOLO, WebSocket             Events, MQTT topics
  hal_ble_features         Canvas 2D/3D map            Geo, Notifications
  hal_tinyml, hal_voice    7 intelligence modules      Classifier, COT
  hal_scan_optimizer       145 frontend JS files       BaseLearner ABC
  hal_radio_scheduler      Forensics + Collaboration   Intel Packages
  hal_tamper_detect        Operator chat + drawing
  hal_diag_dump            Swarm coordination
  Fleet server :8080       Fleet lifecycle mgmt
                           Remote diagnostics
                           Intel package export/import
```

## Plugins (20 active)

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

## Route Redundancy Audit (Wave 109)

88 routers with unique prefixes. Shared-prefix routers have non-overlapping suffixes:

| Prefix | Routers | Collision? |
|--------|---------|------------|
| `/api/targets` | 6 (ar_export, classification_override, enrichment, nearby_targets, target_search, timeline) | No — unique suffixes |
| `/api/devices` | 2 (device_management, devices) | No — unique suffixes |
| `/api/analytics` | 3 (analytics_dashboard, history_analytics, movement_analytics) | No — unique suffixes |
| `/api/system` | 3 (metrics, self_test, system_inventory) | No — unique suffixes |

No duplicate or overlapping endpoint paths found.

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

## Infrastructure Health

| Host | Disk | RAM Free | Status |
|------|------|----------|--------|
| gb10-01 (primary) | — | — | Active development |
| gb10-02 (backup) | — | — | SSH unreachable this session (host key verification) |

## Known Blockers

- **NimBLE esp_bt.h not found** -- blocks BLE serial + BLE OTA. WiFi/mesh/SD alternatives work.
- **BLE/WiFi coexistence** -- can't run BLE scanner alongside WiFi. Radio scheduler HAL wired (Wave 105), needs serial verification.
- **RGB parallel display glitches** -- 43C-BOX cosmetic issue when USB connected.
- **RL pipeline idle** -- TrainingStore has 54 feedback entries but 0 correlation/classification decisions. Correlator needs to call `log_correlation()` during operation to generate training data for the learned model.
- **gb10-02 sync** -- SSH host key verification failed; needs manual acceptance of new host key.
