# Tritium System Status

Current state of all components as of 2026-03-14 (post Wave 42 security audit).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | 47.9% RAM, 29.1% flash (within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 1404 tests passing, 0 failures |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict (radio scheduler HAL ready) |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |

## Test Results (Wave 42 Baseline)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib pytest | 1420 passed, 29 skipped | All passing |
| tritium-sc fast suite | 17,824 passed, 41 known failures | 95/96 tiers pass |
| tritium-sc test infra | 120 passed | All passing |
| tritium-sc ROS2 robot | 125 passed | All passing |
| tritium-edge build | 47.9% RAM, 29.1% Flash | 0 warnings |

**Known JS test failures (pre-existing):**
- `test_menu_bar.js` — 41 failures (panel button order off-by-one after panel additions)

## Codebase Metrics (Wave 42)

| Component | Language | Lines of Code |
|-----------|----------|---------------|
| tritium-sc Python | Python | 88,871 |
| tritium-sc JS | JavaScript | 63,993 |
| tritium-edge firmware | C++/H | 71,206 |
| tritium-edge fleet server | Python | 25,037 |
| tritium-lib | Python | 16,736 |
| **Total** | **All** | **265,843** |

| Metric | Value |
|--------|-------|
| Total test files | 818 (634 SC + 65 lib + 119 edge) |
| Total test assertions (SC fast) | 17,824 |
| Test-to-code ratio (SC Python) | 1 test file per 140 LOC |
| Test-to-code ratio (lib) | 1 test file per 257 LOC |

## Firmware (tritium-edge)

**Build target:** `pio run -e touch-lcd-43c-box-os`

**HAL count:** 42 hardware abstraction layers

**Launcher apps:** Settings, Monitor, Mesh, Storage, BLE, Terminal

**Status bar:** WiFi RSSI, BLE count, Mesh peers, Battery/USB, Clock (1s updates)

**Settings tabs:** Display, WiFi, Power, Screensaver, System, Clock, Developer

**Screensaver:** Starfield with 500 stars, parallax drift, clock overlay, NVS-persisted settings

**Notification shade:** Quick settings toggles, dismiss gestures

**Remote API:** Click simulation, screensaver control, settings access, diagnostic self-test

**Supported boards:** 6 Waveshare ESP32-S3 (3 hardware-verified, 1 pin-verified, 2 need verification)

### Known Blockers

- **NimBLE esp_bt.h not found** -- blocks BLE serial + BLE OTA. WiFi/mesh/SD alternatives work.
- **BLE/WiFi coexistence** -- can't run BLE scanner alongside WiFi. Radio scheduler HAL ready for testing.
- **RGB parallel display glitches** -- 43C-BOX cosmetic issue when USB connected.

## Command Center (tritium-sc)

**Server:** FastAPI on :8000

**Frontend:** Vanilla JS command center with tactical map, 48 floating panels, panel search

**AI Commander Amy:** 4-layer cognitive AI (reflex, instinct, awareness, deliberation)
- Instinct layer: automatic threat response rules
- Autonomous dispatch: threat response, asset selection, fusion narration
- Full Sense-Decide-Act pipeline

**Simulation:** 10Hz battle engine, 10-wave combat, 16 unit types

**Test suite:** 7 tiers (syntax, unit, JS, infrastructure, integration, visual quality, visual E2E)

### Plugins (14 active)
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
| acoustic | Sound classification (gunshot, voice, vehicle) |
| federation | Multi-site Tritium federation via MQTT |

### Frontend Panels (48 registered)
| Panel | Purpose |
|-------|---------|
| amy | Amy AI commander chat + status |
| amy-conversation | Full inner monologue timeline |
| alerts | Alert feed |
| assets | Asset placement (drag sensors onto map) |
| audio | Audio controls |
| automation | If-then rule CRUD |
| bookmarks | Map position bookmarks |
| camera-feeds | Live camera feed grid (MJPEG) |
| cameras | Synthetic camera PIP |
| device-manager | Remote OTA, reboot, config |
| dossiers | Persistent entity intelligence browser |
| edge-tracker | Edge device sighting monitor |
| escalation | Threat escalation display |
| events | Events timeline |
| export-scheduler | Data export scheduling |
| fleet | Fleet node monitoring |
| fleet-dashboard | Aggregated fleet dashboard |
| game-hud | Battle game HUD |
| geofence | Polygon zone management |
| graph-explorer | Force-directed entity graph |
| graphlings | NPC behavior observer |
| heatmap | Target density heatmap |
| layers | Map layer browser (43 layers) |
| mesh | Meshtastic LoRa client |
| minimap | Tactical overview minimap |
| missions | Mission coordination |
| multi-camera | Multi-camera grid view |
| notification_prefs | Notification preferences |
| notifications | Notification feed |
| patrol | Patrol route management |
| quick-start | Getting started guide |
| replay | Event replay |
| rf-motion | RF-based motion events |
| scenarios | Scenario runner |
| search | Intel search |
| sensors | Sensor network view |
| stats | Battle statistics |
| system | Infrastructure panel |
| system-health | System health overview |
| tak | TAK server management |
| target-compare | Side-by-side target comparison |
| target-merge | Target merge workflow |
| target-search | Target search/filter |
| testing | Testing dashboard |
| timeline | Target timeline |
| unit-inspector | Unit detail inspector |
| units | Unit list |
| videos | Video playback |
| zones | Zone management |

### Intelligence Capabilities (28)
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
| RF motion detection (RSSI variance) | Active |
| Acoustic classification | Active |
| JWT authentication | Active |
| Rate limiting | Active |
| Database migrations | Active |
| Backup/restore | Active |
| Behavior pattern analysis | Active |
| Terrain/RF propagation modeling | Active |
| Target export (CSV/JSON/GeoJSON) | Active |
| BLE/WiFi coverage visualization | Active |
| Target clustering for map readability | Active |
| Event-driven alert rules | Active |
| Target pinning (persistent, prune-protected) | Active |
| WebSocket auto-reconnect with exponential backoff | Active |
| Investigation map overlay (entities on tactical map) | Active |
| Panel search with keyboard shortcut (Ctrl+/) | Active |

## Shared Library (tritium-lib)

**Models:** 250 exports from 42 model files covering device, firmware, mesh, BLE, CoT, alerts, topology, diagnostics, transport, sensor, acoustic, seed, provision, correlation, timeseries, trilateration, dossier, ontology, federation, drone/UAV, radio scheduler, camera MQTT, behavior, terrain, event schemas, export/import, alert rules, notification rules, system summary, mission management, intelligence reports, sensor configuration, LPR, AIS/ADS-B

**Graph:** KuzuDB embedded graph store with formal ontology schema

**Stores:** SQLite-backed DossierStore, BleStore, TargetStore, ReIDStore, AuditStore, ConfigStore (all using BaseStore)

**MQTT:** Standardized topic hierarchy `tritium/{site}/{domain}/{device}/{type}`

**Geo:** Coordinate transforms, camera projection, haversine distance (shared with SC)

**Classifier:** Multi-signal BLE/WiFi device classifier with 11 fingerprint databases

**Packages:** models, mqtt, events, auth, config, store, cot, web, testing, graph, ontology, geo, notifications, classifier

## Feature Roadmap Status

| # | Feature | Status |
|---|---------|--------|
| 1-14 | Core OS features | Done |
| 15 | Meshtastic BLE bridge | Blocked (WiFi/BLE coex) |
| 16-31 | Full tactical intelligence platform | Done |
| 32 | WiFi probe request tracking | Done (Wave 31) |
| 33 | Multi-node trilateration | Done (Wave 13) |
| 34 | Geofencing alerts | Done (Wave 6) |
| 35 | Target history/trails | Done (Wave 6) |
| 36 | Acoustic classification | Done (Wave 18) |
| 37 | RF environment mapping | Partial (RF motion done) |
| 38 | TAK/CoT bridge | Done (Wave 8) |
| 39 | Video recording/playback | Done (Wave 18) |
| 40 | Multi-site federation | Done (Wave 14+) |

## Panel Redundancy Analysis (Wave 39)

49 panel JS files, 48 registered. Potentially overlapping panels identified:

| Panel Pair | Verdict | Reason |
|------------|---------|--------|
| cameras.js / camera-feeds.js | Distinct | cameras = synthetic PIP overlay; camera-feeds = live MJPEG grid from camera_feeds plugin |
| fleet.js / fleet-dashboard.js | Distinct | fleet = deep node monitoring with per-device detail; fleet-dashboard = aggregated overview |
| search.js / target-search.js | Distinct | search = full intel search (text, events); target-search = target-specific filter panel |
| system.js / system-health.js | Distinct | system = infrastructure config/actions; system-health = at-a-glance status dashboard |
| notification_prefs.js | Not registered | File exists but is not registered in main.js |

**Shared patterns that could benefit from a base component:**
- `_esc()` helper duplicated in 30+ panels -- could be extracted to a shared utility
- `_timeAgo()` helper duplicated in 8+ panels -- candidate for shared utility
- List+detail pattern (fleet, dossiers, units, targets) -- could share a filterable list component
- CRUD pattern (automation, geofence, missions, zones) -- could share form builder

**Recommendation:** Extract `_esc()` and `_timeAgo()` to a shared `panel-utils.js` module. The list+detail and CRUD patterns are similar but each has domain-specific rendering, so forced abstraction would add complexity without clear benefit at this scale.

## Rule System Analysis

Three rule types exist in the codebase with deliberate separation of concerns:

| Rule Type | Location | Purpose | Common Fields |
|-----------|----------|---------|---------------|
| **AutomationRule** | tritium-sc/plugins/automation/ | Execute actions (commands, tags, escalations) in response to events | rule_id, name, trigger, conditions, enabled, cooldown |
| **AlertRule** | tritium-lib/models/alert_rules.py | Generate alerts/notifications from system events with severity routing | rule_id, name, trigger, conditions, enabled, cooldown, channels |
| **NotificationRule** | tritium-lib/models/notification_rules.py | Route notifications to channels (WS, MQTT, email) with severity filtering | rule_id, name, trigger, enabled, cooldown, channels |

## API Documentation

GET /api/docs -- auto-generated JSON catalog of all API endpoints from FastAPI OpenAPI schema.
- `/api/docs` -- full catalog with parameters and request body schemas
- `/api/docs/summary` -- compact method + path + summary
- `/api/docs/tags` -- endpoints grouped by tag

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

## Security (Wave 42 Audit)

| Area | Status | Details |
|------|--------|---------|
| Annotation XSS | Hardened | HTML tags stripped, entities escaped, text length limits |
| Watchlist XSS | Hardened | HTML tags stripped, tag count limits, notes length limits |
| Annotation type validation | Hardened | Enum validation (6 valid types only) |
| Lat/lng range validation | Hardened | -90..90 lat, -180..180 lng |
| Collection DoS | Hardened | Max 10,000 annotations, 5,000 watch entries |
| WebSocket auth | Hardened | Optional token via WS_AUTH_TOKEN env var, 4003 reject |
| WebSocket heartbeat | Hardened | Server ping every 30s, stale connections closed after 90s |
| SQL injection | N/A | In-memory stores (no SQL), user text HTML-escaped |

## Development Velocity

42 waves completed across autonomous sessions:
- **265,843 lines of code** across 3 repos (Python + JS + C++)
- **818 test files** with 17,824+ assertions
- **1,420 tests** in tritium-lib (0 failures)
- **48 floating panels** in the command center frontend
- **42 HALs** in tritium-edge firmware
- **14 plugins** active in tritium-sc
- **28 intelligence capabilities** operational
- **250 model exports** in tritium-lib
- **3 submodules** coordinated with shared models and MQTT topics
