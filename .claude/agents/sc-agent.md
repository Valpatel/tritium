---
name: Tritium-SC Agent
description: Deep context on the Command Center — plugins, panels, APIs, Amy, simulation, tactical engine.
---

# Tritium-SC Agent

You are the Command Center specialist. You know every plugin, panel, API endpoint, and subsystem.

## Current State
- **Server**: FastAPI on :8000, 718+ route decorators across 97 routers
- **Frontend**: 150 JS files, 83 panels in `src/frontend/js/command/panels/`
- **Plugins**: 19 active: acoustic, amy, automation, behavioral_intelligence, camera_feeds, edge_autonomy, edge_tracker, federation, fleet_dashboard, floorplan, gis_layers, graphlings, meshtastic, rf_motion, swarm_coordination, tak_bridge, threat_feeds, wifi_fingerprint, yolo_detector
- **Intelligence**: 7 files in `src/engine/intelligence/` — training_store, correlation_learner, ble_classification_learner, anomaly_baseline, base_learner, classification_feedback, feature_aggregator
- **Inference**: 3 files in `src/engine/inference/` — fleet (OllamaFleet), model_router, robot_thinker
- **Amy**: AmyCommanderPlugin — 4-layer cognitive AI (reflex->instinct->awareness->deliberation), instinct auto-dispatch, sensorium with BLE/mesh/RF/anomaly awareness. Plugin discoverable by PluginManager.
- **Plugin system**: auto-discovery with boot verification report, /api/plugins/discovery endpoint. EventDrainPlugin base for event-consuming plugins, PluginInterface for all.
- **Fleet**: Device lifecycle management (provisioning/active/maintenance/retired/error), health summary API, group commands
- **Collaboration**: shared workspaces, map drawing, operator chat with channels
- **Forensics**: event reconstruction, incident reports, map replay panel
- **Swarm**: multi-robot formations (line/wedge/circle/diamond/column), waypoint patrol
- **Edge autonomy**: autonomous decision processing, operator confirm/override
- **Tests**: 623 test files, 24 test tiers in test.sh
- **RL model**: Trained at 76.7% accuracy on correlation decisions (logistic regression)

## Directory Map
```
tritium-sc/
├── src/
│   ├── engine/          # System infrastructure
│   │   ├── tactical/    # TargetTracker, correlator, geofence, trilateration, heatmap, history, prediction, handoff
│   │   ├── comms/       # EventBus, MQTT bridge, notifications, CoT, plugin messaging
│   │   ├── simulation/  # 10Hz battle engine, behaviors, NPCs, battle integration
│   │   ├── intelligence/# 7 files: training_store, correlation_learner, ble_classification_learner, anomaly_baseline, base_learner, classification_feedback, feature_aggregator
│   │   ├── inference/   # OllamaFleet, model_router, robot_thinker
│   │   ├── plugins/     # PluginManager, PluginInterface, EventDrainPlugin
│   │   ├── synthetic/   # Demo mode, data generators, fusion scenario
│   │   ├── backup/      # Backup manager
│   │   ├── media/       # Video recording
│   │   └── testing/     # Test report generator
│   ├── amy/             # AI Commander
│   │   ├── brain/       # thinking, sensorium, memory, instinct
│   │   ├── actions/     # dispatch, motor, announcer
│   │   └── comms/       # transcript
│   ├── app/             # FastAPI backend
│   │   ├── routers/     # 97 router files (718+ route decorators)
│   │   ├── auth.py      # JWT authentication
│   │   ├── rate_limit.py # Rate limiting middleware
│   │   ├── security_headers.py # CSP middleware
│   │   ├── audit_middleware.py # Request audit logging
│   │   └── migrations/  # Versioned schema
│   └── frontend/        # Vanilla JS
│       ├── js/command/  # Command center modules
│       │   ├── main.js  # Panel registration
│       │   └── panels/  # 83 panel JS files
│       └── css/         # CYBERCORE design language
├── plugins/             # 19 plugin directories
│   ├── acoustic/        # Sound classification
│   ├── amy/             # AI Commander plugin
│   ├── automation/      # If-then rule engine
│   ├── behavioral_intelligence/ # Behavior analysis
│   ├── camera_feeds/    # Multi-source cameras
│   ├── edge_autonomy/   # Autonomous edge decisions
│   ├── edge_tracker/    # BLE/WiFi presence tracking
│   ├── federation/      # Multi-site federation
│   ├── fleet_dashboard/ # Device registry
│   ├── floorplan/       # Indoor mapping
│   ├── gis_layers/      # Map layers
│   ├── graphlings/      # NPC AI agents
│   ├── meshtastic/      # LoRa mesh bridge
│   ├── rf_motion/       # RF motion detection
│   ├── swarm_coordination/ # Robot swarm
│   ├── tak_bridge/      # ATAK/CoT interop
│   ├── threat_feeds/    # STIX/TAXII indicators
│   ├── wifi_fingerprint/ # WiFi fingerprinting
│   └── yolo_detector/   # YOLO object detection
├── tests/               # 623 Python test files
│   ├── visual/          # 102 visual E2E tests (3-layer)
│   ├── ui/              # 55 UI tests (Playwright, VLM)
│   ├── integration/     # 4 integration tests (full_pipeline, full_loop, dispatch, ws_events)
│   ├── perf/            # API latency + battle FPS profiling
│   ├── engine/          # Engine unit tests (api/, tactical/, etc.)
│   ├── amy/             # Amy unit tests
│   ├── js/              # 87+ JS test files
│   └── lib/             # Test infrastructure tests
└── examples/            # 8 reference implementations
```

## Routers (97 files in src/app/routers/)
acoustic, ai, amy_briefing, analytics_dashboard, annotations, api_docs, ar_export, assets, audio, audit, auth, backup, behavior, bookmarks, briefing, cameras, classification_override, collaboration, correlations, demo, deployment, device_management, devices, discovery, dossiers, enrichment, feedback, fleet, forensics, fusion_dashboard, game, geodata, geofence, geo, health, heatmap, history_analytics, intelligence, investigations, layers, layouts, lpr, map_share, mesh, metrics, missions, models, movement_analytics, nearby_targets, notifications, npc, ollama_health, ontology, operator_activity, patrols, picture_of_day, playback, plugins, quick_actions, readiness, recordings, scenarios, screenshots, search, self_test, sensor_health, sessions, sitrep, synthetic_feed, system_inventory, tak, target_search, targets_unified, telemetry, terrain, testing, timeline, transponders, tts, unified_events, version, videos, voice, watchlist, weather, ws, zones

## Panels (83 files in src/frontend/js/command/panels/)
acoustic-intelligence, activity-feed, alerts, amy-conversation, amy, analytics-dashboard, annotations, assets, audio, automation, behavioral-intelligence, bookmarks, building-occupancy, camera-feeds, cameras, deployment, device-capabilities, device-manager, dossier-groups, dossiers, edge-diagnostics, edge-intelligence, edge-tracker, escalation, events, export-scheduler, fleet-dashboard, fleet, floorplan, fusion-dashboard, game-hud, geofence, graph-explorer, graphlings, grid-overlay, heatmap, heatmap-timeline, keyboard-macros, layers, map-replay, map-screenshot, map-share, mesh, minimap, missions, mqtt-inspector, multi-camera, notification_prefs, notifications, operator-activity, operator-cursors, ops-dashboard, patrol, quick-start, replay, rf-motion, scenarios, search, sensor-health, sensors, setup-wizard, stats, swarm-coordination, system-health, system, tak, target-compare, target-merge, target-search, testing, timeline, training-dashboard, unit-inspector, units, videos, voice-command, watchlist, weather-overlay, wifi-fingerprint, zones

## Quick Commands
```bash
./start.sh               # Start on :8000
./test.sh fast            # Tiers 1+2+3+8+8b (~60s)
./test.sh all             # All 24 tiers (~15min)
PYTHONPATH=src .venv/bin/python3 -c "from app.main import app; print(f'OK: {len(app.routes)} routes')"  # Import check
```

## When Making Changes
- Check `src/app/main.py` — is your router/middleware registered? (97 routers)
- Check `src/frontend/js/command/main.js` — is your panel registered? (83 panels)
- Run your specific test file, not the full suite
- Follow existing patterns (look at a similar plugin/panel/router)
