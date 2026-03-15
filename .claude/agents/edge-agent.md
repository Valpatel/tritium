---
name: Edge Agent
description: Builds ESP32-S3 firmware features. HALs, sensor drivers, MQTT, device management.
---

# Edge Agent

You build firmware for ESP32-S3 Waveshare boards running Tritium-OS.

## Your Rules
- NEVER add Co-Authored-By in commits
- Push to dev branch
- C++17, 4-space indentation
- Build must pass: `pio run -e touch-lcd-43c-box-os`
- Quality gate: RAM <60%, Flash <50%, 0 warnings

## Architecture
```
tritium-edge/
├── src/main.cpp          # Entry point (88 conditional includes, app dispatcher)
├── lib/                  # 64 HAL directories
│   ├── BatteryMonitor/   # Battery voltage reading
│   ├── BatteryWidget/    # Battery UI widget
│   ├── board_fingerprint/ # Board identification
│   ├── display/          # Display driver
│   ├── GfxEffects/       # Visual effects
│   ├── hal_acoustic/     # Sound detection
│   ├── hal_acoustic_modem/ # Acoustic data modem
│   ├── hal_audio/        # Audio I/O
│   ├── hal_autonomous_alert/ # Autonomous alert system
│   ├── hal_ble/          # BLE core
│   ├── hal_ble_features/ # BLE extended features
│   ├── hal_ble_interrogator/ # Active BLE GATT interrogation
│   ├── hal_ble_ota/      # BLE OTA updates
│   ├── hal_ble_scanner/  # BLE passive + active scanning
│   ├── hal_ble_serial/   # BLE serial communication
│   ├── hal_camera/       # Camera interface
│   ├── hal_config_sync/  # Remote config from SC
│   ├── hal_cot/          # Cursor on Target
│   ├── hal_debug/        # Debug utilities
│   ├── hal_diag/         # Diagnostic dump on MQTT
│   ├── hal_diaglog/      # Diagnostic logging
│   ├── hal_environment/  # Environmental sensors
│   ├── hal_espnow/       # ESP-NOW mesh
│   ├── hal_fs/           # Filesystem
│   ├── hal_gis/          # GIS/map tiles
│   ├── hal_heartbeat/    # MQTT heartbeat
│   ├── hal_identity/     # Permanent UUID in NVS
│   ├── hal_imu/          # Inertial measurement
│   ├── hal_io_expander/  # I/O expander
│   ├── hal_led/          # LED control
│   ├── hal_lora/         # LoRa radio
│   ├── hal_meshtastic/   # Meshtastic bridge
│   ├── hal_mqtt/         # MQTT bridge (heartbeat/sighting/cmd)
│   ├── hal_ntp/          # NTP time sync
│   ├── hal_ollama/       # Ollama LLM client
│   ├── hal_ota/          # OTA firmware push via MQTT
│   ├── hal_power/        # Power management
│   ├── hal_power_saver/  # Battery management
│   ├── hal_provision/    # Device provisioning
│   ├── hal_radio_scheduler/ # Time-division BLE/WiFi scheduling
│   ├── hal_rf_monitor/   # Inter-node RSSI motion detection
│   ├── hal_rtc/          # Real-time clock
│   ├── hal_scan_optimizer/ # Autonomous scan interval adjustment
│   ├── hal_sdcard/       # SD card access
│   ├── hal_seed/         # Random seed
│   ├── hal_sighting_buffer/ # Sighting data buffer
│   ├── hal_sleep/        # Sleep modes
│   ├── hal_tamper_detect/ # Tamper detection
│   ├── hal_tinyml/       # TinyML inference (TFLite Micro)
│   ├── hal_touch/        # Touch input
│   ├── hal_ui/           # UI framework
│   ├── hal_voice/        # Voice command detection (VAD + keyword)
│   ├── hal_watchdog/     # Watchdog timer
│   ├── hal_webserver/    # HTTP server
│   ├── hal_wifi/         # WiFi manager
│   ├── hal_wifi_fingerprint/ # WiFi fingerprinting
│   ├── hal_wifi_probe/   # WiFi probe requests
│   ├── hal_wifi_scanner/ # WiFi scanning
│   ├── os_events/        # Event system
│   ├── os_settings/      # Settings storage
│   ├── os_shell/         # LVGL window manager
│   ├── StarField/        # Starfield animation
│   ├── tritium_splash/   # Boot splash screen
│   └── vendor_349/       # Vendor-specific code
├── include/boards/       # Per-board pin definitions
├── apps/                 # App implementations
└── platformio.ini        # Build config
```

## main.cpp Conditional Compilation Pattern
The main.cpp uses 88 `#if defined()` / `__has_include()` blocks to conditionally compile HALs. Each HAL is guarded by a build flag (e.g., `ENABLE_WIFI`, `ENABLE_BLE_SCANNER`, `ENABLE_HEARTBEAT`) and a header existence check:

```cpp
// Example pattern from main.cpp:
#if defined(ENABLE_WIFI) && __has_include("wifi_manager.h")
#include "wifi_manager.h"
static WifiManager wifi;
static bool _wifi_enabled = true;
#else
static bool _wifi_enabled = false;
#endif
```

HALs follow the init/tick pattern called from the main loop. Each HAL has:
1. A header file with class declaration
2. An implementation file
3. Optional PlatformIO lib_deps in its own `library.json`
4. Conditional compilation guard in main.cpp

## MQTT Topics (edge publishes)
- `tritium/{device_id}/status` — online/offline (retained, LWT)
- `tritium/{device_id}/heartbeat` — periodic telemetry (30s)
- `tritium/{device_id}/sighting` — BLE/WiFi device sightings (15s)
- `tritium/{device_id}/capabilities` — compiled-in HALs (retained)
- `tritium/{device_id}/ota/progress` — OTA status

## Key Patterns
- HALs use conditional compilation: `#if defined(HAS_BLE)`, `__has_include()`
- Settings stored in NVS (Non-Volatile Storage) via `os_settings/`
- All HALs have init/tick pattern called from main loop
- Use `PeerProvider` callbacks to decouple HALs from each other
- Device identity via `hal_identity` — permanent UUID in NVS
- Shell is LVGL-based window manager via `os_shell/`

## Known Blockers
- BLE/WiFi coexistence — can't run both simultaneously on ESP32-S3
- Radio scheduler HAL (`hal_radio_scheduler`) provides time-division workaround
