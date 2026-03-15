# Video Analytics & Historical Footage Review — Research Document

Date: 2026-03-15

---

## 1. Available Public Datasets

### Surveillance & Parking Lot

**VIRAT Video Dataset**
- URL: https://viratdata.org/
- Ground camera and aerial surveillance footage of realistic outdoor scenes
- Annotations: full tracks on all movers, 46 activity types, 7 object types
- License: available for research use (check site for current terms)
- Good for: event detection, activity recognition, multi-object tracking in surveillance settings

**UFPArk (Parking Lot Surveillance)**
- Paper: https://ieeexplore.ieee.org/document/9356211/
- Video clips from a parking lot surveillance camera throughout a full day
- Faces and license plates anonymized
- Good for: vehicle counting, occupancy detection, parking behavior analysis

### Traffic & Vehicles

**UA-DETRAC (Vehicle Detection and Tracking)**
- Samples available via dataset hosting platforms (search "UA-DETRAC")
- 10K+ annotated vehicle images from traffic surveillance cameras
- Annotations in COCO JSON, YOLO Darknet TXT, Pascal VOC XML, TFRecord
- Good for: vehicle detection, classification, tracking from fixed cameras

**Multi-Perspective Traffic Video Dataset**
- Paper: https://www.nature.com/articles/s41597-026-06907-y
- Three viewpoints: vehicle-mounted, roadside surveillance, drone-mounted
- Good for: multi-view fusion, cross-camera correspondence

**TU-DAT (Traffic Anomaly Dataset)**
- Paper: https://www.mdpi.com/1424-8220/25/11/3259
- Spatiotemporal annotations for traffic accident analysis
- Sources: real surveillance footage, public videos, synthetic scenarios
- Good for: anomaly detection, incident alerting

### Multiple Object Tracking

**MOT Challenge (MOT17 / MOT20)**
- URL: https://motchallenge.net/data/MOT17/ and https://motchallenge.net/data/MOT20/
- Benchmark datasets for pedestrian and multi-object tracking
- License: Creative Commons Attribution-NonCommercial-ShareAlike 3.0
- Ground truth annotations, detection files, image sequences
- Good for: tracking algorithm development and benchmarking

### Person Re-Identification

**Market-1501**
- 32,668 bounding boxes, 1,501 identities across 6 cameras
- Download: http://www.liangzheng.org/Project/project_reid.html
- Good for: person ReID model training and evaluation

**DukeMTMC-reID**
- 36,411 bounding boxes, 1,404 identities across 8 cameras
- 16,522 training images, 2,228 query images, 17,661 gallery images
- Good for: cross-camera person matching

### Vehicle Re-Identification

**VeRi-776**
- 49,357 images, 776 vehicles, 20 cameras, 1.0 km2 coverage over 24 hours
- URL: https://github.com/JDAI-CV/VeRidataset
- Good for: vehicle ReID across cameras, cross-camera vehicle tracking

### General Object Detection

**COCO (Common Objects in Context)**
- URL: https://cocodataset.org/
- 123,272+ images with 80 object categories
- License: Creative Commons Attribution 4.0
- Good for: baseline object detection model training, YOLO pre-training

### ReID Dataset Collection

- Comprehensive list: https://github.com/NEU-Gou/awesome-reid-dataset
- Vehicle ReID collection: https://github.com/layumi/Vehicle_reID-Collection
- Torchreid supported datasets: https://kaiyangzhou.github.io/deep-person-reid/datasets.html

---

## 2. UX Patterns for Historical Video Review

### Timeline Scrubber

The core interaction pattern for video review is a horizontal timeline bar spanning hours or days. Key features:

- **Dual-track timeline**: one track shows the video position, a second colored track shows motion/event density so the user knows where activity happened without scrubbing manually
- **Zoom levels**: day view, hour view, minute view — user scrolls to zoom, with the timeline expanding to show more detail
- **Event markers**: colored ticks or blocks on the timeline indicating detected events (person, vehicle, alarm trigger) — clicking jumps to that moment
- **Thumbnail preview on hover**: as the cursor moves over the timeline, a small preview frame appears above it showing what the camera saw at that instant

### Calendar Heat Map

- A month or week calendar grid where each cell (hour or day) is color-coded by activity density
- Hotter colors = more events or more motion detected
- Clicking a cell jumps the timeline to that period
- Useful for identifying patterns: "every day at 3 AM there is activity in the north lot"
- Implementation: cal-heatmap (https://cal-heatmap.com/) or d3-based heatmap libraries work well for vanilla JS

### Smart Fast-Forward

- Skip periods with zero motion automatically (green-light scrubbing)
- Adaptive playback speed: 1x during events, 16x or 64x during idle periods
- "Next event" / "Previous event" buttons to jump between detections
- Filter fast-forward by object type: "skip to next person" or "skip to next vehicle"

### Forensic Search Interface

Modern video review systems provide search panels alongside the timeline:

- **Object type filter**: checkboxes for person, vehicle, animal, unknown
- **Attribute filter**: color, size, direction of travel
- **Zone filter**: select a region of the camera view; only show events in that area
- **Time range filter**: start/end datetime pickers
- **Results gallery**: grid of thumbnail crops from matching detections, each clickable to jump to that moment in the timeline
- **Multi-camera search**: search across all cameras simultaneously, results sorted by time

### Bookmarking and Export

- Mark segments of interest for later review or export
- Add text annotations to specific timestamps
- Export clips with burned-in timestamp and camera ID
- Chain clips from multiple cameras into a single incident timeline

---

## 3. AI Search Capabilities to Build

### Object Re-Identification (ReID)

ReID matches the same person or vehicle across different cameras and time periods. Architecture:

1. **Feature extraction**: for each detection crop, run a ReID model (ResNet50 or Vision Transformer backbone) to produce a 2048-dim embedding vector
2. **Index storage**: store embeddings in a vector database or FAISS index, keyed by target ID, camera, timestamp
3. **Query**: given a crop (from clicking a detection), find the N nearest embeddings across all cameras and times
4. **Cross-camera linking**: when embeddings from different cameras are close enough (cosine similarity > threshold), link them as the same target

Key models and tools:
- **CLIP-ReID**: uses vision-language pre-training for ReID without needing text labels (https://github.com/Syliz517/CLIP-ReID)
- **TF-CLIP**: text-free CLIP for video-based person ReID using sequence features
- **Torchreid**: comprehensive ReID library with many model architectures (https://kaiyangzhou.github.io/deep-person-reid/)
- **FastReID**: production-ready ReID toolbox supporting person and vehicle ReID

### Natural Language Video Search

Use CLIP to search video frames by text description. Architecture:

1. **Frame embedding**: periodically (every 1-5 seconds) extract a frame, encode with CLIP vision encoder into a 512-dim vector
2. **Text query**: user types "red truck entering from north gate", encode with CLIP text encoder into matching 512-dim vector
3. **Similarity search**: find frames where cosine similarity between frame embedding and text embedding is highest
4. **Results**: return ranked thumbnails with timestamps and camera IDs

Open source tools:
- **OpenCLIP**: open implementation of CLIP with many model variants (https://github.com/mlfoundations/open_clip)
- **clip-retrieval**: end-to-end tool to compute embeddings and build a retrieval system (https://github.com/rom1504/clip-retrieval)
- Typical pipeline: extract frames, compute embeddings in batch, store in FAISS, query at search time

### Attribute-Based Search

Build a detection attribute extractor that tags each crop with:
- **Color**: dominant colors (red, blue, white, black, etc.) via color histogram or small classifier
- **Size**: bounding box area relative to frame, mapped to small/medium/large
- **Type**: person, car, truck, motorcycle, bicycle, animal (from YOLO class)
- **Direction**: estimate motion vector from consecutive frames, map to cardinal directions
- **Speed**: pixels/frame translated to approximate real-world speed if camera calibration is known

These attributes go into a structured database alongside the vector embeddings, enabling both semantic search ("red truck") and attribute filters (color=red AND type=truck).

### "Find Similar" Feature

When a user clicks any detection on the map or in the timeline:
1. Extract the ReID embedding for that crop
2. Query the vector index for top-K nearest neighbors
3. Display results as a gallery with camera name, timestamp, and similarity score
4. User can click any result to jump to that moment on that camera
5. Optionally, auto-build a "trail" showing all appearances of that target across cameras in chronological order

### Embedding Pipeline Architecture

For Tritium integration:
```
Camera frame → YOLO detection → crop each box →
  ├── ReID model → 2048-dim embedding → vector store (FAISS/SQLite-vec)
  ├── CLIP model → 512-dim embedding → CLIP index
  ├── Attribute extractor → structured DB columns
  └── Thumbnail → stored as JPEG with metadata
```

All indexed by: target_id, camera_id, timestamp, bounding_box, confidence.

---

## 4. Map-Integrated Video Display Patterns

### Camera Icons on Map

- Place camera icons at their GPS coordinates on the tactical map
- Show field-of-view cone (triangular sector) extending from the camera position
- Color-code camera icons by status: green=online, red=offline, yellow=recording-only, cyan=detecting
- On hover: show camera name, resolution, FPS, last detection count

### Click-to-View Popup

- Click a camera icon on the map to open a floating panel with the live feed
- Panel is draggable and resizable
- Panel header shows camera name, coordinates, detection count
- Panel can be pinned (stays open) or auto-close when clicking elsewhere
- Multiple panels can be open simultaneously for side-by-side comparison

### Detection Event Markers

- When a camera detects an object, place a marker on the map at the estimated real-world position
- Marker icon reflects object type: person silhouette, car icon, animal icon
- Marker color reflects alliance: green=friendly, red=hostile, yellow=unknown
- Click a detection marker to see the crop thumbnail and metadata
- Link from detection marker back to the camera timeline at that moment
- Markers fade/expire after configurable time if no re-detection

### Picture-in-Picture (PiP)

- Designate 1-4 "priority" camera feeds as always-visible PiP windows
- PiP windows dock to a corner or edge of the map view
- When an event triggers on a priority camera, the PiP flashes its border color
- Double-click PiP to expand to full panel

### Video Wall Layout

- Dedicated "Video Wall" view mode separate from the map
- Grid layouts: 1x1, 2x2, 3x3, 4x4, custom
- Drag cameras from a sidebar list into grid cells
- Each cell shows live feed with overlay: camera name, timestamp, detection boxes
- Click a cell to expand it full-screen with timeline scrubber
- Auto-cycle mode: rotate through cameras on a timer
- Event-driven layout: when alarm triggers, override a cell with the alerting camera

### Immersion Mode

- Semi-transparent video overlay on the map, aligned to camera FOV
- Shows what the camera sees projected onto the map surface
- Useful for understanding spatial context: "where exactly on the property is this person?"
- Requires camera calibration (homography matrix mapping image pixels to map coordinates)

---

## 5. Recommended Features for Tritium UX Loops

### Phase 1 — Foundation (Immediate)

1. **Camera map placement**: drag camera icons onto the tactical map at their real-world positions, show FOV cones
2. **Click-to-view popup**: click camera icon to open live feed in floating panel
3. **Detection markers on map**: YOLO detections placed as target markers with type/alliance icons
4. **Basic timeline**: horizontal time bar per camera showing event density, click to jump

### Phase 2 — Historical Review (Near-term)

5. **Calendar heat map panel**: week/month view showing detection density per hour per camera
6. **Smart fast-forward**: skip idle periods, jump between events by type
7. **Forensic search panel**: filter by object type, time range, camera; results as thumbnail gallery
8. **Clip export**: select time range, export video clip with burned-in metadata

### Phase 3 — AI-Powered Search (Medium-term)

9. **ReID pipeline**: embed every detection crop, store in vector index, enable "find similar" from any detection
10. **Target trail builder**: click a detection, see all appearances of that target across cameras in chronological order on the map
11. **Natural language search**: type a text query, get ranked frame results via CLIP embeddings
12. **Attribute tagging**: auto-tag detections with color, size, direction; enable structured filtering

### Phase 4 — Command Center (Advanced)

13. **Video wall mode**: configurable grid layout for multi-camera monitoring
14. **PiP priority feeds**: always-visible feeds for critical cameras
15. **Event-driven layout switching**: alarm triggers auto-display the relevant camera
16. **Immersion mode**: semi-transparent video overlay on map aligned to camera FOV
17. **Cross-camera incident timeline**: stitch clips from multiple cameras into single incident narrative

### Integration with Existing Tritium Systems

- **TargetTracker fusion**: ReID embeddings become another correlation signal alongside BLE/WiFi MAC matching
- **Amy AI commander**: Amy can answer "show me the last time a red vehicle was seen" by querying the CLIP index
- **Automation plugin**: rules like "when person detected in zone X after midnight, alert and save clip"
- **Threat feeds**: match detected vehicle colors/types against known-bad vehicle descriptions
- **Fleet dashboard**: camera health/status integrated into device monitoring

### Test Data Strategy

For development without real cameras:
1. Use VIRAT dataset clips as synthetic camera feeds (load video files, serve frames via MJPEG)
2. Use MOT17 sequences for tracking algorithm development
3. Use Market-1501 / VeRi-776 crops for ReID model testing
4. Generate synthetic detection events from dataset annotations to populate the timeline and map
5. COCO images for YOLO detection baseline validation

---

## Sources

- https://viratdata.org/
- https://motchallenge.net/
- https://cocodataset.org/
- https://github.com/JDAI-CV/VeRidataset
- https://github.com/NEU-Gou/awesome-reid-dataset
- https://github.com/mlfoundations/open_clip
- https://github.com/rom1504/clip-retrieval
- https://github.com/Syliz517/CLIP-ReID
- https://kaiyangzhou.github.io/deep-person-reid/datasets.html
- https://cal-heatmap.com/
- https://github.com/blakeblackshear/frigate
- https://ieeexplore.ieee.org/document/9356211/
