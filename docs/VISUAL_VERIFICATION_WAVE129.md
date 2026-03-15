# Wave 129 Visual Verification Report

**Date:** 2026-03-15
**Branch:** dev

## Server + Demo Mode Verification

### Server Start
- Server started on port 8000 successfully
- Amy boot: degraded mode (no YOLO/STT/torch, expected on this machine)
- Target tracker bridge: running
- WebSocket broadcast: active

### Demo Mode
- 7 generators started: BLEScanGenerator, MeshtasticNodeGenerator, 2x CameraDetectionGenerator, FusionScenario, RLTrainingGenerator, TrilaterationDemoGenerator
- Demo uptime: ~35 seconds during verification

### Target Count: 35 (PASS, >10 required)
Verified via `GET /api/targets`:
- BLE devices: 6 (ble_device, phone, watch, wearable)
- YOLO persons: 7+
- YOLO vehicles: 3+
- Trilateration targets: 3
- Multiple sources active and generating targets

### Dossier Count: 1+ (PASS, >0 required)
- DossierStore functional, creates dossiers on correlation
- Correlation summary: correlator running (0 high-confidence pairs during short test window)
- Training store: 63,148 correlation examples, 1,411 confirmed

### RL Model Status: 10 Features (PASS)
- Old 6-feature model (`data/models/correlation_model.pkl`) deleted
- CorrelationLearner starts untrained with 10-feature extractor
- Features: distance, rssi_delta, co_movement, device_type_match, time_gap, signal_pattern, co_movement_duration, time_of_day_similarity, source_diversity_score, wifi_probe_correlation
- RLTrainingGenerator running: 22 ticks, generating 10-feature training data
- Fresh model will train automatically when enough confirmed examples accumulate

### ESC-50 Audio Dataset: Accessible (PASS)
- Location: `data/library/audio/ESC-50/`
- WAV files: 2,000 files present
- Metadata: `meta/esc50.csv` present with all entries
- 50 categories available for acoustic classification testing

## Test Results

### tritium-lib: 27/27 passed
- `tests/models/test_vehicle.py`: VehicleTrack model, speed/heading computation, suspicious scoring

### tritium-sc: 33/33 passed
- `tests/engine/tactical/test_vehicle_tracker.py`: 21 tests — VehicleBehavior, VehicleTrackingManager
- `tests/engine/audio/test_acoustic_esc50.py`: 12 tests — ESC-50 dataset access, feature extraction from real WAV files, MFCC classification pipeline

## Features Delivered

### A. RL Model Reset
- Deleted old 6-feature `correlation_model.pkl` (51.3% accuracy = coin flip)
- Learner now starts fresh with 10-feature extractor
- RLTrainingGenerator produces 10-feature training data in demo mode
- Auto-retrain will fire when threshold of new confirmed examples is reached

### B. Visual Re-verification
- All items verified as documented above

### C. Acoustic Classifier Test with ESC-50
- 12 tests using real ESC-50 WAV files
- Pure-Python feature extraction (no numpy/librosa required)
- Tests: dataset availability, feature extraction from 10 categories, MFCC KNN classification, category mapping completeness, feature determinism

### D. Vehicle Tracking Enhancement
- `src/engine/tactical/vehicle_tracker.py`: VehicleBehavior + VehicleTrackingManager
- Computes speed (mph) and heading from consecutive frame positions
- Vehicles >30mph on roads = normal; stopped in unusual locations = suspicious
- Suspicious scoring: loitering, unusual location, slow crawling, erratic speed/heading
- Trail history (up to 20 positions) for map rendering

### E. Vehicle Model in tritium-lib
- `src/tritium_lib/models/vehicle.py`: VehicleTrack Pydantic model
- Fields: target_id, speed_mph, heading, road_segment, stopped_duration_s, suspicious_score
- Helper functions: compute_speed_mph, compute_heading, compute_suspicious_score, heading_to_label
- Exported from tritium_lib.models

### F. Quality
- 60 new tests across 3 files, all passing
- Changelogs pending in next commit
