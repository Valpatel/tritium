# Focus: Tritium-Edge (Firmware + Fleet Server)

You are now working on **tritium-edge** — ESP32-S3 firmware (Tritium-OS) and the fleet management server.

## Context

Read `tritium-edge/CLAUDE.md` for full conventions, board table, and pitfalls.

## Key Directories

| Directory | Purpose |
|-----------|---------|
| `tritium-edge/lib/` | 40+ HAL libraries (display, WiFi, BLE, mesh, power, etc.) |
| `tritium-edge/apps/` | App implementations (starfield, system, camera, etc.) |
| `tritium-edge/src/main.cpp` | Firmware entry point and app dispatcher |
| `tritium-edge/include/boards/` | Per-board pin definitions |
| `tritium-edge/docs/` | 24 technical documents |
| `tritium-edge/server/` | Fleet management FastAPI server |
| `tritium-edge/scripts/` | Build/flash/monitor automation |

## Quick Commands

```bash
# Build firmware (this IS the test)
cd tritium-edge && pio run -e touch-lcd-43c-box-os
# Quality gate: RAM <60%, Flash <50%

# Or use Makefile
make build BOARD=touch-lcd-43c-box
make flash BOARD=touch-lcd-43c-box
make monitor
make list-boards
make list-apps

# Flash scripts
./scripts/flash.sh touch-lcd-349
./scripts/monitor.sh
```

## Key Documents

- `tritium-edge/docs/TRITIUM-OS-VISION.md` — OS architecture and roadmap
- `tritium-edge/docs/ARCHITECTURE.md` — System design
- `tritium-edge/docs/ADDING_A_BOARD.md` — How to add new hardware
- `tritium-edge/docs/ADDING_AN_APP.md` — How to create new apps
- `tritium-edge/docs/DEVICE-PROTOCOL.md` — Heartbeat v2, config sync

## Important Patterns

- **Board selection**: Compile-time via `-DBOARD_*` flag in platformio.ini
- **App selection**: Compile-time via `-DAPP_*` flag
- **Display HAL**: `display_init()` → `display_get_panel()` → `esp_lcd_panel_draw_bitmap()`
- **Settings**: NVS-backed via `os_settings/`
- **Events**: `os_events/` pub/sub system

## Related

- `focus-lib` — if you need new models or MQTT topics
- `focus-sc` — if you need to wire up SC integration
