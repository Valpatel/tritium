# Discovery Report -- Wave 83

**Date:** 2026-03-14
**Agent:** Discovery Agent (Serendipity Engine)
**Method:** Random exploration across all 3 submodules

---

## 1. wifi_fingerprint Plugin: Complete but Never Loaded

**Severity: HIGH**

The `plugins/wifi_fingerprint/` directory contains a complete implementation:
- `plugin.py` (150 lines) -- WiFiFingerprintPlugin with EventBus drain, BLE-WiFi correlation
- `correlator.py` -- ProbeCorrelator for temporal/spatial correlation
- `routes.py` -- 6 API endpoints under `/api/wifi-fingerprint/`

The frontend panel exists too: `src/frontend/js/command/panels/wifi-fingerprint.js` calls `/api/wifi-fingerprint/status` and `/api/wifi-fingerprint/links`.

The edge HAL exists: `tritium-edge/lib/hal_wifi_fingerprint/` (3 files) -- captures WiFi RSSI fingerprints and publishes via MQTT.

**Problem:** There is no `plugins/wifi_fingerprint_loader.py`. Every other plugin directory has a corresponding `*_loader.py` file. Without a loader, this plugin is never registered, its routes are never mounted, and the frontend panel fetches from non-existent endpoints.

**Full pipeline (edge -> MQTT -> SC backend -> frontend) is wired but the SC plugin loader is the missing link.**

**Recommendation:** Create `wifi_fingerprint_loader.py` following the pattern of other loader files.

---

## 2. edge_tracker Plugin: Zero Test Coverage

**Severity: HIGH**

`plugins/edge_tracker/` is the core BLE/WiFi tracking plugin -- the most critical plugin for the entire system's mission of target tracking. It has:
- `plugin.py` (572 lines)
- `routes.py`

No test file exists anywhere in the test tree matching `*edge_tracker*`. For the single most important plugin in the system, this is a significant gap.

**Recommendation:** Create test file `tests/engine/plugins/test_edge_tracker.py` covering MQTT sighting ingestion, target creation, BLE classification, and route responses.

---

## 3. CLAUDE.md Plugin List Undercounts Reality

**Severity: LOW**

The top-level CLAUDE.md "Plugin System" section lists 11 plugins:
- edge_tracker, meshtastic, camera_feeds, fleet_dashboard, yolo_detector, tak_bridge, gis_layers, automation, threat_feeds, graphlings, npc_thoughts

Actual plugin directories: **16** (plus 1 built-in NPC Intelligence in the simulation engine).

Missing from CLAUDE.md listing:
- `acoustic` -- ML sound classification + source localization (full implementation)
- `behavioral_intelligence` -- Pattern detection (full implementation)
- `federation` -- Multi-site target sharing via MQTT (full implementation)
- `floorplan` -- Indoor spatial intelligence, room localization (full implementation)
- `rf_motion` -- RF-based motion detection (full implementation)
- `wifi_fingerprint` -- WiFi probe-to-BLE correlation (full implementation but unloaded)

**Recommendation:** Update the Plugin System section in CLAUDE.md to list all 16+ plugins.

---

## 4. STATUS.md Metrics Are Stale (Wave 78 Baseline vs Wave 83 Reality)

**Severity: LOW**

| Metric | STATUS.md (Wave 78) | Actual (Wave 83) | Delta |
|--------|---------------------|-------------------|-------|
| tritium-lib tests | 1,822 | 1,957 | +135 |
| Lib model files | 61 | 65 | +4 |
| Frontend panels | 71 | 75 | +4 |
| Edge HAL dirs | 50 | 62 | +12 |

MEMORY.md claims 833 lib tests (severely outdated -- likely from Wave 5 era).

**Recommendation:** Update STATUS.md metrics and MEMORY.md test baselines.

---

## 5. Lib Models: 52 of 65 Have No SC Consumer

**Severity: MEDIUM (architectural)**

tritium-lib defines 65 model files. Only 13 are imported by tritium-sc code:
- `acoustic_intelligence`, `ble_interrogation`, `correlation`, `diagnostics`, `event_schema`, `federation`, `fleet`, `mission`, `pattern`, `report`, `topology`, `trilateration`, `user`

The remaining 52 models (including `drone`, `swarm`, `terrain`, `lpr`, `prediction`, `tactical_situation`, `visualization`, `transport`, etc.) are tested in isolation but never consumed by any application code.

These models represent either:
- Forward-looking definitions for planned features (acceptable if tracked)
- Speculative code that may never be used (tech debt if untracked)

All 65 have test coverage, so they are not broken -- just unused.

**Recommendation:** Audit the 52 unused models. Either wire them into SC plugins or mark them as "planned future" in a tracking document.

---

## 6. TODO/FIXME Comments

**Severity: LOW**

Only 2 genuine TODOs found across the entire codebase:

1. `tritium-sc/src/app/ai/mapper.py:468` -- "TODO: Deserialize properly"
2. `tritium-sc/src/engine/nodes/audio.py:17` -- "TODO Phase 2: Implement audio recording/playback for arbitrary..."

The codebase is remarkably clean of TODO markers for its size.

---

## 7. npc_thoughts.py: Standalone File, Not a Plugin Directory

**Severity: INFO**

`plugins/npc_thoughts.py` is a single file, not a directory like all other plugins. It follows a different loading pattern (loaded by the simulation engine directly). This works fine but is architecturally inconsistent with the plugin directory convention.

---

## Summary

| Finding | Severity | Action |
|---------|----------|--------|
| wifi_fingerprint missing loader | HIGH | Create loader file |
| edge_tracker has zero tests | HIGH | Add test coverage |
| CLAUDE.md undercounts plugins | LOW | Update documentation |
| STATUS.md metrics stale | LOW | Refresh metrics |
| 52/65 lib models unused by SC | MEDIUM | Audit and document |
| 2 TODO comments | LOW | Address or remove |
| npc_thoughts standalone file | INFO | Cosmetic inconsistency |
