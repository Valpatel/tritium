# Tritium System Status

Current state of all components as of 2026-03-14 (Wave 93 — Maintenance).

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

## Wave 91-92 Features

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Swarm coordination plugin | tritium-sc | Tests passing | Complete |
| Edge autonomy plugin | tritium-sc | Tests passing | Complete |
| Mission target binder | tritium-sc | Tests passing | Complete |
| Cross-camera ReID (YOLO) | tritium-sc | Code review | Complete |
| Per-user rate limits | tritium-sc | Tests passing | Complete |
| API key scoping | tritium-sc | Tests passing | Complete |
| Plugin auth middleware | tritium-sc | Tests passing | Complete |
| Swarm/autonomy models | tritium-lib | Tests passing | Complete |
| Swarm coordination panel | tritium-sc frontend | Code review | Complete |

## Wave 93 Features (Maintenance)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| STATUS.md update (Waves 88-93) | docs | -- | Complete |
| Annotations test upgrade (TestClient) | tritium-sc | 22 tests | Complete |
| Plugin redundancy audit | tritium-sc | -- | Complete |
| Lib test baseline: 2,062 passing | tests | -- | Complete |
| gb10-02 sync verified | infrastructure | -- | Complete |
| Agent files updated | docs | -- | In Progress |
| Changelogs updated | docs | -- | In Progress |

## Codebase Metrics (Wave 93 Baseline)

| Metric | Value |
|--------|-------|
| **Total waves completed** | 93 |
| **Total features shipped** | 230+ |
| **Active plugins** | 19 (18 directory + 1 built-in NPC Intelligence) |
| **API routes** | 685+ |
| **Frontend panel files** | 77 |
| **Lib model files** | 99 |
| **Lib test files** | 102 |
| **HAL libraries** | 64 |
| **SC Python test files** | 624 |
| **SC JS test files** | 99 |
| **Correlation strategies** | 5 (spatial, temporal, signal_pattern, dossier, learned) |
| **Intelligence modules** | 7 (all using BaseLearner ABC) |
| **Total test files** | 825+ (624 SC Python + 99 SC JS + 102 lib) |

## Test Results (Wave 93 Baseline)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib pytest | 2,062 passed | All passing (11.6s) |
| tritium-lib on gb10-02 | 2,062 passed | All passing (20.5s) |
| tritium-sc test.sh fast | 97 tiers passed, 0 failures | All passing (397s) |
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
