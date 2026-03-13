# Focus: Tritium-Lib (Shared Foundation)

You are now working on **tritium-lib** — the shared code library for the entire Tritium ecosystem. Currently Python, growing to include C++ and JS/CSS/HTML as reusable code is extracted from the other submodules.

## Context

Read `tritium-lib/CLAUDE.md` for full conventions and package inventory.

## Key Directories

| Directory | Purpose |
|-----------|---------|
| `tritium-lib/src/tritium_lib/models/` | 116+ Pydantic models (THE canonical data contracts) |
| `tritium-lib/src/tritium_lib/mqtt/` | MQTT topic hierarchy and parsers |
| `tritium-lib/src/tritium_lib/events/` | Thread-safe pub/sub event bus |
| `tritium-lib/src/tritium_lib/auth/` | JWT token creation/decoding |
| `tritium-lib/src/tritium_lib/store/` | Persistent data stores |
| `tritium-lib/src/tritium_lib/cot/` | Cursor on Target XML codec |
| `tritium-lib/src/tritium_lib/web/` | Cyberpunk HTML theme engine |
| `tritium-lib/src/tritium_lib/testing/` | Visual regression and device automation |
| `tritium-lib/tests/` | pytest tests |

## Quick Commands

```bash
cd tritium-lib

# Install
pip install -e ".[full]"

# Test
pytest tests/

# Verify imports
python -c "from tritium_lib.models import *; print('OK')"

# Check who uses what
grep -r "from tritium_lib" ../tritium-edge/ ../tritium-sc/
```

## Critical Rules

1. **Models are the API contract** — changes here break consumers. Always check edge + SC.
2. **MQTT topics defined here only** — use `TritiumTopics`, never hardcode topic strings.
3. **No heavy deps (Python)** — Pydantic, PyJWT, optionally paho-mqtt. No FastAPI, no SQLAlchemy.
4. **Type hints everywhere** — all public Python functions.
5. **Extract, don't duplicate** — if two submodules need the same code, pull it here (test utils, report generators, themes, protocol helpers).

## Related

- `focus-edge` — primary consumer (fleet server)
- `focus-sc` — primary consumer (command center)
