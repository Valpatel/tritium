# Tritium System Status

Current state of all components as of 2026-03-14 (Wave 70 — MILESTONE).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | 49.6% RAM, 29.2% flash (within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 1,762+ tests passing, 0 failures |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict (radio scheduler HAL ready) |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |

## Wave 70 Milestone Summary

| Milestone Metric | Value |
|------------------|-------|
| **Total waves completed** | 70 |
| **Total features shipped** | 155+ |
| **Total lines of code** | ~501,000 across 3 repos |
| **Python source (SC + lib)** | 119,657 lines |
| **C/C++ source (edge)** | 107,009 lines |
| **JavaScript** | 68,830 lines |
| **CSS** | 13,514 lines |
| **Active plugins** | 15 |
| **Frontend JS files** | 129 |
| **API routers** | 76 router files |
| **API routes** | 490+ |
| **Lib model files** | 55 |
| **Lib dataclasses** | 320+ |
| **Edge header files** | 190 |
| **Edge source files** | 100 |
| **Correlation strategies** | 5 (spatial, temporal, signal_pattern, dossier, learned) |
| **Total test files** | 749 (665 SC + 84 lib) |

## Test Results (Wave 70 Baseline)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib pytest | 1,762+ passed | All passing |
| tritium-sc Python (unit) | 8,637+ passed | All passing |
| tritium-sc test tiers | 97+ tiers | All passing |
| tritium-sc JS | 93+ test suites | All passing |
| tritium-sc test files | 665 (567+ py + 98 js) | -- |
| tritium-lib test files | 84 | -- |
| tritium-edge build | 49.6% RAM, 29.2% Flash | 0 warnings |
| **Total test files** | **749** across all repos | -- |

## Wave 70 New Features

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Movement analytics API (`/api/analytics/movement/{target_id}`) | tritium-sc | 15 | Complete |
| Amy daily briefing (`POST /api/amy/briefing`) | tritium-sc | 8 | Complete |
| MovementAnalytics + FleetMetrics models | tritium-lib | 14 | Complete |
| API latency benchmarks (20 endpoints) | tritium-sc | 21 | Complete |
| Wave 70 milestone report | docs | -- | Complete |

## Codebase Metrics (Wave 70 Baseline)

| Metric | Value |
|--------|-------|
| **Total waves completed** | 70 |
| **Total features shipped** | 155+ |
| **Total lines of code** | ~501,000 across 3 repos |
| **SC Python tests** | 8,637+ unit tests passing |
| **Lib tests** | 1,762+ |
| **JS test suites** | 93+ |
| **Frontend JS files** | 129 |
| **Frontend panels** | 67 registered (7 categories) |
| **Active plugins** | 15 |
| **Edge HAL directories** | 48 |
| **Edge header files** | 190 |
| **Edge source files** | 100 |
| **Edge boards** | 6 Waveshare ESP32-S3 (3 HW-verified) |
| **Intelligence capabilities** | 40+ operational |
| **Lib model exports** | 324+ classes from 55 model files |
| **Correlation strategies** | 5 (spatial, temporal, signal_pattern, dossier, learned) |
| **Agent definition files** | 11 |

## LOC Breakdown

| Component | Language | Lines of Code |
|-----------|----------|---------------|
| tritium-sc Python (src+tests+scripts+examples) | Python | ~97,800 + tests |
| tritium-sc JS (frontend) | JavaScript | ~68,830 |
| tritium-sc CSS | CSS | ~13,514 |
| tritium-sc HTML | HTML | ~1,574 |
| tritium-edge firmware (src) | C++/H | ~107,009 |
| tritium-lib (src+tests) | Python | ~21,900 + tests |
| **Total** | **All** | **~501,000** |

## Architecture

```
  tritium-edge (C++17)     tritium-sc (Python+JS)     tritium-lib (Python)
  ==================       =====================       ===================
  ESP32-S3 firmware        FastAPI :8000               55 model files
  6 board types            15 plugins                  324+ dataclasses
  48 HAL dirs              76 routers                  84 test files
  190 headers              490+ routes                 Graph DB, Auth
  MQTT, BLE, WiFi          AI Commander Amy            Events, MQTT topics
  LoRa, ESP-NOW            YOLO, WebSocket             Geo, Notifications
  Fleet server :8080       Canvas 2D/3D map            Classifier, COT
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

## Known Blockers

- **NimBLE esp_bt.h not found** -- blocks BLE serial + BLE OTA. WiFi/mesh/SD alternatives work.
- **BLE/WiFi coexistence** -- can't run BLE scanner alongside WiFi. Radio scheduler HAL ready for testing.
- **RGB parallel display glitches** -- 43C-BOX cosmetic issue when USB connected.
