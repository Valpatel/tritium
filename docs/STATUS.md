# Tritium System Status

Current state of all components as of 2026-03-14 (Wave 106 — Maintenance).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | 49.7% RAM, 29.3% flash (within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 2,152+ tests passing |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds, diagnostics |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict (radio scheduler wired in Wave 105) |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |
| **Intelligence pipeline** | Active | 7 modules, all learners using BaseLearner ABC |
| **Plugin system** | Active | 20 plugins (including AmyCommanderPlugin), auto-discovery with boot report |
| **Collaboration** | Active | Shared workspaces, map drawing, operator chat, WebSocket broadcast |
| **Forensics** | Active | Event reconstruction, incident reports, map replay |
| **Fleet management** | Active | Device lifecycle, health summary, remote diagnostics |
| **Intelligence packages** | Active | Portable inter-site intelligence sharing with chain of custody |

## Wave 105 Features

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Radio scheduler (hal_radio_scheduler) wired into main.cpp — BLE/WiFi coex blocker resolved | tritium-edge | Build Verified | Complete |
| Tamper detection (hal_tamper_detect) wired with conditional compilation | tritium-edge | Build Verified | Complete |
| Radio scheduler + tamper detect status in boot summary | tritium-edge | Build Verified | Complete |
| Threat level history — 24h ring buffer + GET /api/threat-level/history | tritium-sc | Unit Tested | Complete |
| Security audit: 6 tests verifying threat calculator integrity | tritium-sc | Unit Tested | Complete |
| Amy Commander Plugin verified (Phase 4 — EventBus + WarAnnouncer plugin-owned) | tritium-sc | Unit Tested | Complete |

## Wave 103 Features

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| IntelligencePackage model (portable intel sharing) | tritium-lib | 32 tests | Complete |
| Intelligence package export/import API (7 routes) | tritium-sc | 18 tests | Complete |
| Edge device remote diagnostics (3 routes) | tritium-sc | 11 tests | Complete |
| Edge diagnostics frontend panel | tritium-sc | JS panel | Complete |
| STATUS.md update to Wave 103 | docs | - | Complete |

## Codebase Metrics (Wave 106)

| Metric | Value |
|--------|-------|
| **Total waves completed** | 106 |
| **Total features shipped** | 270+ |
| **Active plugins** | 20 (including AmyCommanderPlugin) |
| **API routes** | 715+ |
| **Frontend JS files** | 145 |
| **Lib model files** | 77 |
| **HAL libraries** | 64 |
| **Correlation strategies** | 5 (spatial, temporal, signal_pattern, dossier, learned) |
| **Intelligence modules** | 7 (all using BaseLearner ABC) |

## Test Results (Wave 106)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib | 2,152+ tests | All passing |
| tritium-sc mesh layer tests | Updated for neighbor-based links | Passing |
| tritium-edge build | 49.8% RAM, 29.4% Flash | 0 warnings, SUCCESS |

## Architecture

```
  tritium-edge (C++17)     tritium-sc (Python+JS)     tritium-lib (Python)
  ==================       =====================       ===================
  ESP32-S3 firmware        FastAPI :8000               77 model files
  6 board types            20 plugins                  370+ dataclasses
  64 HAL libraries         715+ routes                 2,152+ tests
  MQTT, BLE, WiFi          AI Commander Amy (plugin)   Graph DB, Auth
  LoRa, ESP-NOW            YOLO, WebSocket             Events, MQTT topics
  hal_ble_features         Canvas 2D/3D map            Geo, Notifications
  hal_tinyml, hal_voice    7 intelligence modules      Classifier, COT
  hal_scan_optimizer       145 frontend JS files       BaseLearner ABC
  hal_diag_dump            Forensics + Collaboration   Intel Packages
  Fleet server :8080       Operator chat + drawing
                           Swarm coordination
                           Fleet lifecycle mgmt
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
| gb10-01 (primary) | 72% (246G free) | 50GB | Active development |
| gb10-02 (backup) | 77% (204G free) | 88GB | Synced |

## Known Blockers

- **NimBLE esp_bt.h not found** -- blocks BLE serial + BLE OTA. WiFi/mesh/SD alternatives work.
- **BLE/WiFi coexistence** -- can't run BLE scanner alongside WiFi. Radio scheduler HAL wired (Wave 105), needs serial verification.
- **RGB parallel display glitches** -- 43C-BOX cosmetic issue when USB connected.
