---
name: Tritium-Lib Agent
description: Deep context on the shared library — models, stores, intelligence, graph, ontology.
---

# Tritium-Lib Agent

You are the shared library specialist. Everything reusable across the ecosystem lives here.

## Current State (Wave 152)
- **Models**: 97 model files with 262+ Pydantic v2 BaseModel classes
- **Stores**: 9 SQLite stores inheriting BaseStore (base, ble, targets, dossiers, reid, audit_log, config_store, event_store, screenshot_store)
- **Graph**: KuzuDB embedded graph store with formal ontology (10 entity types, 12 relationships)
- **Intelligence**: 8 files — CorrelationScorer ABC, AnomalyDetector ABC, BaseLearner ABC, ModelRegistry, FusionMetrics, PatternLearner, ThreatModel, RLMetrics
- **Classifier**: DeviceClassifier with 700+ fingerprint entries (BLE + WiFi)
- **Testing**: 4 modules — VisualCheck, FlickerAnalyzer, UITestRunner, DeviceAPI
- **Tests**: 131 test files, 2,527 tests passing
- **RL model**: 81.7% accuracy on clean 10-feature examples (Wave 150 retrain)

## Package Map
```
tritium-lib/src/tritium_lib/
├── models/          # 97 Pydantic model files (262+ BaseModel classes)
├── store/           # BaseStore + 9 concrete stores
│   ├── base.py      # BaseStore ABC (SQLite, migrations)
│   ├── ble.py       # BLE sighting store
│   ├── targets.py   # Target tracking store
│   ├── dossiers.py  # Target dossier store
│   ├── reid.py      # Re-identification store
│   ├── audit_log.py # Audit logging store
│   ├── config_store.py # Configuration store
│   ├── event_store.py  # Event store
│   └── screenshot_store.py # Screenshot store
├── graph/           # KuzuDB graph store (store.py)
├── ontology/        # Schema + registry (schema.py, registry.py)
├── intelligence/    # 8 files
│   ├── base_learner.py   # BaseLearner ABC (train/predict/save/load)
│   ├── scorer.py         # CorrelationScorer ABC
│   ├── anomaly.py        # AnomalyDetector ABC
│   ├── model_registry.py # SQLite-backed versioned model storage
│   ├── fusion_metrics.py # Sensor fusion quality metrics
│   ├── pattern_learning.py # PatternLearner for behavior patterns
│   └── threat_model.py  # Threat assessment models
├── classifier/      # DeviceClassifier + JSON fingerprint databases
├── data/            # JSON lookup tables (BLE, WiFi, OUI — <1MB total, in git)
├── mqtt/            # TritiumTopics topic builder
├── events/          # EventBus, AsyncEventBus
├── auth/            # JWT encode/decode
├── cot/             # Cursor on Target XML codec
├── geo/             # Coordinate transforms
├── notifications/   # Notification model + manager
├── web/             # Theme engine, sanitize utilities
├── config/          # Base settings
└── testing/         # 4 test utility modules
    ├── visual.py    # VisualCheck — OpenCV layout/rendering checks
    ├── flicker.py   # FlickerAnalyzer — frame drop detection
    ├── runner.py    # UITestRunner — device test orchestration
    └── device.py    # DeviceAPI — REST client for ESP32
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
cd /home/scubasonar/Code/tritium/tritium-lib
pip install -e ".[full]"     # Install all deps
pytest tests/ -q             # Run 116 test files (2,283 tests)
python -c "from tritium_lib.models import *; print('OK')"  # Import check
```
