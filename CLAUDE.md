# Tritium — Unified Operating Picture for Robotics & Security

## Mission

**Track, identify, and engage every target** — cars, phones, watches, computers, people, animals — using all available technologies. Every detected entity gets a unique target ID. Fuse BLE, WiFi, camera vision, LoRa mesh, acoustic, RF, and any future sensor into a single unified operating picture on a real-world tactical map.

This is an ATAK-like distributed cybernetic operating system. The battle simulation exercises the same pipelines used for real-world operation. The system must work without hardware (demo mode with synthetic data), with one sensor (43C board doing WiFi/BLE), or with hundreds of deployed nodes.

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

### Plugin System (the growth engine)
Plugins are how every capability gets added. Each plugin owns its own backend services, API routes, UI panels, and pub/sub topics. Current plugins:
- **edge_tracker** — BLE/WiFi presence → TargetTracker → map, with BLE classifier
- **meshtastic** — LoRa mesh radio bridge, GPS-equipped nodes on map
- **camera_feeds** — multi-source camera management (synthetic/RTSP/MJPEG/MQTT/USB)
- **fleet_dashboard** — device registry, battery, uptime, sighting counts
- **yolo_detector** — YOLO object detection pipeline
- **tak_bridge** — ATAK/CoT interoperability (multicast UDP, TCP, MQTT)
- **gis_layers** — OSM/satellite/terrain/building map layers
- **automation** — if-then rule engine with 9 condition operators, 6 action types
- **threat_feeds** — STIX/TAXII-style known-bad indicator matching
- **graphlings** — NPC AI agents
- **npc_thoughts** — NPC context-aware thought bubbles

### Integration
- MQTT broker for device telemetry, commands, and chat
- REST heartbeats for device registration and config sync
- WebSocket for real-time UI updates and Amy event streaming
- ROS2 bridges for robot integration
- CoT/TAK for ATAK interoperability

## Autonomous Iteration — The Prime Directive

You are expected to build independently. Do NOT stop to ask the user unless you are truly blocked by something external (hardware access, credentials, API keys). Follow this loop continuously:

### The Loop
1. **Assume it's broken.** Tests passing does NOT mean it works. Code compiling does NOT mean it's correct. Features existing does NOT mean they integrate. Assume massive gaps in testing, architectural flaws, and untested edge cases.
2. **Push the vision.** Read this file. Every target needs a unique UUID. Every sensor feeds the unified picture. Ask: what's the biggest gap between where we are and the vision?
3. **Build features AND quality.** Every wave must include vision advancement (new capabilities) AND quality improvement (find what's actually broken, add missing tests, run visual validation).
4. **Verify.** RAM <60%, Flash <50%, no warnings. Run tests. But also: start the server, hit the API, verify the frontend renders, check that demo mode actually shows fusion.
5. **Commit & push.** Short descriptive message. NO Co-Authored-By. Push to dev.
6. **Update changelogs.** Every change logged in `docs/CHANGELOG.md` with verification level.
7. **Launch 6+ parallel agents.** Every wave: 2-3 feature agents, 1 quality/testing agent, 1 infrastructure agent, 1 test-runner that auto-launches the next wave.
8. **NEVER STOP.** When a wave finishes, immediately launch the next wave. Do not wait for approval. Do not report and pause. The loop is infinite. If all planned waves are done, read the vision and identify new work.

### Periodic Maintenance (Every 3rd Wave)
Every 3rd wave, reserve 2 agents for maintenance — one for docs, one for cleanup:

**Documentation fractal pass (1 agent):**
- Traverse ALL directories in ALL submodules
- Every package/directory must have a README.md with: "where you are", what it does, key files, related links
- Update CLAUDE.md plugin list and feature roadmap
- Update docs/STATUS.md with current component health
- Update docs/CHANGELOG.md with recent wave entries and verification levels
- Update memory/project_iteration_queue.md with completed waves
- Documentation rot is as bad as code rot — treat it with equal priority

**Redundancy cleanup (1 agent):**
- Grep for duplicate functions across SC, edge, and lib — consolidate into lib
- Find SC code that should be in lib (models, stores, utilities)
- Remove dead code (functions with no callers, unused imports, orphaned tests)
- Consolidate similar patterns across plugins (shared base classes, common routers)
- Verify SC actually uses lib versions of extracted code (geo, notifications, models)
- Consider BaseStore class for the 5+ SQLite stores that share the same pattern

### Security & Performance Audit (Every 5th Wave)
Every 5th wave, dedicate 2 agents to adversarial review:

**Security audit (1 agent):**
- OWASP Top 10 review: injection, XSS, broken auth, sensitive data exposure, CSRF
- API endpoint audit: which endpoints lack auth? Which accept unsanitized input?
- MQTT security: can an unauthorized device publish to command topics?
- SQLite injection: are all queries parameterized?
- File path traversal: can API params escape intended directories?
- Secrets in code: grep for hardcoded passwords, API keys, tokens
- Dependency audit: check for known CVEs in pip dependencies

**Performance & skepticism audit (1 agent):**
- Memory profiling: how much RAM does the SC server use under load?
- Query performance: are there N+1 queries? Unindexed lookups?
- WebSocket scalability: what happens with 100 connected browsers?
- Plugin startup time: do any plugins block app boot?
- TargetTracker lock contention: is the threading lock a bottleneck at scale?
- Assume NOTHING works: try to start the server, hit every API endpoint, verify real responses
- Try demo mode end-to-end: does it actually show fusion on a map?
- Try every frontend panel: do they load? Do they show data? Or are they just empty shells?

### How to Continue Autonomously
- Read `memory/project_iteration_queue.md` for the wave roadmap
- Find the first incomplete wave
- Launch 6 agents per wave with BROAD scope across ALL submodules:
  - **1 tritium-edge agent** — firmware HALs, sensor drivers, OTA, device management
  - **1-2 tritium-sc backend agents** — plugins, APIs, intelligence, integration
  - **1 tritium-sc frontend agent** — panels, map rendering, 3D visualization, UX
  - **1 tritium-lib agent** — extract shared code from SC/edge, add models, stores
  - **1 test-runner** (delayed 15min) — validates, updates changelogs, MUST auto-launch next wave
- **RESOURCE SAFETY**: Feature agents run TARGETED tests only (their specific test files, not full suite). Only the test-runner runs `./test.sh fast`. Never run multiple full test suites concurrently — this will OOM the system. Check `free -m` before heavy operations.
- **BROAD SCOPE**: Don't only build new features. Also:
  - Complete the stack for existing features (backend-only → add frontend + edge)
  - Audit previous waves: can a user SEE this in the browser? Does data flow edge→SC→browser?
  - Refactor: pull reusable code from SC into lib, improve architecture
  - Fix: find what's actually broken when you run the server and open the browser
- **FULL STACK**: Every feature needs ALL layers to be usable:
  1. Edge firmware HAL (produces data)
  2. MQTT transport (moves data)
  3. SC backend plugin (processes data)
  4. SC frontend panel (human sees data)
  5. Lib models (shared contracts)
  If any layer is missing, the feature is NOT done.
- Never ask "should I continue?" — just continue
- Never assume the code works — run it, look at it, test every layer

### The Target Model
Every detected entity becomes a TrackedTarget with:
- **Unique target ID** — `ble_{mac}`, `det_{class}_{n}`, `mesh_{node}`, `wifi_{bssid}`
- **Source** — which sensor detected it (ble, yolo, mesh, wifi, acoustic, manual)
- **Position** — lat/lng or local x/y, with confidence and source (GPS, trilateration, proximity, YOLO)
- **Classification** — person, vehicle, phone, watch, computer, animal, mesh_radio, ble_device, unknown
- **Alliance** — friendly, hostile, unknown (based on known device lists, behavior, threat classification)
- **Correlation** — fused with detections from other sensors (camera sees person + BLE sees their phone = same target)

### Sensor Fusion Priority
1. **BLE scanning** — passive, identifies phones/watches/IoT by MAC, OUI manufacturer, device class
2. **WiFi scanning** — SSIDs, BSSIDs, probe requests, network classification
3. **Camera/YOLO** — visual detection of people, vehicles, animals with bounding boxes
4. **Meshtastic/LoRa** — long-range mesh nodes with GPS, extends coverage to km scale
5. **ESP-NOW mesh** — peer-to-peer device mesh for local coordination
6. **Acoustic** — audio analysis, VAD, sound classification
7. **RF fingerprinting** — future: passive RF environment mapping

### Multi-Submodule Work
When a feature spans submodules (e.g., edge MQTT → SC plugin → lib models):
1. Start with tritium-lib if new models/topics are needed
2. Build the edge firmware feature
3. Wire up the SC integration
4. Test end-to-end: build firmware, run SC tests, verify MQTT flow
5. Commit each submodule separately, then update parent

### Agent Teams
Use parallel agents for independent work — always launch 6+ agents:
- **Edge agent**: firmware features, HALs, sensor drivers in `tritium-edge/`
- **SC plugin agents**: one per plugin being built/improved in `tritium-sc/`
- **SC frontend agent**: map rendering, panels, UI in `tritium-sc/src/frontend/`
- **Lib agent**: shared models, MQTT topics, stores in `tritium-lib/`
- **Test agent**: run tests, fix failures, expand coverage
- **Research agent**: investigate APIs, find datasets, explore solutions

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

### Demo mode
```bash
cd tritium-sc && ./start.sh
# Then: POST http://localhost:8000/api/demo/start
# Synthetic BLE/Meshtastic/camera data flows through full pipeline
```

## Feature Roadmap

### Completed (Waves 1-44)
1. SQLite sighting logger
2. P2P mesh chat (ESP-NOW)
3. MQTT SC bridge (heartbeat, sighting, chat, commands)
4. Terminal app (on-device + web)
5. OUI/MAC manufacturer lookup
6. BLE device type classifier (15 types)
7. Mesh chat → MQTT bridge
8. Sighting/BLE stats in MQTT heartbeat
9. GIS/map tile viewer (MBTiles on SD)
10. Power management (auto-profiles)
11. Lock screen (PIN entry)
12. WebSocket support
13. Web settings page
14. Event-driven toasts
15. Meshtastic plugin (LoRa bridge, GPS tracking, send/waypoint)
16. Camera feeds plugin (multi-source: synthetic/RTSP/MJPEG/MQTT/USB)
17. BLE → TargetTracker → tactical map (RSSI confidence, trilateration)
18. Mesh radio rendering on tactical map
19. Asset placement panel (drag cameras/sensors onto map)
20. Fleet dashboard plugin (device registry, battery, sighting counts)
21. Synthetic data generators (BLE, Meshtastic, camera)
22. Demo mode (full pipeline exercise with synthetic data)
23. WebSocket broadcast for BLE/mesh targets
24. Camera feed panel (live MJPEG grid)
25. YOLO detector plugin (modular detection pipeline)
26. Target correlator (fuse camera + BLE into unified targets)
27. BLE threat classifier (known/unknown/new/suspicious)
28. Amy sensorium BLE/mesh awareness
29. WiFi SSID classifier (corporate/hotspot/IoT/mesh)
30. MQTT sighting subscription in edge tracker
31. ROS2 camera node example
32. Geofencing alerts (Wave 6)
33. Target history/trails (Wave 6)
34. TAK/CoT bridge (Wave 8)
35. Graph ontology + investigations (Wave 9)
36. Automation engine (Wave 9)
37. Multi-node trilateration (Wave 13)
38. RF motion detection (Wave 13)
39. Multi-site federation (Wave 14+)
40. Radio scheduler HAL (Wave 16)
41. JWT authentication (Wave 16)
42. Rate limiting + DB migrations + backup (Wave 17)
43. Acoustic classification (Wave 18)
44. Video recording/playback (Wave 18)
45. Drone/UAV models (Wave 18)
46. LPR + AIS/ADS-B transponder plugins (Wave 21)
47. Security audit (Wave 22)
48. Terrain analysis + RF propagation (Wave 23)
49. Behavior analysis + correlation scoring (Wave 24)
50. Store consolidation (BaseStore) (Wave 25)
51. WebSocket batching + target clustering (Wave 26)
52. Event schemas (41 typed events) (Wave 26)
53. BLE RSSI history + trend detection (Wave 26)
54. Audit middleware + security hardening (Wave 27)
55. Map measurement tool + fleet sparklines (Wave 28)
56. MAC randomization detection (Wave 28)
57. BLE/WiFi coverage layers + target detail modal (Wave 29)
58. Target export (CSV/JSON/GeoJSON) (Wave 29)
59. Mesh sighting relay (Wave 29)
60. Alert rules + event-driven alert generation (Wave 29)
61. WiFi probe request tracking (Wave 31)
62. Config sync HAL (Wave 32)
63. Notification preferences + rules (Wave 30)
64. Heatmap visualization (Wave 30)
65. Graph explorer panel (Wave 30)
66. Target timeline panel (Wave 30)
67. Quick-start panel (Wave 33)
68. System health panel (Wave 33)
69. Device manager panel + remote OTA (Wave 34)
70. Testing dashboard panel (Wave 34)
71. Mission management panel (Wave 35)
72. Target comparison panel (Wave 35)
73. Multi-camera panel (Wave 35)
74. Target merge workflow (Wave 35)
75. Amy conversation panel (Wave 37)
76. Export scheduler panel (Wave 37)
77. Bookmarks panel (Wave 37)
78. RF monitor HAL (Wave 38)
79. WiFi probe HAL (Wave 38)
80. Power saver HAL (Wave 38)
81. Panel search with Ctrl+/ shortcut (Wave 39)
82. Heatmap timeline + notification bell (Wave 39)
83. Map annotations + target watch list (Wave 40)
84. Plugin messaging bus (Wave 40)
85. Compass rose overlay (Wave 40)
86. Ops dashboard panel (Wave 41)
87. Map dark mode toggle (Wave 41)
88. Dossier target grouping on map (Wave 41)
89. Input validation + WebSocket auth/heartbeat (Wave 42)
90. Shared panel-utils.js (_esc, _timeAgo, _badge, _statusDot, _fetchJson) (Wave 44)
91. Categorized panel menu (7 categories, 55 panels) (Wave 44)
92. Setup wizard (first-launch configuration) (Wave 44)

### Next Up
93. **RF environment mapping** — passive spectrum analysis beyond motion detection
94. **Multi-camera re-identification** — cross-camera person tracking via embeddings
95. **Panel data subscriptions** — reactive data binding for panels (reduce polling)

## Known Blockers
- **NimBLE esp_bt.h not found** — BLE scanner runs stubs, WiFi/mesh alternatives work fine
- **BLE/WiFi coexistence** — can't run BLE scanner alongside WiFi on ESP32-S3

## Style & Conventions
- No frontend frameworks — vanilla JavaScript only
- Cyberpunk aesthetic: cyan #00f0ff, magenta #ff2a6d, green #05ffa1, yellow #fcee0a
- Background: void #0a0a0f, surfaces #0e0e14/#12121a/#1a1a2e
- C++17 for firmware, Python 3.12+ for servers, vanilla JS for frontend
- 4-space indentation everywhere
- Changelogs in every repo at `docs/CHANGELOG.md` with verification levels
