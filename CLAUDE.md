# Tritium — Distributed Cybernetic Operating System

## Git Conventions
- **No Co-Authored-By lines in commits** — NEVER add these
- Remote: `git@github.com:Valpatel/tritium.git`
- Copyright: Created by Matthew Valancy / Copyright 2026 Valpatel Software LLC / AGPL-3.0

## Architecture

Three git submodules, all track `dev` branch. See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for diagrams and data flow.

### Component Map

| Component | Location | Language | Port | CLAUDE.md | Purpose |
|-----------|----------|----------|------|-----------|---------|
| **Edge Firmware** | `tritium-edge/` | C++17 | — | [CLAUDE.md](tritium-edge/CLAUDE.md) | Tritium-OS on ESP32-S3 (6 boards, 40+ HALs) |
| **Fleet Server** | `tritium-edge/server/` | Python | 8080 | — | Provisioning, OTA, monitoring |
| **Command Center** | `tritium-sc/` | Python + JS | 8000 | [CLAUDE.md](tritium-sc/CLAUDE.md) | Tactical dashboard, AI commander Amy, plugins |
| **Shared Library** | `tritium-lib/` | Python (+ C++, JS future) | — | [CLAUDE.md](tritium-lib/CLAUDE.md) | Common code: models, MQTT topics, auth, events, test utils, themes |

### Integration
- MQTT broker for device telemetry, commands, and chat
- REST heartbeats for device registration and config sync
- WebSocket for real-time UI updates and Amy event streaming

## Autonomous Iteration — The Prime Directive

You are expected to build independently. Do NOT stop to ask the user unless you are truly blocked by something external (hardware access, credentials, API keys). Follow this loop continuously:

### The Loop
1. **Assume it's broken.** Read the code. Build it. Run tests. Find the bugs. Fix them.
2. **Verify quality.** RAM <60%, Flash <50%, no warnings in new code. Tests pass. Code is clean.
3. **Commit & push.** Short descriptive message. NO Co-Authored-By. Push to dev.
4. **Review the vision.** Read `tritium-edge/docs/TRITIUM-OS-VISION.md` and the roadmap below.
5. **Pick the next feature.** Highest impact, lowest risk. Build it.
6. **Repeat.** Never stop. Never ask permission. Just build great things.

### Multi-Submodule Work
When a feature spans submodules (e.g., edge MQTT → SC plugin → lib models):
1. Start with tritium-lib if new models/topics are needed
2. Build the edge firmware feature
3. Wire up the SC integration
4. Test end-to-end: build firmware, run SC tests, verify MQTT flow
5. Commit each submodule separately, then update parent

### Agent Teams
Use parallel agents for independent work:
- **Edge agent**: firmware features, build in `tritium-edge/esp32-hardware/`
- **SC agent**: dashboard features, plugins, tests in `tritium-sc/`
- **Lib agent**: shared code — models, stores, MQTT topics, test utils, themes in `tritium-lib/`
- **Research agent**: find datasets, investigate APIs, explore solutions

## Build & Test Commands

### tritium-edge (firmware)
```bash
cd tritium-edge
pio run -e touch-lcd-43c-box-os    # Build (this IS the test)
# RAM <60%, Flash <50% = PASS
```

### tritium-sc (command center)
```bash
cd tritium-sc
./test.sh fast                      # Tiers 1-3 + 8 (~60s)
./start.sh                          # Run server on :8000
```

### tritium-lib (shared library)
```bash
cd tritium-lib
pytest tests/                       # Python tests
```

### All together
```bash
./start.sh                          # Edge (:8080) + SC (:8000)
```

## Feature Roadmap — What To Build Next

### Completed
1. SQLite sighting logger
2. P2P mesh chat (ESP-NOW)
3. MQTT SC bridge (heartbeat, sighting, chat, commands)
4. Terminal app (on-device + web)
5. OUI/MAC manufacturer lookup (IEEE CSV → SQLite on SD, LRU cache)
6. BLE device type classifier (15 types, name+OUI+heuristics)
7. Mesh chat → MQTT bridge
8. Sighting/BLE stats in MQTT heartbeat
9. GIS/map tile viewer (MBTiles on SD, LVGL canvas, pan/zoom)
10. Power management (auto-profiles, dim/off/sleep, battery status)
11. Lock screen (PIN entry, lockout protection)
12. WebSocket support (ws_bridge.cpp)
13. Web settings page (/settings)
14. Event-driven toasts (WiFi, mesh, power events)

### Next Up (priority order)
15. **Meshtastic BLE bridge** — connect to Meshtastic radios via BLE, bridge their mesh to Tritium mesh and MQTT. This extends range massively via LoRa.
16. **Camera → MQTT pipeline** — JPEG frames from ESP32 camera to SC for YOLO object detection. Wire into Amy's perception system.
17. **Voice control** — wake word detection + audio streaming via MQTT to SC's whisper.cpp pipeline.
18. **Sensor dashboard app** — IMU/audio/temperature live plots on LVGL
19. **Tritium Package Manager (TPM)** — dynamic app loading from SD card
20. **Automation engine** — if-then rules for autonomous device behavior

### SD Card Datasets (expand intelligence)
- **IEEE OUI database** ✅ DONE — 39K manufacturer entries in SQLite
- **California map tiles** ✅ DONE — MBTiles for offline GIS
- **BLE device fingerprints** ✅ DONE — 15 device types classified
- **WiFi SSID patterns** — known network types (corporate, IoT, mobile hotspot)
- **RF frequency databases** — for LoRa/Meshtastic channel identification
- **Geolocation databases** — WiFi BSSID → approximate location

### SC Integration Points
- Edge publishes to `tritium/{device_id}/status|heartbeat|sighting|chat`
- SC subscribes and displays in fleet tracker plugin
- SC sends commands via `tritium/{device_id}/cmd`
- Camera frames → `tritium/{device_id}/camera` → YOLO pipeline
- Amy can dispatch commands to edge devices autonomously

## Known Blockers
- **NimBLE esp_bt.h not found** — BLE scanner runs stubs, WiFi/mesh alternatives work fine. This blocks Meshtastic BLE bridge. Investigate ESP-IDF 5.5.2 NimBLE component configuration.

## Style & Conventions
- No frontend frameworks — vanilla JavaScript only
- Cyberpunk aesthetic: cyan #00f0ff, magenta #ff2a6d, green #05ffa1, yellow #fcee0a
- Background: void #0a0a0f, surfaces #0e0e14/#12121a/#1a1a2e
- C++17 for firmware, Python 3.12+ for servers, vanilla JS for frontend
- 4-space indentation everywhere
