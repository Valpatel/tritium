# Village Idiot Check — Wave 162

**Date:** 2026-03-15
**Loop Tested:** UX Loop 5 — Monitor a Zone
**Tester:** Village Idiot (automated browser walkthrough)

## Overall Verdict: PARTIALLY WORKING — Key wiring gap prevents end-to-end completion

---

## Step-by-Step Results

### Step 1: Open browser, see map, start demo, see targets — PASS
- Map loads correctly with satellite imagery (MapLibre GL)
- Demo mode starts via `POST /api/demo/start` (8 generators running)
- Targets appear on map (8 markers visible: BLE, YOLO, fusion, trilateration)
- Target positions confirmed at lat ~37.7159, lng ~-121.896
- No JS errors on load

### Step 2: Find the geofence drawing tool — PASS (but hard to discover)
- **VIEW menu** in the top menu bar contains "GEOFENCE" entry (among 80+ panel options!)
- Clicking it opens the Geofence panel
- The panel has two tabs (ZONES / EVENTS) and a "+ DRAW ZONE" button
- Right-click context menu also has "CREATE GEOFENCE ZONE HERE"
- **Discoverability concern:** The VIEW menu has 80+ items. Finding "GEOFENCE" requires scrolling. No visual cue that geofencing exists until you explore menus.

### Step 3: Try to draw a polygon on the map — PARTIAL
- The "+ DRAW ZONE" button exists in the geofence panel
- Right-click "CREATE GEOFENCE ZONE HERE" opens the geofence panel and puts a marker at the click location
- However, the polygon drawing interaction was unclear — no visible drawing mode indicator, no polygon vertex placement confirmed
- The zone creation dialog input field was present but not visible/interactable in the test (may be a z-index or visibility CSS issue)

### Step 4: Name the zone and set it as "restricted" — PASS (via API only)
- API endpoint `POST /api/geofence/zones` works correctly
- Accepts: name, zone_type (restricted/monitored/safe), polygon, alert_on_enter, alert_on_exit
- Zone was successfully created: `zone_id=55d56cec4af8`, name "Restricted Zone Alpha", type "restricted"
- API returns proper response with all fields
- **UI path blocked:** The dialog input field from the context menu was not interactable (timed out waiting for visibility)

### Step 5: Wait 30 seconds for notification when target enters — FAIL
- Created a geofence polygon around known target positions (lat 37.7157-37.7161, lng -121.8962 to -121.8958)
- Waited 20+ seconds after zone creation
- **Zero geofence events generated** (`GET /api/geofence/events` returns `[]`)
- **Zero zone occupants detected** (`GET /api/geofence/zones/{id}/occupants` returns `occupant_count: 0`)
- **Zero geofence notifications** (out of 100+ notifications, none from geofence source)
- **Root cause identified:** The `GeofenceEngine.check()` method is never called for real targets. It only gets called from:
  1. `fusion_scenario.py` line 432 — but only for `fusion-*` actor IDs
  2. `battle_integration.py` line 638 — but using local (x, y) coordinates, not lat/lng
- The main target tracker (`target_tracker.py`) does NOT call `geofence_engine.check()` when target positions update
- Even when called by battle_integration, it uses local (x, y) not lat/lng, while the API creates zones with lat/lng polygons — coordinate system mismatch

### Step 6: Check the geofence panel for zone occupancy — FAIL
- Geofence panel opens and shows the created zone in the ZONES tab
- Events tab shows "Loading events..." then empty
- Zone occupancy is always 0 (because check() is never called)
- No visual indication of the geofence polygon on the map

---

## Bugs Found

### Critical
1. **Geofence engine never checks real targets** — `GeofenceEngine.check()` is not called from the target tracker update loop. Zones are created but nothing ever enters or exits them. This makes the entire geofence feature non-functional for BLE/WiFi/camera targets.

2. **Coordinate system mismatch** — The API accepts lat/lng polygons, but `battle_integration.py` calls `check()` with local (x, y) coordinates. These are completely different coordinate spaces.

### Major
3. **Context menu "Create Geofence Zone Here" dialog input not interactable** — The zone name input field exists in the DOM but `element is not visible` according to Playwright. Likely a CSS z-index or display issue with the dialog that appears.

4. **No geofence polygon visualization on map** — After creating a zone, there is no visible polygon drawn on the tactical map. Users can't see where their zones are.

### Minor
5. **VIEW menu has 80+ items** — Discovering the geofence panel requires scrolling through a massive list. Consider grouping or providing a search/filter.

6. **Server crashes during extended Playwright sessions** — The server became unreachable during the first test run (connection refused). May be related to WebSocket pressure from the headed browser session.

---

## What Would Complete Loop 5

To make "Monitor a Zone" work end-to-end, the system needs:

1. **Wire `GeofenceEngine.check()` into the target tracker update loop** — Every time a target's lat/lng position updates, call `geofence_engine.check(target_id, (lat, lng))` with the correct coordinate system.

2. **Ensure polygon coordinates match** — Decide whether geofence polygons are in lat/lng or local x/y, and be consistent. The API and the check() calls must use the same coordinate space.

3. **Fix the zone creation dialog** — Make the input field visible and interactable when triggered from the right-click context menu.

4. **Draw geofence polygons on the map** — Use MapLibre GL's polygon/fill layers to show zone boundaries.

5. **Generate notifications on zone entry/exit** — The EventBus is wired, but since check() is never called, no events flow. Once check() is called, events should propagate to the notification system.

---

## Screenshots

All screenshots saved to `docs/idiot_screenshots/`:
- `step1_initial_load.png` — Map with targets (PASS)
- `loop5_step2_view_menu.png` — VIEW menu showing GEOFENCE option
- `context_menu.png` — Right-click showing "CREATE GEOFENCE ZONE HERE"
- `loop5_step3b_geofence_dialog.png` — Geofence panel after context menu click
- `step5_geofence_created.png` — After API zone creation (server reconnecting banner visible)
- `step6_final.png` — Final state (no events, no occupants)

---

## API Endpoints Verified

| Endpoint | Status | Notes |
|----------|--------|-------|
| `GET /api/geofence/zones` | WORKS | Returns zone list |
| `POST /api/geofence/zones` | WORKS | Creates zone, returns zone_id |
| `DELETE /api/geofence/zones/{id}` | WORKS | Deletes zone |
| `GET /api/geofence/zones/{id}/occupants` | WORKS | Always returns 0 (never populated) |
| `GET /api/geofence/events` | WORKS | Always returns [] (never populated) |
| `GET /api/notifications` | WORKS | Shows 100+ notifications, 0 from geofence |
