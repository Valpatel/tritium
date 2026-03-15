# Tritium System Status

Current state of all components as of 2026-03-15 (Wave 144 — Feature + Maintenance).

## Component Health

| Component | Status | Notes |
|-----------|--------|-------|
| **tritium-edge firmware** | Building | 49.9% RAM, 29.4% Flash (within budget) |
| **tritium-edge fleet server** | Running | :8080, device provisioning + OTA |
| **tritium-sc command center** | Running | :8000, full tactical intelligence platform |
| **tritium-lib** | Stable | 2,411 tests passing (29 skipped) |
| **MQTT bridge** | Active | Heartbeat, sighting, chat, commands, camera feeds, diagnostics |
| **BLE scanner** | Disabled | WiFi/BLE coexistence conflict (radio scheduler wired in Wave 105) |
| **Graph database** | Active | KuzuDB ontology with 10 entity types, 12 relationships |
| **Intelligence pipeline** | Active | 7 modules, all learners using BaseLearner ABC, 10-feature model |
| **RL pipeline** | Retrained | 54.8% accuracy on 507 clean 10-feature examples; top feature: source_diversity_score |
| **Plugin system** | Active | 22 plugins (including LPR, AmyCommanderPlugin), auto-discovery with boot report |
| **Collaboration** | Active | Shared workspaces, map drawing, operator chat, WebSocket broadcast |
| **Forensics** | Active | Event reconstruction, incident reports, map replay |
| **Fleet management** | Active | Device lifecycle, health summary, remote diagnostics |
| **Intelligence packages** | Active | Portable inter-site intelligence sharing with chain of custody |
| **Dwell tracking** | Active | Monitors stationary targets >5min, severity classification |
| **Command history** | Active | Fleet command audit log with timeout detection |

## Wave 144 (Feature + Maintenance)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Target activity heatmap — /api/analytics/activity-heatmap 24-bin hourly histogram | tritium-sc | - | Complete |
| Per-target activity heatmap — /api/analytics/activity-heatmap/{target_id} with regularity_score | tritium-sc | - | Complete |
| Analytics dashboard: embedded 24-hour heatmap visualization | tritium-sc | - | JS verified |
| Fleet dashboard: first-seen/last-seen columns, >1h offline warning highlight | tritium-sc | - | JS verified |
| Fleet device-activity endpoint — /api/fleet/device-activity with potentially_offline flag | tritium-sc | - | Complete |
| DailyPattern model — hourly_counts, peak_hour, quiet_hours, regularity_score | tritium-lib | 17 tests | Complete |
| STATUS.md updated through Wave 143 | docs | - | Complete |
| Lib pytest: 2,411 passing (up from 2,394), 29 skipped | tritium-lib | 2,411 | Verified |
| Edge build: 49.9% RAM, 29.4% Flash, 0 warnings | tritium-edge | - | Verified |
| Changelogs updated | docs | - | Complete |

## Wave 143 (Security + RL Clean Retrain + Ops Accuracy Widget + Group Viz)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| RL retrained on clean 10-feature data: 54.8% accuracy on 507 examples | tritium-sc | - | API verified |
| Fixed RL feature drift: reset on feature mismatch | tritium-sc | - | Unit tested |
| Security: behavioral intelligence routes require auth | tritium-sc | 14 tests | Complete |
| Ops dashboard: RL accuracy trend sparkline | tritium-sc | - | JS verified |
| Map: target group visualization — highlight rings, connecting lines | tritium-sc | - | JS verified |

## Wave 142 (Maintenance)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| STATUS.md updated through Wave 141 | docs | - | Complete |
| Lib pytest: 2,394 passing (down from 2,416 — 29 skipped) | tritium-lib | 2,394 | Verified |
| RL training data purged: 65,495 old 6-feature records deleted, 148 clean 10-feature records remain | tritium-sc | - | Complete |
| correlation_model.pkl deleted — next retrain starts fresh on 10-feature-only data | tritium-sc | - | Complete |
| training.db vacuumed: 33 MB to 10 MB | tritium-sc | - | Complete |
| RL feature consistency verified: FEATURE_NAMES in correlation_learner.py, scorer.py, and EXTENDED_FEATURE_NAMES in feature_engineering.py all match (10 features identical) | all | - | Verified |
| Agent refiner: updated counts in agent-refiner.md and maintenance-agent.md | agents | - | Complete |
| Codebase counts: 99 app routers, 87 panels (84 registered), 154 JS files, 636 SC test files, 124 lib test files | all | - | Verified |
| Changelogs updated | docs | - | Complete |

## Wave 141 (Feature: Target Clustering + Night Mode + RL Retrain + Power Saver)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Behavioral clustering — /api/patterns/clusters groups targets by movement similarity | tritium-sc | - | Complete |
| BehaviorCluster model with FormationType, CommonPattern, ClusterSummary | tritium-lib | 7 tests | Complete |
| Map night mode — auto-dims between sunset/sunrise, NIT quick toggle | tritium-sc | - | JS verified |
| RL model retrained: 10-feature set, 3,802 examples, 49.4% accuracy (old 6-feature data still in training set) | tritium-sc | - | Retrained |
| Power saver optimization — reduced serial output, disabled non-essential consumers | tritium-edge | - | Code review |

## Wave 140 (Feature: Orphan Panel Registration + Ops Dashboard Uptime Widget)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| 5 orphan panels converted to PanelDef and registered in main.js (edge-diagnostics, fusion-dashboard, operator-activity, swarm-coordination, training-dashboard) | tritium-sc | 93 JS tests | Complete |
| System Uptime widget added to Ops Dashboard | tritium-sc | 27 tests | Complete |
| /api/health extended with started_at, targets_processed, events_logged | tritium-sc | - | Complete |
| Edge HAL discovery: hal_acoustic, hal_voice, hal_camera gaps identified | tritium-edge | - | Audited |

## Wave 139 (Maintenance)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| STATUS.md updated through Wave 138 | docs | - | Complete |
| Lib pytest: 2,416 passing (up from 2,394) | tritium-lib | 2,416 | Verified |
| Edge build: 49.9% RAM, 29.4% Flash, SUCCESS | tritium-edge | - | Verified |
| Orphan panel audit: 7 panel files not registered in main.js (edge-diagnostics, fusion-dashboard, operator-activity, operator-cursors, swarm-coordination, training-dashboard, weather-overlay) — none use PanelDef pattern, pre-panel-manager legacy | tritium-sc | - | Identified |
| Agent refiner: updated counts in agent-refiner.md and maintenance-agent.md | agents | - | Complete |
| Codebase counts: 100 app routers, 18 plugin routes, 87 panels (78 registered), 154 JS files, 700 SC tests, 123 lib tests, 65 HALs | all | - | Verified |
| gb10-02 not reachable via Tailscale | infra | - | Checked |
| Changelogs updated through Wave 138 | docs | - | Complete |

## Wave 138 (Feature: LPR Auth Security, Acoustic WAV Hardening, LPR Panel, ReID Matches Panel)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| LPR auth security audit — endpoint hardening | tritium-sc | - | Complete |
| Acoustic WAV classifier hardening | tritium-sc | - | Complete |
| LPR panel — frontend panel for license plate recognition | tritium-sc | - | Complete |
| ReID matches panel — cross-camera re-identification UI | tritium-sc | - | Complete |

## Wave 137 (Feature: WAV Acoustic Training, Vehicle Awareness, GeoJSON Trails, Auto-Gain)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| WAV-based acoustic classifier training — train_from_wavs(), ESC-50 category map, MFCCClassifier v2 | tritium-sc | 16 tests | Complete |
| Amy vehicle behavior awareness — instinct layer polls VehicleTrackingManager | tritium-sc | 13 tests | Complete |
| GeoJSON trail export — /targets/{id}/trail/export?format=geojson | tritium-sc | - | Complete |
| AcousticTrainingSet model — structured audio ML training data | tritium-lib | 22 tests | Complete |
| Microphone auto-gain control — EMA-smoothed RMS, clipping detection | tritium-edge | - | Build verified |

## Wave 136 (Maintenance)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| STATUS.md updated through Wave 135 | docs | - | Complete |
| Lib pytest: 2,394 passing (up from 2,361) | tritium-lib | 2,394 | Verified |
| Plugin audit: 22 plugins all discoverable (20 loader files + npc_thoughts + built-in npc_intelligence) | tritium-sc | - | Verified |
| LPR plugin confirmed as 22nd plugin with loader, routes, tests | tritium-sc | - | Verified |
| Agent refiner: updated counts in agent-refiner.md and maintenance-agent.md | agents | - | Complete |
| Codebase counts: 99 app routers, 18 plugin routes, 85 panels, 152 JS files, 693 SC tests, 124 lib tests, 89 model files | all | - | Verified |
| Disk: 70% used (604G/916G) — safe, no cleanup needed | infra | - | Verified |
| Changelogs updated, Waves 137-141 planned | docs | - | Complete |
| Documented: ESC-50 acoustic accuracy 21.2%, LPR is 22nd plugin, RL model at 55% with 10 features | docs | - | Complete |

## Wave 135 (Feature: LPR Plugin, Graph Edge Labels, ESC-50 Benchmark, RL Export)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| LPR (License Plate Recognition) stub plugin — watchlist CRUD, detection pipeline, search, demo mode | tritium-sc | 19 tests | Complete |
| Graph explorer edge labels — relationship types + confidence %, directional arrows, legend | tritium-sc | - | Complete |
| ESC-50 full benchmark — 2000 WAV files, 34/50 categories mapped, 21.2% accuracy on real data | tritium-lib | - | Complete |
| RLMetrics.export() — JSON-serializable metrics snapshot, PredictionRecord export | tritium-lib | 13 tests | Complete |

## Wave 134 (Feature: RL E2E Pipeline, ReID Cross-Camera, Dossier Timeline, BLE Dwell)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| RL training E2E pipeline — generate, train, verify 55% accuracy, save/reload | tritium-sc | 2 tests | Complete |
| ReID embedding store for cross-camera identity matching + demo generator | tritium-sc | 7 tests | Complete |
| Dossier timeline panel — chronological signal visualization with source colors | tritium-sc | - | Complete |
| RLMetrics — model accuracy, feature importance, prediction distribution | tritium-lib | 10 tests | Complete |
| BLE device dwell time tracking (dwell_time_s in all JSON outputs) | tritium-edge | - | Build verified |

## Wave 133 (Maintenance + Security)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| **CRITICAL FIX: BLE target node position auto-registration** — demo trilateration generator sends node_lat/node_lon but edge tracker never stored them; now auto-registers positions from event data so trilateration engine can compute BLE positions | tritium-sc | 8 tests | Complete |
| **GEOFENCE BLE FIX VALIDATED**: Geofence engine correctly fires enter/exit events for BLE targets with lat/lon positions (Wave 132 fix + Wave 133 node registration fix) | tritium-sc | 8 tests | Unit Tested |
| Security audit: added optional_auth to /api/wifi-fingerprint/proximity and /proximity/{mac}/closest | tritium-sc | - | Complete |
| Security: input validation bounds on limit params (ge=1, le=1000/2000) for proximity, BLE history, WiFi history endpoints | tritium-sc | - | Complete |
| Security: MAC address length validation (max 40 chars) on proximity closest-node endpoint | tritium-sc | - | Complete |
| Lib pytest: 2,381 passing (up from 2,361) | tritium-lib | 2,381 | Verified |
| STATUS.md updated through Wave 132 | docs | - | Complete |
| Codebase counts: 122 APIRouter files, 84 JS panels, 154 JS/HTML frontend files, 2,381 lib tests | all | - | Verified |

## Wave 132 (Feature: Indoor-Outdoor Transitions, Probe Proximity, Geofence Fix)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Indoor-outdoor transition detector — detects BLE targets moving between GPS and WiFi-only positioning | tritium-sc | 12 tests | Complete |
| WiFi probe multi-node proximity estimator — ranks closest edge node from probe timing + RSSI | tritium-sc | 14 tests | Complete |
| Geofence end-to-end fix: edge tracker now calls GeofenceEngine.check() on BLE targets with positions | tritium-sc | 7 tests | Complete |
| **NOTE**: Geofence fix was incomplete — node positions were never auto-registered from event data (fixed in Wave 133) | tritium-sc | - | Fixed in Wave 133 |

## Wave 131 (Feature: Target Groups, Annotation Persistence, Kalman Filter)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| /api/target-groups CRUD — create named groups of targets, persist in SQLite | tritium-sc | 9 tests | Complete |
| Annotations persisted to SQLite — survive server restarts | tritium-sc | 9 tests | Complete |
| GeoJSON import/export for annotations | tritium-sc | - | Complete |
| Kalman filter predictor — position + velocity + acceleration tracking | tritium-sc | 12 tests | Complete |

## Wave 130 (Maintenance)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| STATUS.md updated through Wave 129 with corrected counts | docs | - | Complete |
| MILESTONE: RL model reset — now trains on REAL ESC-50 acoustic data features | tritium-sc | - | Documented |
| Agent refiner: updated counts in agent-refiner.md and maintenance-agent.md | agents | - | Complete |
| Lib pytest: 2,361 passing (up from 2,305) | tritium-lib | 2,361 | Verified |
| Codebase audit: 19 plugin dirs + amy + AmyCommander = 21 plugins, 98 app routers, 17 plugin routes, 84 panels, 151 JS files | all | - | Verified |
| Changelogs updated, Waves 131-135 planned | docs | - | Complete |

## Wave 129 (Feature: RL Model Reset + Vehicle Tracking + ESC-50 Acoustic Tests)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| RL MODEL RESET: Deleted old 6-feature correlation_model.pkl (51.3% coin flip accuracy) — learner starts fresh with 10-feature extractor | tritium-sc | - | Verified |
| Vehicle tracking enhancement — speed/heading from consecutive YOLO frames, suspicious scoring | tritium-sc | 21 tests | Complete |
| VehicleTrack model — Pydantic with compute_speed_mph, compute_heading, compute_suspicious_score | tritium-lib | 27 tests | Complete |
| ESC-50 acoustic classifier tests — real WAV file feature extraction and MFCC KNN classification | tritium-lib | 12 tests | Complete |
| Visual: Server + demo verified: 35 targets, dossier store functional, ESC-50 dataset accessible | tritium-sc | - | Server-verified |

## Wave 128 (Security: OWASP Audit + ESC-50 Dataset)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| OWASP auth pass on Waves 121-127 endpoints — added auth to 10 unprotected routes | tritium-sc | 14 tests | Complete |
| Prompt injection mitigation on /api/intelligence/anomaly/describe | tritium-sc | 5 tests | Complete |
| Input validation bounds on /api/intelligence/features?limit= (1-1000) | tritium-sc | - | Complete |
| Security Audit Trail panel + API (/api/security/audit-trail, /audit-stats) | tritium-sc | - | Complete |
| ESC-50 dataset downloaded (1.4 GB, 2000 clips, 50 environmental sound classes) | data | - | Verified |
| MANIFEST.json for data library tracking | data | - | Created |
| gb10-02 synced — tritium-lib 2,334 tests passing | infra | - | SSH verified |

## Wave 127 (Maintenance + Dossier Enrichment)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| STATUS.md updated through Wave 126 | docs | - | Complete |
| WiFi probe dossier auto-enrichment — BLE dossiers enriched with probed SSIDs from same observer | tritium-sc | 4 tests | Complete |
| DossierManager handles fleet.wifi_presence events for cross-sensor enrichment | tritium-sc | 38 total | Verified |
| 6-strategy correlator weights verified balanced: sum=1.00 (spatial=0.30, temporal=0.15, signal_pattern=0.14, dossier=0.13, learned=0.13, wifi_probe=0.15) | tritium-sc | - | Verified |
| Feature engineering library in lib: 5 functions (device_type_match, co_movement_score, time_similarity, source_diversity, wifi_probe_temporal_correlation) | tritium-lib | 34 tests | Verified |
| RL model expanded to 10 features (Wave 126) for better correlation accuracy | tritium-sc | - | Verified |
| Lib pytest: 2,305 passing (up from 2,283) | tritium-lib | 2,305 | Verified |
| Edge build: 49.9% RAM, 29.4% Flash, SUCCESS | tritium-edge | - | Verified |
| Changelogs updated | all | - | Complete |

## Wave 126 (Feature: RL Feature Expansion + WiFi Probe Correlation)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| WiFiProbeStrategy — 6th correlation strategy for BLE+WiFi probe temporal matching | tritium-sc | 65 tests | Complete |
| CorrelationLearner expanded from 6 to 10 features | tritium-sc | 12 tests | Complete |
| Feature engineering library — 5 reusable ML feature functions | tritium-lib | 34 tests | Complete |
| DEFAULT_WEIGHTS rebalanced for 6 strategies | tritium-sc | - | Verified |
| Edge WiFi probe timestamps (microsecond + epoch) for SC-side correlation | tritium-edge | - | Build verified |

## Wave 125 (Feature: Acoustic TDoA + RL Prediction Cones)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Acoustic plugin TDoA endpoint with NTP-synced timestamps | tritium-sc/edge | 16 tests | Complete |
| Target prediction cones scaled by RL confidence | tritium-sc | - | Complete |
| RL accuracy dropped to 50.5% — identified as overfitting on small dataset | tritium-sc | - | Analyzed |

## Wave 124 (Maintenance + Agent Refiner)

## Wave 123 (Feature)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| PredictionEllipseManager — directional confidence ellipses on map | tritium-sc | - | Complete |
| FederationPanelDef — site status panel with add/remove, health, sync | tritium-sc | - | Complete |
| Map quick toggle (ELP) for prediction ellipses | tritium-sc | - | Complete |
| Visual re-verification: 26 targets, 20 dossiers, RL model trained at 76.7% | tritium-sc | - | Server-verified |

## Wave 122 (Feature)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| CameraDetectionLink model + CameraTargetLinker | tritium-lib/sc | 26 tests | Complete |
| TargetReappearanceMonitor — returning target detection | tritium-sc | 15 tests | Complete |
| Investigation timeline endpoint | tritium-sc | 4 tests | Complete |
| BLE ScanStats in heartbeat payload | tritium-edge | - | Complete |

## Wave 121 (Feature + Maintenance)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Multi-node BLE trilateration live demo generator | tritium-sc | - | Complete |
| Target handoff visualization (animated arcs on map) | tritium-sc | - | Complete |
| Orphan routers registered: dwell.py, mesh_environment.py | tritium-sc | - | Fixed |
| Lib pytest: 2,272 passing (up from 2,265) | tritium-lib | 2,272 | Verified |

## Waves 119-120 (DONE)

Previously completed waves — feature + maintenance cycles continuing autonomous iteration.

## Wave 118 (Maintenance + Visual Re-verification)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Re-verify: /api/threat-feeds/ returns 200 with 10 indicators | tritium-sc | Live server | VERIFIED |
| Re-verify: /api/dossiers returns 12 dossiers after demo | tritium-sc | Live server | VERIFIED |
| Re-verify: /api/system/readiness shows 21/21 plugins | tritium-sc | Live server | VERIFIED |
| Re-verify: /api/targets/export?format=cot returns valid XML | tritium-sc | Live server | VERIFIED |
| Re-verify: /api/amy/personality returns traits | tritium-sc | Live server | VERIFIED |
| Re-verify: /api/fleet/map/devices returns (empty, no MQTT) | tritium-sc | Live server | VERIFIED |
| Duplicate route prefix audit: 7 shared prefixes, all unique suffixes | tritium-sc | Code review | Complete |
| STATUS.md updated through Wave 118 | docs | - | Complete |
| Agent trigger schedule "Last Run" updated | docs | - | Complete |
| Lib pytest: 2,265 passing (up from 2,247) | tritium-lib | 2,265 | Verified |
| Changelogs updated | all | - | Complete |

## Wave 115 (Maintenance + Re-verification)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Re-verify Wave 114 fixes: /api/threat-feeds returns 200 with 10 indicators | tritium-sc | Live server | VERIFIED |
| Re-verify Wave 114 fixes: /api/dossiers returns 11 dossiers after demo | tritium-sc | Live server | VERIFIED |
| Re-verify Wave 114 fixes: /api/system/readiness shows 21/21 plugins | tritium-sc | Live server | VERIFIED |
| STATUS.md updated through Wave 115 | docs | - | Complete |
| gb10-02 sync via SSH | infra | - | Complete (synced to Wave 114) |
| visual-testing-agent.md updated with current counts | docs | - | Complete |
| Lib pytest: 2,247 passing confirmed | tritium-lib | 2,247 | Verified |
| Changelogs updated | all | - | Complete |

## Wave 113-114 Features

| Feature | Wave | Component | Status |
|---------|------|-----------|--------|
| DwellEvent model + DwellTracker backend | 113 | tritium-lib/sc | Complete |
| Dwell monitor panel with severity badges | 113 | tritium-sc | Complete |
| Weather overlay with mesh environment data | 113 | tritium-sc | Complete |
| Fleet command history panel + audit log | 113 | tritium-sc | Complete |
| CommandHistoryStore with timeout detection | 113 | tritium-sc | 9 tests |
| Edge command ACK (MQTT ack with command_id) | 113 | tritium-edge | Build SUCCESS |
| /api/threat-feeds alias routes fixed | 114 | tritium-sc | 53 tests |
| DossierManager handles demo event types | 114 | tritium-sc | 63 tests |
| Plugin count uses status=="running" | 114 | tritium-sc | 66 tests |
| Playwright headed visual test | 114 | tritium-sc | Import verified |

## Wave 112 (Maintenance + Security)

| Feature | Component | Tests | Status |
|---------|-----------|-------|--------|
| Security: /api/feedback requires auth (prevents training data poisoning) | tritium-sc | - | Fixed |
| Orphan router: proximity.py registered in main.py (was unlinked since Wave 108) | tritium-sc | - | Fixed |
| 5 orphan panels registered in main.js (acoustic-intelligence, behavioral-intelligence, map-replay, voice-command, wifi-fingerprint) | tritium-sc | - | Fixed |
| Lib pytest: 2,236 passing confirmed | tritium-lib | 2,236 | Verified |

## Wave 107-111 Features

| Feature | Wave | Component | Status |
|---------|------|-----------|--------|
| Security: classify API requires auth, 6 tests | 107 | tritium-sc | Complete |
| Meshtastic chat bridge (operator-to-mesh bidirectional) | 107 | tritium-sc | Complete |
| CoT XML export format for targets | 107 | tritium-sc/lib | Complete |
| Amy daily learning summary endpoint | 107 | tritium-sc | Complete |
| tritium-lib CoT export models (CoTExportEvent, CoTExportPoint) | 107 | tritium-lib | Complete |
| ProximityMonitor engine + REST API /api/proximity/ | 108 | tritium-sc | Complete |
| Investigation auto-close with configurable delay | 108 | tritium-sc | Complete |
| STATUS.md comprehensive update, route audit (88 routers) | 109 | docs | Complete |
| RL pipeline health audit | 109 | tritium-sc | Complete |
| Correlator logs correlation decisions to TrainingStore | 110 | tritium-sc | Complete |
| BLE classifier logs classification decisions to TrainingStore | 110 | tritium-sc | Complete |
| Health endpoint includes rl_training metrics | 110 | tritium-sc | Complete |
| Playwright visual test (dark theme, map, menu bar) | 110 | tritium-sc | Complete |
| Target capacity benchmark (248K ops/s at 10K targets) | 111 | tritium-sc | Complete |
| WebSocket stress test (10/50/100 concurrent connections) | 111 | tritium-sc | Complete |
| Demo mode RL training generator (100+ examples in 5 min) | 111 | tritium-sc | Complete |

## Codebase Metrics (Wave 144)

| Metric | Value |
|--------|-------|
| **Total waves completed** | 144 |
| **Total features shipped** | 390+ |
| **Active plugins** | 22 (20 dirs + npc_thoughts + built-in npc_intelligence) |
| **App routers** | 99 |
| **Plugin route files** | 18 |
| **Total routers** | 118 (99 app + 18 plugin + amy) |
| **Route decorators** | 760+ |
| **Frontend panels** | 87 (84 registered + 3 legacy orphans: operator-cursors, weather-overlay, map-screenshot) |
| **Frontend JS files** | 154 |
| **Test files total** | 760+ (636 SC + 124 lib) |
| **Lib model files** | 89 |
| **Lib Pydantic classes** | 250+ |
| **Lib tests** | 2,411 |
| **HAL libraries** | 65 |
| **Correlation strategies** | 6 (spatial=0.30, temporal=0.15, signal_pattern=0.14, dossier=0.13, learned=0.13, wifi_probe=0.15) |
| **Intelligence modules** | 7 (all using BaseLearner ABC) |
| **RL features** | 10 (expanded from 6 in Wave 126, model reset Wave 129, training data purged Wave 142) |
| **ESC-50 dataset** | 2,000 clips, 50 sound classes, 1.4 GB, 21.2% accuracy benchmark |

## Test Results (Wave 144)

| Suite | Count | Status |
|-------|-------|--------|
| tritium-lib | 2,411 tests (29 skipped) | All passing |
| tritium-sc | 99 router files, 87 panel JS files | Passing |
| tritium-edge build | 49.9% RAM, 29.4% Flash | 0 warnings, SUCCESS |
| Total test files | 760+ (636 SC + 124 lib) | |

## RL Pipeline Status (Wave 144 — 10-Feature Model, Clean Retrained)

| Metric | Value |
|--------|-------|
| **TrainingStore DB** | data/training.db (10 MB after vacuum) |
| **Model path** | data/models/correlation_model.pkl |
| **Feature count** | 10 (expanded from 6 in Wave 126) |
| **Features** | distance, rssi_delta, co_movement, device_type_match, time_gap, signal_pattern, co_movement_duration, time_of_day_similarity, source_diversity_score, wifi_probe_correlation |
| **Training data** | 507 clean 10-feature examples |
| **Accuracy** | 54.8% on clean 10-feature data (Wave 143 retrain) |
| **Top feature** | source_diversity_score |
| **Static fallback** | Active when model=None (graceful degradation) |
| **Auto-retrain scheduler** | Every 6 hours or 50 new feedback entries |
| **Training threshold** | 10+ confirmed correlation examples needed |
| **Security** | POST /api/feedback requires authentication (Wave 112) |
| **6-strategy weights** | spatial=0.30, wifi_probe=0.15, temporal=0.15, signal_pattern=0.14, dossier=0.13, learned=0.13 (sum=1.00) |
| **Status** | Clean 10-feature model retrained (Wave 143). 54.8% accuracy, up from 49.4% on mixed data. Feature consistency verified across all modules. |

## Architecture

```
  tritium-edge (C++17)     tritium-sc (Python+JS)     tritium-lib (Python)
  ==================       =====================       ===================
  ESP32-S3 firmware        FastAPI :8000               89 model files
  6 board types            22 plugins                  250+ Pydantic classes
  65 HAL libraries         118 routers                 2,394 tests
  MQTT, BLE, WiFi          AI Commander Amy (plugin)   Graph DB, Auth
  LoRa, ESP-NOW            YOLO, WebSocket             Events, MQTT topics
  hal_ble_features         Canvas 2D/3D map            Geo, Notifications
  hal_tinyml, hal_voice    7 intelligence modules      Classifier, COT
  hal_scan_optimizer       87 frontend panels          BaseLearner ABC
  hal_radio_scheduler      Forensics + Collaboration   Intel Packages
  hal_tamper_detect        Operator chat + drawing
  hal_diag_dump            Swarm coordination
  Fleet server :8080       Fleet lifecycle mgmt
                           Remote diagnostics
                           Intel package export/import
                           Proximity monitoring
```

## Plugins (22 active)

| Plugin | Purpose |
|--------|---------|
| edge_tracker | Edge device fleet tracking via MQTT |
| meshtastic | LoRa mesh radio bridge |
| camera_feeds | Multi-source camera management |
| fleet_dashboard | Device registry, fleet overview, lifecycle, group commands, remote diagnostics |
| yolo_detector | Object detection inference pipeline |
| gis_layers | OSM/satellite/terrain map layers |
| tak_bridge | ATAK/CoT military interoperability |
| automation | If-then rule engine |
| graphlings | NPC behavior system |
| npc_thoughts | NPC inner monologue |
| threat_feeds | Known-bad indicator matching |
| rf_motion | Passive RF-based motion detection |
| acoustic | Sound classification, ML MFCC, TDoA localization |
| federation | Multi-site federation + intelligence package sharing |
| wifi_fingerprint | WiFi device fingerprinting |
| behavioral_intelligence | Pattern detection, anomaly alerting |
| floorplan | Indoor floor plan + localization |
| swarm_coordination | Multi-robot formations and waypoints |
| edge_autonomy | Autonomous edge decision processing |
| lpr | License Plate Recognition — watchlist, detection, search |
| amy | AI Commander Amy (4-layer cognitive AI, sensorium, instinct dispatch) |

## Security Audit (Wave 112)

| Endpoint | Risk | Status |
|----------|------|--------|
| POST /api/feedback | Training data poisoning via unauthenticated feedback | FIXED — now requires `require_auth` |
| POST /api/targets/{id}/classify | Classification override without auth | Fixed in Wave 106 |
| MQTT topics | Unrestricted pub/sub | ACL template created in Wave 106 |

## Integration Points

| Flow | Status |
|------|--------|
| Edge MQTT heartbeat to SC fleet tracker | Working |
| Edge MQTT sighting to SC display | Working |
| Edge MQTT chat to SC dashboard | Working |
| SC MQTT cmd to Edge execute | Working |
| Camera MQTT to YOLO pipeline | Working (synthetic) |
| Amy MQTT to Edge autonomous commands | Working |
| Correlator to Graph store (entity relationships) | Working |
| TAK/CoT bridge to ATAK | Working |
| Geofence alerts via EventBus | Working |
| DossierManager periodic flush to SQLite | Working |
| Federation MQTT bridge to remote sites | Working |
| Intelligence package export/import | Working |
| Edge diagnostic dump via MQTT cmd | Working |
| Remote diagnostics panel | Working |
| Swarm coordination commands | Working |
| Edge autonomy decision pipeline | Working |
| Device lifecycle state machine | Working |
| Fleet health summary aggregation | Working |
| Plugin auto-discovery with boot report | Working |
| Unified event feed | Working |
| Proximity monitoring + alerts | Working |

## Known Blockers

- **NimBLE esp_bt.h not found** -- blocks BLE serial + BLE OTA. WiFi/mesh/SD alternatives work.
- **BLE/WiFi coexistence** -- can't run BLE scanner alongside WiFi. Radio scheduler HAL wired (Wave 105), needs serial verification.
- **RGB parallel display glitches** -- 43C-BOX cosmetic issue when USB connected.
- **gb10-02 sync** -- RESOLVED (Wave 124). Synced to Wave 123 via 192.168.110.2.
