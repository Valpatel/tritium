# Tritium System Status

Current state of all components as of 2026-03-14 (Wave 84 — Maintenance).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | 49.6% RAM, 29.2% flash (within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 1,957 tests passing, 0 failures |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict (radio scheduler HAL ready) |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |
| **Intelligence pipeline** | Active | 7 modules, all learners using BaseLearner ABC |
| **Plugin system** | Active | 17 plugins (16 directory + 1 built-in), auto-discovery with boot report |

## Wave 81-83 Features

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| History analytics API | tritium-sc | Unit tested | Complete |
| Weather overlay API | tritium-sc | Unit tested | Complete |
| AR export API | tritium-sc | Unit tested | Complete |
| Amy briefing API | tritium-sc | Unit tested | Complete |
| Movement analytics API | tritium-sc | Unit tested | Complete |
| Ollama health endpoint | tritium-sc | Unit tested | Complete |
| Nearby targets API | tritium-sc | Unit tested | Complete |
| Picture of day API | tritium-sc | Unit tested | Complete |

## Wave 84 Features (Maintenance + Operational Readiness)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| CorrelationLearner refactored to extend BaseLearner | tritium-sc | 10 tests | Complete |
| BLEClassificationLearner refactored to extend BaseLearner | tritium-sc | 10 tests | Complete |
| Operational readiness checklist (`/api/system/readiness`) | tritium-sc | 10 tests | Complete |
| Unified event feed (`/api/events/unified`) | tritium-sc | 10 tests | Complete |
| STATUS.md updated to Wave 84 state | docs | -- | Complete |

## Codebase Metrics (Wave 84 Baseline)

| Metric | Value |
|--------|-------|
| **Total waves completed** | 84 |
| **Total features shipped** | 195+ |
| **Total lines of code** | ~619,000 across 3 repos |
| **SC Python source** | ~101,800 lines |
| **SC Python tests** | ~254,600 lines |
| **SC JS (frontend)** | ~72,100 lines |
| **SC CSS** | ~13,800 lines |
| **Lib Python source** | ~24,500 lines |
| **Lib Python tests** | ~19,800 lines |
| **Edge C++/H** | ~62,500 lines (222 project files) |
| **Frontend JS files** | 139 |
| **Frontend panels** | 74 registered |
| **Active plugins** | 17 (16 directory + 1 built-in NPC Intelligence) |
| **API routers** | 81 router files |
| **API routes** | 501+ |
| **Lib model files** | 66 |
| **HALs** | 50 |
| **Correlation strategies** | 5 (spatial, temporal, signal_pattern, dossier, learned) |
| **Intelligence modules** | 7 (all using BaseLearner ABC) |
| **Total test files** | 880 (743 SC + 97 lib + 39 edge) |

## Test Results (Wave 84 Baseline)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib pytest | 1,957 passed | All passing |
| tritium-sc new tests (Wave 84) | 30 passed | All passing |
| tritium-sc test files | 743 (644 py + 99 js) | -- |
| tritium-lib test files | 97 | -- |
| tritium-edge build | 49.6% RAM, 29.2% Flash | 0 warnings, SUCCESS |
| **Total test files** | **880** across all repos | -- |

## Architecture

```
  tritium-edge (C++17)     tritium-sc (Python+JS)     tritium-lib (Python)
  ==================       =====================       ===================
  ESP32-S3 firmware        FastAPI :8000               66 model files
  6 board types            17 plugins                  340+ dataclasses
  222 source files         81 routers                  97 test files
  50 HALs                  501+ routes                 Graph DB, Auth
  MQTT, BLE, WiFi          AI Commander Amy            Events, MQTT topics
  LoRa, ESP-NOW            YOLO, WebSocket             Geo, Notifications
  hal_ble_features         Canvas 2D/3D map            Classifier, COT
  Fleet server :8080       7 intelligence modules      BaseLearner ABC
  Intelligence pipeline    74 frontend panels          1,957 tests
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

## Known Blockers

- **NimBLE esp_bt.h not found** -- blocks BLE serial + BLE OTA. WiFi/mesh/SD alternatives work.
- **BLE/WiFi coexistence** -- can't run BLE scanner alongside WiFi. Radio scheduler HAL ready for testing.
- **RGB parallel display glitches** -- 43C-BOX cosmetic issue when USB connected.
