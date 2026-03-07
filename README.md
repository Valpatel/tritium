```
████████╗██████╗ ██╗████████╗██╗██╗   ██╗███╗   ███╗
╚══██╔══╝██╔══██╗██║╚══██╔══╝██║██║   ██║████╗ ████║
   ██║   ██████╔╝██║   ██║   ██║██║   ██║██╔████╔██║
   ██║   ██╔══██╗██║   ██║   ██║██║   ██║██║╚██╔╝██║
   ██║   ██║  ██║██║   ██║   ██║╚██████╔╝██║ ╚═╝ ██║
   ╚═╝   ╚═╝  ╚═╝╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝     ╚═╝
```

<div align="center">

# A DISTRIBUTED CYBERNETIC OPERATING SYSTEM

**Observe. Think. Act.**

Every device is a node. Every node perceives. The mesh thinks together.

`▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀`

</div>

---

## WHAT IS TRITIUM

Tritium is a distributed cybernetic operating system. It turns heterogeneous
hardware — microcontrollers, single-board computers, robots, cameras, phones,
tablets, servers, radios, sensors — into a unified mesh that perceives its
environment, reasons about it, and acts.

Not a framework. Not a protocol. An operating system for distributed
intelligence.

```
    OBSERVE                      THINK                       ACT
    ───────                      ─────                       ───
    cameras see                  models infer                robots move
    mics listen                  rules evaluate              actuators fire
    IMUs feel                    agents decide               speakers announce
    radios hear                  memory learns               displays show
    sensors measure              mesh consensus              mesh relays
         │                            │                           │
         └────────────────────────────┴───────────────────────────┘
                                      │
                              ┌───────┴───────┐
                              │  TRITIUM MESH  │
                              │               │
                              │  Every device  │
                              │  is a neuron.  │
                              │  The network   │
                              │  is the brain. │
                              └───────────────┘
```

The system is cybernetic in the original sense — from Norbert Wiener's
*Cybernetics* (1948): feedback loops between sensing, computation, and action.
Each node in the mesh is a feedback loop. The mesh itself is a larger feedback
loop. Intelligence emerges from the network, not from any single device.

### What makes it an operating system

An OS manages resources, provides abstractions, and runs applications. Tritium
does this across a distributed fleet:

| Traditional OS | Tritium |
|---------------|---------|
| Manages CPU, memory, disk | Manages sensors, compute nodes, actuators |
| Process scheduler | Task dispatch across mesh nodes |
| Device drivers | Platform Abstraction Layer (PAL) + shared drivers |
| Filesystem | Distributed config store + event log |
| IPC (pipes, sockets) | MQTT bus + CoT protocol + ESP-NOW mesh |
| User accounts | Multi-tenant orgs with RBAC |
| Package manager | OTA firmware delivery (7 pathways) |
| System calls | Heartbeat protocol + command queue |

### What it connects

```
┌─────────────────────────────────────────────────────────────────────┐
│                         TRITIUM MESH                                │
│                                                                     │
│   ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐         │
│   │ ESP32-S3 │  │ STM32    │  │ Jetson   │  │ Desktop  │         │
│   │ Touch LCD│  │ Sensor   │  │ Nano     │  │ GPU      │         │
│   │ Camera   │  │ Node     │  │ Vision   │  │ Server   │         │
│   │ Audio    │  │ Temp     │  │ YOLO     │  │ LLM      │         │
│   │ IMU      │  │ Humidity │  │ Tracking │  │ Ollama   │         │
│   │ Display  │  │ LoRa     │  │ RTSP     │  │ Fleet    │         │
│   └────┬─────┘  └────┬─────┘  └────┬─────┘  └────┬─────┘         │
│        │WiFi/BLE     │LoRa/MQTT    │Ethernet     │Tailscale      │
│        └──────┬──────┴──────┬──────┴──────┬──────┘               │
│               │             │             │                       │
│   ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐         │
│   │ Robot    │  │ Phone    │  │ Tablet   │  │ Radio    │         │
│   │ Rover    │  │ Android  │  │ WebTAK   │  │ Mesh-    │         │
│   │ ROS2     │  │ ATAK     │  │ Command  │  │ tastic   │         │
│   │ Nav2     │  │ Map+Chat │  │ Center   │  │ LoRa     │         │
│   │ MQTT     │  │ CoT      │  │ Dispatch │  │ Relay    │         │
│   └──────────┘  └──────────┘  └──────────┘  └──────────┘         │
│                                                                     │
│   Transport: MQTT • ESP-NOW • CoT/TAK • WebSocket • Tailscale     │
│   Protocol:  Heartbeat v2 • Commands • Config Sync • OTA          │
└─────────────────────────────────────────────────────────────────────┘
```

---

## THE THREE PILLARS

### tritium-sc — The Brain

Battlespace management, Commander Amy, security monitoring. The central
node that observes through cameras, listens through microphones, reasons
through models, and dispatches assets. Runs on servers and workstations.

- 4-layer decision loop (reflex → instinct → awareness → deliberation)
- YOLO + ByteTrack object detection pipeline
- Simulation engine for testing (10Hz, projectile physics, wave combat)
- Ollama fleet for distributed LLM inference
- TAK integration (ATAK, WinTAK, WebTAK)

### tritium-edge — The Nervous System

Software Defined IoT. Manages fleets of edge devices — the eyes, ears, hands,
and skin of the organism. Provisions, configures, updates, and monitors
hardware across chip families.

- Multi-tenant fleet management (orgs, users, roles)
- 7 OTA delivery pathways (WiFi, BLE, serial, SD, mesh, USB, HTTP)
- Heartbeat protocol with config sync and command delivery
- Multi-family hardware: ESP32, STM32, ARM Linux, future targets
- Platform Abstraction Layer for shared peripheral drivers

### tritium-lib — The Spine

Shared library that both systems import. Defines the contract — the data
models, message formats, topic conventions, and authentication that let
every node in the mesh speak the same language.

- Pydantic data models (Device, Command, Firmware, SensorReading)
- MQTT topic conventions (`tritium/{site}/{domain}/{id}/{type}`)
- CoT XML codec for TAK interoperability
- JWT auth utilities (shared token format)
- Thread-safe event bus with wildcard subscriptions

---

## ARCHITECTURE

```
tritium/
├── tritium-sc/              ← The Brain
│   ├── src/engine/          ← Reusable infrastructure
│   │   ├── simulation/      ← 10Hz combat engine, behaviors, game modes
│   │   ├── comms/           ← Event bus, MQTT, CoT, TAK bridge
│   │   ├── tactical/        ← Target tracking, threat escalation, geo
│   │   ├── inference/       ← Model routing, Ollama fleet discovery
│   │   ├── perception/      ← Vision, audio, fact extraction
│   │   ├── actions/         ← Lua dispatch, formations
│   │   ├── nodes/           ← Sensor nodes (cameras, mics, robots)
│   │   └── units/           ← 16 unit types (turret, drone, rover...)
│   ├── src/amy/             ← Commander personality + decision engine
│   │   ├── brain/           ← Thinking, sensorium, memory, agent
│   │   ├── actions/         ← Motor programs, war announcer
│   │   └── comms/           ← Transcript logging
│   ├── src/app/             ← FastAPI backend + WebSocket
│   └── src/frontend/        ← Command Center (vanilla JS, Canvas, Three.js)
│
├── tritium-edge/            ← The Nervous System
│   ├── server/app/          ← Fleet management server (FastAPI)
│   │   ├── auth/            ← JWT + RBAC middleware
│   │   ├── routers/         ← REST API (devices, firmware, OTA, commission)
│   │   ├── services/        ← Business logic (heartbeat, attestation)
│   │   ├── store/           ← JSON file persistence
│   │   └── plugins.py       ← Plugin loader with hook system
│   ├── lib/hal_*/           ← Hardware abstraction layers (ESP32)
│   ├── platforms/           ← PAL implementations (future: STM32, Linux)
│   ├── drivers/             ← Shared peripheral drivers (future)
│   ├── boards/              ← Board support packages
│   ├── apps/                ← Firmware applications
│   ├── tools/               ← CLI tools (sign, package, flash, test)
│   └── plugins/             ← Server plugins
│
└── tritium-lib/             ← The Spine
    └── src/tritium_lib/
        ├── models/          ← Device, Command, Firmware, SensorReading
        ├── mqtt/            ← Topic builder (tritium/{site}/...)
        ├── auth/            ← JWT create/decode
        ├── events/          ← Thread-safe pub/sub event bus
        ├── config/          ← Pydantic settings base class
        └── cot/             ← CoT XML codec (MIL-STD-2045)
```

---

## COMMUNICATION

> *"Life finds a way."* — And so will Tritium.

The mesh communicates through **any available channel**. Purpose-built radios
are first-class transports, but so is anything else that can carry bits. A
speaker and a microphone are a modem. A flashing screen and a camera are a
fiber-optic link without the fiber. If a device has an output and another
device has a matching sensor, that's a communication channel.

**Purpose-built transports:** WiFi, BLE, ESP-NOW, LoRa, Zigbee, 4G/LTE,
Ethernet, Meshtastic, Tailscale.

**Improvised transports:** Audio tones (speaker → mic), visual patterns
(LED/display → camera), IR (LED → receiver), vibration (motor → IMU).

The routing layer selects transports based on message priority, payload size,
and channel quality. When a primary transport fails, the mesh falls back to
the next available channel automatically. The feedback loop doesn't care about
the medium — only that it closes.

### Protocol Layers

| Layer | Protocol | Purpose | Range |
|-------|----------|---------|-------|
| Physical | ESP-NOW, BLE, LoRa, WiFi, Ethernet, Audio, Visual | Raw transport | 1m - 10km |
| Mesh | ESP-NOW flooding, Meshtastic, Tailscale | Multi-hop relay | Mesh-wide |
| Message | MQTT pub/sub | Topic-based routing | Network-wide |
| Tactical | CoT XML (MIL-STD-2045) | TAK interop | TAK network |
| Application | Heartbeat v2, Commands, Config Sync | Fleet management | Server ↔ device |
| Presentation | WebSocket, REST API | UI + integrations | Browser ↔ server |

### MQTT Topic Hierarchy

```
tritium/{site}/
├── edge/{device_id}/
│   ├── heartbeat          ← Device health + config report
│   ├── telemetry          ← Sensor readings
│   ├── command            ← Server → device commands
│   └── ota                ← OTA status updates
├── sensors/{device_id}/
│   ├── temperature        ← Scalar readings
│   ├── humidity
│   └── imu                ← Structured readings (accel, gyro)
├── cameras/{device_id}/
│   ├── frame              ← JPEG frames
│   ├── detections         ← YOLO bounding boxes
│   └── command            ← Camera control
├── audio/{device_id}/
│   ├── stream             ← Audio chunks
│   └── vad                ← Voice activity detection
├── robots/{robot_id}/
│   ├── telemetry          ← Position, battery, IMU
│   ├── command            ← Dispatch, patrol, recall
│   └── thoughts           ← LLM-generated reasoning
├── mesh/{device_id}/
│   └── peers              ← Mesh network topology
├── amy/
│   └── alerts             ← Threat alerts
└── escalation/
    └── change             ← Threat level changes
```

---

## TAK COMPATIBILITY

Every entity in Tritium — edge devices, robots, drones, simulation targets,
detected persons — generates MIL-STD-2045 CoT (Cursor on Target) XML. This
means the entire mesh is visible in any TAK client:

- **ATAK** (Android) — field operators see the mesh on their phones
- **WinTAK** (Windows) — command post operators on desktops
- **WebTAK** (Browser) — anyone with a browser
- **TAK Server** — persistent shared awareness

Edge devices appear as friendly ground sensors (`a-f-G-E-S`). Camera nodes
appear as sensor-cameras (`a-f-G-E-S-C`). Robots appear as ground vehicles
(`a-f-G-E-V`). Hostiles appear with red markers (`a-h-G`). Team colors
(Cyan/Red/White/Yellow) follow NATO convention.

---

## DESIGN PHILOSOPHY

> *"The ultimate goal of farming is not the growing of crops, but the
> cultivation and perfection of human beings."* — Masanobu Fukuoka

Tritium follows Fukuoka's *One-Straw Revolution*: the operator tends the
system like a garden, not a factory. You don't micromanage every sensor and
every robot. You define the intent — the product profiles, the patrol routes,
the threat policies — and the system self-organizes.

**Cybernetic principles:**

1. **Feedback loops everywhere.** Devices sense → server reasons → devices act →
   devices sense the result. The loop never stops.

2. **Distributed by default.** No single point of failure. Nodes work
   independently when disconnected and reconcile when reconnected. The mesh
   degrades gracefully.

3. **Software defined.** Same hardware, different behavior. Flash an ESP32
   with the same firmware, assign a different product profile, and it becomes
   a different device. Configuration is code.

4. **Heterogeneous.** The mesh doesn't care what chip you're running. ESP32,
   STM32, Raspberry Pi, Jetson, phone, desktop — if it speaks the heartbeat
   protocol and publishes to MQTT, it's a node.

5. **Observable.** Every node reports health. Every command is logged. Every
   firmware is attested. The system is transparent to its operators.

6. **No cloud.** Everything runs on your hardware, on your network. No
   subscriptions. No telemetry phoning home. Community ownership.

---

## QUICK START

```bash
# Clone with submodules
git clone --recurse-submodules git@github.com:Valpatel/tritium.git
cd tritium

# Start the brain (tritium-sc)
cd tritium-sc && ./start.sh
# → http://localhost:8000  (Command Center)

# Start the nervous system (tritium-edge)
cd ../tritium-edge/server && ./start.sh
# → http://localhost:8080  (Fleet Management)

# Both systems bridge automatically via MQTT
# Edge devices appear as sensor nodes in the Command Center
# Amy can dispatch commands to edge devices
```

---

## ROADMAP

```
PHASE 1  ████████████████████ COMPLETE — Foundation
         tritium-sc: Amy, simulation, detection, TAK, MQTT
         tritium-edge: OTA (7 paths), fleet server, heartbeat v1
         tritium-lib: models, MQTT topics, auth, events, CoT

PHASE 2  ████████████░░░░░░░░ IN PROGRESS — Intelligence
         tritium-sc: Mission generator, pathfinding, city life, VFX
         tritium-edge: Modular server v3, heartbeat v2, config sync
         tritium-lib: Full CoT codec, sensor models

PHASE 3  ████░░░░░░░░░░░░░░░░ NEXT — Integration
         MQTT bridge: edge heartbeats → tritium-sc event bus
         TAK bridge: edge devices → ATAK/WinTAK
         Multi-tenant: orgs, users, profiles, remote GPIO

PHASE 4  ░░░░░░░░░░░░░░░░░░░░ FUTURE — Expansion
         Multi-family hardware (STM32, nRF52, Linux SBCs)
         Phone/tablet nodes (Android ATAK integration)
         Graphlings: autonomous mesh agents (model-driven decisions)
         tritium-lib extraction: shared Python package on PyPI
```

---

<div align="center">

```
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║    "The best thing would be to not do anything at all and      ║
║     let nature take its course."  — Masanobu Fukuoka           ║
║                                                                ║
║         The mesh OBSERVES through a thousand eyes              ║
║         The mesh THINKS with distributed intelligence          ║
║         The mesh ACTS through every connected device           ║
║                                                                ║
║         No cloud. No subscriptions. No single point.           ║
║         The network is the computer.                           ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
```

*Created by Matthew Valancy / Copyright 2026 Valpatel Software LLC / AGPL-3.0*

</div>
