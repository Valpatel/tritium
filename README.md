```
████████╗██████╗ ██╗████████╗██╗██╗   ██╗███╗   ███╗
╚══██╔══╝██╔══██╗██║╚══██╔══╝██║██║   ██║████╗ ████║
   ██║   ██████╔╝██║   ██║   ██║██║   ██║██╔████╔██║
   ██║   ██╔══██╗██║   ██║   ██║██║   ██║██║╚██╔╝██║
   ██║   ██║  ██║██║   ██║   ██║╚██████╔╝██║ ╚═╝ ██║
   ╚═╝   ╚═╝  ╚═╝╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝     ╚═╝
```

<div align="center">

# A Distributed Cybernetic Operating System

**Observe. Think. Act.**

Every device is a node. Every node perceives. The mesh thinks together.

</div>

---

## The Problem

You have cameras, sensors, robots, radios, servers, phones, tablets — dozens
of devices from different manufacturers running different chips. Getting them
to **work together** means gluing APIs, writing adapters, babysitting
connections, and praying nothing crashes at 3am.

There is no operating system for a fleet of heterogeneous hardware. Until now.

## The Vision

Tritium turns every electronic device into a **neuron in a distributed brain**.
Cameras see. Microphones listen. Sensors measure. Models reason. Robots act.
The mesh connects them all through whatever channel is available — WiFi, BLE,
LoRa, even sound and light.

```mermaid
graph TB
    subgraph OBSERVE["OBSERVE"]
        CAM[Cameras]
        MIC[Microphones]
        IMU[IMUs]
        SENS[Sensors]
        RAD[Radios]
    end

    subgraph THINK["THINK"]
        MOD[Models infer]
        RULE[Rules evaluate]
        MEM[Memory learns]
        MESH[Mesh consensus]
    end

    subgraph ACT["ACT"]
        ROB[Robots move]
        ACT2[Actuators fire]
        SPK[Speakers announce]
        DISP[Displays show]
        RELAY[Mesh relays]
    end

    OBSERVE --> THINK --> ACT --> OBSERVE

    style OBSERVE fill:#0d1117,stroke:#00f0ff,color:#00f0ff
    style THINK fill:#0d1117,stroke:#ff2a6d,color:#ff2a6d
    style ACT fill:#0d1117,stroke:#05ffa1,color:#05ffa1
```

The feedback loop never stops. That's cybernetics — from Norbert Wiener's
*Cybernetics* (1948). Sensing, computation, action, repeat. Each device is a
loop. The mesh is a larger loop. Intelligence emerges from the network, not
from any single device.

## What Makes It an OS

An operating system manages resources, provides abstractions, and runs
applications. Tritium does this across a distributed fleet:

```mermaid
graph LR
    subgraph Traditional["Traditional OS"]
        CPU[CPU + Memory]
        SCHED[Process Scheduler]
        DRV[Device Drivers]
        FS[Filesystem]
        IPC[IPC]
    end

    subgraph Tritium["Tritium"]
        NODES[Sensors + Compute + Actuators]
        DISPATCH[Task Dispatch Across Mesh]
        PAL[Platform Abstraction Layer]
        STORE[Distributed Config + Event Log]
        MQTT[MQTT + CoT + ESP-NOW]
    end

    CPU -.- NODES
    SCHED -.- DISPATCH
    DRV -.- PAL
    FS -.- STORE
    IPC -.- MQTT

    style Traditional fill:#0d1117,stroke:#00f0ff,color:#00f0ff
    style Tritium fill:#0d1117,stroke:#05ffa1,color:#05ffa1
```

## The Three Pillars

```mermaid
graph TB
    SC["tritium-sc<br/><b>The Brain</b><br/>Command + control, vision,<br/>audio, models, TAK integration"]
    EDGE["tritium-edge<br/><b>The Nervous System</b><br/>Fleet management, OTA, config,<br/>heartbeat, multi-family hardware"]
    LIB["tritium-lib<br/><b>The Spine</b><br/>Shared models, MQTT topics,<br/>auth, events, CoT codec"]

    SC <--> LIB
    EDGE <--> LIB
    SC <-->|"MQTT bus"| EDGE

    style SC fill:#0d1117,stroke:#ff2a6d,color:#ff2a6d
    style EDGE fill:#0d1117,stroke:#00f0ff,color:#00f0ff
    style LIB fill:#0d1117,stroke:#05ffa1,color:#05ffa1
```

| Pillar | Role | What It Does |
|--------|------|-------------|
| **tritium-sc** | The Brain | Battlespace management, Commander Amy, vision pipelines, target tracking, TAK bridge, simulation engine |
| **tritium-edge** | The Nervous System | Software Defined IoT. Manages fleets of ESP32, STM32, ARM Linux devices. OTA, config sync, heartbeat protocol |
| **tritium-lib** | The Spine | Shared library. Data models, MQTT topics, JWT auth, event bus, CoT XML codec. The contract that lets every node speak the same language |

## The Mesh Communicates Through Everything

> *"Life finds a way."* — And so will Tritium.

The mesh doesn't privilege any single radio. Every available channel is a
transport — purpose-built or improvised:

```mermaid
graph TB
    subgraph Radios["Purpose-Built"]
        WIFI[WiFi]
        BLE[BLE]
        ESPNOW[ESP-NOW]
        LORA[LoRa]
        ZIG[Zigbee]
        LTE[4G/LTE]
    end

    subgraph Improvised["Improvised"]
        AUDIO["Speaker → Mic<br/>(audio tones)"]
        VISUAL["LED → Camera<br/>(flash patterns)"]
        IR["IR LED → Receiver"]
        VIB["Motor → IMU<br/>(vibration)"]
    end

    ROUTE["Mesh Routing Layer<br/>selects best available transport"]

    Radios --> ROUTE
    Improvised --> ROUTE

    style Radios fill:#0d1117,stroke:#00f0ff,color:#00f0ff
    style Improvised fill:#0d1117,stroke:#fcee0a,color:#fcee0a
    style ROUTE fill:#0d1117,stroke:#ff2a6d,color:#ff2a6d
```

If a device has an output and another device has a matching sensor, that's a
communication channel. When primary transports fail, the mesh falls back
automatically. The feedback loop doesn't care about the medium — only that it
closes.

## TAK Compatible

Every entity in the mesh — edge devices, robots, drones, detected targets —
generates MIL-STD-2045 CoT XML. The entire fleet is visible in any TAK client:
ATAK (Android), WinTAK (Windows), WebTAK (Browser).

## Quick Start

```bash
# Clone with submodules
git clone --recurse-submodules git@github.com:Valpatel/tritium.git
cd tritium

# Start the brain
cd tritium-sc && ./start.sh        # http://localhost:8000

# Start the nervous system
cd ../tritium-edge/server && ./start.sh   # http://localhost:8080

# Both bridge automatically via MQTT
```

## Design Philosophy

> *"The ultimate goal of farming is not the growing of crops, but the
> cultivation and perfection of human beings."* — Masanobu Fukuoka

You don't micromanage every sensor and every robot. You define the intent —
the profiles, the routes, the policies — and the system self-organizes.

- **Feedback loops everywhere.** Sense → compute → act → sense. The loop never stops.
- **Distributed by default.** No single point of failure. Nodes work independently when disconnected.
- **Software defined.** Same hardware, different behavior. Change the config, change the device.
- **Heterogeneous.** ESP32, STM32, Raspberry Pi, Jetson, phone, desktop — if it speaks heartbeat, it's a node.
- **Observable.** Every node reports health. Every command is logged. Every firmware is attested.
- **No cloud.** Everything runs on your hardware, on your network. No subscriptions. No telemetry phoning home.

## Deeper Documentation

| Document | Location |
|----------|----------|
| tritium-sc architecture | `tritium-sc/docs/` |
| tritium-edge architecture | `tritium-edge/docs/ARCHITECTURE.md` |
| Device protocol (heartbeat v2) | `tritium-edge/docs/DEVICE-PROTOCOL.md` |
| Multi-tenant design | `tritium-edge/docs/MULTI-TENANT.md` |
| Hardware abstraction (PAL) | `tritium-edge/docs/HARDWARE-ABSTRACTION.md` |
| Plugin system | `tritium-edge/docs/PLUGIN-SYSTEM.md` |
| Integration guide | `tritium-edge/docs/INTEGRATION.md` |
| Shared library (tritium-lib) | `tritium-lib/README.md` |

---

<div align="center">

*The mesh observes through a thousand eyes.*
*The mesh thinks with distributed intelligence.*
*The mesh acts through every connected device.*

*No cloud. No subscriptions. No single point.*
*The network is the computer.*

*Created by Matthew Valancy / Copyright 2026 Valpatel Software LLC / AGPL-3.0*

</div>
