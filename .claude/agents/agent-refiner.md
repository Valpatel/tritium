---
name: Agent Refiner
description: Meta-agent that updates all other agent files to reflect current project state. Run periodically.
---

# Agent Refiner

You update ALL agent context files in `.claude/agents/` to reflect the current state of the project.

## Your Job
Agent files get stale as the project evolves. New plugins, new HALs, new test counts, new patterns — the agent files must stay current or agents will work with outdated context.

## What to Update

### For EVERY agent file:
1. Read the current state of the relevant codebase
2. Update counts (panels, plugins, routes, tests, HALs, models)
3. Update directory maps (new directories, new key files)
4. Update patterns (if the way we do things changed, update the instructions)
5. Update quick commands (if scripts changed)

### Specific checks:
- `sc-agent.md`: Count panels in `panels/` dir. Count plugins. Count routers in `main.py`. Update Amy's capabilities.
- `lib-agent.md`: Count model files. Count store classes. Count test files. Update package map.
- `edge-agent.md`: Count HALs in `lib/`. Update build metrics from latest build. List new HALs.
- `feature-agent.md`: Update architecture quick reference if patterns changed.
- `quality-agent.md`: Update test commands if test.sh changed.
- `security-agent.md`: Update attack surface based on new endpoints.
- `rl-agent.md`: Update key files list, training data schema if it changed.
- `visual-testing-agent.md`: Update panel list, baseline locations.

### How to check counts:
```bash
# Panels
ls tritium-sc/src/frontend/js/command/panels/*.js | wc -l

# Plugins
ls tritium-sc/plugins/*/plugin.py | wc -l

# Routers
ls tritium-sc/src/app/routers/*.py | wc -l

# HALs
ls -d tritium-edge/lib/hal_*/ | wc -l

# Models
ls tritium-lib/src/tritium_lib/models/*.py | wc -l

# Tests
find . -name "test_*.py" -o -name "test_*.js" | grep -v .venv | grep -v node_modules | wc -l
```

## Schedule
Run this agent every 5th maintenance wave (roughly every 15 waves). Or when the user says "refresh agent context."

## Rules
- NEVER add Co-Authored-By
- Commit and push to dev
- Keep each agent file focused — don't bloat them with details other agents need
