# Tritium System Status

Current state of all components as of 2026-03-13 (post Wave 10).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | 44.7% RAM, 28.5% flash (well within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 955 tests passing, 975 collected (20 skipped) |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |

## Test Results (Wave 10 Final)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib pytest | 955 passed, 20 skipped | All passing |
| tritium-sc fast (tiers 1-3+8) | 81 tiers | All passing |
| tritium-edge build | 44.7% RAM, 28.5% Flash | 0 warnings |

## Firmware (tritium-edge)

**Build target:** `pio run -e touch-lcd-43c-box-os`

**Launcher apps:** Settings, Monitor, Mesh, Storage, BLE, Terminal

**Status bar:** WiFi RSSI, BLE count, Mesh peers, Battery/USB, Clock (1s updates)

**Settings tabs:** Display, WiFi, Power, Screensaver, System, Clock, Developer

**Screensaver:** Starfield with 500 stars, parallax drift, clock overlay, NVS-persisted settings

**Notification shade:** Quick settings toggles, dismiss gestures

**Remote API:** Click simulation, screensaver control, settings access

**Supported boards:** 6 Waveshare ESP32-S3 (3 hardware-verified, 1 pin-verified, 2 need verification)

### Known Blockers

- **NimBLE esp_bt.h not found** — blocks BLE serial + BLE OTA. WiFi/mesh/SD alternatives work.
- **BLE/WiFi coexistence** — can't run BLE scanner alongside WiFi. BLE scanner uses stubs.
- **RGB parallel display glitches** — 43C-BOX cosmetic issue when USB connected.

## Command Center (tritium-sc)

**Server:** FastAPI on :8000

**Frontend:** Vanilla JS command center with tactical map, 26+ floating panels

**AI Commander Amy:** 4-layer cognitive AI (reflex, instinct, awareness, deliberation)
- Instinct layer: automatic threat response rules
- Autonomous dispatch: threat response, asset selection, fusion narration
- Full Sense-Decide-Act pipeline

**Simulation:** 10Hz battle engine, 10-wave combat, 16 unit types

**Test suite:** 7 tiers (syntax, unit, JS, infrastructure, integration, visual quality, visual E2E)

### Plugins (10 active)
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

### Intelligence Capabilities
| Capability | Status |
|------------|--------|
| Multi-sensor target correlation | Active |
| BLE threat classification | Active |
| Target enrichment pipeline (OUI, WiFi, BLE) | Active |
| Geofencing with enter/exit alerts | Active |
| Target position history and trails | Active |
| Target search and filtering | Active |
| Dossier management (persistent entity intelligence) | Active |
| Graph ontology (KuzuDB, 10 entity types) | Active |
| Investigation workflows | Active |
| Patrol pattern system | Active |
| Target timeline | Active |
| Demo mode with multi-sensor fusion scenarios | Active |

## Shared Library (tritium-lib)

**Models:** 116+ Pydantic models covering device, firmware, mesh, BLE, CoT, alerts, topology, diagnostics, transport, sensor, acoustic, seed, provision, correlation, timeseries, trilateration, dossier, ontology

**Graph:** KuzuDB embedded graph store with formal ontology schema

**Stores:** SQLite-backed DossierStore, target store

**MQTT:** Standardized topic hierarchy `tritium/{site}/{domain}/{device}/{type}`

**Packages:** models, mqtt, events, auth, config, store, cot, web, testing, graph, ontology

## Feature Roadmap Status

| # | Feature | Status |
|---|---------|--------|
| 1-14 | Core OS features | Done |
| 15 | Meshtastic BLE bridge | Blocked (WiFi/BLE coex) |
| 16 | Camera MQTT pipeline | Done (SC side) |
| 17 | Voice control | Planned |
| 18 | Sensor dashboard app | Planned |
| 19 | Tritium Package Manager | Planned |
| 20 | Automation engine | Done |

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

## Development Velocity

10 waves completed in a single autonomous session:
- **122+ new tests** added to tritium-lib (833 to 955)
- **10 plugins** active in tritium-sc
- **12 intelligence capabilities** operational
- **3 submodules** coordinated with shared models and MQTT topics
