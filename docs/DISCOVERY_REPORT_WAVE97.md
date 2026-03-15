# Discovery Report — Wave 97

Date: 2026-03-14

## A. Meshtastic Bridge Importability

**File:** `tritium-sc/scripts/meshtastic-bridge.py` (600 lines)

**Result: PASS** — All top-level imports resolve (json, logging, os, signal, sys, time, threading, datetime). The `meshtastic`, `paho.mqtt`, and `pubsub` libraries are imported lazily inside methods (`_connect_mqtt`, `_connect_meshtastic`, `_setup_pubsub`), so the script can be loaded without those packages installed. This is correct design for an optional bridge daemon.

**Note:** The file uses a hyphen in its name (`meshtastic-bridge.py`), so it cannot be imported as a Python module via `from scripts.meshtastic_bridge import *`. This is fine since it is a standalone script (`python3 scripts/meshtastic-bridge.py`), not a library.

## B. Largest Source Files in tritium-sc/src/

**10 files exceed 1000 lines:**

| Lines | File | Split candidate? |
|-------|------|-----------------|
| 2353 | `amy/commander.py` | YES — orchestrator, could extract battle logic, sensor wiring |
| 1804 | `engine/simulation/engine.py` | YES — 10Hz tick loop + spawner + cleanup, large surface |
| 1502 | `engine/simulation/mission_director.py` | MAYBE — single-purpose director |
| 1334 | `app/main.py` | YES — boot sequence + lifespan + plugin wiring, could extract plugin startup |
| 1270 | `engine/synthetic/video_gen.py` | MAYBE — procedural video generation |
| 1239 | `engine/simulation/behaviors.py` | MAYBE — each behavior type could be separate |
| 1160 | `app/routers/geo.py` | YES — router with heavy logic, should extract geo services |
| 1135 | `engine/simulation/backstory.py` | NO — data-heavy, mostly string constants |
| 1096 | `engine/comms/cot.py` | MAYBE — CoT protocol handling |
| 1059 | `amy/brain/thinking.py` | MAYBE — L4 deliberation is inherently complex |

**Total source:** 104,472 lines across all Python files in `src/`.

**Recommendation:** `amy/commander.py` (2353 lines) and `app/main.py` (1334 lines) are the strongest split candidates. Commander could separate battle orchestration from sensor management. Main.py could extract plugin bootstrapping into its own module.

## C. Test Counts

| Suite | Result |
|-------|--------|
| **tritium-lib** `pytest -q` | **2077 passed**, 29 skipped (3.57s) |
| **tritium-sc** `tests/engine/tactical/` | **874 passed**, 3 skipped (43.49s) |
| **tritium-sc** `tests/engine/intelligence/` | **97 passed** (1.75s) |

All tests green.

## D. Plugin Audit

**19 plugins found** in `tritium-sc/plugins/`:

| # | Plugin | Loader File | Directory | Importable |
|---|--------|-------------|-----------|------------|
| 1 | acoustic | acoustic_loader.py | acoustic/ | OK |
| 2 | automation | automation_loader.py | automation/ | OK |
| 3 | behavioral_intelligence | behavioral_intelligence_loader.py | behavioral_intelligence/ | OK |
| 4 | camera_feeds | camera_feeds_loader.py | camera_feeds/ | OK |
| 5 | edge_autonomy | edge_autonomy_loader.py | edge_autonomy/ | OK |
| 6 | edge_tracker | edge_tracker_loader.py | edge_tracker/ | OK |
| 7 | federation | federation_loader.py | federation/ | OK |
| 8 | fleet_dashboard | fleet_dashboard_loader.py | fleet_dashboard/ | OK |
| 9 | floorplan | floorplan_loader.py | floorplan/ | OK |
| 10 | gis_layers | gis_layers_loader.py | gis_layers/ | OK |
| 11 | graphlings | graphlings_loader.py | graphlings/ | OK |
| 12 | meshtastic | meshtastic_loader.py | meshtastic/ | OK |
| 13 | npc_thoughts | npc_thoughts.py (standalone) | — | OK |
| 14 | rf_motion | rf_motion_loader.py | rf_motion/ | OK |
| 15 | swarm_coordination | swarm_coordination_loader.py | swarm_coordination/ | OK |
| 16 | tak_bridge | tak_bridge_loader.py | tak_bridge/ | OK |
| 17 | threat_feeds | threat_feeds_loader.py | threat_feeds/ | OK |
| 18 | wifi_fingerprint | wifi_fingerprint_loader.py | wifi_fingerprint/ | OK |
| 19 | yolo_detector | yolo_detector_loader.py | yolo_detector/ | OK |

**All 19 plugins have loader files and are importable.** One note: `npc_thoughts` is a standalone `.py` file without a corresponding directory or `_loader.py` suffix — it works but is structurally different from the other 18.

Additionally, `NPCIntelligencePlugin` is registered as a built-in plugin from `src/engine/simulation/npc_intelligence/plugin.py` (not in the plugins/ directory).

## E. Submodule Pointers

Updated parent submodule pointers to latest `dev` commits:

| Submodule | Commit | Message |
|-----------|--------|---------|
| tritium-edge | `97d0904` | Add autonomous alert HAL for local threshold-based alerting |
| tritium-lib | `faa5466` | Add ConfidenceModel with exponential decay per source type |
| tritium-sc | `6104e71` | Add confidence decay, WS sanitization, Amy curiosity system |
