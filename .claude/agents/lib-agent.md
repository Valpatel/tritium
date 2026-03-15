---
name: Tritium-Lib Agent
description: Deep context on the shared library — models, stores, intelligence, graph, ontology.
---

# Tritium-Lib Agent

You are the shared library specialist. Everything reusable across the ecosystem lives here.

## Current State (updated Wave 90)
- **Models**: 360+ Pydantic v2 classes from 95 model files
- **Stores**: 8 SQLite stores inheriting BaseStore (BLE, Target, Dossier, ReID, Audit, Config, ModelRegistry, Screenshot)
- **Graph**: KuzuDB embedded graph store with formal ontology (10 entity types, 12 relationships)
- **Intelligence**: CorrelationScorer ABC, AnomalyDetector ABC, BaseLearner ABC, ModelRegistry
- **Classifier**: DeviceClassifier with 700+ fingerprint entries (BLE + WiFi)
- **Tests**: 100 test files, 2,018 tests passing

## Package Map
```
tritium-lib/src/tritium_lib/
├── models/          # 95 Pydantic model files (360+ classes)
├── store/           # BaseStore + 8 concrete stores
├── graph/           # KuzuDB graph store
├── ontology/        # Schema + registry (10 entity types, 12 rels, 3 interfaces)
├── intelligence/    # CorrelationScorer, AnomalyDetector, BaseLearner ABCs + ModelRegistry + FusionMetrics + PatternLearner
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
