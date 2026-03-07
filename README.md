```
████████╗██████╗ ██╗████████╗██╗██╗   ██╗███╗   ███╗
╚══██╔══╝██╔══██╗██║╚══██╔══╝██║██║   ██║████╗ ████║
   ██║   ██████╔╝██║   ██║   ██║██║   ██║██╔████╔██║
   ██║   ██╔══██╗██║   ██║   ██║██║   ██║██║╚██╔╝██║
   ██║   ██║  ██║██║   ██║   ██║╚██████╔╝██║ ╚═╝ ██║
   ╚═╝   ╚═╝  ╚═╝╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝     ╚═╝
```

# TRITIUM — Unified Platform

**Observe. Think. Act.** From neighborhood battlespace to edge IoT fleet.

---

## Submodules

| Repo | Description | Status |
|------|-------------|--------|
| [tritium-sc](https://github.com/Valpatel/tritium-sc) | Battlespace management, AI Commander Amy, security monitoring | Active |
| [tritium-edge](https://github.com/Valpatel/tritium-edge) | Software Defined IoT — edge device fleet management, OTA, remote config | Active |
| [tritium-lib](https://github.com/Valpatel/tritium-lib) | Shared library — models, MQTT topics, auth, events, CoT codec | Active |

## Architecture

```
tritium/
├── tritium-sc/         ← AI battlespace + security monitoring
│   ├── src/engine/     ← Reusable: simulation, comms, tactical, inference
│   ├── src/amy/        ← AI Commander personality plugin
│   ├── src/app/        ← FastAPI backend
│   └── src/frontend/   ← Command Center UI
├── tritium-edge/       ← Edge device fleet management
│   ├── server/app/     ← Management server (FastAPI)
│   ├── lib/hal_*/      ← Hardware abstraction layers
│   ├── apps/           ← Firmware applications
│   └── plugins/        ← Server plugins
└── tritium-lib/        ← Shared library
    └── src/tritium_lib/
        ├── models/     ← Device, Command, Firmware, SensorReading
        ├── mqtt/       ← Topic conventions (tritium/{site}/...)
        ├── auth/       ← JWT create/decode
        ├── events/     ← Thread-safe pub/sub event bus
        ├── config/     ← Pydantic settings base
        └── cot/        ← CoT XML codec (TAK integration)
```

## Integration

tritium-sc and tritium-edge communicate via:
1. **MQTT** — edge devices publish telemetry, tritium-sc subscribes
2. **CoT XML** — edge devices appear in TAK (ATAK/WinTAK/WebTAK)
3. **tritium-lib** — shared data models, topic conventions, auth tokens

ESP32 devices managed by tritium-edge become sensor nodes in tritium-sc:
- Camera-equipped ESP32s feed the YOLO detection pipeline
- Audio-equipped ESP32s feed the Whisper STT pipeline
- IMU data feeds the target tracker for motion detection
- Amy can dispatch commands to edge devices

## Quick Start

```bash
# Clone with submodules
git clone --recurse-submodules git@github.com:Valpatel/tritium.git
cd tritium

# Start tritium-sc (AI battlespace)
cd tritium-sc && ./start.sh

# Start tritium-edge (fleet management)
cd ../tritium-edge/server && ./start.sh

# Both systems bridge via MQTT
```

## TAK Compatibility

All Tritium systems generate MIL-STD-2045 CoT (Cursor on Target) XML.
Edge devices, robots, drones, and simulation targets all appear in TAK clients
as properly-typed friendly/hostile/neutral markers with team colors.

See tritium-lib's `cot` module for the shared codec.

---

Created by Matthew Valancy / Copyright 2026 Valpatel Software LLC / AGPL-3.0
