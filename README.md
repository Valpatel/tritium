```
████████╗██████╗ ██╗████████╗██╗██╗   ██╗███╗   ███╗
╚══██╔══╝██╔══██╗██║╚══██╔══╝██║██║   ██║████╗ ████║
   ██║   ██████╔╝██║   ██║   ██║██║   ██║██╔████╔██║
   ██║   ██╔══██╗██║   ██║   ██║██║   ██║██║╚██╔╝██║
   ██║   ██║  ██║██║   ██║   ██║╚██████╔╝██║ ╚═╝ ██║
   ╚═╝   ╚═╝  ╚═╝╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝     ╚═╝
```

# Tritium

A distributed cybernetic operating system for IoT fleets.

## What It Does

- **Runs on real hardware.** A custom real-time OS for six Waveshare ESP32-S3 boards with touch displays, BLE, WiFi, LoRa, and mesh networking.
- **Manages your fleet.** A server that handles device provisioning, over-the-air firmware updates, and live monitoring of every node.
- **Command Center.** A tactical dashboard with a map view, an AI commander, and a plugin system you can extend.
- **Shared foundation.** A common library for data models, events, MQTT messaging, and authentication -- used by every component.

Everything runs on your own hardware. No cloud accounts, no subscriptions, fully offline capable.

## The Three Pieces

This repo is the parent. The actual code lives in three submodules:

- [**tritium-edge**](https://github.com/Valpatel/tritium-edge) -- The IoT side: ESP32-S3 firmware (Tritium-OS) and the fleet management server.
- [**tritium-sc**](https://github.com/Valpatel/tritium-sc) -- The Command Center: web dashboard, AI commander, vision pipelines, plugin system.
- [**tritium-lib**](https://github.com/Valpatel/tritium-lib) -- The shared library: data models, MQTT topics, JWT auth, event bus.

Each submodule has its own README with full details.

## Quick Start

```bash
# Clone everything (including submodules)
git clone --recurse-submodules git@github.com:Valpatel/tritium.git
cd tritium

# Start the servers
./start.sh              # Edge server (:8080) + Command Center (:5000)

# Flash a board (from the edge submodule)
cd tritium-edge
make flash BOARD=touch-lcd-349
```

The board will auto-connect to the fleet server at `http://localhost:8080`.

## Where To Go Next

- **Hardware and firmware** -- [tritium-edge README](https://github.com/Valpatel/tritium-edge)
- **Command Center** -- [tritium-sc README](https://github.com/Valpatel/tritium-sc)
- **Shared library** -- [tritium-lib README](https://github.com/Valpatel/tritium-lib)

---

<div align="center">

Copyright 2026 Valpatel Software LLC -- Licensed under AGPL-3.0

</div>
