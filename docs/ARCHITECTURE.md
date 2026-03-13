# Tritium Architecture

## System Overview

Tritium is a distributed cybernetic operating system for robotics and security applications. Three components work together to create a complete edge-to-cloud IoT platform.

```
┌─────────────────────────────────────────────────────────────┐
│                    TRITIUM-SC (Command Center)              │
│                         :8000                               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────────┐  │
│  │ FastAPI   │  │ Amy AI   │  │ Sim      │  │ Plugins    │  │
│  │ Backend   │  │ Commander│  │ Engine   │  │ System     │  │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └─────┬──────┘  │
│       │              │             │               │         │
│  ┌────┴──────────────┴─────────────┴───────────────┴──────┐  │
│  │              EventBus (pub/sub)                        │  │
│  └────────────────────┬──────────────────────────────────┘  │
│                       │                                     │
│  ┌────────────────────┴──────────────────────────────────┐  │
│  │  Vanilla JS Frontend (unified.html, Canvas 2D, Three) │  │
│  └───────────────────────────────────────────────────────┘  │
└──────────────────────┬──────────────────────────────────────┘
                       │
              MQTT / REST / WebSocket
                       │
┌──────────────────────┴──────────────────────────────────────┐
│                    TRITIUM-EDGE (Fleet)                     │
│                         :8080                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              Fleet Management Server (FastAPI)       │   │
│  │  Provisioning, OTA, Config Sync, Monitoring          │   │
│  └──────────────────────┬───────────────────────────────┘   │
│                         │                                   │
│  ┌──────────────────────┴───────────────────────────────┐   │
│  │              ESP32-S3 Firmware (Tritium-OS)           │   │
│  │  6 boards, 10 apps, 40+ HALs, LVGL UI               │   │
│  │  WiFi + BLE + ESP-NOW mesh + LoRa                    │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│                   TRITIUM-LIB (Shared)                      │
│  Common code: 116+ models, MQTT topics, auth, events       │
│  Test utils, report generators, themes, protocol codecs    │
│  Python now, growing to include C++ and JS/CSS/HTML        │
└─────────────────────────────────────────────────────────────┘
```

## Component Map

| Component | Location | Language | Port | Purpose |
|-----------|----------|----------|------|---------|
| **Edge Firmware** | `tritium-edge/` | C++17 | — | Tritium-OS on ESP32-S3 hardware |
| **Fleet Server** | `tritium-edge/server/` | Python | 8080 | Device provisioning, OTA, monitoring |
| **Command Center** | `tritium-sc/` | Python + JS | 8000 | Tactical dashboard, AI commander, plugins |
| **AI Commander** | `tritium-sc/src/amy/` | Python | — | 4-layer cognitive AI (reflex→deliberation) |
| **Sim Engine** | `tritium-sc/src/engine/` | Python | — | 10Hz battle simulation, unit AI, combat |
| **Shared Library** | `tritium-lib/` | Python (+ C++, JS future) | — | Common code: models, topics, auth, events, test utils, themes |

## Communication

### MQTT Topic Hierarchy

```
tritium/{site}/{domain}/{device}/{type}

Domains:
  edge/     — ESP32 devices
  cameras/  — Camera feeds
  robots/   — Robot units
  amy/      — AI commander

Types:
  heartbeat — Periodic status
  status    — Online/offline (retained, LWT)
  sighting  — BLE/WiFi detections
  chat      — Mesh chat messages
  cmd       — Commands (subscribe)
  telemetry — Sensor data
  command   — Dispatch instructions
  thoughts  — LLM-generated reasoning
```

### Protocols

| Protocol | Use | Direction |
|----------|-----|-----------|
| MQTT | Device telemetry, commands, chat | Bidirectional |
| REST | Device registration, config, OTA | Edge → Server |
| WebSocket | Real-time UI updates, Amy events | Server → Browser |
| ESP-NOW | Mesh networking between devices | Device ↔ Device |
| CoT/XML | TAK/ATAK interoperability | SC ↔ TAK Server |

## Data Flow

1. **Edge → SC**: Devices publish heartbeats, sightings, chat to MQTT. SC subscribes and displays in fleet tracker.
2. **SC → Edge**: SC sends commands via MQTT `cmd` topic. Devices subscribe and execute.
3. **Camera → AI**: JPEG frames via MQTT → YOLO detection → Amy perception → autonomous response.
4. **Mesh → Cloud**: ESP-NOW mesh chat bridges to MQTT, appears in SC dashboard.
5. **Lib ↔ Both**: Shared models ensure type-safe data contracts across the stack.

## Technology Stack

| Layer | Technology |
|-------|-----------|
| Firmware | ESP-IDF 5.x, PlatformIO, Arduino, LVGL, esp_lcd |
| Fleet Server | FastAPI, Python 3.12+ |
| Command Center | FastAPI, SQLAlchemy, aiosqlite |
| Frontend | Vanilla JS, Canvas 2D, Three.js, CYBERCORE CSS |
| AI/ML | YOLOv8, ByteTrack, Ollama, whisper.cpp, Piper TTS |
| Communication | MQTT (paho-mqtt), REST, WebSocket, ESP-NOW |
| Database | SQLite with FTS5 |
| Hardware | ESP32-S3 (6 Waveshare boards), cameras, sensors |

## Supported Hardware

| Board | Display | Resolution | Status |
|-------|---------|------------|--------|
| ESP32-S3-Touch-AMOLED-2.41-B | RM690B0 QSPI | 450x600 | Verified |
| ESP32-S3-AMOLED-1.91-M | RM67162 QSPI | 240x536 | Needs verification |
| ESP32-S3-Touch-AMOLED-1.8 | SH8601Z QSPI | 368x448 | Compiles |
| ESP32-S3-Touch-LCD-3.5B-C | AXS15231B QSPI | 320x480 | Verified (display+camera+audio) |
| ESP32-S3-Touch-LCD-4.3C-BOX | ST7262 RGB | 800x480 | Pin-verified |
| ESP32-S3-Touch-LCD-3.49 | AXS15231B QSPI | 172x640 | Verified |
