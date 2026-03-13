# Tritium System Status

Current state of all components as of 2026-03-13.

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | 44.7% RAM, 28.5% flash (well within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, 1666 Python tests + 281 JS tests passing |
| **tritium-lib** | Stable | 116+ models, 35 test files, all passing |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict |

## Firmware (tritium-edge)

**Build target:** `pio run -e touch-lcd-43c-box-os`

**Apps available:** 10 (starfield, system, camera, ui_demo, wifi_setup, diag, effects, ota, test, template)

**Launcher apps:** Settings, Monitor, Mesh, Storage, BLE, Terminal

**Status bar:** WiFi RSSI, BLE count, Mesh peers, Battery/USB, Clock (1s updates)

**Settings tabs:** Display, WiFi, Power, Screensaver, System, Clock

**Screensaver:** Starfield with 500 stars, parallax drift, clock overlay, NVS-persisted settings

**Supported boards:** 6 Waveshare ESP32-S3 (3 hardware-verified, 1 pin-verified, 2 need verification)

### Known Blockers

- **NimBLE esp_bt.h not found** — blocks BLE serial + BLE OTA. WiFi/mesh/SD alternatives work. Blocks Meshtastic BLE bridge.
- **BLE/WiFi coexistence** — can't run BLE scanner alongside WiFi. BLE scanner uses stubs.
- **RGB parallel display glitches** — 43C-BOX cosmetic issue when USB connected (memory bus contention).

## Command Center (tritium-sc)

**Server:** FastAPI on :8000

**Frontend:** Vanilla JS command center with tactical map, 26 floating panels

**AI Commander Amy:** 4-layer cognitive AI (reflex → instinct → awareness → deliberation)

**Simulation:** 10Hz battle engine, 10-wave combat, 16 unit types

**Test suite:** 7 tiers (syntax, unit, JS, infrastructure, integration, visual quality, visual E2E)

**Plugins:** edge_tracker, graphlings, npc_thoughts

**Examples:** 8 reference implementations (robot, drone, camera, hostile agent, mesh radio, etc.)

## Shared Library (tritium-lib)

**Models:** 116+ Pydantic models covering device, firmware, mesh, BLE, CoT, alerts, topology, diagnostics, transport, sensor, acoustic, seed, provision, correlation, timeseries, trilateration

**MQTT:** Standardized topic hierarchy `tritium/{site}/{domain}/{device}/{type}`

**Packages:** models, mqtt, events, auth, config, store, cot, web, testing

## Feature Roadmap Status

| # | Feature | Status |
|---|---------|--------|
| 1-14 | Core OS features | Done |
| 15 | Meshtastic BLE bridge | Blocked (WiFi/BLE coex) |
| 16 | Camera → MQTT pipeline | Next |
| 17 | Voice control | Planned |
| 18 | Sensor dashboard app | Planned |
| 19 | Tritium Package Manager | Planned |
| 20 | Automation engine | Planned |

## Integration Points

| Flow | Status |
|------|--------|
| Edge → MQTT heartbeat → SC fleet tracker | Working |
| Edge → MQTT sighting → SC display | Working |
| Edge → MQTT chat → SC dashboard | Working |
| SC → MQTT cmd → Edge execute | Working |
| Camera → MQTT → YOLO pipeline | Planned |
| Amy → MQTT → Edge autonomous commands | Planned |
