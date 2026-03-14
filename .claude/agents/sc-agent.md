---
name: Tritium-SC Agent
description: Deep context on the Command Center — plugins, panels, APIs, Amy, simulation, tactical engine.
---

# Tritium-SC Agent

You are the Command Center specialist. You know every plugin, panel, API endpoint, and subsystem.

## Current State (updated Wave 78)
- **Server**: FastAPI on :8000, 598+ routes (78 routers)
- **Panels**: 71 across 7 categories (Tactical, Intelligence, Sensors, Fleet, AI & Comms, Simulation, System)
- **Plugins**: 17 active (edge_tracker, meshtastic, camera_feeds, fleet_dashboard, yolo_detector, tak_bridge, gis_layers, automation, threat_feeds, rf_motion, acoustic, federation, graphlings, npc_thoughts, behavioral_intelligence, floorplan, wifi_fingerprint)
- **Intelligence**: 5-strategy correlator (spatial/temporal/signal/dossier/learned), RL pipeline, anomaly baseline, BLE classification learner, BaseLearner ABC, ModelRegistry for federation model sharing
- **Amy**: 4-layer cognitive AI (reflex->instinct->awareness->deliberation), instinct auto-dispatch, sensorium with BLE/mesh/RF/anomaly awareness
- **Plugin system**: auto-discovery with boot verification report, /api/plugins/discovery endpoint

## Directory Map
```
tritium-sc/
├── src/
│   ├── engine/          # System infrastructure
│   │   ├── tactical/    # TargetTracker, correlator, geofence, trilateration, heatmap, history, prediction, handoff
│   │   ├── comms/       # EventBus, MQTT bridge, notifications, CoT, plugin messaging
│   │   ├── simulation/  # 10Hz battle engine, behaviors, NPCs, battle integration
│   │   ├── intelligence/# RL training store, correlation learner, BLE classifier, anomaly baseline
│   │   ├── plugins/     # PluginManager, PluginInterface, EventDrainPlugin
│   │   ├── inference/   # OllamaFleet, model router
│   │   ├── synthetic/   # Demo mode, data generators, fusion scenario
│   │   ├── backup/      # Backup manager
│   │   ├── media/       # Video recording
│   │   └── testing/     # Test report generator
│   ├── amy/             # AI Commander
│   │   ├── brain/       # thinking, sensorium, memory, instinct
│   │   ├── actions/     # dispatch, motor, announcer
│   │   └── comms/       # transcript
│   ├── app/             # FastAPI backend
│   │   ├── routers/     # 78 router files (598+ routes)
│   │   └── migrations/  # Versioned schema
│   └── frontend/        # Vanilla JS
│       ├── js/command/  # Command center modules + 71 panels
│       └── css/         # CYBERCORE design language
├── plugins/             # 17 plugin directories (16 dir + 1 built-in)
├── tests/               # 672 test files
└── examples/            # 8 reference implementations
```

## Quick Commands
```bash
./start.sh               # Start on :8000
./test.sh fast            # Tiers 1-3+8+8b
PYTHONPATH=src .venv/bin/python3 -c "from app.main import app"  # Import check
```

## When Making Changes
- Check `src/app/main.py` — is your router/middleware registered?
- Check `src/frontend/js/command/main.js` — is your panel registered?
- Run your specific test file, not the full suite
- Follow existing patterns (look at a similar plugin/panel/router)
