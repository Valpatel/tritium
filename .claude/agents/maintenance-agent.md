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

## Current Baselines (Wave 99)
- **tritium-lib**: 2,120 tests passing, 29 skipped (gb10-02: 2,149 all passing, 22s)
- **tritium-sc**: 895 tactical tests passing, 3 skipped
- **tritium-edge**: 49.7% RAM, 29.3% Flash, 0 warnings
- **Plugins**: 20 directories (including amy)
- **Frontend JS**: 144 | **API routes**: 703+ | **HALs**: 64
- **Models**: 75 lib model files | **Test files**: 787 total
- **gb10-02**: 77% disk (204G free), 88GB free RAM, 2,149 lib tests passing

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
- All stores should inherit from BaseStore
- Check for common patterns across plugins that should be shared utilities
- panel-utils.js should be used by all panels (no inline _esc/_timeAgo)

## Test Baselines
Record definitive counts (targeted, not full suite):
- `tritium-lib`: `python3 -m pytest tests/ -q`
- `tritium-sc`: `python3 -m pytest tests/engine/tactical/ -q` (876 tests, ~44s)
- `tritium-edge`: `pio run -e touch-lcd-43c-box-os` (RAM%, Flash%)
