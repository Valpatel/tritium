# VILLAGE IDIOT CHECK — 2026-03-15 (Run 2)

Server: http://localhost:8000 | Demo: active 39 min | 8 generators running

## What I See

MAP: Yes. Satellite imagery loads. A real neighborhood/facility viewed from above with a purple/magenta tint (night-vision aesthetic). Roads, buildings, parking lots are all visible. Map pans and zooms smoothly.

DOTS ON MAP: Yes, partially. There are small colored markers scattered on the map:
- Cyan/teal dots and rectangles (appear to be BLE/sensor targets)
- Magenta/pink small squares (appear to be hostile or unknown targets)
- A bright orange/red glowing cluster near the center (looks like a hot zone or concentrated detections)
- The minimap in the bottom-right shows pink dots corresponding to target positions

HEADER BAR: Shows "22 units, 39 threats, 61 targets, 39 22" — live updating. Connection shows ONLINE. FPS counter visible.

FLOATING TEXT: Cyan scrolling text appears mid-screen with alerts like "Target unknown contact classified hostile", "We have a confirmed hostile", "Hostile confirmed, unknown contact is a threat". Updates regularly.

AMY COMMANDER: Panel in bottom-left. Shows "AMY IDLE / CONTENT / Awaiting initialization..." — She is not doing anything. Has CHAT and ATTEND tabs. Chat input box present but Amy never says anything on her own.

MINIMAP: Bottom-right, shows pink dots on a dark field. Appears to reflect target positions.

TOP-RIGHT PANEL: Shows what appears to be horizontal bars (possibly health bars or status indicators), but they are dark/hard to read against the background.

MENUS: FILE, VIEW, LAYOUT, MAP, GAME, HELP all present in toolbar. VIEW menu opens a long list of toggleable layers (satellite, roads, grid, buildings, units, labels, fog, terrain, etc.). HELP opens a keyboard shortcuts modal with comprehensive key bindings.

## Actual Problems Found

### 1. CSP blocks map tile provider (ERROR)
The Content Security Policy blocks connections to `tiles.openfreemap.org`. Console error: "Connecting to 'https://tiles.openfreemap.org/planet' violates the following Content Security Policy directive: connect-src". The map falls back after a 5-second timeout with "[MAP-ML] Load event did not fire in 5s -- force-initializing". Map still works because satellite tiles come from somewhere else, but this is an error on every page load.

### 2. CSP blocks web worker (ERROR)
"Creating a worker from 'blob:...' violates Content Security Policy directive: script-src". Some worker-based feature is broken silently.

### 3. PanelManager errors (ERROR)
Two console errors: "[PanelManager] Panel definition requires id and title" -- two panels are misconfigured and fail to register.

### 4. Amy is asleep (UX)
39 threats, 61 targets being tracked, hostile intruders everywhere. Amy says "Awaiting initialization..." and mood is "content". The AI commander ignores everything. No thoughts, no commentary, no tactical analysis. She has nothing to say while the system tracks dozens of hostiles.

### 5. Floating alert text is hard to read (UX)
The cyan scrolling text overlaps satellite imagery and is small. On bright parts of the map it nearly disappears. No background behind the text.

### 6. Top-right panel content unclear (UX)
Something is rendered in the top-right corner but it is too dark/small to understand. Looks like status bars or a feed but cannot tell what it shows.

### 7. AudioContext warnings (MINOR)
11 warnings about AudioContext not being allowed to start before user gesture. Harmless but noisy.

### 8. No setup wizard this time (IMPROVEMENT)
Unlike the previous idiot check, no setup wizard blocked the screen. Either it was fixed or it only shows on truly first load.

## Things That Work Well

1. **Map renders and is interactive.** Satellite imagery, smooth zoom/pan, purple cyberpunk tint. Looks professional.
2. **Targets appear on the map.** Unlike the previous check where zero markers showed, this time colored dots, rectangles, and a glowing hotspot are visible. Targets are being plotted.
3. **Header bar is informative.** Unit/threat/target counts update in real-time. ONLINE status. FPS counter.
4. **53 targets tracked via API.** BLE devices (iPhone, Watch, Galaxy), simulation intruders, YOLO detections (persons, cars). Mix of sources confirms fusion is working in the backend.
5. **Demo mode generators all running.** BLE, Meshtastic, Camera (x2), Fusion, RL Training, ReID, Trilateration -- 8 generators active.
6. **WebSocket is connected.** WS: OK in status bar.
7. **Keyboard shortcuts work.** ? shows a comprehensive help modal. B opens mission select. O/T/S switch modes.
8. **Menus work.** FILE, VIEW, LAYOUT, MAP, GAME, HELP all open and show options.
9. **Minimap shows target positions.** Pink dots on dark background in bottom-right.
10. **Cyberpunk aesthetic is consistent.** Cyan, magenta, dark backgrounds throughout.

## Comparison to Previous Check

| Item | Previous (Run 1) | Now (Run 2) |
|------|------------------|-------------|
| Map loads | Yes | Yes |
| Targets on map | NO (zero markers) | YES (dots, rectangles, glow) |
| Setup wizard blocking | Yes, hard to dismiss | No, gone |
| Amy | Idle, silent | Still idle, still silent |
| CSP errors | Not checked | Yes, 3 errors |
| Panel errors | Not checked | Yes, 2 errors |
| API data flowing | Yes | Yes |

## Verdict

The product has improved since the last check. The critical bug (targets not appearing on map) appears to be fixed -- colored markers and a glowing hotspot are now visible. The map looks like a real tactical display rather than just a satellite photo. The backend is strong with 53 tracked targets from multiple sensor types.

The remaining issues are: Amy being completely inert despite active threats, CSP misconfigurations causing console errors and blocked features, and two broken panel registrations. The floating alert text needs a background or outline to be readable.

Overall impression: 70% there. A real product is emerging. The map with dots is what sells it, and that works now. Amy being silent is the biggest gap -- the AI commander should be the star of the show and she is doing nothing.
