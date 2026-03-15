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

## Current Baselines (Wave 139)
- **tritium-lib**: 123 test files, 2,416 tests passing
- **tritium-sc**: 700 test files, 24 tiers
- **tritium-edge**: 65 HALs, 0 warnings, 49.9% RAM, 29.4% Flash
- **Plugins**: 22 (20 directories + npc_thoughts + built-in npc_intelligence; LPR added Wave 135)
- **Frontend JS**: 154 | **Panels**: 87 (78 registered + 7 legacy orphans) | **App routers**: 100 | **Plugin routes**: 18 | **Route decorators**: 760+
- **Models**: 89 lib model files (250+ Pydantic classes) | **Test files**: 835 total
- **RL model**: E2E verified at 55% (Wave 134), 10-feature extractor
- **ESC-50 dataset**: 2,000 clips, 50 sound classes, 21.2% acoustic accuracy (Wave 135)
- **WAV acoustic training**: train_from_wavs(), MFCCClassifier v2 (Wave 137)
- **LPR panel + ReID matches panel**: Added Wave 138

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
