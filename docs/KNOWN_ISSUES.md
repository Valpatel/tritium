# Known Issues

Tracked hardware and software issues across the Tritium platform.

---

## EDGE-001: RGB Parallel Display Glitches When USB Connected

**Boards:** ESP32-S3-Touch-LCD-4.3C-BOX (ST7262 RGB parallel)
**Severity:** Cosmetic
**Status:** Open — hardware limitation

### Symptoms

Small display corruption artifacts (flickering pixels, brief color glitches)
appear intermittently when a USB cable is connected to a PC. The display
renders cleanly when running standalone (no USB).

### Root Cause

The ESP32-S3 RGB parallel LCD peripheral continuously DMA-scans the
framebuffer from PSRAM at ~46 MB/s (800x480x2 bytes x 60 Hz). When USB CDC
is active, its interrupts and DMA transfers compete for the same memory bus.
Brief bus contention causes the LCD peripheral to read stale or partial
framebuffer data for one refresh cycle, producing visible artifacts.

This does not affect QSPI display boards (349, 35BC, 241B, 1.8, 1.91M)
because QSPI panels have their own display RAM and are only written to on
change — there is no continuous scan-out from ESP32 PSRAM.

### Mitigations

- **Bounce buffers** (already configured at 10 rows) copy PSRAM data to
  internal SRAM in chunks, reducing direct PSRAM contention
- **Double buffering** (`num_fbs = 2`) allows atomic buffer swaps at vsync
  when using LVGL (but the boot sequence bypasses LVGL)
- **Minimize Serial output** during display-critical operations — each
  `Serial.printf()` triggers USB CDC transfers that compete for bus time
- **No fix possible** without hardware changes — this is inherent to the
  ESP32-S3 memory architecture when RGB LCD + USB CDC + PSRAM are all active

### Impact

Cosmetic only. No data loss, no crashes. Artifacts appear as brief single-frame
glitches and self-correct on the next refresh. In production (no USB cable),
the display is clean.

### References

- [ESP-IDF RGB LCD documentation](https://docs.espressif.com/projects/esp-idf/en/latest/esp32s3/api-reference/peripherals/lcd/rgb_lcd.html)
- Board config: `include/boards/esp32_s3_touch_lcd_43c_box.h`
- Display driver: `lib/display/boards/board_display_43c.h`

---

## EDGE-002: NimBLE esp_bt.h Not Found

**Boards:** All (build-time)
**Severity:** Blocking — prevents BLE serial and BLE OTA compilation
**Status:** Open

### Symptoms

Compilation fails with `esp_bt.h: No such file or directory` when building
with `hal_ble_serial` or `hal_ble_ota` enabled.

### Root Cause

NimBLE library expects ESP-IDF Bluetooth headers that aren't properly exposed
in the ESP-IDF build path for ESP32-S3.

### Impact

BLE serial console and BLE OTA update paths are blocked. BLE passive scanning
(`hal_ble_scanner`) works because it uses a different NimBLE code path that
doesn't require `esp_bt.h`.

### Workaround

Use alternative update paths (WiFi OTA, serial USB, SD card, ESP-NOW mesh).

---

## EDGE-003: Boot Sequence Byte-Swap on RGB Panels

**Boards:** ESP32-S3-Touch-LCD-4.3C-BOX
**Severity:** Fixed
**Status:** Resolved

### Symptoms

Boot screen colors were inverted (cyan appeared as red/orange, greens as red)
on the 43C-BOX RGB parallel panel.

### Root Cause

The `rgb565()` function in `boot_sequence.cpp` byte-swapped all color values
for SPI panel compatibility. RGB parallel panels expect native byte order.

### Fix

Added compile-time panel type detection: `_swap_bytes = false` for
`BOARD_TOUCH_LCD_43C_BOX`, `true` for all QSPI boards. Applied in commit
`101ccbe`.
