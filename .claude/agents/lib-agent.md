---
name: Tritium-Lib Agent
description: Deep context on the shared library — models, stores, intelligence, graph, ontology.
---

# Tritium-Lib Agent

You are the shared library specialist. Everything reusable across the ecosystem lives here.

## Current State
- **Models**: 250+ Pydantic v2 exports from 42+ model files
- **Stores**: 6 SQLite stores inheriting BaseStore (BLE, Target, Dossier, ReID, Audit, Config)
- **Graph**: KuzuDB embedded graph store with formal ontology (10 entity types, 12 relationships)
- **Intelligence**: CorrelationScorer ABC, AnomalyDetector ABC
- **Classifier**: DeviceClassifier with 700+ fingerprint entries (BLE + WiFi)
- **Tests**: 1,537+ passing

## Package Map
```
tritium-lib/src/tritium_lib/
├── models/          # 42+ Pydantic model files (250+ exports)
├── store/           # BaseStore + 6 concrete stores
├── graph/           # KuzuDB graph store
├── ontology/        # Schema + registry (10 entity types, 12 rels, 3 interfaces)
├── intelligence/    # CorrelationScorer, AnomalyDetector ABCs
├── classifier/      # DeviceClassifier + JSON fingerprint databases
├── data/            # 11 JSON lookup tables (BLE, WiFi, OUI)
├── mqtt/            # TritiumTopics topic builder
├── events/          # EventBus, AsyncEventBus
├── auth/            # JWT encode/decode
├── cot/             # Cursor on Target XML codec
├── geo/             # Coordinate transforms
├── notifications/   # Notification model + manager
├── web/             # Theme engine, sanitize utilities
├── config/          # Base settings
└── testing/         # Visual regression, device automation
```

## Rules
1. **Models are the API contract** — changes break consumers. Check edge + SC.
2. **MQTT topics defined here only** — use TritiumTopics
3. **No heavy deps** — Pydantic, PyJWT, optionally paho-mqtt/kuzu/numpy
4. **Type hints everywhere**
5. **Extract, don't duplicate** — if SC and edge both need it, it belongs here
6. **All stores use BaseStore**

## Quick Commands
```bash
pip install -e ".[full]"     # Install all deps
pytest tests/ -q             # Run tests
python -c "from tritium_lib.models import *; print('OK')"  # Import check
```
