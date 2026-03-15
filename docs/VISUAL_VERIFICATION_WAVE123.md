# Wave 123 Visual Re-Verification Report

**Date:** 2026-03-15
**Server:** uvicorn on port 8099
**Demo mode:** Active (7 generators)

## Endpoint Verification

| Check | Endpoint | Result | Status |
|-------|----------|--------|--------|
| Target count after demo | `GET /api/targets` | 26 targets (>10 required) | PASS |
| Dossier count | `GET /api/dossiers` | 20 dossiers (>0 required) | PASS |
| Threat level | `GET /api/threat-level` | `{"level":"black","score":100.0}` | PASS |
| Amy personality | `GET /api/amy/personality` | Returns aggression, curiosity, verbosity, caution, initiative + 5 presets | PASS |
| Security status | `GET /api/system/security-status` | Returns overall, auth, tls, rate_limiting, mqtt, csp, cors | PASS |
| CoT/TAK export | `GET /api/targets/export` | Returns full JSON with all 26 targets including lat/lng/alliance | PASS |
| TAK status | `GET /api/tak/status` | `{"enabled":false,"connected":false}` (expected without TAK config) | PASS |
| Federation stats | `GET /api/federation/stats` | `{"total_sites":0,"connected_sites":0,"shared_targets":0}` | PASS |

## RL Model Status (Task B)

| Field | Value |
|-------|-------|
| Trained | Yes |
| Accuracy | 76.7% |
| Training count | 60 examples used for model training |
| Last trained | 2026-03-15T07:08:51Z |
| sklearn available | Yes |
| Model path | `data/models/correlation_model.pkl` |
| Features | distance, rssi_delta, co_movement, device_type_match, time_gap, signal_pattern |
| Correlation data total | 61,908 examples |
| Confirmed correlations | 188 |
| Classification data total | 422 |
| Corrected classifications | 53 |
| Feedback total | 98 (47 correct, 48% accuracy) |
| Retrain scheduler | Fired (model trained with 60 examples from confirmed correlations) |

**Analysis:** The RL correlation model has successfully trained with 76.7% accuracy
on 60 confirmed correlation examples. The training data store has accumulated 61,908
total correlation observations with 188 confirmed. The retrain scheduler has fired
at least once. Feedback accuracy at 48% suggests the system is still learning from
corrections — this is expected early in operation.

## Demo Mode Generators

All 7 generators confirmed running:
1. BLEScanGenerator (5 devices, 5s interval)
2. MeshtasticNodeGenerator (3 nodes, 10s interval)
3. CameraDetectionGenerator x2 (demo-cam-01, demo-cam-02)
4. FusionScenario (3 actors, 2s interval)
5. RLTrainingGenerator (3s interval)
6. TrilaterationDemoGenerator (3 targets, 3 nodes, 3s interval)

## Target Breakdown

- BLE devices: 8 (iPhone, Galaxy, Watch, AirPods, Echo-Dot, trilat tags)
- YOLO detections: 35+ (persons, cars)
- Simulation: 1 (escaped intruder)
- Position sources: trilateration, yolo, simulation, unknown
- Alliances: hostile, unknown

## Verification Level

**Server-verified** — All endpoints tested via curl against running server with active demo mode. No browser visual verification performed (headless test environment).
