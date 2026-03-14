# Tritium Changelog

Changes tracked with verification status. All changes on `dev` branch.

## Verification Levels

| Level | Meaning |
|-------|---------|
| **Unit Tested** | Passes automated unit tests (pytest, JS tests) |
| **Integration Tested** | Passes ./test.sh fast (tiers 1-3 + 8) |
| **Build Verified** | Firmware compiles, RAM/Flash within budget |
| **Human Verified** | Manually tested by a human on real hardware or browser |
| **Deployed** | Running on real hardware in the field |

---

## 2026-03-13 — Session 1: Architecture & Documentation

### Parent Repo
| Change | Verification |
|--------|-------------|
| `.claude/settings.json` — workspace permissions | N/A (config) |
| `.claude/commands/focus-{edge,sc,lib}.md` — context switching | N/A (docs) |
| `docs/ARCHITECTURE.md` — system diagram, component map, data flow | N/A (docs) |
| `docs/STATUS.md` — current state of all components | N/A (docs) |
| `CLAUDE.md` — updated with component map table | N/A (docs) |
| `LICENSE` — AGPL-3.0 added | N/A (legal) |

### tritium-edge
| Change | Verification |
|--------|-------------|
| `docs/README.md` — full 24-document index | N/A (docs) |
| `LICENSE` — AGPL-3.0 added | N/A (legal) |
| WiFi network priority reordering (`wifi_manager.cpp`, `shell_apps.cpp`) | Build Verified |
| MQTT SC bridge (`mqtt_sc_bridge.cpp/h`) — heartbeat/sighting/cmd topics | Build Verified |
| `mqtt_ai_bridge.cpp` — stub when hal_audio unavailable | Build Verified |
| `CLAUDE.md` — fixed build path | N/A (docs) |

### tritium-sc
| Change | Verification |
|--------|-------------|
| Subsystem READMEs (engine, amy, app, frontend, tests, plugins, examples) | N/A (docs) |
| `docs/README.md` — updated with navigation and cross-project links | N/A (docs) |
| `LICENSE` — AGPL-3.0 added | N/A (legal) |
| `TargetTracker.update_from_ble()` — BLE devices as tracked targets | Unit Tested |
| EdgeTrackerPlugin → TargetTracker BLE push | Unit Tested |
| Meshtastic plugin (`plugins/meshtastic/`) — LoRa bridge | Unit Tested |
| Meshtastic route tests | Unit Tested |
| `geo.py` latlng_to_local tuple unpacking fix | Unit Tested |
| BLE device rendering on tactical map (war-combat.js) | Integration Tested |
| Mesh radio rendering on tactical map | Integration Tested |
| BLE + mesh rendering in command map (map.js, unit-icons.js) | Integration Tested |
| Camera feeds plugin (`plugins/camera_feeds/`) — multi-source | Unit Tested |
| Asset placement panel (`panels/assets.js`) | Integration Tested |
| ROS2 camera node example (`examples/ros2-camera/`) | Unit Tested |

### tritium-lib
| Change | Verification |
|--------|-------------|
| `CLAUDE.md` — submodule context (was missing) | N/A (docs) |
| `src/tritium_lib/README.md` — package reference | N/A (docs) |
| `LICENSE` — AGPL-3.0 added | N/A (legal) |
| Lazy imports in `testing/__init__.py` | Unit Tested |
| `[testing]` optional dep group in pyproject.toml | Unit Tested |
| Meshtastic models (Node, Message, Waypoint, Status) | Unit Tested |
| Camera models (Source, Frame, Detection, BoundingBox) | Unit Tested |
| MQTT topic constants for Meshtastic + camera feeds | Unit Tested |

---

## 2026-03-13 — Session 2: Plugin Hardening & Integration

### tritium-sc (in progress)
| Change | Verification |
|--------|-------------|
| Camera feeds plugin ↔ MQTTBridge integration | Pending |
| Edge tracker MQTT sighting subscription | Pending |
| Expanded plugin test coverage | Pending |
| Asset placement panel | Pending |
| ROS2 camera node example | Pending |

---

## Test Baseline

| Suite | Count | Status | Date |
|-------|-------|--------|------|
| tritium-lib pytest | 833 | All passing | 2026-03-13 |
| tritium-sc fast (tiers 1-3+8) | 81 tiers | All passing | 2026-03-13 |
| tritium-edge build | 45.9% RAM, 28.8% Flash | 0 warnings | 2026-03-13 |

---

## Known Issues

| Issue | Status | Impact |
|-------|--------|--------|
| BLE scanner disabled (WiFi/BLE coexistence) | Open | No real BLE data flows; MQTT pipeline ready |
| NimBLE esp_bt.h not found | Open | Blocks BLE serial + BLE OTA |
| RGB parallel display glitches (43C-BOX + USB) | Cosmetic | Memory bus contention |
