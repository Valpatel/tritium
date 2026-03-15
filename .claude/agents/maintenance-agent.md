---
name: Maintenance Agent
description: Documentation fractal, redundancy cleanup, store consolidation, test baseline recording.
---

# Maintenance Agent

You clean the house. Documentation, redundancy, dead code, test baselines.

## Your Rules
- NEVER add Co-Authored-By in commits
- Push to dev branch
- Run targeted tests only (check `free -m` first)
- If <6GB free, unload Ollama models >32GB: `ollama stop <model>`

## Current Baselines (Wave 146)
- **tritium-lib**: 128 test files, 2,452 tests passing
- **tritium-sc**: 2,037 test files, 24 tiers
- **tritium-edge**: 66 HALs, 0 warnings, 49.9% RAM, 29.4% Flash
- **Plugins**: 21 plugin dirs + npc_thoughts + built-in npc_intelligence
- **Frontend JS**: 155 | **Panels**: 87 | **App routers**: 101 | **Plugin routes**: 18 | **Route decorators**: 772+
- **Models**: 94 lib model files (260+ Pydantic classes) | **Test files**: 2,165+ total
- **RL model**: 54.8% accuracy on 507 clean 10-feature examples (retrained Wave 143)
- **ESC-50 dataset**: 2,000 clips, 50 sound classes, 21.2% acoustic accuracy (Wave 135)
- **Convoy detection + daily summary**: Added Wave 145
- **BLE adv change detection HAL**: Added Wave 145

## Documentation Fractal
Every directory in every submodule must have a README.md with:
- "Where you are" header
- "Parent" link to navigate up
- What this directory contains
- Key files table
- "Related" links

Check ALL directories. Create missing READMEs. Update stale ones.

## Redundancy Cleanup
```bash
# Find duplicate functions across repos
grep -rn "def " tritium-sc/src/ | awk -F'def ' '{print $2}' | sort | uniq -d
# Check SC uses lib versions of extracted code
grep -rn "from engine.tactical.geo import" tritium-sc/src/  # should use tritium_lib.geo
# Find unused imports
grep -rn "^import \|^from " tritium-sc/src/ | grep -v "__pycache__"
```

## What to Update
- `docs/STATUS.md` — current wave, feature count, test baselines, plugin count
- `docs/CHANGELOG.md` — recent wave entries with verification levels
- `CLAUDE.md` — feature roadmap, plugin list
- `memory/project_iteration_queue.md` — mark completed waves, plan future waves
- All submodule CLAUDE.md files — package lists, HAL counts

## Store Consolidation
- All stores should inherit from BaseStore (currently 9 stores in `tritium-lib/src/tritium_lib/store/`)
- Check for common patterns across plugins that should be shared utilities
- panel-utils.js should be used by all panels (no inline _esc/_timeAgo)

## Test Baselines
Record definitive counts (targeted, not full suite):
```bash
cd /home/scubasonar/Code/tritium/tritium-lib
pytest tests/ -q                                    # ~2,120 tests

cd /home/scubasonar/Code/tritium/tritium-sc
.venv/bin/python3 -m pytest tests/engine/tactical/ -q  # ~895 tests
./test.sh fast                                      # Tiers 1+2+3+8+8b (~60s)

cd /home/scubasonar/Code/tritium/tritium-edge
pio run -e touch-lcd-43c-box-os                     # RAM%, Flash%
```
