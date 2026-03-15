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

Status: **PARTIALLY WORKING** (Wave 158 — map loads, targets render, but demo must be started via API call, no obvious UI button)

What's missing:
- [ ] "Start Demo" button visible in the UI without digging through menus
- [ ] Welcome tooltip or overlay (not a blocking wizard) explaining what they're seeing
- [ ] Click-to-inspect a target on the map

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

Status: **BACKEND EXISTS** (Wave 153 dossier enrichment) — but:

What's missing:
- [ ] Click target on map opens inspection panel
- [ ] Inspection panel has "Open Dossier" button that works
- [ ] Dossier panel renders signal history chart (not just JSON)
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
