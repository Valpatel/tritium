# Village Idiot Check — UX Loop 5: Monitor a Zone

**Date:** 2026-03-15
**Tester:** Village Idiot (automated Playwright, headed browser)
**Server:** http://localhost:8000
**Demo mode:** Active (44 targets)

## Summary

**Score: 7/8 steps PASS.** UX Loop 5 is mostly functional. A user can create a geofence zone, targets trigger enter/exit events, and the geofence panel shows both zones and events. One gap: dossier integration (geofence events are not recorded in target dossiers).

## Step-by-Step Results

| # | Step | Result | Details |
|---|------|--------|---------|
| 1 | Open browser, see map | **PASS** | MapLibre map loads with satellite imagery, canvas present |
| 2 | Start demo, targets visible | **PASS** | 44 targets active across BLE, mesh, camera, fusion |
| 3 | Open Geofence panel | **PASS** | Panel found. Note: `[data-panel="geofence"]` not in menu dropdown; fell back to `panelManager.open('geofence')` via JS. Menu item may be missing from Tactical category dropdown rendering. |
| 4 | Create restricted zone around targets | **PASS** | POST `/api/geofence/zones` returned 201. Zone polygon covers target cluster area. |
| 4b | DRAW ZONE button works | **PASS** | Button `[data-action="draw-zone"]` found and clickable. Emits `geofence:drawZone` event. Toast appears: "Click to place vertices..." |
| 5a | Geofence events fired | **PASS** | 8 events recorded. 4 BLE targets triggered `enter` events for IDIOT-TEST-ZONE. |
| 5b | Zone shows occupant count | **PASS** | `/api/geofence/zones/{id}/occupants` returned `occupant_count=4` with target IDs. |
| 6 | Dossier records geofence event | **FAIL** | `/api/dossier/{target_id}` returns 404. Dossier API is at `/api/dossiers` (plural, list-based). Geofence enter/exit events are NOT automatically added to target dossiers. |

## Visual Observations

- **Map:** Satellite imagery renders correctly. Target markers visible on map.
- **Geofence panel:** Opens on left side. Shows zone list with type color indicator (red for restricted). Events tab shows timestamped enter/exit events.
- **Zone polygon on map:** The geofence polygon zone does NOT appear to render as a colored overlay on the tactical map. The zone exists in the backend and fires events, but there is no visible polygon boundary on the map view. This means the user cannot visually see where their zone is.
- **Toast notifications:** 13 toast elements present on page during test. The system does produce toasts.
- **Menu access:** The geofence panel is listed in the Tactical menu category in code, but the menu dropdown click did not find `[data-panel="geofence"]`. The panel was opened via `panelManager.open('geofence')` fallback.

## Gaps Found

### Critical
1. **Geofence polygon not visible on map** — After creating a zone via API, the polygon boundary does not render on the tactical map. Users cannot see where their zones are. The code has `_drawGeofencePolygonZones()` in `map.js` but it may not be fetching/rendering API-created zones properly.

### Moderate
2. **Dossier integration missing** — Geofence enter/exit events are not recorded in target dossiers. When investigating a target (UX Loop 6), there's no geofence history in the dossier.
3. **Menu panel access** — The Tactical menu dropdown doesn't surface `[data-panel="geofence"]` as a clickable item. The panel exists but isn't easily discoverable through the menu.

### Minor
4. **Zone creation UX** — Creating a zone via the DRAW ZONE button requires clicking vertices on the map, then finishing with double-click or Enter. The flow works but there's no visual guide for the zone name/type input after drawing completes. It would benefit from a modal dialog asking for name and type.

## API Endpoints Verified

| Endpoint | Status | Notes |
|----------|--------|-------|
| `POST /api/demo/start` | Working | Starts 8 generators, 44 targets |
| `GET /api/targets` | Working | Returns all tracked targets with positions |
| `POST /api/geofence/zones` | Working | Creates zone, returns 201 |
| `GET /api/geofence/zones` | Working | Lists all zones |
| `GET /api/geofence/zones/{id}/occupants` | Working | Returns occupant count and target IDs |
| `GET /api/geofence/events` | Working | Returns enter/exit events with timestamps |
| `DELETE /api/geofence/zones/{id}` | Working | Cleans up zone |
| `GET /api/geofence/occupancy` | Not tested | Should return all zone occupancies |

## Screenshots

All saved to `tritium-sc/tests/.baselines/idiot_loop5_*.png`:
- `01_initial_load.png` — Map with satellite imagery, welcome tooltip
- `02_demo_running.png` — Demo active, targets on map
- `03a_tactical_menu.png` — Tactical menu opened
- `03b_geofence_panel.png` — Geofence panel opened
- `04a_draw_zone_mode.png` — Draw zone mode activated
- `04b_zone_created.png` — Zone created, panel shows it
- `05_events_tab.png` — Events tab showing enter events
- `06_final_state.png` — Final state

## Recommendation

UX Loop 5 is **functional at the API level** but has visual gaps. Priority fixes:
1. Render geofence polygon zones on the tactical map (highest impact -- users need to SEE the zone)
2. Wire geofence events into dossier manager (so Loop 6 benefits too)
3. Ensure geofence panel is accessible from menu dropdown
