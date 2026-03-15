# Tritium Data Library Catalog

Last updated: 2026-03-15 (Wave 155 audit)

Datasets discovered for Tritium's sensing pipelines. Relevance scored 0.0-1.0 based on
how directly the dataset supports our detection, classification, and tracking pipelines.

## Data Gap Summary

| Gap | Severity | Notes |
|-----|----------|-------|
| WiFi BSSID-to-location database | HIGH | No local geolocation DB. MLS shut down. WiGLE API only. See WiFi Geolocation section. |
| BLE Company IDs coverage | MEDIUM | Only 130 of ~3,000+ Bluetooth SIG company IDs mapped. Enough for common devices but misses niche IoT. |
| IEEE OUI freshness | LOW | 39,029 entries as of 2026-03-14. IEEE publishes updates quarterly; re-scrape recommended every 3 months. |
| Apple Continuity types | MEDIUM | Static snapshot. Apple adds new message types with each iOS release; no automated update pipeline. |
| No WiFi probe request fingerprint DB | HIGH | No database mapping probe request patterns to device types/OS versions. Would improve passive WiFi tracking. |
| No acoustic model weights | MEDIUM | ESC-50 downloaded but no trained classifier weights. Need to train or find pretrained model. |
| No YOLO test images | LOW | COCO val2017 not yet downloaded. Synthetic data works for now. |

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

| Dataset | Size | License | Relevance | URL | Downloaded | Status |
|---------|------|---------|-----------|-----|-----------|--------|
| WiGLE (API access) | Variable | Free API (rate-limited) | 0.7 | https://wigle.net/ | No | Best available option |
| Mozilla Location Services (MLS) | N/A | N/A | N/A | https://location.services.mozilla.com/ | No | SHUT DOWN (2024) |
| OpenWifi.su | Unknown | Unknown | 0.4 | https://openwifi.su/ | No | Russian site, limited coverage, reliability unknown |
| Apple/Google Location APIs | N/A | Proprietary | N/A | N/A | N/A | Not bulk-accessible |

### WiFi Geolocation — Detailed Analysis

**Mozilla Location Services (MLS)** was the gold standard for open WiFi geolocation (BSSID/cell-tower to lat/lng). Mozilla shut down MLS and the Ichnaea stumble server in 2024. The dataset is no longer available for download or API access. Some community mirrors may exist but are stale.

**WiGLE** (Wireless Geographic Logging Engine) is now the primary public source:
- Free account required, API key for programmatic access
- Rate-limited: ~100 API calls/day on free tier, 11K results per search query
- Covers 1.2B+ WiFi networks globally (as of 2025)
- Provides BSSID -> approximate lat/lng
- **Recommended approach**: Build a local SQLite cache by querying WiGLE API for our deployment areas. Cache schema: `(bssid TEXT PRIMARY KEY, ssid TEXT, lat REAL, lng REAL, last_seen TEXT, source TEXT)`
- No bulk export available; must query per-area

**OpenWifi.su** is a Russian wardriving database. Coverage is spotty outside Russia/CIS. Data quality and freshness are unverified. Not recommended as primary source.

**What we need**: A `databases/wifi_geolocation.db` SQLite file with BSSID-to-location mappings for deployment areas. This should be populated incrementally via:
1. WiGLE API queries (requires API key — user must provide)
2. Self-collected wardriving data from Tritium edge nodes with GPS
3. Optional: community stumble file imports

### Notes
- No freely available bulk WiFi geolocation dataset exists as of 2026
- Best strategy is a hybrid local cache: WiGLE API + self-collected data from GPS-equipped edge nodes
- Edge nodes with WiFi scanning + GPS could contribute to our own geolocation database over time (self-improving system)

## BLE/RF Datasets (Device Fingerprinting)

| Dataset | Size | License | Relevance | URL | Downloaded |
|---------|------|---------|-----------|-----|-----------|
| BLEBeacon Dataset | 888 MB (full), 920 KB sample | Research | 0.7 | https://github.com/dimisik/BLEBeacon-Dataset | Sample only |
| BLE Separate-Channel Fingerprinting | Unknown | CC-BY-4.0 | 0.5 | https://www.nature.com/articles/s41597-025-04581-0 | No |
| BLE Social Interactions Dataset | Unknown | Research | 0.5 | https://www.sciencedirect.com/science/article/pii/S2352340920309963 | No |

### Notes
- **BLEBeacon Dataset** contains real BLE advertisement traces from beacons carried by people in a university building over a month. Includes RSSI reports -- directly useful for testing our BLE tracker and trilateration.
- BLE fingerprinting datasets from academic papers tend to focus on RF-level (IQ samples) rather than advertisement-level data. Our existing JSON lookup tables in tritium-lib/data/ are more practical for device classification.
- Sample downloaded to `rf/blebeacon_sample/` (10K checkin + 10K RSSI records in CSV format).

## Device Intelligence Databases (Already Maintained)

| Database | Location | Size | Entries | Updated | Freshness |
|----------|----------|------|---------|---------|-----------|
| IEEE OUI (MA-L) | tritium-edge/sdcard_data/oui.db | 1.5 MB | 39,029 | 2026-03-14 | OK — re-scrape quarterly |
| Apple Continuity Types | tritium-lib/data/apple_continuity_types.json | 8 KB | ~30 types | 2026-03-14 | STALE RISK — no auto-update for new iOS releases |
| BLE Appearance Values | tritium-lib/data/ble_appearance_values.json | 22 KB | ~200 | 2026-03-14 | OK — BT SIG updates infrequently |
| BLE Company IDs | tritium-lib/data/ble_company_ids.json | 11 KB | 130 | 2026-03-14 | INCOMPLETE — BT SIG has 3,000+ assigned IDs |
| BLE Fingerprints | tritium-lib/data/ble_fingerprints.json | 21 KB | ~100 | 2026-03-14 | OK — curated |
| BLE Name Patterns | tritium-lib/data/ble_name_patterns.json | 24 KB | ~150 | 2026-03-14 | OK — curated |
| BLE Service UUIDs | tritium-lib/data/ble_service_uuids.json | 8 KB | ~60 | 2026-03-14 | INCOMPLETE — BT SIG has 200+ standard UUIDs |
| Device Classification Rules | tritium-lib/data/device_classification_rules.json | 6 KB | ~40 | 2026-03-14 | OK — curated |
| OUI Device Types | tritium-lib/data/oui_device_types.json | 50 KB | ~500 | 2026-03-14 | OK — curated |
| WiFi SSID Patterns | tritium-lib/data/wifi_ssid_patterns.json | 10 KB | ~80 | 2026-03-14 | OK — curated |
| WiFi Vendor Fingerprints | tritium-lib/data/wifi_vendor_fingerprints.json | 12 KB | ~90 | 2026-03-14 | OK — curated |

### BLE Manufacturer Database — Gaps and Sources

**Bluetooth SIG Company Identifiers** (https://www.bluetooth.com/specifications/assigned-numbers/):
- Official registry has 3,000+ assigned company IDs
- Our `ble_company_ids.json` has only 130 entries (top manufacturers + common IoT vendors)
- The full list is available at https://bitbucket.org/bluetooth-SIG/public/src/main/assigned_numbers/company_identifiers/company_identifiers.yaml
- Also available via NordicSemiconductor/bluetooth-numbers-database on GitHub
- **Action needed**: Expand from 130 to at least 500+ entries covering all major consumer electronics, wearables, and IoT manufacturers

**IEEE OUI Registry** (https://standards-oui.ieee.org/):
- Our `oui.db` has 39,029 entries — this is comprehensive and current
- IEEE publishes the full MA-L (OUI) list as a CSV at https://standards-oui.ieee.org/oui/oui.csv
- **Action needed**: Set up quarterly refresh script (last updated 2026-03-14)

**Apple Continuity Message Types**:
- Apple uses undocumented BLE advertisement subtypes for AirDrop, FindMy, Handoff, etc.
- Community-maintained lists at https://github.com/furiousMAC/continuity (may be stale)
- New types appear with each major iOS release
- **Action needed**: Cross-reference with latest reverse-engineering efforts; current list may miss iOS 19+ types

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
