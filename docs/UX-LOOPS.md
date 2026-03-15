# Tritium UX Loops — What Users Actually Do

Every feature must serve a user workflow. If a user can't complete the loop end-to-end, the feature is not done. This document defines the core loops and their current status.

## How to Use This File

Agents should pick a loop, try to complete it in a headed browser, and report what works and what breaks. The Village Idiot agent should attempt one loop per run. Feature agents should build toward completing broken loops before adding new capabilities.

**A loop is COMPLETE when a non-technical user can do it without reading code.**

---

## Loop 1: First Boot — "What am I looking at?"

**The user opens the browser for the first time.**

Steps:
1. Navigate to `http://localhost:8000`
2. See a tactical map with satellite imagery
3. Understand what the UI is (header stats, map, menu bar)
4. Open the VIEW menu and browse available panels
5. Start demo mode (GAME > Start Demo or a visible button)
6. See targets appear on the map within 5 seconds
7. Click a target to see its details

Status: **NEARLY COMPLETE** (Wave 159 audit)
- Steps 1-4: WORKING — map loads, header stats visible, VIEW menu works
- Step 5: PARTIAL — Demo start exists in quick-start panel, ops-dashboard panel, command palette, and setup wizard, but none are auto-visible on first load. User must know to open a specific panel.
- Step 6: WORKING — targets render on map within seconds once demo starts (Wave 158 fix)
- Step 7: PARTIAL — `_openTargetDetailModal` exists in map.js with DOSSIER/GRAPH/INSPECT buttons, but untested visually

What's missing:
- [ ] Demo start button visible without opening a panel (e.g., in header bar or as a floating action button)
- [ ] Welcome tooltip or overlay (not a blocking wizard) explaining what they're seeing
- [x] Click-to-inspect a target on the map (code exists: `_openTargetDetailModal` — needs visual verification)

---

## Loop 2: Add a Sensor Node — "I plugged in a new ESP32"

**The user flashes an ESP32, powers it on, and sees it appear on the map.**

Steps:
1. Flash firmware to ESP32 via USB (or OTA from the dashboard)
2. ESP32 boots, connects to WiFi, sends MQTT heartbeat
3. Device appears in Fleet Dashboard panel automatically
4. User drags the device icon to its physical location on the map
5. Device starts reporting BLE/WiFi sightings
6. Sightings appear as targets on the tactical map near that node's position
7. User can click the node to see its health (battery, uptime, sighting count)

Status: **MOSTLY BACKEND** — Fleet dashboard exists, MQTT bridge works, but:

What's missing:
- [ ] OTA flash from the dashboard (upload firmware, push to device)
- [ ] Drag-to-place device on map (asset placement panel exists but untested)
- [ ] Automatic device appearance when first heartbeat arrives
- [ ] Visual indicator on map showing node's detection radius
- [ ] Click node on map to see health popup

---

## Loop 3: Add a Robot — "I want to deploy a rover"

**The user connects a robot and controls it from the command center.**

Steps:
1. Robot connects via MQTT (using `examples/robot-template/`)
2. Robot appears on the map at its GPS position
3. User clicks robot, sees status (battery, heading, speed)
4. User right-clicks map to dispatch robot to a location
5. Robot navigates to waypoint
6. User draws a patrol route, assigns it to the robot
7. Robot patrols the route, reporting what it sees

Status: **PARTIALLY WORKING** — Robot template exists, MQTT bridge works, dispatch exists, patrol drawing added in Wave 154

What's missing:
- [ ] Robot template actually tested end-to-end with the command center
- [ ] Visual robot icon on map (distinct from other targets)
- [ ] Click-to-see-robot-status popup
- [ ] Dispatch animation (line from robot to destination)
- [ ] Patrol route visible on map when assigned

---

## Loop 4: Run a Combat Simulation — "Let's test our defenses"

**The user starts a battle simulation to exercise the system.**

Steps:
1. Press B or click GAME > Start Battle
2. Select mission type (BATTLE, DEFENSE, PATROL, etc.)
3. Hostiles spawn and move on the map
4. Amy narrates what's happening (commentary, threat assessments)
5. Turrets/drones engage hostiles automatically
6. Kill feed shows eliminations
7. Wave counter shows progression
8. Game ends with stats screen

Status: **PARTIALLY WORKING** — Simulation engine exists, wave system works, but Amy is inert

What's missing:
- [ ] Amy actually responds during battle (she says "Awaiting initialization")
- [ ] Kill feed visible and updating
- [ ] Combat effects visible (tracers, explosions) — code exists but untested visually
- [ ] End-of-battle stats overlay
- [ ] Sound effects playing

---

## Loop 5: Monitor a Zone — "Alert me when someone enters the parking lot"

**The user draws a geofence and gets notified when targets enter it.**

Steps:
1. Click "Draw Geofence" on the map toolbar
2. Draw a polygon around the area of interest
3. Name the zone and set type (monitored/restricted)
4. Zone appears on the map with colored fill
5. When a BLE/camera target enters the zone, a notification appears
6. Notification shows in the alerts panel and as a toast
7. The target's dossier records the zone entry event

Status: **DRAWING WORKS** (Wave 154) — geofence creation works, but:

What's missing:
- [ ] Visual confirmation that geofence alerting is active (zone pulses or has an icon)
- [ ] Toast notification actually appears when target enters zone
- [ ] Dossier panel shows the zone entry event
- [ ] Clear indication of which targets are currently inside which zones

---

## Loop 6: Investigate a Target — "Who is that?"

**The user sees an unknown target and builds a dossier on it.**

Steps:
1. See an unknown target on the map (cyan dot)
2. Click it to see basic info (BLE MAC, device type, RSSI, first seen)
3. Open its dossier (click "Dossier" button in target details)
4. See signal history (RSSI over time)
5. See movement history (zones visited, distance traveled)
6. See behavioral profile (stationary/mobile, activity hours)
7. Tag the target (friendly/hostile/VIP)
8. See correlated targets (this phone belongs to that person on camera)

Status: **FRONTEND WIRED BUT UNTESTED** (Wave 160 audit)
- Step 1-2: PARTIAL — target detail modal exists with basic info, triggered from map click
- Step 3: PARTIAL — modal has DOSSIER button that emits panel open event, but dossier panel may not receive target context
- Step 4-6: BACKEND ONLY — dossier enrichment (Wave 153) has signal history, behavioral profile, but no frontend charts
- Step 7: NOT WIRED — no tag/alliance UI in the target modal
- Step 8: PARTIAL — fusion viz (Wave 153) shows correlated targets, but no visual link lines

What's missing:
- [x] Click target on map opens inspection panel (code exists — `_openTargetDetailModal`)
- [ ] Dossier panel receives target_id from the modal DOSSIER button and loads that target
- [ ] Dossier panel renders signal history chart (not just JSON)
- [ ] Tag target as friendly/hostile/VIP from the modal
- [ ] Correlation visualization (fused targets linked visually)

---

## Loop 7: Flash Firmware — "Update all my nodes at once"

**The user uploads new firmware and pushes it to devices.**

Steps:
1. Open Fleet Dashboard panel
2. See all connected devices with current firmware version
3. Upload new firmware binary
4. Select devices to update (or "Update All")
5. Progress bar shows OTA push status
6. Devices reboot and reconnect with new version
7. Fleet dashboard shows updated version numbers

Status: **NOT IMPLEMENTED** — OTA models exist in edge, but no dashboard UI for firmware upload/push

What's missing:
- [ ] Firmware upload endpoint
- [ ] OTA push from dashboard to devices via MQTT
- [ ] Progress tracking per device
- [ ] Version comparison view

---

## Loop 8: Connect a Camera — "I want to add a security camera"

**The user adds an RTSP camera and sees its feed in the command center.**

Steps:
1. Open Camera Feeds panel
2. Click "Add Camera" and enter RTSP URL
3. Camera feed appears as a live thumbnail
4. Camera is placed on the map at its location
5. YOLO detections from the camera create targets on the map
6. Camera FOV cone visible on the map
7. Click camera on map to see live feed

Status: **PARTIALLY WORKING** — Camera feeds plugin exists, YOLO detector exists

What's missing:
- [ ] "Add Camera" UI in the camera feeds panel
- [ ] Camera placement on map after adding
- [ ] FOV cone visualization on tactical map
- [ ] Click camera icon on map to see feed inline

---

## How Agents Should Use This

1. **Feature agents**: Before building something new, check if it completes a broken step in an existing loop. Completing a loop step is worth more than adding a new backend endpoint.

2. **Village Idiot**: Pick one loop per run. Try to complete it. Report exactly where it breaks.

3. **Quality agents**: For each loop, verify the happy path works end-to-end in a headed browser.

4. **Discovery agents**: Find steps that claim to be done but actually don't work when you try them.

5. **Visual testing**: Screenshot each step of a loop. If any step produces a blank screen or error, the loop is broken.

**The goal: every loop should be completable by Wave 175.**

---

## Wave 160 Meta-Cognition Audit

### Audit of Waves 146-159: UX Loop Impact

| Wave | Focus | UX Loops Served | Verdict |
|------|-------|----------------|---------|
| 146 | Convoy viz, BLE notifications, OWASP audit | Loop 5 (partial: notifications) | Mixed — convoy is new capability, not a loop step |
| 147 | Panel registration, trail export, env sensors | Loop 6 (trail export helps dossier) | Low impact — organized existing panels, trail export backend-only |
| 148 | LPR panel, ReID panel, edge power states | None directly | DRIFT — LPR/ReID are new verticals before core loops complete |
| 149 | Maintenance, model wiring, annotation fix | None | Maintenance wave, acceptable |
| 150 | RL retrain 82%, dead route wiring, milestone report | Loop 6 (RL improves classification) | Mixed — RL accuracy helps but users can't see it; dead route wiring helped |
| 151 | Acoustic MFCC, federation, I2S mic HAL | None directly | DRIFT — new capabilities (acoustic, federation) before loops 1-6 done |
| 152 | Maintenance | None | Maintenance wave, acceptable |
| 153 | Map layer switcher, fusion viz, dossier enrichment | Loop 1 (map layers), Loop 6 (dossier) | GOOD — directly advances two loops |
| 154 | Geofence drawing, patrol routes, discovery | Loop 5 (geofence drawing), Loop 3 (patrol) | GOOD — directly completes loop steps |
| 155 | Security, self-preservation, librarian | None directly | Infrastructure, acceptable |
| 156 | Collaboration hub, indoor positioning | None directly | DRIFT — collaboration/indoor are new features before loops complete |
| 157 | RL 92%, BLE company IDs, indoor panel | Loop 6 (better classification) | Mixed — RL/BLE IDs help accuracy but no visible UX improvement |
| 158 | UI fixes, CSP fixes, target rendering, Village Idiot | Loop 1 (critical fixes) | EXCELLENT — fixed the actual black screen, targets visible |
| 159 | Village Idiot followup, UX Loops framework | Loop 1 (layer cleanup, CSP) | GOOD — created this framework, fixed real rendering bugs |

### Drift Analysis

**14 waves analyzed. Only 4 directly advanced UX loops (153, 154, 158, 159). 4 waves were maintenance. 6 waves built new capabilities that don't serve any loop.**

Key drift patterns:
1. **New verticals before completing core loops**: Waves 148 (LPR/ReID), 151 (acoustic/federation), 156 (collaboration/indoor) added entirely new features while Loop 1 still had a black screen bug and Loop 6 had zero frontend.
2. **Backend-heavy without frontend follow-through**: Dossier enrichment (153), trail export (147), convoy viz (146) all added backend endpoints or lib models but left the user-facing side incomplete.
3. **RL optimization on invisible features**: Waves 150 and 157 improved RL accuracy from 55% to 92%, but users cannot see classification results anywhere in the UI. The RL model classifies targets but no UI element displays the classification or confidence.
4. **Security/maintenance cadence is healthy**: Waves 149, 152, 155 did necessary housekeeping without pretending to advance features.

### Loop Status Summary (Wave 160)

| Loop | Status | Steps Done | Steps Remaining | Priority |
|------|--------|------------|-----------------|----------|
| 1: First Boot | 5/7 | Map, stats, menu, targets render, click-inspect exists | Demo button visible, welcome hint | HIGH |
| 2: Add Sensor | 2/7 | MQTT bridge, fleet dashboard | OTA, drag-place, auto-appear, radius, health popup | LOW (needs hardware) |
| 3: Add Robot | 2/7 | Robot template, patrol drawing | E2E test, robot icon, status, dispatch viz, patrol viz | MEDIUM |
| 4: Combat Sim | 3/8 | Battle start, hostiles spawn, waves | Amy narration, kill feed, effects, stats, sound | MEDIUM |
| 5: Monitor Zone | 3/7 | Geofence draw, zone naming, zone display | Alert on enter, toast, dossier event, zone occupancy | HIGH |
| 6: Investigate | 2/8 | Click-inspect exists, dossier backend | Dossier frontend, charts, tagging, correlation viz | HIGH |
| 7: Flash Firmware | 0/7 | Nothing | Everything | LOW (needs hardware fleet) |
| 8: Connect Camera | 1/7 | Camera plugin exists | Add camera UI, placement, FOV, click-to-view | MEDIUM |

## Next Priorities (Waves 161-165)

Based on the audit, the next 5 waves should focus exclusively on completing loop steps, not adding new capabilities. The system has accumulated significant backend depth but users cannot access most of it.

### Wave 161: Complete Loop 1 (First Boot)
- Add a "START DEMO" button to the header bar or as a floating action button (always visible, not hidden in a panel)
- Add a subtle welcome overlay on first visit (dismiss with click, stored in localStorage)
- Visually verify target click modal works end-to-end in a browser
- **Success criteria**: A new user can go from `localhost:8000` to seeing and clicking targets in under 30 seconds with zero documentation.

### Wave 162: Complete Loop 6 (Investigate Target)
- Wire the target detail modal DOSSIER button to open the dossier panel with the correct target_id
- Render signal history as a sparkline/chart (not JSON) in the dossier panel
- Add "Tag as Friendly/Hostile/VIP" buttons to the target detail modal
- Show RL classification + confidence in the target detail modal (users should SEE the 92% model output)
- **Success criteria**: Click target on map -> see details -> open dossier -> see signal chart -> tag it.

### Wave 163: Complete Loop 5 (Monitor Zone)
- Wire geofence crossing detection to the notification system (toast + alerts panel)
- Show which targets are currently inside each zone (zone tooltip or sidebar)
- Record zone entry/exit events in the target's dossier
- Visual indicator that a zone has active alerting (pulse animation or icon)
- **Success criteria**: Draw zone -> target enters -> toast appears -> dossier records it.

### Wave 164: Loop 4 (Combat Sim) + Loop 8 (Camera)
- Fix Amy: wire battle events to Amy's commentary system so she narrates during simulation
- Add kill feed panel or overlay that updates during battle
- Add "Add Camera" button in camera feeds panel with RTSP URL input
- Camera FOV cone on map for placed cameras
- **Success criteria**: Start battle -> Amy speaks -> kill feed updates. Add camera -> see feed.

### Wave 165: Loop 3 (Robot) + Quality Sweep
- Visual robot icon distinct from targets on the map
- Click robot -> see status (battery, heading, speed, current task)
- Dispatch animation: line from robot to destination when right-click dispatched
- Quality sweep: Village Idiot runs all 8 loops, screenshots each step, reports remaining gaps
- **Success criteria**: Robot on map with distinct icon, clickable status, visible dispatch path.

### Principles for Waves 161-165
1. **No new plugins or capabilities** — only complete existing loop steps
2. **Frontend-first** — the backend exists for most features; wire it to the UI
3. **Visual verification required** — every wave must include a Village Idiot run with screenshots
4. **One loop per wave** — focused completion beats scattered partial progress
5. **Show the models** — RL classification, behavioral profiles, dossier enrichment all exist in backend; make them visible to users
