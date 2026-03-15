# Discovery Report -- Wave 146

**Date:** 2026-03-15
**Last discovery:** Wave 97 (49 waves overdue)

## 1. Orphan Panels (3 found)

Panel JS files that exist in `tritium-sc/src/frontend/js/command/panels/` but are NOT imported or registered in `main.js`:

| File | Description | Status |
|------|-------------|--------|
| `convoy-panel.js` | Convoy group visualization, calls `/api/targets/convoys` | Not imported, not registered. Exports `ConvoyPanelDef` but nobody uses it. |
| `operator-cursors.js` | Multi-operator cursor sharing over WebSocket | Not imported. Exports `initCursorSharing()` utility, never called. |
| `weather-overlay.js` | Weather data overlay on tactical map | Not imported as a panel. Exports `WeatherOverlay` class, never instantiated in main.js. |

**Note:** `map-screenshot.js` is imported as a hotkey utility (not a panel), and `stats.js` is registered as `BattleStatsPanelDef` -- both are properly wired. Total registered panels: 84. Total panel files: 87 (84 registered + 3 orphans).

### Recommendation
Register `ConvoyPanelDef` in main.js and add it to the Intelligence category in menu-bar.js PANEL_CATEGORIES. Wire `WeatherOverlay` into the map initialization. `operator-cursors.js` depends on multi-session infrastructure -- park it until sessions/auth is fully wired.

---

## 2. Dead API Routes (4 found)

Backend routers that define endpoints with NO frontend consumer (no panel, no JS fetch call):

| Router | Endpoint | Has Tests? | Notes |
|--------|----------|------------|-------|
| `picture_of_day.py` | `GET /api/picture-of-day` | Yes (test exists) | Daily operational summary. No frontend panel or widget calls it. |
| `ar_export.py` | `GET /api/targets/ar-export` | Test exists | AR headset data format. Only referenced in README, no frontend consumer. |
| `readiness.py` | `GET /api/readiness` | No | Operational readiness checklist. No frontend panel calls it. Could be shown in system-health panel or setup-wizard. |
| `rate_limit_dashboard.py` | `GET /api/rate-limits/*` | No | Rate limit stats. No frontend panel calls it. |

**Also notable:** `self_test.py` defines endpoints with no frontend consumer, but is tested.

### Recommendation
- Wire `/api/picture-of-day` into the ops-dashboard panel as a daily summary widget.
- Wire `/api/readiness` into the setup-wizard or system-health panel.
- Consider removing `ar_export.py` if no AR integration is planned, or document it as an external API.

---

## 3. Unused Lib Models (4 found)

Model files in `tritium-lib/src/tritium_lib/models/` that are exported from `__init__.py` but imported ONLY by their own tests -- never used by tritium-sc or tritium-edge application code:

| Model | Classes | Test Only? | Notes |
|-------|---------|------------|-------|
| `convoy.py` | `Convoy`, `ConvoyFormation`, `ConvoyStatus`, `ConvoySummary` | Yes | Coordinated movement detection. The orphan `convoy-panel.js` would consume this, but no backend route produces convoy data. |
| `daily_pattern.py` | `DailyPattern` | Yes | Daily temporal patterns. No SC consumer. |
| `acoustic_training.py` | `AcousticTrainingExample`, `AcousticTrainingSet`, `TrainingSource` | Yes | ML training data for acoustic classification. No SC consumer. |
| `vehicle.py` | `VehicleTrack`, `compute_heading`, `compute_speed_mph`, `compute_suspicious_score` | Yes | Vehicle tracking models. No SC consumer despite being directly relevant to LPR panel. |

**Note:** `benchmark.py` (`BenchmarkResult`, `BenchmarkSuite`) is also test-only in tritium-sc.

### Recommendation
- Wire `vehicle.py` models into the LPR plugin or a new vehicle tracking backend.
- Wire `convoy.py` models into behavioral intelligence and create a `/api/targets/convoys` endpoint to feed the orphan `convoy-panel.js`.
- `daily_pattern.py` and `acoustic_training.py` are forward-looking models that will be needed when ML training pipelines are built.

---

## 4. Random Deep Dives

### 4a. `tritium-lib/src/tritium_lib/models/tak_export.py`
**What it does:** Converts TrackedTargets into MIL-STD-2045 Cursor on Target XML for ATAK/WinTAK interoperability.
**Is it used?** Yes -- imported by `tritium-sc/src/app/routers/targets_unified.py` and has tests.
**Verdict:** Connected, tested, functional. Good model.

### 4b. `tritium-sc/src/app/routers/mesh_environment.py`
**What it does:** Returns temperature/humidity/pressure readings from Meshtastic mesh nodes with environment sensors.
**Is it used?** The `weather-overlay.js` panel fetches `/api/mesh/environment` -- but `weather-overlay.js` is an orphan (see finding #1). So the router exists and the consumer exists, but they are not wired together in main.js.
**Verdict:** Backend + frontend both exist but are disconnected. Wiring `WeatherOverlay` into main.js would connect this pipeline end-to-end.

### 4c. `tritium-sc/src/frontend/js/command/panels/convoy-panel.js`
**What it does:** Displays detected convoy groups with suspicion scores, heading, speed, formation type. Calls `/api/targets/convoys`.
**Is it used?** No -- orphan panel. The backend endpoint `/api/targets/convoys` does not exist either. The lib model `convoy.py` exists but is unused.
**Verdict:** A complete vertical slice was built across three layers (lib model + frontend panel) but the middle layer (backend route) is missing, and the panel was never registered. This is a textbook example of a disconnected feature.

---

## 5. TODO/FIXME Scan

### Top 10 Most Important

| Priority | Location | TODO |
|----------|----------|------|
| HIGH | `tritium-edge/lib/hal_lora/hal_lora.cpp:99-274` | 6 TODOs for SX1262/SX1276 LoRa radio SPI initialization, transmit, receive, and NimBLE Meshtastic client. Core LoRa functionality is stubbed out. |
| HIGH | `tritium-edge/lib/hal_environment/hal_environment.cpp:30-102` | 3 TODOs for I2C sensor scan, MQTT wiring, and actual sensor reads. Environment HAL is fully stubbed. |
| MEDIUM | `tritium-sc/src/app/ai/mapper.py:468` | "TODO: Deserialize properly" -- mapper returns raw data without proper deserialization. |
| MEDIUM | `tritium-sc/src/engine/nodes/audio.py:17` | "TODO Phase 2: Implement audio recording/playback for arbitrary..." -- audio node is stub. |
| MEDIUM | `tritium-edge/platformio.ini:290-995` | 14 "TODO: Port to esp_lcd" comments across board environments. Many board configs are waiting for display driver migration. |
| LOW | `tritium-edge/lib/hal_diag/diag_service.h:59` | "TODO: add PMIC temp read to PowerHAL" -- minor telemetry gap. |
| LOW | `tritium-edge/scripts/new-app.sh:67` | Template TODO in app generator script (expected). |
| LOW | `tritium-sc/examples/robot-template/brain/nav_planner.py:218-262` | 3 TODOs for ROS2 navigation, LiDAR, and GPS integration. Example code, expected to be stub. |
| INFO | `tritium-edge/docs/TRITIUM-OS-VISION.md:817-846` | 8 TODO items in vision doc checklist (WiFi config app, WebSocket, terminal, mesh viewer, sensor dashboard, camera streaming, fleet management). These are roadmap items, not code debt. |

**Summary:** The codebase has 30+ TODO markers. The most impactful are the 6 stubbed LoRa functions in `hal_lora.cpp` and the 3 stubbed environment sensor functions in `hal_environment.cpp` -- these represent hardware integration gaps that block real LoRa mesh and environment sensing.

---

## 6. Menu-Bar Category Gaps

The `PANEL_CATEGORIES` in `menu-bar.js` lists panel IDs for the View menu. Some registered panels are NOT in any category and will fall into the "Other" bucket:

Panels in "Other" (uncategorized): `activity-feed`, `mqtt-inspector`, `annotations`, `watchlist`, `map-share`, `keyboard-macros`, `grid-overlay`, `floorplan`, `building-occupancy`, `acoustic-intelligence`, `behavioral-intelligence`, `map-replay`, `voice-command`, `wifi-fingerprint`, `edge-diagnostics`, `fusion-dashboard`, `operator-activity`, `swarm-coordination`, `training-dashboard`, `lpr`, `reid-matches`, `dossier-timeline`, `dossier-groups`, `edge-intelligence`, `setup-wizard`.

That is 25 panels in the "Other" bucket -- nearly 30% of all panels. The menu categories have not been updated as new panels were added in recent waves.

### Recommendation
Add new category entries. Suggested additions:
- **Diagnostics**: `edge-diagnostics`, `mqtt-inspector`, `sensor-health`, `system-health`
- **Analytics**: `analytics-dashboard`, `behavioral-intelligence`, `dwell-monitor`, `fusion-dashboard`, `training-dashboard`
- **Tools**: `annotations`, `watchlist`, `keyboard-macros`, `grid-overlay`, `map-share`, `voice-command`, `map-replay`, `activity-feed`
- **Identification**: `lpr`, `reid-matches`, `wifi-fingerprint`, `acoustic-intelligence`

---

## Summary

| Finding | Count | Severity |
|---------|-------|----------|
| Orphan panel files (not registered) | 3 | MEDIUM |
| Dead API routes (no frontend consumer) | 4 | LOW |
| Unused lib models (test-only) | 4-5 | LOW |
| Disconnected vertical slice (convoy) | 1 | MEDIUM |
| Weather overlay + mesh env disconnected | 1 | MEDIUM |
| Uncategorized panels in menu | 25 | LOW |
| TODO/FIXME comments | 30+ | varies |

The biggest actionable finding is the **convoy vertical slice**: the lib model exists, the frontend panel exists, but the backend route is missing and the panel is not registered. Similarly, `weather-overlay.js` and `mesh_environment.py` are both implemented but not connected. These represent completed work that was never wired into the system.
