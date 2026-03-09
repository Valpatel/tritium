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

## What Is Tritium?

Tritium turns heterogeneous hardware — cameras, sensors, radios, robots — into
a **distributed mesh** that senses, reasons, and acts as one. Nodes communicate
through whatever channel is available (WiFi, BLE, ESP-NOW, LoRa, even acoustic)
and self-organize without central infrastructure.

**Local-first.** Everything runs on your hardware. No subscriptions, no
telemetry. Optional cloud bridge when you choose — but the mesh operates fully
offline.

**TAK compatible.** Every entity generates MIL-STD-2045 CoT XML, visible in
ATAK, WinTAK, and WebTAK.

**AGPL-3.0.** The code stays open. The mesh spreads, and so does the source.

## Repository Structure

This is the top-level repo. Tritium is split into three submodules:

| Submodule | Purpose |
|-----------|---------|
| [**tritium-edge**](https://github.com/Valpatel/tritium-edge) | Software Defined IoT — ESP32-S3 firmware (Tritium-OS), fleet server, device management, OTA |
| [**tritium-sc**](https://github.com/Valpatel/tritium-sc) | Command Center — battlespace management, Commander Amy, vision pipelines, TAK bridge |
| [**tritium-lib**](https://github.com/Valpatel/tritium-lib) | Shared library — data models, MQTT topics, JWT auth, event bus, CoT codec |

Each submodule has its own README and `docs/` folder with detailed documentation.

## Quick Start

```bash
git clone --recurse-submodules git@github.com:Valpatel/tritium.git
cd tritium

# Start services
./start.sh              # Edge Server (:8080) + SC (:5000) + MQTT check
./start.sh edge         # Edge server only
./start.sh sc           # SC only
./start.sh stop         # Stop all services

# Flash an ESP32 node
cd tritium-edge
make flash BOARD=touch-lcd-349   # Default starfield app
# Node auto-connects to fleet server at http://localhost:8080
```

## Submodule Branches

All submodules track `dev` by default. Use the branch management script to
switch all submodules at once:

```bash
./switch-branches.sh        # Switch all to dev (default)
./switch-branches.sh main   # Switch all to main (production)
```

## Documentation

Detailed docs live in each submodule:

- **Firmware & hardware** → `tritium-edge/docs/` and `tritium-edge/CLAUDE.md`
- **Fleet server API** → `tritium-edge/server/`
- **Command Center** → `tritium-sc/docs/`
- **Shared models & protocols** → `tritium-lib/README.md`

---

<div align="center">

*Created by Matthew Valancy / Copyright 2026 Valpatel Software LLC / AGPL-3.0*

</div>
