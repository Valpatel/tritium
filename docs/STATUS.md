# Tritium System Status

Current state of all components as of 2026-03-14 (Wave 72 — Maintenance).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | 49.6% RAM, 29.2% flash (within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 1,750 tests passing, 0 failures |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict (radio scheduler HAL ready) |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |
| **Intelligence pipeline** | Active | 7 modules: training_store, correlation_learner, ble_classification_learner, anomaly_baseline, feature_aggregator, classification_feedback, base_learner |

## Wave 71 New Features

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| BLE feature extraction HAL (`hal_ble_features`) | tritium-edge | Build verified | Complete |
| Feature aggregation service (`FeatureAggregator`) | tritium-sc | 16 tests | Complete |
| Classification feedback loop (`ClassificationFeedbackService`) | tritium-sc | 87 total intel tests | Complete |
| Edge intelligence panel (frontend) | tritium-sc | -- | Complete |
| FeatureVector, ClassificationFeedback, EdgeIntelligenceMetrics models | tritium-lib | 14+ tests | Complete |

## Codebase Metrics (Wave 72 Baseline)

| Metric | Value |
|--------|-------|
| **Total waves completed** | 72 |
| **Total features shipped** | 160+ |
| **Total lines of code** | ~510,000 across 3 repos |
| **SC Python source** | ~99,300 lines |
| **SC Python tests** | ~252,000 lines |
| **SC JS (frontend)** | ~69,000 lines |
| **SC CSS** | ~13,500 lines |
| **Lib Python** | ~21,300 lines |
| **Edge C++/H** | ~69,200 lines (260 files) |
| **Frontend JS files** | 130 |
| **Frontend panels** | 67 registered (7 categories) |
| **Active plugins** | 15 |
| **API routers** | 77 router files |
| **API routes** | 490+ |
| **Lib model files** | 57 |
| **Correlation strategies** | 5 (spatial, temporal, signal_pattern, dossier, learned) |
| **Intelligence modules** | 7 (2,667 lines) |
| **Agent definition files** | 11 |

## Test Results (Wave 72 Baseline)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib pytest | 1,750 passed, 29 skipped | All passing |
| tritium-sc intelligence tests | 87 passed | All passing |
| tritium-sc meshtastic unit tests | 105+ passed | All passing (20 UI-only failures pre-existing) |
| tritium-sc test files | 730 (631 py + 99 js) | -- |
| tritium-lib test files | 86 | -- |
| tritium-edge build | 49.6% RAM, 29.2% Flash | 0 warnings, SUCCESS |
| **Total test files** | **816** across all repos | -- |

## Architecture

```
  tritium-edge (C++17)     tritium-sc (Python+JS)     tritium-lib (Python)
  ==================       =====================       ===================
  ESP32-S3 firmware        FastAPI :8000               57 model files
  6 board types            15 plugins                  324+ dataclasses
  260 source files         77 routers                  86 test files
  MQTT, BLE, WiFi          490+ routes                 Graph DB, Auth
  LoRa, ESP-NOW            AI Commander Amy            Events, MQTT topics
  hal_ble_features         YOLO, WebSocket             Geo, Notifications
  Fleet server :8080       Canvas 2D/3D map            Classifier, COT
  Intelligence pipeline    7 intelligence modules      FeatureVector models
```

## Plugins (15 active)

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
| acoustic | Sound classification |
| federation | Multi-site Tritium federation |
| wifi_fingerprint | WiFi device fingerprinting |

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

## Known Blockers

- **NimBLE esp_bt.h not found** -- blocks BLE serial + BLE OTA. WiFi/mesh/SD alternatives work.
- **BLE/WiFi coexistence** -- can't run BLE scanner alongside WiFi. Radio scheduler HAL ready for testing.
- **RGB parallel display glitches** -- 43C-BOX cosmetic issue when USB connected.
