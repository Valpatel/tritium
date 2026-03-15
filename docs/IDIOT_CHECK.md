# VILLAGE IDIOT REPORT — 2026-03-15

## Summary

WEBSITE: partially broken
MAP: visible — satellite imagery loads, shows a real neighborhood/facility from above
TARGETS ON MAP: no — header says 54 targets but zero dots/markers/blips appear on the map
CLICKING: responds — keyboard shortcuts work (B opens mission select, T/O/S change modes, F zooms)
DEMO MODE: things appeared — scrolling cyan alert text shows up ("confirmed hostile", "unknown contact classified hostile"), target counter goes up, but nothing is plotted on the actual map
APIs: 4 of 5 returned data

## OBVIOUS PROBLEMS

1. **No targets visible on the map.** The header says 54 targets, 33 threats, 21 units. The API returns target data with lat/lng coordinates. The TritiumStore has 50+ units. But the map has ZERO MapLibre markers. Nothing is drawn. The map is just a satellite photo with no dots on it. This is the single biggest problem — the whole point of the product is to show targets on a map, and it does not.

2. **Setup wizard blocks the entire screen on first load.** A "WELCOME TO TRITIUM" setup wizard (6 pages) pops up and covers the map. There is no obvious X button or close mechanism that works. Pressing Escape does not close it. I had to hide it with JavaScript. A new user would be stuck.

3. **Amy is doing nothing.** The Amy Commander panel says "IDLE" and "Awaiting initialization..." with no thoughts, no activity. Demo mode is running with 33 threats and she has nothing to say about it. The AI commander is asleep while the house is on fire.

4. **Fleet devices endpoint is empty.** `GET /api/fleet/devices` returns `{"devices":[], "count":0}` even with demo mode running. If I'm supposed to see my sensor devices, there are none.

5. **Threat level is RED but nothing feels urgent.** The page says THREAT RED, 33 threats, 36 alerts — but visually it looks like a calm satellite photo of a neighborhood. No flashing, no obvious danger indicators on the map. The urgency is only in tiny text in the corners.

6. **The scrolling cyan text is hard to read.** Alert messages scroll across the middle of the map in a stylized font that's small and overlaps with the satellite imagery. It's like subtitles on a bright movie scene — you can barely make them out.

## THINGS THAT WORK

1. **The satellite map loads and looks good.** Real satellite imagery, smooth zooming and panning, proper tile loading. The map itself is solid.

2. **The header bar gives useful info at a glance.** Unit count, threat count, target count, connection status (ONLINE), FPS counter — all there and updating.

3. **The API endpoints return real data.** Targets, dossiers, plugins (23 running), system readiness — the backend is clearly doing work.

4. **WebSocket connection is live.** Status shows WS: OK, and the target counter updates in real-time.

5. **Keyboard shortcuts work.** B opens mission selection, F centers the camera, T/O/S switch map modes. The UI responds to input.

6. **Mission initialization screen looks cool.** When you press B, a proper mission selection screen comes up with BATTLE, DEFENSE, PATROL, ESCORT, CIVIL UNREST, DRONE SWARM options. Cyberpunk aesthetic is on point.

7. **Minimap exists** in the bottom-left corner and shows a small overview.

8. **Filter buttons exist** (SAT, HM, FOG, GRD, PTR, MSH, NIT, TRL, ELP) suggesting there are map layers that can be toggled.

## MY HONEST IMPRESSION

This looks like a backend that works connected to a frontend that is 80% there. The satellite map, the cyberpunk UI chrome, the header stats, the mission selection — all of that is polished and impressive. But the ONE thing this product is supposed to do — show me where targets are on a map — does not work. 54 targets exist in the data and none of them appear on the screen. It's like a weather app that shows a beautiful map but no weather.
