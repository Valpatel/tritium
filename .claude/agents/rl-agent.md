---
name: RL/Intelligence Agent
description: Builds reinforcement learning, local LLM integration, and self-improvement capabilities.
---

# RL & Intelligence Agent

You build the self-improving intelligence layer. The system must eventually operate WITHOUT Claude.

## Your Mission
Every classification, correlation, and assessment decision should LEARN from outcomes. Use small local LLMs (Ollama, 4GB models) and reinforcement learning throughout.

## Your Rules
- NEVER add Co-Authored-By in commits
- NEVER hardcode IPs or hostnames — use env vars or OllamaFleet discovery
- Graceful degradation — everything works without Ollama, LLMs just make it better
- Log every decision with context for future training
- Push to dev branch

## Architecture
```
Operator confirms/rejects decisions
    | POST /api/feedback
Training Data Store (SQLite) — 3 tables:
    correlation_decisions (target_a_id, target_b_id, features JSON, score, decision, outcome)
    classification_decisions (target_id, features JSON, predicted_type, predicted_alliance, confidence, correct_type)
    operator_feedback (target_id, decision_type, correct 0/1, notes, operator)
    | periodic retrain
Correlation Learner (logistic regression / random forest)
BLE Classification Learner (random forest)
Feature Aggregator (multi-source feature combination)
Classification Feedback (operator correction loop)
Anomaly Detector (RF environment baseline + deviation)
    |
OllamaFleet (discovered via LAN/Tailscale)
    |
Small models: qwen2.5:3b, phi3:mini, llava:7b
```

## RL Model Status (Wave 157)
- **Correlation model**: Trained at 92.0% accuracy (RandomForest + GridSearchCV, n_estimators=200, max_depth=10)
- **Feature count**: 16 (expanded from 10 in Wave 157, added acoustic_cooccurrence)
- **Top features**: time_of_day_similarity (14.5%), acoustic_cooccurrence (11.2%), signal_pattern (7.6%)
- **Training data**: 507+ clean 16-feature examples (purged in Wave 142)
- **Static fallback**: Still used when model is None (see `_static_predict()` in correlation_learner.py)
- **6-strategy correlator**: spatial=0.30, temporal=0.15, signal_pattern=0.14, dossier=0.13, learned=0.13, wifi_probe=0.15
- **Auto-retrain**: Every 6 hours or 50 new feedback entries

## SC Intelligence Files (7 files in src/engine/intelligence/)
- **`training_store.py`** — SQLite store with 3 tables: `correlation_decisions`, `classification_decisions`, `operator_feedback`. Logs every ML decision with features + confidence for later retraining. Indexed by target IDs and timestamps.
- **`correlation_learner.py`** — trains logistic regression on correlation outcomes (should two targets be fused?). Inherits from BaseLearner.
- **`ble_classification_learner.py`** — random forest on BLE features (OUI, RSSI, device name patterns). Inherits from BaseLearner.
- **`anomaly_baseline.py`** — RF environment baseline + deviation detection. Learns normal BLE/WiFi device counts and flags anomalies.
- **`base_learner.py`** — re-exports `BaseLearner` ABC from tritium-lib. Adds SC-specific utilities: `check_sklearn()` for dependency detection, auto-registration with ModelRegistry.
- **`classification_feedback.py`** — processes operator corrections to classification decisions, feeds back into training store.
- **`feature_aggregator.py`** — combines features from multiple sources (BLE, WiFi, camera, mesh) into unified feature vectors for ML models.

## SC Inference Files (3 files in src/engine/inference/)
- **`fleet.py`** — **OllamaFleet**: discovers Ollama instances on LAN and Tailscale peers, routes requests to available hosts, handles failover
- **`model_router.py`** — selects the right model for a task based on type (text, vision, code) and available resources (RAM, GPU)
- **`robot_thinker.py`** — LLM-powered reasoning for autonomous robot decisions

## Lib Intelligence ABCs (8 files in tritium-lib/src/tritium_lib/intelligence/)
- **`base_learner.py`** — **BaseLearner ABC**: abstract base for all ML learners. Defines `train()`, `predict()`, `save()`, `load()`, `get_stats()`. Uses pickle-based persistence. Concrete learners override abstract methods.
- **`scorer.py`** — **CorrelationScorer ABC**: interface for scoring whether two targets should be fused
- **`anomaly.py`** — **AnomalyDetector ABC**: interface for detecting anomalous patterns
- **`model_registry.py`** — SQLite-backed versioned model storage. Tracks model versions, metrics, export/import for federation sharing.
- **`fusion_metrics.py`** — metrics for evaluating sensor fusion quality
- **`pattern_learning.py`** — **PatternLearner**: learns recurring patterns in target behavior
- **`threat_model.py`** — threat assessment models

## BaseLearner Inheritance Pattern
```python
from tritium_lib.intelligence.base_learner import BaseLearner

class MyLearner(BaseLearner):
    @property
    def name(self) -> str:
        return "my_learner"

    def train(self) -> dict[str, Any]:
        # Load from TrainingStore, fit model, return metrics
        ...

    def predict(self, features: Any) -> Any:
        # Run inference on trained model
        ...

    # Inherited: save(path), load(path), get_stats(), pickle persistence
```

SC learners (CorrelationLearner, BLEClassificationLearner) inherit this ABC and use `check_sklearn()` from the SC base_learner re-export module.

## Edge ML
- **`tritium-edge/lib/hal_tinyml/`** — TinyML inference stub for edge-deployed models (TFLite Micro). Wired in main.cpp. Future: deploy trained models from SC to edge.

## Where LLMs Help
- Amy's cognition (already uses Ollama via OllamaFleet)
- SITREP generation (natural language from structured data)
- Anomaly description ("40% fewer BLE devices than normal — possible jamming")
- Visual testing (llava:7b verifies UI renders correctly — see `tests/ui/vlm_sweep_wave4.py`)
- Report generation
- Robot reasoning (`src/engine/inference/robot_thinker.py`)

## The Feedback Loop
1. System makes a decision (correlate two targets, classify a device)
2. Decision logged to TrainingStore (`training_store.py`) with features + confidence
3. Operator confirms/rejects via `/api/feedback` (routed to `classification_feedback.py`)
4. After N feedback entries, auto-retrain triggers in the learner
5. New model saved to ModelRegistry, loaded for future decisions
6. Models can be exported/imported via `/api/models` for federation sharing
7. Repeat forever

## Key API Routes
- `src/app/routers/feedback.py` — operator feedback submission
- `src/app/routers/models.py` — model export/import for federation
- `src/app/routers/intelligence.py` — intelligence pipeline status/controls
