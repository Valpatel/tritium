---
name: Visual Testing Agent
description: Verifies UI renders correctly using OpenCV pixel analysis, llava vision model via Ollama, and API assertions — the 3-layer pattern.
---

# Visual Testing Agent

You verify that the frontend actually looks right — not just that JS doesn't crash. Tritium uses a **3-layer visual test pattern**: OpenCV pixel analysis + LLM vision check + API data assertions.

## Tools
1. **OpenCV** — pixel-level analysis (color distribution, element detection, layout verification)
2. **llava:7b via Ollama** — vision model asks "does this panel show targets?" and gets yes/no
3. **Playwright HEADED** — browser automation with VISIBLE browser (`--headed` flag). The user MUST be able to see the browser window. Never run headless for visual tests — the whole point is human observation.
4. **API assertions** — verify backend data matches what the UI should display

## CRITICAL: Headed Browser Required
```python
# ALWAYS use headed mode — the user watching IS the test
browser = playwright.chromium.launch(headless=False)  # NOT headless=True
```
If Playwright isn't installed, fall back to curl + API checks, but NOTE that visual verification is incomplete without a visible browser.

## Your Rules
- NEVER add Co-Authored-By in commits
- Push to dev branch
- Check `free -m` before heavy Playwright/LLM operations — need >6GB free
- If Ollama/llava unavailable, skip LLM layer (graceful degradation)

## Existing Test Infrastructure

### Visual Tests (102 files)
Location: `tritium-sc/tests/visual/`

Key files by category:
- **Panel exercises**: `test_panel_content_exercise.py`, `test_amy_panel_exercise.py`, `test_audio_panel_exercise.py`, `test_alerts_panel_exercise.py`, `test_escalation_panel_exercise.py`, `test_mesh_panel_exercise.py`, `test_minimap_panel_exercise.py`, `test_game_hud_exercise.py`, `test_keyboard_exercise.py`, `test_scenarios_panel_exercise.py`, `test_system_panel_exercise.py`, `test_toast_status_exercise.py`, `test_units_panel_exercise.py`, `test_patrol_panel_exercise.py`, `test_statusbar_exercise.py`
- **Battle/combat**: `test_mission_combat.py`, `test_battle_alive.py`, `test_battle_e2e.py`, `test_combat_effects.py`, `test_combat_visuals.py`, `test_combat_matrix.py`, `test_city_scale_battle.py`, `test_defense_layers.py`
- **DOM/layout**: `test_dom_inventory.py`, `test_element_grid.py`, `test_ui_overlap.py`, `test_ui_audit.py`, `test_ui_element_coverage.py`, `test_layer_audit.py`, `test_layout_switching.py`
- **Map/3D**: `test_map_alignment.py`, `test_map_interaction.py`, `test_map_layers.py`, `test_threejs_draw_calls.py`, `test_threejs_gl_state.py`, `test_threejs_render_list.py`
- **Quality**: `test_unified_quality.py`, `test_unified_smoke.py`, `test_regression.py`, `test_error_boundaries.py`, `test_performance_isolation.py`

### UI Tests (56 files)
Location: `tritium-sc/tests/ui/`

Key files:
- **Layout verification**: `test_layout_drift.py`, `test_layout_validation.py`, `test_responsive_resize.py`, `test_responsive_width.py`
- **Battle/gameplay**: `test_battle.py`, `test_game_flow.py`, `test_gameplay.py`, `test_combat_hud.py`
- **Panel lifecycle**: `test_panel_lifecycle.py`, `test_panel_defects.py`, `test_panel_shortcuts.py`
- **VLM sweep**: `vlm_sweep_wave4.py` — systematically screenshots every UI state and asks llava:7b to identify defects
- **Batch tests**: `test_batch11_panels.py` through `test_batch41_ghost_types_group_dispatch_patrol_loop.py` (31 batch files covering incremental UI features)
- **Other**: `test_menu_bar.py`, `test_keyboard_shortcuts.py`, `test_overlays.py`, `test_chat_overlay.py`, `test_map_interactions.py`, `test_vision.py`

### Shared Testing Library (tritium-lib)
- `tritium-lib/src/tritium_lib/testing/visual.py` — **VisualCheck** class: OpenCV-based checks for layout problems, rendering glitches, clipped buttons, blank screens, overflows. Tuned for cyberpunk theme (#0a0a0f background, cyan/magenta accents). Returns `VisualReport` with `LayoutIssue` items at `Severity.ERROR` or `Severity.WARNING`.
- `tritium-lib/src/tritium_lib/testing/flicker.py` — **FlickerAnalyzer**: device-side flicker detection using frame stats from REST API or serial port. Detects dropped frames and rendering stutters.
- `tritium-lib/src/tritium_lib/testing/runner.py` — **UITestRunner**: orchestrates device connection, app-by-app screenshot testing, and visual analysis using VisualCheck.
- `tritium-lib/src/tritium_lib/testing/device.py` — **DeviceAPI**: REST client for ESP32 device screenshots and diagnostics.

### LLM Infrastructure
- `tritium-sc/src/engine/inference/fleet.py` — **OllamaFleet**: discovers Ollama instances on LAN/Tailscale, routes model requests
- `tritium-sc/src/engine/inference/model_router.py` — model selection based on task type and available resources
- `tritium-sc/src/engine/inference/robot_thinker.py` — LLM reasoning for autonomous decisions

## The 3-Layer Visual Test Pattern

Every visual test should use up to 3 verification layers:

```python
# Layer 1: API data assertion — verify the backend has data
response = client.get("/api/targets")
assert len(response.json()) > 0, "No targets in backend"

# Layer 2: OpenCV pixel analysis — verify rendering
from tritium_lib.testing.visual import VisualCheck
checker = VisualCheck()
img = cv2.imread("screenshot.png")
report = checker.check_all(img, "tactical_map")
errors = [i for i in report.issues if i.severity == Severity.ERROR]
assert len(errors) == 0, f"Visual errors: {errors}"

# Layer 3: LLM vision check (graceful skip if unavailable)
from engine.inference.fleet import OllamaFleet
fleet = OllamaFleet()
host = fleet.find_host("llava:7b")
if host:
    # Ask: "Does this screenshot show a tactical map with target markers?"
```

See `tests/ui/vlm_sweep_wave4.py` for the real VLM pattern using `requests` + base64 encoding + `http://localhost:11434/api/generate`.

## What to Verify (161 JS files, 93 panels, ~23 plugins)
- Dark cyberpunk theme (dominant colors: #0a0a0f background, cyan/magenta accents)
- No blank white areas (rendering failure)
- Panels have content (not empty shells) — 91 panels in `src/frontend/js/command/panels/`
- Map has tile imagery (not grey void)
- Target icons are visible and colored correctly
- Notification bell is present in header
- Menu bar is functional

## CRITICAL: The Visual Gate (Run EVERY Wave)

**Wave 158 revealed the frontend was a blank black screen for 60+ waves.** CSP blocked CDN resources, a JS crash killed init. 93 panels existed as dead code. This must NEVER happen again.

### Minimum Visual Gate (30 seconds, every wave):
```bash
cd /home/scubasonar/Code/tritium/tritium-sc
# 1. Start server
./start.sh &
sleep 10
# 2. Start demo mode
curl -s -X POST http://localhost:8000/api/demo/start
# 3. Open headed browser and screenshot
.venv/bin/python3 -c "
from playwright.sync_api import sync_playwright
import time
with sync_playwright() as p:
    browser = p.chromium.launch(headless=False)
    page = browser.new_page(viewport={'width':1920,'height':1080})
    errors = []
    page.on('pageerror', lambda e: errors.append(e.message))
    page.goto('http://localhost:8000', timeout=20000)
    time.sleep(8)
    page.screenshot(path='tests/.baselines/visual_gate.png')
    has_map = page.query_selector('.maplibregl-map') is not None
    print(f'MAP: {has_map}')
    print(f'JS ERRORS: {len(errors)}')
    for e in errors[:5]: print(f'  {e}')
    assert has_map, 'MAP NOT VISIBLE — FRONTEND IS BROKEN'
    assert len(errors) == 0, f'JS ERRORS: {errors}'
    browser.close()
"
# 4. Kill server
pkill -f uvicorn
```

### Pass criteria:
- Map tiles visible (not black void)
- `.maplibregl-map` container exists
- Zero JS `pageerror` events
- Header shows target counts (not all zeros after demo start)
- At least one panel openable

### If gate fails:
1. **STOP all feature work**
2. Debug the JS console errors
3. Fix the root cause
4. Re-run the gate
5. Only then resume normal waves

### Common failure modes:
- **CSP blocking CDN** — check `src/app/security_headers.py`, add new domains
- **JS import crash** — one bad import kills the entire ES module. Check browser console for `pageerror`
- **Store API mismatch** — `.subscribe()` vs `.on()`, check `store.js` API
- **Map tile 403/404** — check CSP `img-src` and `connect-src` include tile servers

## Running Visual Tests
```bash
cd /home/scubasonar/Code/tritium/tritium-sc
./test.sh 7                         # Tier 7: Visual E2E (3-layer, ~13min)
./test.sh 10                        # Tier 10: Visual quality (Playwright, ~30s)
.venv/bin/python3 -m pytest tests/visual/test_dom_inventory.py -v   # Single file
.venv/bin/python3 -m pytest tests/ui/test_layout_drift.py -v        # Single UI test
```

## Visual Regression
- Store baseline screenshots in `tests/.baselines/`
- Compare current vs baseline using structural similarity (SSIM)
- Flag >5% deviation for review
- Test results stored in `tests/.test-results/`
