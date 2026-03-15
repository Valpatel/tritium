# Tritium System Status

Current state of all components as of 2026-03-14 (Wave 87 — Maintenance).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | 49.6% RAM, 29.2% flash (within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 1,990 tests passing, 0 failures |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict (radio scheduler HAL ready) |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |
| **Intelligence pipeline** | Active | 7 modules, all learners using BaseLearner ABC |
| **Plugin system** | Active | 17 plugins (16 directory + 1 built-in), auto-discovery with boot report |

## Wave 85-86 Features

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Geofence intelligence auto-investigations | tritium-sc | Unit tested (8 tests) | Complete |
| Fusion dashboard (status/strategies/pairs/weights) | tritium-sc | Server tested | Complete |
| FusionMetrics thread-safe tracking | tritium-lib | Unit tested (17 tests) | Complete |
| Security: auth on unified events + audit APIs | tritium-sc | Verified | Complete |
| Security: IP address redaction in event feed | tritium-sc | Verified | Complete |
| Cross-sensor fusion improvements | tritium-sc | Unit tested | Complete |
| Camera-BLE auto-correlation | tritium-sc | Unit tested | Complete |

## Wave 87 Features (Maintenance)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| hal_tinyml + hal_voice wired into main.cpp | tritium-edge | Conditional compilation | Complete |
| Agent files updated to Wave 87 counts | docs | -- | Complete |
| STATUS.md, CHANGELOG.md comprehensive update | docs | -- | Complete |
| Iteration queue Waves 83-86 marked DONE, 88-92 planned | docs | -- | Complete |
| gb10-02 self-preservation: pulled, PyJWT upgraded, 1974 lib tests passing | infra | -- | Complete |
| SC test baseline: 97 tiers passing, 0 failures | tests | -- | Complete |
| Lib test baseline: 1,990 passing | tests | -- | Complete |

## Codebase Metrics (Wave 87 Baseline)

| Metric | Value |
|--------|-------|
| **Total waves completed** | 87 |
| **Total features shipped** | 210+ |
| **SC Python source** | ~101,800 lines |
| **SC Python tests** | ~254,600 lines |
| **SC JS (frontend)** | ~72,100 lines |
| **SC CSS** | ~13,800 lines |
| **Lib Python source** | ~24,500 lines |
| **Lib Python tests** | ~19,800 lines |
| **Edge C++/H** | ~62,500 lines (222 project files) |
| **Frontend JS files** | 139 |
| **Frontend panels** | 75 registered |
| **Active plugins** | 17 (16 directory + 1 built-in NPC Intelligence) |
| **API routers** | 81 router files |
| **API routes** | 500+ |
| **Lib model files** | 66 |
| **HALs** | 50 |
| **Correlation strategies** | 5 (spatial, temporal, signal_pattern, dossier, learned) |
| **Intelligence modules** | 7 (all using BaseLearner ABC) |
| **Total test files** | 880+ (743 SC + 97 lib + 39 edge) |

## Test Results (Wave 87 Baseline)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib pytest | 1,990 passed | All passing |
| tritium-sc test.sh fast | 97 tiers passed | All passing (404s) |
| tritium-lib on gb10-02 | 1,974 passed | All passing |
| tritium-edge build | 49.6% RAM, 29.2% Flash | 0 warnings, SUCCESS |
| **Total test files** | **880+** across all repos | -- |

## Architecture

```
  tritium-edge (C++17)     tritium-sc (Python+JS)     tritium-lib (Python)
  ==================       =====================       ===================
  ESP32-S3 firmware        FastAPI :8000               66 model files
  6 board types            17 plugins                  340+ dataclasses
  222 source files         81 routers                  97 test files
  50 HALs                  500+ routes                 Graph DB, Auth
  MQTT, BLE, WiFi          AI Commander Amy            Events, MQTT topics
  LoRa, ESP-NOW            YOLO, WebSocket             Geo, Notifications
  hal_ble_features         Canvas 2D/3D map            Classifier, COT
  hal_tinyml, hal_voice    7 intelligence modules      BaseLearner ABC
  Fleet server :8080       75 frontend panels          1,990 tests
```

## Plugins (17 active)

| Plugin | Purpose |
|--------|---------|
| edge_tracker | Edge device fleet tracking via MQTT |
| meshtastic | LoRa mesh radio bridge |
| camera_feeds | Multi-source camera management |
| fleet_dashboard | Device registry, fleet overview, group commands |
| yolo_detector | Object detection inference pipeline |
| gis_layers | OSM/satellite/terrain map layers |
| tak_bridge | ATAK/CoT military interoperability |
| automation | If-then rule engine |
| graphlings | NPC behavior system |
| npc_thoughts | NPC inner monologue |
| threat_feeds | Known-bad indicator matching |
| rf_motion | Passive RF-based motion detection |
| acoustic | Sound classification |
| federation | Multi-site Tritium federation |
| wifi_fingerprint | WiFi device fingerprinting |
| behavioral_intelligence | Pattern detection, anomaly alerting |
| floorplan | Indoor floor plan + localization |

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

## Known Blockers

- **NimBLE esp_bt.h not found** -- blocks BLE serial + BLE OTA. WiFi/mesh/SD alternatives work.
- **BLE/WiFi coexistence** -- can't run BLE scanner alongside WiFi. Radio scheduler HAL ready for testing.
- **RGB parallel display glitches** -- 43C-BOX cosmetic issue when USB connected.
