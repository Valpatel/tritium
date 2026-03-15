# Tritium Data Library Catalog

Last updated: 2026-03-15

Datasets discovered for Tritium's sensing pipelines. Relevance scored 0.0-1.0 based on
how directly the dataset supports our detection, classification, and tracking pipelines.

## Video Datasets (Person/Vehicle Detection)

| Dataset | Size | License | Relevance | URL | Downloaded |
|---------|------|---------|-----------|-----|-----------|
| COCO val2017 | ~1 GB (images) + 241 MB (annotations) | CC-BY-4.0 | 0.9 | http://images.cocodataset.org/zips/val2017.zip | No |
| MOT17 (Multi-Object Tracking) | ~5 GB | Research-only | 0.8 | https://motchallenge.net/data/MOT17/ | No |
| PETS2009 | ~500 MB (est.) | Free for research | 0.7 | http://ftp.cs.rdg.ac.uk/PETS2009/ | No |
| VisDrone (drone-view detection) | 2.3 GB | Research-only | 0.7 | https://github.com/VisDrone/VisDrone-Dataset | No |
| Vehicle Dataset for YOLO | 379 MB | Supervisely | 0.6 | https://datasetninja.com/vehicle-dataset-for-yolo | No |

### Notes
- **COCO val2017** is the top pick: 5K images, 80 object classes including person/vehicle/animal, YOLO-native annotations available via Ultralytics. Standard benchmark for detection.
- **MOT17** provides multi-camera pedestrian tracking sequences with ground truth bounding boxes -- ideal for testing our TargetTracker correlation.
- **PETS2009** is small, focused on surveillance-style pedestrian tracking from fixed cameras -- closest to our deployment scenario.

## Audio Datasets (Acoustic Classification)

| Dataset | Size | License | Relevance | URL | Downloaded |
|---------|------|---------|-----------|-----|-----------|
| ESC-50 | 1.4 GB (full repo) | CC-BY-NC-3.0 | 0.9 | https://github.com/karolpiczak/ESC-50 | YES (2026-03-15) |
| Gunshot/Gunfire Audio (Zenodo) | 1.6 GB | CC-BY-4.0 | 0.8 | https://zenodo.org/records/7004819 | No |
| UrbanSound8K | 5.6 GB | CC-BY-NC-3.0 | 0.7 | https://urbansounddataset.weebly.com/urbansound8k.html | No |

### Notes
- **ESC-50** is the top pick: 2,000 clips across 50 environmental sound classes (dog bark, siren, gunshot, engine, rain, etc.), 5-second clips at 44.1 kHz. Small enough to download now.
- **Gunshot/Gunfire** is specialized: multi-firearm, multi-orientation recordings from an outdoor range. Direct relevance to security/threat detection.
- **UrbanSound8K** is comprehensive (8,732 clips, 10 urban classes including gun_shot, siren, car_horn) but large at 5.6 GB.

## Speech Datasets (STT Testing)

| Dataset | Size | License | Relevance | URL | Downloaded |
|---------|------|---------|-----------|-----|-----------|
| Mini LibriSpeech | 458 MB (train 332 MB + dev 126 MB) | CC-BY-4.0 | 0.8 | https://www.openslr.org/31/ | No |
| Mozilla Common Voice (en subset) | Variable | CC0-1.0 | 0.7 | https://commonvoice.mozilla.org/en/datasets | No |

### Notes
- **Mini LibriSpeech** is purpose-built for regression testing of ASR systems. Clean English speech, small download. Top pick for STT pipeline validation.
- **Common Voice** requires account + download from Mozilla Data Collective as of 2025. Larger and more diverse but harder to automate downloading.

## WiFi/Geolocation Datasets

| Dataset | Size | License | Relevance | URL | Downloaded |
|---------|------|---------|-----------|-----|-----------|
| WiGLE (API access) | Variable | Free API (rate-limited) | 0.6 | https://wigle.net/ | No |

### Notes
- **WiGLE** is the primary public WiFi geolocation database (BSSID -> lat/lng). No bulk download available; API access requires free account and is rate-limited to 11K results per query. Could build a local cache via API queries for our deployment areas.
- No publicly available bulk WiFi geolocation dataset found. Most research datasets are proprietary or require institutional access.

## BLE/RF Datasets (Device Fingerprinting)

| Dataset | Size | License | Relevance | URL | Downloaded |
|---------|------|---------|-----------|-----|-----------|
| BLEBeacon Dataset | 888 MB (full), 920 KB sample | Research | 0.7 | https://github.com/dimisik/BLEBeacon-Dataset | Sample only |
| BLE Separate-Channel Fingerprinting | Unknown | CC-BY-4.0 | 0.5 | https://www.nature.com/articles/s41597-025-04581-0 | No |
| BLE Social Interactions Dataset | Unknown | Research | 0.5 | https://www.sciencedirect.com/science/article/pii/S2352340920309963 | No |

### Notes
- **BLEBeacon Dataset** contains real BLE advertisement traces from beacons carried by people in a university building over a month. Includes RSSI reports -- directly useful for testing our BLE tracker and trilateration.
- BLE fingerprinting datasets from academic papers tend to focus on RF-level (IQ samples) rather than advertisement-level data. Our existing JSON lookup tables in tritium-lib/data/ are more practical for device classification.

## Device Intelligence Databases (Already Maintained)

| Database | Location | Size | Updated |
|----------|----------|------|---------|
| IEEE OUI (MA-L) | tritium-edge/sdcard_data/oui.db | 1.3 MB | 2026-03-14 (39,029 entries) |
| Apple Continuity Types | tritium-lib/data/apple_continuity_types.json | 8 KB | 2026-03-14 |
| BLE Appearance Values | tritium-lib/data/ble_appearance_values.json | 22 KB | 2026-03-14 |
| BLE Company IDs | tritium-lib/data/ble_company_ids.json | 11 KB | 2026-03-14 |
| BLE Fingerprints | tritium-lib/data/ble_fingerprints.json | 21 KB | 2026-03-14 |
| BLE Name Patterns | tritium-lib/data/ble_name_patterns.json | 24 KB | 2026-03-14 |
| BLE Service UUIDs | tritium-lib/data/ble_service_uuids.json | 8 KB | 2026-03-14 |
| Device Classification Rules | tritium-lib/data/device_classification_rules.json | 6 KB | 2026-03-14 |
| OUI Device Types | tritium-lib/data/oui_device_types.json | 50 KB | 2026-03-14 |
| WiFi SSID Patterns | tritium-lib/data/wifi_ssid_patterns.json | 10 KB | 2026-03-14 |
| WiFi Vendor Fingerprints | tritium-lib/data/wifi_vendor_fingerprints.json | 12 KB | 2026-03-14 |

## Priority Download Queue

Ordered by value-per-byte for our pipelines:

1. ~~**ESC-50**~~ DOWNLOADED (1.4 GB, CC-BY-NC) -- at `data/library/audio/ESC-50/`, 2000 clips, 50 classes
2. **Mini LibriSpeech** (458 MB, CC-BY-4.0) -- STT regression testing
3. **BLEBeacon Dataset** (888 MB full, 920 KB sample downloaded) -- BLE tracker testing
4. **COCO val2017** (~1.2 GB, CC-BY-4.0) -- YOLO detection benchmark
5. **Gunshot Audio** (1.6 GB, CC-BY-4.0) -- security-relevant acoustic
6. **PETS2009** (~500 MB, Research) -- surveillance pedestrian tracking
7. **UrbanSound8K** (5.6 GB, CC-BY-NC) -- broad urban sound classification
8. **MOT17** (~5 GB, Research) -- multi-object tracking benchmark
