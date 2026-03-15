# Discovery Report -- Wave 154

**Date:** 2026-03-15
**Scope:** Post-Wave 146 audit (Waves 147-153 additions)
**Agent:** Discovery Agent

---

## 1. Orphan Panel Check

**Result: All panels categorized.** All 89 panels registered in `main.js` are present in the `PANEL_CATEGORIES` map in `menu-bar.js`. The menu-bar also has an "Other" catch-all for any uncategorized panels at runtime. No orphan panels found from Waves 147-153.

New Wave 147-153 panels confirmed registered and categorized:
- `trail-export` (Intelligence)
- `lpr` (Intelligence)
- `reid-matches` (Intelligence)
- `fusion-dashboard` (Intelligence)
- `acoustic-intelligence` (Intelligence)
- `convoy` (Tactical)
- `map-layer-switcher` (Map & GIS)
- `operator-cursors` (Collaboration)
- `weather-overlay` (Map & GIS)
- `training-dashboard` (Fleet)
- `swarm-coordination` (Tactical)
- `edge-diagnostics` (Sensors)
- `operator-activity` (Collaboration)
- `federation` (Fleet)

---

## 2. API/Frontend Alignment -- 5 Random Routers

### /api/lpr (lpr.py) -- MISMATCH FOUND
- **Backend endpoints:** POST `/detect`, GET `/detections`, GET `/search`, GET `/stats`, POST `/watchlist`, GET `/watchlist`, DELETE `/watchlist/{plate}`
- **Frontend calls:** `fetch('/api/lpr/')` (line 144 of `lpr.js`) -- **root GET does not exist**, will 404
- Other calls (`/detections`, `/watchlist`, `/search`) are correctly aligned
- **Severity: Medium** -- the LPR panel's overview tab likely fails on load

### /api/reid (reid.py) -- OK
- Backend: GET `/matches`, GET `/persons`, GET `/stats`
- Frontend calls: `/api/reid/stats`, `/api/reid/persons`, `/api/reid/matches` -- all match

### /api/fusion (fusion_dashboard.py) -- PARTIAL
- Backend: GET `/status`, GET `/strategies`, GET `/pairs`, GET `/weights`
- Frontend calls only: `/api/fusion/status`, `/api/fusion/weights`
- `/strategies` and `/pairs` endpoints exist but are never called by frontend
- **Severity: Low** -- dead backend endpoints, not broken functionality

### /api/acoustic (acoustic.py) -- MISMATCH FOUND
- **Backend endpoints:** POST `/classify`, GET `/events`, GET `/stats`
- **Frontend calls:** `/api/acoustic/stats`, `/api/acoustic/timeline`, `/api/acoustic/localizations`, `/api/acoustic/counts`
- **3 frontend calls have no backend endpoints:** `/timeline`, `/localizations`, `/counts`
- **Severity: High** -- the acoustic-intelligence panel's timeline, localization map, and classification chart tabs all fail with 404/405

### /api/collaboration (collaboration.py) -- NO FRONTEND
- Backend has 14 endpoints (workspaces, drawings, chat)
- **Zero frontend calls** -- no JS file references `/api/collaboration`
- **Severity: Low** -- backend-only code, functional but invisible to users

---

## 3. Lib Model Coverage in SC

| Model File | Imported by SC? | Details |
|---|---|---|
| `acoustic_feature_vector.py` | **NO** | Not imported anywhere in tritium-sc. The `AcousticFeatureVector` model is defined but SC never uses it for deserialization. |
| `kml.py` | **YES** | Used in `targets_unified.py` (line 230) for KML trail export and in `geo.py` for KML import. |
| `trail_export.py` | **YES** | Used in `targets_unified.py` (lines 155, 231) for GPX/KML trail export. |
| `convoy_visualization.py` | **NO** | Not imported anywhere in tritium-sc. The convoy overlay JS (`convoy-overlay.js`) uses its own inline data structures instead of consuming the lib model. |

**Finding:** 2 of 4 new lib models (`acoustic_feature_vector`, `convoy_visualization`) are orphaned -- defined in tritium-lib but never consumed by tritium-sc. They represent a broken full-stack contract.

---

## 4. Frontend JS Dead Code

### Confirmed Dead: `operator-cursors.js`
- **File:** `src/frontend/js/command/panels/operator-cursors.js` (218 lines)
- Exports `initCursorSharing` and `destroyCursorSharing`
- **Not imported by any other file** in `src/frontend/js/`
- A separate `operator-cursors-panel.js` exists and is what's actually registered as the `operator-cursors` panel
- The two files appear to be a utility module (`operator-cursors.js`) that was superseded by the panel version (`operator-cursors-panel.js`) but the panel does NOT import the utility

### Not Dead (Verified):
- `weather-overlay.js` -- imported by `weather-overlay-panel.js` as a helper module
- `map-screenshot.js` -- imported in `main.js` via `initScreenshotHotkey`
- All other panel files are imported and registered in `main.js`

---

## 5. Random Deep Dives

### AcousticFeatureVector (tritium-lib)
- Well-structured Pydantic model with MFCC coefficients, spectral features
- Has `to_mqtt_payload()` / `from_mqtt_payload()` with compact key serialization
- MQTT topic: `tritium/{site}/acoustic/{device_id}/features`
- Problem: SC never subscribes to or deserializes these messages

### ConvoyVisualization (tritium-lib)
- Frontend-ready model with bounding box polygon, heading, speed, formation type
- Has `to_dict()` and `from_dict()` for JSON transport
- Problem: The actual convoy overlay in SC (`convoy-overlay.js`) builds its own data structures from target positions rather than consuming this model via API

### operator-cursors.js (tritium-sc frontend)
- 218-line Canvas 2D cursor rendering system
- Supports viewport rectangle sharing (shows what each operator is looking at)
- Throttled WebSocket cursor updates at 200ms intervals
- Well-implemented but completely dead -- nobody calls `initCursorSharing()`

---

## Summary of Actionable Findings

| # | Severity | Finding | Fix |
|---|----------|---------|-----|
| 1 | **HIGH** | Acoustic panel calls 3 nonexistent endpoints (`/timeline`, `/localizations`, `/counts`) | Add missing endpoints to `acoustic.py` or fix frontend to use `/events` and `/stats` |
| 2 | **MEDIUM** | LPR panel calls `GET /api/lpr/` which doesn't exist | Add root GET endpoint to `lpr.py` (return pipeline summary/stats) |
| 3 | **LOW** | `acoustic_feature_vector` lib model never imported by SC | Wire SC acoustic plugin to deserialize MQTT feature vectors using this model |
| 4 | **LOW** | `convoy_visualization` lib model never imported by SC | Wire convoy API/WebSocket to use the lib model instead of ad-hoc structures |
| 5 | **LOW** | `operator-cursors.js` is dead code (218 lines) | Delete it or have `operator-cursors-panel.js` import its rendering logic |
| 6 | **LOW** | `/api/collaboration` has 14 endpoints with zero frontend callers | Build collaboration panel or remove dead backend code |
| 7 | **LOW** | `/api/fusion/strategies` and `/api/fusion/pairs` never called by frontend | Wire into fusion-dashboard panel or remove |
