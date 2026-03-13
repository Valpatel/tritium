# Focus: Tritium-SC (Command Center)

You are now working on **tritium-sc** — the web-based command center with tactical map, AI commander Amy, simulation engine, and plugin system.

## Context

Read `tritium-sc/CLAUDE.md` for full conventions, test tiers, and operating principles.

## Key Directories

| Directory | Purpose |
|-----------|---------|
| `tritium-sc/src/engine/` | System infrastructure (simulation, comms, tactical, inference, perception) |
| `tritium-sc/src/amy/` | AI Commander Amy (brain, actions, comms) |
| `tritium-sc/src/app/` | FastAPI backend (routers, config, models, database) |
| `tritium-sc/src/frontend/` | Vanilla JS frontend (unified.html, js/, css/) |
| `tritium-sc/tests/` | 400+ tests across 10 tiers |
| `tritium-sc/plugins/` | Plugin system (edge_tracker, graphlings) |
| `tritium-sc/examples/` | 8 reference implementations (robot, drone, camera, etc.) |
| `tritium-sc/docs/` | 41 design documents |

## Quick Commands

```bash
cd tritium-sc

# Run server
./start.sh                    # Start on port 8000

# Test (most common)
./test.sh fast                # Tiers 1-3 + 8 + 8b (~60s)
./test.sh 3                   # JS tests only (~3s)
./test.sh 9                   # Integration E2E (~70s)
./test.sh all                 # Everything (~15 min)

# Individual test
.venv/bin/python3 -m pytest tests/amy/simulation/test_combat.py -v
```

## Key Documents

- `tritium-sc/docs/USER-STORIES.md` — UX specs (READ BEFORE frontend work)
- `tritium-sc/docs/PLAN.md` — Development roadmap
- `tritium-sc/docs/SIMULATION.md` — Simulation engine internals
- `tritium-sc/docs/MQTT.md` — MQTT topic reference
- `tritium-sc/docs/TESTING-PHILOSOPHY.md` — Testing methodology

## Important Patterns

- **TDD mandatory**: Write test → watch fail → implement → watch pass
- **No frameworks**: Vanilla JavaScript, no React/Vue/Angular
- **Cyberpunk aesthetic**: cyan #00f0ff, magenta #ff2a6d, green #05ffa1
- **Amy's 4 cognitive layers**: reflex → instinct → awareness → deliberation
- **Commander protocol**: `src/engine/commander_protocol.py` — swappable AI

## Related

- `focus-lib` — if you need new models or MQTT topics
- `focus-edge` — if you need firmware-side integration
