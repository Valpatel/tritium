# Tritium System Status

Current state of all components as of 2026-03-14 (Wave 78 — Maintenance).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | 49.6% RAM, 29.2% flash (within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 1,822 tests passing, 0 failures |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict (radio scheduler HAL ready) |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |
| **Intelligence pipeline** | Active | 7 modules: training_store, correlation_learner, ble_classification_learner, anomaly_baseline, feature_aggregator, classification_feedback, base_learner |
| **Plugin system** | Active | 17 plugins (16 directory + 1 built-in), auto-discovery with boot report |

## Wave 77 Features (Fleet Operations + Multi-Node Coordination)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Fleet coordination commands (reboot, scan_burst, ota_update, etc.) | tritium-sc | 20 tests | Complete |
| Device group management | tritium-sc | Unit tested | Complete |
| Config template system (3 built-in + custom CRUD) | tritium-sc | Unit tested | Complete |
| Fleet analytics dashboard + history | tritium-sc | Unit tested | Complete |
| Coverage map endpoint | tritium-sc | Unit tested | Complete |

## Wave 78 Features (Maintenance)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Plugin auto-discovery verification on boot | tritium-sc | 10 tests (2 new) | Complete |
| Plugin discovery report endpoint (`/api/plugins/discovery`) | tritium-sc | 2 tests | Complete |
| Boot self-test enhanced with plugin discovery details | tritium-sc | Integrated | Complete |
| Health endpoint updated with discovery report + baselines | tritium-sc | Verified | Complete |
| Agent files updated with current counts | docs | -- | Complete |
| STATUS.md, CHANGELOG.md, iteration queue updated | docs | -- | Complete |

## Codebase Metrics (Wave 78 Baseline)

| Metric | Value |
|--------|-------|
| **Total waves completed** | 78 |
| **Total features shipped** | 175+ |
| **Total lines of code** | ~535,000 across 3 repos |
| **SC Python source** | ~99,700 lines |
| **SC Python tests** | ~253,400 lines |
| **SC JS (frontend)** | ~70,300 lines |
| **SC CSS** | ~13,500 lines |
| **Lib Python** | ~22,500 lines |
| **Edge C++/H** | ~75,500 lines (296 files) |
| **Frontend JS files** | 133 |
| **Frontend panels** | 71 registered |
| **Active plugins** | 17 (16 directory + 1 built-in NPC Intelligence) |
| **API routers** | 78 router files |
| **API routes** | 598+ (463 core + 135 plugin) |
| **Lib model files** | 61 |
| **HALs** | 50 |
| **Correlation strategies** | 5 (spatial, temporal, signal_pattern, dossier, learned) |
| **Intelligence modules** | 7 (2,667 lines) |
| **Agent definition files** | 11 |
| **Total test files** | 840 (672 SC + 89 lib + 79 edge) |

## Test Results (Wave 78 Baseline)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib pytest | 1,822 passed, 29 skipped | All passing |
| tritium-sc test.sh fast | 97 tiers passed, 0 failed | All passing |
| tritium-sc plugin API tests | 10 passed | All passing |
| tritium-sc test files | 672 (577 py + 95 js) | -- |
| tritium-lib test files | 89 | -- |
| tritium-edge build | 49.6% RAM, 29.2% Flash | 0 warnings, SUCCESS |
| **Total test files** | **840** across all repos | -- |

## Architecture

```
  tritium-edge (C++17)     tritium-sc (Python+JS)     tritium-lib (Python)
  ==================       =====================       ===================
  ESP32-S3 firmware        FastAPI :8000               61 model files
  6 board types            17 plugins                  324+ dataclasses
  296 source files         78 routers                  89 test files
  50 HALs                  598+ routes                 Graph DB, Auth
  MQTT, BLE, WiFi          AI Commander Amy            Events, MQTT topics
  LoRa, ESP-NOW            YOLO, WebSocket             Geo, Notifications
  hal_ble_features         Canvas 2D/3D map            Classifier, COT
  Fleet server :8080       7 intelligence modules      FeatureVector models
  Intelligence pipeline    71 frontend panels          1,822 tests
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

## Known Blockers

- **NimBLE esp_bt.h not found** -- blocks BLE serial + BLE OTA. WiFi/mesh/SD alternatives work.
- **BLE/WiFi coexistence** -- can't run BLE scanner alongside WiFi. Radio scheduler HAL ready for testing.
- **RGB parallel display glitches** -- 43C-BOX cosmetic issue when USB connected.
