# Tritium System Status

Current state of all components as of 2026-03-14 (Wave 96 — Maintenance).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | 49.6% RAM, 29.2% flash (within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 2,062 tests passing, 0 failures |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds, diagnostics |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict (radio scheduler HAL ready) |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |
| **Intelligence pipeline** | Active | 7 modules, all learners using BaseLearner ABC |
| **Plugin system** | Active | 19 plugins (18 directory + 1 built-in), auto-discovery with boot report |
| **Collaboration** | Active | Shared workspaces, map drawing, operator chat, WebSocket broadcast |
| **Forensics** | Active | Event reconstruction, incident reports, map replay |

## Wave 94-95 Features

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Analytics dashboard widgets (counter/chart/table/timeline) | tritium-sc | 9 tests | Complete |
| DashboardWidget, WidgetType, WidgetConfig models | tritium-lib | 9 tests | Complete |
| Drag-drop configurable analytics panel | tritium-sc frontend | Code review | Complete |
| Confidence decay (exponential per source type) | tritium-lib | 15 tests | Complete |
| ConfidenceModel wired into TargetTracker | tritium-sc | 876 tactical pass | Complete |
| WebSocket message sanitization | tritium-sc | Code review | Complete |
| Amy curiosity system (autonomous investigation) | tritium-sc | Code review | Complete |

## Wave 96 Features (Maintenance)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| STATUS.md update (Waves 94-96) | docs | -- | Complete |
| Unloaded nemotron-3-super:120b (94GB GPU) | infrastructure | -- | Complete |
| Agent files updated (quality, maintenance, refiner) | docs | -- | Complete |
| Iteration queue updated | docs | -- | Complete |
| gb10-02 synced: 2,086 lib tests passing | infrastructure | -- | Complete |
| Lib test baseline: 2,086 passing | tests | -- | Complete |
| SC tactical test baseline: 876 passing | tests | -- | Complete |

## Codebase Metrics (Wave 96 Baseline)

| Metric | Value |
|--------|-------|
| **Total waves completed** | 96 |
| **Total features shipped** | 240+ |
| **Active plugins** | 19 (18 directory + 1 built-in NPC Intelligence) |
| **API routes** | 690+ |
| **Frontend panel files** | 78 |
| **Lib model files** | 72 |
| **HAL libraries** | 52 |
| **Router files** | 86 |
| **Correlation strategies** | 5 (spatial, temporal, signal_pattern, dossier, learned) |
| **Intelligence modules** | 7 (all using BaseLearner ABC) |
| **Total test files** | 873 |

## Test Results (Wave 96 Baseline)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib pytest | 2,086 passed | All passing |
| tritium-lib on gb10-02 | 2,086 passed | All passing (26s) |
| tritium-sc tactical tests | 876 passed, 1 skipped | All passing (44s) |
| tritium-sc confidence+dashboard | 24 passed | All passing |
| tritium-edge build | 49.6% RAM, 29.2% Flash | 0 warnings, SUCCESS |

## Architecture

```
  tritium-edge (C++17)     tritium-sc (Python+JS)     tritium-lib (Python)
  ==================       =====================       ===================
  ESP32-S3 firmware        FastAPI :8000               99 model files
  6 board types            19 plugins                  360+ dataclasses
  64 HAL libraries         685+ routes                 102 test files
  MQTT, BLE, WiFi          AI Commander Amy            Graph DB, Auth
  LoRa, ESP-NOW            YOLO, WebSocket             Events, MQTT topics
  hal_ble_features         Canvas 2D/3D map            Geo, Notifications
  hal_tinyml, hal_voice    7 intelligence modules      Classifier, COT
  hal_scan_optimizer       77 frontend panels          BaseLearner ABC
  hal_diag_dump            Forensics + Collaboration   2,062 tests
  Fleet server :8080       Operator chat + drawing
                           Swarm coordination
                           Edge autonomy mgmt
```

## Plugins (19 active)

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
| acoustic | Sound classification, ML MFCC, TDoA localization |
| federation | Multi-site Tritium federation |
| wifi_fingerprint | WiFi device fingerprinting |
| behavioral_intelligence | Pattern detection, anomaly alerting |
| floorplan | Indoor floor plan + localization |
| swarm_coordination | Multi-robot formations and waypoints |
| edge_autonomy | Autonomous edge decision processing |

## Plugin Redundancy Audit (Wave 93)

14 of 19 plugins extend `PluginInterface` directly, duplicating ~30 lines of
event queue boilerplate each. Only 4 use `EventDrainPlugin`. All 16 plugins
with routes use the same `_register_routes` pattern:

```python
def _register_routes(self):
    from .routes import router
    self._app.include_router(router)
```

**Recommendation**: Create a `RoutedPlugin(EventDrainPlugin)` base that adds
`_register_routes()` as a default implementation. Would eliminate ~20 lines
per plugin for the 14 non-EventDrainPlugin plugins. Not urgent — current
pattern works, just verbose.

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

## Known Blockers

- **NimBLE esp_bt.h not found** -- blocks BLE serial + BLE OTA. WiFi/mesh/SD alternatives work.
- **BLE/WiFi coexistence** -- can't run BLE scanner alongside WiFi. Radio scheduler HAL ready for testing.
- **RGB parallel display glitches** -- 43C-BOX cosmetic issue when USB connected.
