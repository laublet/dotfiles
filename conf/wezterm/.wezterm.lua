-- https://wezterm.org
-- https://github.com/wez/wezterm
-- =============================================================================
-- WezTerm Configuration — Loïc
-- =============================================================================
-- Architecture keybindings :
--   Ctrl + arrows            → navigate panes (smart-splits, Neovim ↔ WezTerm)
--   Ctrl + Shift + arrows    → same (use on macOS if Ctrl+arrows do nothing — OS steals Ctrl+←/→ for spaces)
--   Ctrl + Alt + arrows      → resize panes (smart-splits)
--   Ctrl + Alt + Shift + arrows → swap active pane with neighbor in that direction
--        (2 panes: rotate; 3+: PaneSelect fallback until Lua exposes swap_active_with_index)
--   Cmd + Shift + ←/→        → prev/next tab
--   Cmd + Shift + Ctrl + ←/→ → move current tab left/right (intercalate between others)
--   Cmd + Shift + ,          → rename current tab (empty = reset, persisted via resurrect)
--   Cmd + ↑/↓                → scroll to previous/next prompt in scrollback (OSC 133 — zsh emits markers)
--   Cmd + Shift + ↑          → fast copy of the latest command output (no picker)
--   Ctrl + Shift + O         → fzf picker on every output of this pane (floats inline in zsh via ZLE widget;
--                              split fallback when foreground is not zsh). Enter copies, preview on right.
--   Cmd + Ctrl + Space       → CharSelect (Nerd Font / emoji picker, matches macOS system shortcut)
--   Cmd + Shift + ;          → launch_menu picker (btop, gitui, glab-pick, lazydocker, …)
--   Cmd + Alt + Space        → copy mode; / ? = EditPattern (defaults); Enter validates pattern + auto-selects match;
--                              n / Shift+n (or Ctrl+n/p, arrows) cycle matches; y copies; Esc clears pattern + closes;
--                              Cmd+F = separate scrollback overlay (see cheatsheet)
--   Cmd + d/D                → split horizontal/vertical
--   Cmd + w                  → close pane
--   Cmd + Shift + z          → zoom pane (Cmd+z stays free for undo)
--   Cmd + Shift + x          → rotate panes (2 panes = swap positions; 3+ = cycle)
--   Cmd + t / 1-9            → new tab / tab by number
--   Cmd + Shift + f          → quick select (defaults + words 3+, `/…`, `cd /…`, `[|]…`)
--   (in copy mode) s         → quick select (easymotion-style jump to any word)
--   Cmd + Shift + p          → command palette
--   (recharger la config : défauts WezTerm — Ctrl+Shift+R, Cmd+R)
--   Cmd + Shift + s/o        → save / restore session (resurrect; o/O for restore)
--   Cmd + Shift + Ctrl + d   → delete one saved state (fuzzy)
--   Cmd + Shift + Ctrl + x   → wipe all resurrect state (type DELETE to confirm)
--   Cmd + Shift + l          → switch workspace (fuzzy launcher, lists existing)
--   Cmd + Shift + n          → new/switch workspace by name (prompt)
--   Startup                  → restore last saved workspace (resurrect); fallback: new shell
--   Cmd + Backspace          → Ctrl+U (kill line backward — zsh / vim insert)
--
-- Status bar (left only):
--   active workspace name + active key table (copy mode, leader pending, …)
--   Right side intentionally empty — clock lives in the macOS menu bar,
--   CPU/RAM/network are inspected on demand via btop / bandwhich / nettop.
--
-- NOTE: Ctrl+hjkl intentionally NOT bound here — keeps Ctrl+L (clear),
-- Ctrl+H (backspace), etc. available for the shell.
-- =============================================================================

local wezterm = require("wezterm")

-- Hide macOS pointer until physical move (pairs with AeroSpace move-mouse on window focus).
-- Cursor hide disabled (broken on this Mac + caused click lag). Warp only via AeroSpace/HS.
local function hide_cursor_until_move()
end
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()

-- Linux + keyd: physical Cmd (Super) is remapped to Ctrl before WezTerm sees it.
-- Map mac-style "CMD" chords to CTRL so bindings match unified OS-wide keyd.
local is_linux = wezterm.target_triple:find("linux") ~= nil
local function mac_mods(chord)
  if not is_linux then
    return chord
  end
  if chord == "CMD|CTRL" then
    return "CTRL|ALT" -- CharSelect (no CTRL|CTRL); test and tune if needed
  end
  if chord == "CMD|SHIFT|CTRL" then
    return "CTRL|SHIFT|ALT" -- tab move; triple-mod + keyd may need tuning
  end
  return chord:gsub("CMD", "CTRL")
end

-- =============================================================================
-- Plugins
-- =============================================================================
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

-- =============================================================================
-- Appearance
-- =============================================================================

config.color_scheme = "Dracula (Official)"
config.font = wezterm.font('FiraCode Nerd Font')
config.harfbuzz_features = { 'calt=1', 'liga=1' }
config.font_size = 16.0

config.window_decorations = "RESIZE"
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.window_background_opacity = 1.0

-- Tab bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
-- 60s instead of 10s: each status update triggers a global window redraw
-- which re-evaluates the search pattern in copy mode and snaps the cursor
-- back to the first match (wezterm/wezterm#5952). Status bar still refreshes
-- on user interaction (key press, pane switch, workspace change).
config.status_update_interval = 60000
config.tab_max_width = 32

config.colors = {
  tab_bar = {
    background = "#282a36",
    active_tab = {
      bg_color = "#bd93f9",
      fg_color = "#282a36",
      intensity = "Bold",
    },
    inactive_tab = {
      bg_color = "#44475a",
      fg_color = "#f8f8f2",
    },
    inactive_tab_hover = {
      bg_color = "#6272a4",
      fg_color = "#f8f8f2",
    },
    new_tab = {
      bg_color = "#282a36",
      fg_color = "#f8f8f2",
    },
    new_tab_hover = {
      bg_color = "#6272a4",
      fg_color = "#f8f8f2",
    },
  },
}

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"

-- Hide pointer while typing over the terminal (in addition to focus-based hide below).
config.hide_mouse_cursor_when_typing = true

-- Scrollback
config.scrollback_lines = 50000

-- Bell — silence audible beep, keep a subtle cursor flash, raise a macOS toast.
-- Use with `printf '\a'` (or any TUI bell) to be notified when long commands finish:
--   make build && printf '\a'
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_function     = "EaseIn",
  fade_in_duration_ms  = 75,
  fade_out_function    = "EaseOut",
  fade_out_duration_ms = 150,
  target = "CursorColor",
}

-- Kitty keyboard protocol — richer key reporting (distinguishes Ctrl+I from Tab,
-- preserves all home-row-mods bits from Kyria into Neovim/tmux). If a TUI ever
-- shows garbled escape sequences, flip this to false.
config.enable_kitty_keyboard = true

-- Environment — when WezTerm is launched from Finder/Dock, its PATH is the
-- bare macOS default (no /opt/homebrew/bin). Interactive shells fix themselves
-- via zshrc, but NON-interactive spawns (launch_menu items, background_child_process
-- for the cursor:// hyperlink handler, …) inherit this minimal PATH and silently
-- fail to find Homebrew binaries. Pre-populate PATH here so every wezterm child
-- starts with the right environment.
config.set_environment_variables = {
  PATH = table.concat({
    "/opt/homebrew/bin",
    "/opt/homebrew/sbin",
    "/usr/local/bin",
    (os.getenv("HOME") or "") .. "/.local/bin",
    "/usr/bin",
    "/bin",
    "/usr/sbin",
    "/sbin",
  }, ":"),
}

-- Maximize on startup; primary path = resurrect (current_state + workspace JSON)
wezterm.on("gui-startup", function(cmd)
  local ok = resurrect.state_manager.resurrect_on_gui_startup()
  if not ok then
    local _, _, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
  else
    wezterm.time.call_after(100, function()
      local gui = wezterm.gui.gui_windows()[1]
      if gui then
        gui:maximize()
      end
    end)
  end
end)

-- Bell notification — toast in macOS Notification Center on \a from any pane.
wezterm.on("bell", function(window, pane)
  local title = pane:get_title() or "pane"
  window:toast_notification("WezTerm", "Bell — " .. title, nil, 3000)
end)

-- =============================================================================
-- Launch menu — pre-defined CLI shortcuts surfaced via Cmd+Shift+;
-- =============================================================================
-- Picker keybinding lives in config.keys (ShowLauncherArgs LAUNCH_MENU_ITEMS|FUZZY).
-- bandwhich removed: not installed locally. `brew install bandwhich` then re-add.
config.launch_menu = {
  { label = "btop",              args = { "btop" } },
  { label = "gitui",             args = { "gitui" } },
  { label = "glab-pick",         args = { "glab-pick" } },
  { label = "lazydocker",        args = { "lazydocker" } },
  { label = "nettop",            args = { "nettop" } },
  { label = "mac-startup-clean", args = { "mac-startup-clean" } },
}

-- =============================================================================
-- Hyperlink rules — make `path/to/file.ext:LINE[:COL]` clickable
-- =============================================================================
-- Cmd+click in any compiler/linter/test output (tsc, eslint, cargo, vitest, …)
-- opens the file at the right line/column in Neovim. Keeps the default rules
-- (URLs, ipv4, file://, etc.) by starting from default_hyperlink_rules().
config.hyperlink_rules = wezterm.default_hyperlink_rules()

table.insert(config.hyperlink_rules, {
  regex = [[(?:^|\s)((?:\.{0,2}/|~/|/)[\w./@\-]+\.\w+(?::\d+(?::\d+)?)?)]],
  format = "file-line://$1",
  highlight = 1,
})

local function parse_file_line_uri(spec)
  local file, line, col = spec:match("^(.+):(%d+):(%d+)$")
  if file then
    return file, tonumber(line), tonumber(col)
  end
  file, line = spec:match("^(.+):(%d+)$")
  if file then
    return file, tonumber(line), nil
  end
  return spec, nil, nil
end

local function resolve_file_path(file, pane)
  if file:sub(1, 1) == "~" then
    return wezterm.home_dir .. file:sub(2)
  end
  if file:sub(1, 1) == "/" then
    return file
  end
  local cwd = pane:get_current_working_dir()
  local base = cwd and tostring(cwd) or wezterm.home_dir
  if file:sub(1, 2) == "./" then
    file = file:sub(3)
  end
  return base .. "/" .. file
end

wezterm.on("open-uri", function(_window, pane, uri)
  local spec = uri:match("^file%-line://(.+)$")
  if not spec then
    return -- let wezterm handle URLs / other schemes normally
  end

  local file, line, _col = parse_file_line_uri(spec)
  file = resolve_file_path(file, pane)

  local args = { "nvim" }
  if line then
    table.insert(args, "+" .. line)
  end
  table.insert(args, file)

  local cwd = pane:get_current_working_dir()
  wezterm.cli.spawn(args, { cwd = cwd and tostring(cwd) or nil })
  wezterm.log_info("open-uri: opened in nvim → " .. table.concat(args, " "))
  return false -- prevent default handling (no browser)
end)

-- =============================================================================
-- Smart-splits — Ctrl+arrows nav, Ctrl+Alt+arrows resize (ARROWS ONLY)
-- =============================================================================
-- No Ctrl+hjkl: avoids conflicts with shell keybindings (Ctrl+L=clear, etc.)
-- Kyria: Ctrl+Alt is comfortable (adjacent modifiers on left hand).
-- Ctrl+Cmd was NOT: non-adjacent on Kyria (Ctrl | Alt | Cmd | Shift).
--
-- Detects Neovim via IS_NVIM user var (set by smart-splits mux.wezterm.on_init).
-- Cross-boundary move from nvim: Neovim emits OSC SetUserVar=SMART_SPLITS_MOVE (stderr);
-- user-var-changed runs ActivatePaneDirection (no `wezterm cli` for that navigation step).

local function is_nvim(pane)
  return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
  LeftArrow = "Left",
  DownArrow = "Down",
  UpArrow = "Up",
  RightArrow = "Right",
}

-- move_mods: "CTRL" and/or "CTRL|SHIFT" — macOS often does not deliver plain Ctrl+←/→ to apps
-- (Mission Control "switch space"); Ctrl+Shift+Arrow usually reaches WezTerm. In Neovim we still
-- SendKey as CTRL+Arrow so smart-splits <C-Left> etc. keep working.
local function split_nav(resize_or_move, key, move_mods)
  local dir = direction_keys[key]
  local mods = resize_or_move == "resize" and "CTRL|ALT" or (move_mods or "CTRL")
  return {
    key = key,
    mods = mods,
    action = wezterm.action_callback(function(win, pane)
      if is_nvim(pane) then
        local send_mods
        if resize_or_move == "resize" then
          send_mods = "CTRL|ALT"
        else
          send_mods = "CTRL"
        end
        win:perform_action({
          SendKey = {
            key = key,
            mods = send_mods,
          },
        }, pane)
      else
        if resize_or_move == "resize" then
          win:perform_action({ AdjustPaneSize = { dir, 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = dir }, pane)
          hide_cursor_until_move()
        end
      end
    end),
  }
end

-- Neovim smart-splits: OSC user vars for zero-latency cross-boundary navigation/resize
-- SMART_SPLITS_MOVE=<Direction> → ActivatePaneDirection
-- SMART_SPLITS_RESIZE=<Direction>:<Amount> → AdjustPaneSize
wezterm.on("window-focus-changed", function(window, _pane)
  if window:is_focused() then
    hide_cursor_until_move()
  end
end)

wezterm.on("user-var-changed", function(window, pane, name, value)
  if not value or value == "" then
    return
  end

  if name == "SMART_SPLITS_MOVE" then
    window:perform_action({ ActivatePaneDirection = value }, pane)
    hide_cursor_until_move()
  elseif name == "SMART_SPLITS_RESIZE" then
    local direction, amount = value:match("^(%a+):(%d+)$")
    if direction and amount then
      window:perform_action({ AdjustPaneSize = { direction, tonumber(amount) } }, pane)
    end
  end
end)

-- Swap active pane with the adjacent pane in the given direction (same neighbor rule as
-- ActivatePaneDirection). Stable WezTerm does not expose Tab::swap_active_with_index to Lua;
-- we try it anyway for future builds, then fall back: 2 panes → RotatePanes; 3+ → PaneSelect.
local function swap_with_neighbor(key)
  local dir = direction_keys[key]
  return {
    key = key,
    mods = "CTRL|ALT|SHIFT",
    action = wezterm.action_callback(function(win, pane)
      if is_nvim(pane) then
        win:perform_action({
          SendKey = {
            key = key,
            mods = "CTRL|ALT|SHIFT",
          },
        }, pane)
        return
      end
      local tab = pane:tab()
      if not tab then
        return
      end
      local neighbor = tab:get_pane_direction(dir)
      if not neighbor then
        return
      end
      local target_index = nil
      for _, row in ipairs(tab:panes_with_info()) do
        if row.pane:pane_id() == neighbor:pane_id() then
          target_index = row.index
          break
        end
      end
      if target_index == nil then
        return
      end
      local ok = pcall(function()
        tab:swap_active_with_index(target_index, true)
      end)
      if ok then
        return
      end
      local n = #tab:panes()
      if n == 2 then
        win:perform_action(act.RotatePanes("Clockwise"), pane)
      else
        win:perform_action(
          act.PaneSelect({
            mode = "SwapWithActiveKeepFocus",
          }),
          pane
        )
      end
    end),
  }
end

-- =============================================================================
-- Resurrect — session persistence
-- =============================================================================

-- Auto-save every 5 minutes — workspace only.
-- Workspace state already nests all windows/tabs/panes (cf. window_states[] in the
-- saved JSON), so save_windows/save_tabs are redundant for the startup + fuzzy-load
-- flow used here. They were also the source of massive pollution: each periodic tick
-- writes window/<title>.json and tab/<title>.json, and Cursor Agent titles change at
-- every spinner frame ("Working ...", "Working ..·", "Ready", "Planning", …),
-- producing 5-7 orphan files per conversation.
resurrect.state_manager.periodic_save({
  interval_seconds = 300,
  save_tabs = false,
  save_windows = false,
  save_workspaces = true,
})

-- Limit saved terminal output
resurrect.state_manager.set_max_nlines(5000)

-- Toast notifications on save/load
wezterm.on("resurrect.error", function(err)
  local gui = wezterm.gui.gui_windows()[1]
  if gui then
    gui:toast_notification("WezTerm", "Resurrect error: " .. tostring(err), nil, 4000)
  end
end)

-- Plugin emits file_io.write_state.finished, not state_manager.save_state.finished — toast on manual save in resurrect_save_action

-- Mark which workspace to restore on next startup (not written by save_state alone)
wezterm.on("resurrect.state_manager.periodic_save.finished", function()
  local state = resurrect.workspace_state.get_workspace_state()
  if state and state.workspace then
    resurrect.state_manager.write_current_state(state.workspace, "workspace")
  end
end)

-- =============================================================================
-- Status bar — workspace + key table (left only)
-- =============================================================================
-- Right-side system metrics (CPU/RAM/net/time/hostname) were removed: time is
-- already in the macOS menu bar, and CPU/RAM/net are inspected on demand with
-- btop/bandwhich/nettop, not as ambient noise. Keeping the left side because
-- the active key table indicator (copy mode, leader pending, …) is the only
-- piece of context vim-style usage actually needs.

-- Tab title format: respect custom title set via Cmd+Shift+,; otherwise show
-- the active pane title (process). Tab index prefix helps Cmd+1..9 navigation.
-- Active tab is never truncated (so you always see its full name); inactive
-- tabs follow the max_width budget.
--
-- When a custom title is set and an AI agent CLI is running in the active pane,
-- surface its spinner/status icon (cursor-agent's "⠋ Thinking…", "⏳ Working …",
-- "✅ Ready", "🧭 Planning", etc.). Gated on the foreground process name so that:
--   - starship/p10k prompt icons (git branch, language version, …) never leak in
--   - the glyph disappears as soon as the agent exits and the shell takes over
-- Without this gate, the last status emoji stayed stuck on the tab title forever.
local STATUS_PROCESSES = {
  "cursor%-agent",
  "claude",
  "aider",
  "codex",
}

local function pane_has_status_process(proc_name)
  if not proc_name or proc_name == "" then return false end
  for _, pat in ipairs(STATUS_PROCESSES) do
    if proc_name:match(pat) then return true end
  end
  return false
end

-- Scan tokens for a multibyte char (byte ≥ 0x80). Catches glyphs whether they
-- appear at the start, middle or end of the title.
local function extract_status_glyph(pane)
  if not pane_has_status_process(pane.foreground_process_name) then return nil end
  local title = pane.title
  if not title or #title == 0 then return nil end
  for token in title:gmatch("%S+") do
    if token:find("[\128-\255]") then return token end
  end
  return nil
end

wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
  local title = tab.tab_title
  if title and #title > 0 then
    local glyph = extract_status_glyph(tab.active_pane)
    if glyph then title = glyph .. " " .. title end
  else
    title = tab.active_pane.title
  end
  local prefix = " " .. (tab.tab_index + 1) .. ": "
  local suffix = " "
  if not tab.is_active then
    local budget = max_width - #prefix - #suffix
    if budget > 0 and #title > budget then
      title = wezterm.truncate_right(title, math.max(1, budget - 1)) .. "…"
    end
  end
  return prefix .. title .. suffix
end)

-- Cache last rendered status per window — set_left_status / set_right_status
-- force a window repaint on every call, and a repaint re-evaluates the active
-- copy-mode search pattern (snaps cursor back to first match, see
-- wezterm/wezterm#5952). Status_update_interval is supposed to throttle this
-- handler but the 60s setting is silently ignored in some builds (observed
-- 10s ticks in 20260117). Hard-skipping no-op updates side-steps the issue
-- regardless of how often this event fires.
local last_status_cache = {}

wezterm.on("update-status", function(window, _)
  local workspace = window:active_workspace()
  local key_table = window:active_key_table()
  local left = " " .. workspace
  if key_table then left = left .. "  " .. key_table end
  local key = tostring(window:window_id())
  if last_status_cache[key] == left then return end
  last_status_cache[key] = left
  window:set_left_status(wezterm.format({
    { Foreground = { Color = "#6272a4" } },
    { Text = left .. " " },
  }))
  -- Right status only set once per window (first call), never re-set.
end)

-- =============================================================================
-- Keybindings
-- =============================================================================

-- fuzzy_loader passes id like "workspace/foo+bar.json"; load_state expects logical name (slashes)
local function resurrect_parse_state_id(id)
  local path_sep = "/"
  if wezterm.target_triple == "x86_64-pc-windows-msvc" then
    path_sep = "\\"
  end
  local state_type = id:match("^([^/\\]+)[/\\]")
  local basename = id:match("[/\\]([^/\\]+)$")
  if not state_type or not basename then
    return nil, nil
  end
  local encoded = basename:match("(.+)%.json$")
  if not encoded then
    return nil, nil
  end
  local logical_name = encoded:gsub("+", path_sep)
  return state_type, logical_name
end

local function resurrect_wipe_all_saved_states()
  local base = resurrect.state_manager.save_state_dir
  if not base or base == "" then
    return
  end
  for _, sub in ipairs({ "workspace", "window", "tab" }) do
    local pattern = base .. sub .. "/*.json"
    local files = wezterm.glob(pattern)
    if files then
      for _, p in ipairs(files) do
        pcall(os.remove, p)
      end
    end
  end
  pcall(os.remove, base .. "current_state")
end

-- Key callbacks receive (window, pane); use that window for toasts — gui_windows()[1] can be wrong/nil.
local function resurrect_notify(win, title, message, ms)
  if not win then
    return
  end
  local ok = pcall(function()
    win:toast_notification(title, message, nil, ms)
  end)
  if not ok then
    local gui = win:gui_window()
    if gui then
      pcall(function()
        gui:toast_notification(title, message, nil, ms)
      end)
    end
  end
end

local resurrect_save_action = wezterm.action_callback(function(window, _)
  local ok, err = pcall(function()
    local state = resurrect.workspace_state.get_workspace_state()
    resurrect.state_manager.save_state(state)
    if state.workspace then
      resurrect.state_manager.write_current_state(state.workspace, "workspace")
    end
  end)
  if ok then
    resurrect_notify(window, "WezTerm", "Session saved", 2000)
    wezterm.log_info("resurrect: workspace session saved")
  else
    resurrect_notify(window, "WezTerm", "Session save failed: " .. tostring(err), 5000)
    wezterm.log_error("resurrect save: " .. tostring(err))
  end
end)

-- Semantic zone copy — relies on OSC 133 markers emitted by zsh (see zshrc).
-- Only "Output" is exposed: copying the last command's output is the 95% use
-- case. "Input" zones would require wrapping PROMPT with ;P/;B markers, which
-- conflicts with starship rebuilding PROMPT each precmd cycle — not worth the
-- fragility for "copy the command I just ran" which is also `!!` / Ctrl+R away.
--
-- get_text_from_region (not get_text_from_semantic_zone) avoids the wezterm
-- bug that eats the last line of the zone (wezterm/wezterm#5346, #5806).
-- Single-row zones respect end_x exactly to avoid bleeding into starship's
-- RPROMPT (which sits on the same row as LPROMPT, past a cursor-positioning
-- escape that wezterm classifies as a phantom Output zone boundary).
local function zone_text(pane, zone)
  local txt
  if zone.start_y == zone.end_y then
    txt = pane:get_text_from_region(zone.start_x, zone.start_y, zone.end_x + 1, zone.end_y + 1)
  else
    txt = pane:get_text_from_region(zone.start_x, zone.start_y, 0, zone.end_y + 1)
  end
  return (txt or ""):gsub("[%s\n]+$", "")
end

-- In-window flash via the status bar — replaces window:toast_notification which
-- relies on NSUserNotificationCenter (deprecated since macOS 11, silently
-- dropped on modern macOS regardless of System Settings → Notifications).
-- Status-bar feedback is immediate, always visible, and has zero OS dependency.
-- Auto-clears after `ms` (default 1.8s) via wezterm.time.call_after.
local function flash_status(window, message, ms)
  pcall(function()
    window:set_right_status(wezterm.format({
      { Background = { Color = "#bd93f9" } },
      { Foreground = { Color = "#282a36" } },
      { Attribute = { Intensity = "Bold" } },
      { Text = " " .. message .. " " },
    }))
  end)
  wezterm.time.call_after((ms or 1800) / 1000, function()
    pcall(function() window:set_right_status("") end)
  end)
end

-- Filter pane zones to "real" outputs (start at column 0, non-empty content),
-- skipping starship's phantom mid-row RPROMPT zones. Returns oldest-first.
local function get_real_output_zones(pane)
  local zones = pane:get_semantic_zones("Output")
  local out = {}
  for _, z in ipairs(zones or {}) do
    if z.start_x == 0 then
      local txt = zone_text(pane, z)
      if #txt > 0 then
        table.insert(out, { zone = z, text = txt })
      end
    end
  end
  return out
end

-- Best-effort label: the command line that produced the output (one row above
-- the output's start), falling back to the first non-empty line of the output.
-- get_text_from_region returns plain text (no ANSI), so no stripping needed.
local function command_label(pane, entry)
  local label = ""
  if entry.zone.start_y > 0 then
    local prev = pane:get_text_from_region(0, entry.zone.start_y - 1, 0, entry.zone.start_y) or ""
    label = prev:gsub("[\r\n]+", " "):gsub("^%s+", ""):gsub("%s+$", "")
  end
  if label == "" then
    label = (entry.text:match("[^\n]+") or ""):gsub("^%s+", ""):gsub("%s+$", "")
  end
  label = label:gsub("[\t]+", " ")
  if #label > 120 then label = label:sub(1, 117) .. "..." end
  return label
end

-- Dump every output to <tmpdir>/NNN.txt (001 = latest) plus a manifest. Returns
-- tmpdir for the picker script, or nil if no outputs.
--
-- Security: uses `mktemp -d` (no args) which lands in $TMPDIR — on macOS that's
-- /var/folders/<hash>/T/, a per-user directory created with 0700 perms atomically
-- (race-free, unpredictable name). The picker script wipes tmpdir on EXIT via
-- trap, so files normally don't outlive the picker invocation. Worst case
-- (SIGKILL) macOS auto-cleans $TMPDIR on reboot or after ~3 days of inactivity.
local function dump_outputs_for_picker(pane)
  local outputs = get_real_output_zones(pane)
  if #outputs == 0 then return nil end

  local handle = io.popen("mktemp -d 2>/dev/null")
  if not handle then return nil end
  local tmpdir = (handle:read("*l") or ""):gsub("%s+$", "")
  handle:close()
  if tmpdir == "" then return nil end

  local lines = {}
  for picker_idx = 1, #outputs do
    local entry = outputs[#outputs - picker_idx + 1]  -- 1 = latest
    local fname = string.format("%s/%03d.txt", tmpdir, picker_idx)
    local f = io.open(fname, "w")
    if f then
      f:write(entry.text)
      f:close()
    end
    table.insert(lines, string.format("%03d\t%s", picker_idx, command_label(pane, entry)))
  end
  local mf = io.open(tmpdir .. "/manifest", "w")
  if mf then
    mf:write(table.concat(lines, "\n") .. "\n")
    mf:close()
  end
  return tmpdir
end

local picker_bin = (os.getenv("HOME") or "") .. "/.local/bin/wezterm-output-picker"

-- TUIs that use "q" to quit but ignore SIGINT when kitty keyboard is enabled (btop, …).
local function foreground_is(proc_substr)
  return function(pane)
    local name = pane:get_foreground_process_name() or ""
    return name:find(proc_substr, 1, true) ~= nil
  end
end

local function tui_quit_or(fallback_action)
  return wezterm.action_callback(function(window, pane)
    if foreground_is("btop")(pane) then
      pane:send_text("q")
    else
      window:perform_action(fallback_action, pane)
    end
  end)
end

-- Quick path: copy the latest output to clipboard, no picker, no preview, no
-- choice. Single keystroke for the 80% case. Status bar flashes purple.
local copy_last_output_action = wezterm.action_callback(function(window, pane)
  local ok, err = pcall(function()
    local outputs = get_real_output_zones(pane)
    if #outputs == 0 then
      flash_status(window, "No output yet — run a command first (or `exec zsh`)", 3000)
      return
    end
    local entry = outputs[#outputs]
    window:copy_to_clipboard(entry.text, "ClipboardAndPrimarySelection")
    flash_status(window, string.format("Copied last output (%d chars)", #entry.text), 1800)
  end)
  if not ok then
    wezterm.log_error("copy_last_output: " .. tostring(err))
    pcall(function() flash_status(window, "Copy failed: " .. tostring(err), 4000) end)
  end
end)

-- Picker path: when the foreground process is an interactive zsh, hand off to
-- a ZLE widget (`__wezterm_output_picker_widget` in zshrc) bound to Ctrl+X
-- Ctrl+P. We write the tmpdir to a per-pane marker file then send the key
-- sequence: the widget reads the marker and runs `wezterm-output-picker` in
-- the current tty. fzf inherits FZF_DEFAULT_OPTS (`--height 40% --border`),
-- so it floats inline like any other fzf widget (Ctrl+T, Ctrl+R) — no pane
-- split, no layout disruption.
--
-- Fallback (vim, TUI, anything not zsh): keep the old behavior of opening
-- the picker in a split pane. Better than nothing, and the user explicitly
-- triggered the picker so a split is acceptable.
local function pane_is_interactive_zsh(pane)
  local info = pane:get_foreground_process_info()
  if not info or not info.name then return false end
  -- info.name = basename of executable; matches zsh, -zsh (login), etc.
  return info.name:match("zsh$") ~= nil
end

local function marker_path_for_pane(pane)
  return "/tmp/.wezterm-output-picker." .. tostring(pane:pane_id())
end

local pick_output_action = wezterm.action_callback(function(window, pane)
  local ok, err = pcall(function()
    local tmpdir = dump_outputs_for_picker(pane)
    if not tmpdir then
      flash_status(window, "No outputs to pick — run a command first (or `exec zsh`)", 3000)
      return
    end
    if pane_is_interactive_zsh(pane) then
      local marker = marker_path_for_pane(pane)
      local f = io.open(marker, "w")
      if f then
        f:write(tmpdir)
        f:close()
        -- Ctrl+X Ctrl+P (0x18 0x10) — bound in zshrc to the widget.
        pane:send_text("\x18\x10")
        return
      end
      wezterm.log_warn("pick_output: could not write marker " .. marker .. ", falling back to split")
    end
    window:perform_action(act.SplitPane({
      direction = "Down",
      size = { Percent = 75 },
      command = { args = { picker_bin, tmpdir } },
    }), pane)
  end)
  if not ok then
    wezterm.log_error("pick_output: " .. tostring(err))
    pcall(function() flash_status(window, "Picker failed: " .. tostring(err), 4000) end)
  end
end)

local resurrect_restore_action = wezterm.action_callback(function(win, pane)
  resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, _, _)
    local state_type, logical_name = resurrect_parse_state_id(id)
    if not state_type or not logical_name then
      return
    end
    local state
    if state_type == "workspace" then
      state = resurrect.state_manager.load_state(logical_name, "workspace")
      resurrect.workspace_state.restore_workspace(state, {
        window = win,
        relative = true,
        restore_text = true,
        on_pane_restore = resurrect.tab_state.default_on_pane_restore,
      })
    elseif state_type == "window" then
      state = resurrect.state_manager.load_state(logical_name, "window")
      resurrect.window_state.restore_window(pane:window(), state, {
        relative = true,
        restore_text = true,
        on_pane_restore = resurrect.tab_state.default_on_pane_restore,
      })
    elseif state_type == "tab" then
      state = resurrect.state_manager.load_state(logical_name, "tab")
      resurrect.tab_state.restore_tab(pane:tab(), state, {
        relative = true,
        restore_text = true,
        on_pane_restore = resurrect.tab_state.default_on_pane_restore,
      })
    end
  end, {
    title = "Restore Session",
    description = "Select session to restore. Enter = accept, Esc = cancel, / = filter",
    fuzzy_description = "Filter: ",
    is_fuzzy = true,
  })
end)

-- Linux + keyd: Cmd and Ctrl both arrive as CTRL — copy on Ctrl+C, SIGINT on Ctrl+Shift+C.
-- macOS: Cmd+C copy, Ctrl+C interrupt (distinct modifiers).
local copy_interrupt_bindings = is_linux and {
    {
      key = "c",
      mods = "CTRL",
      action = tui_quit_or(act.CopyTo("Clipboard")),
    },
    {
      key = "c",
      mods = "CTRL|SHIFT",
      action = tui_quit_or(act.SendKey({ key = "c", mods = "CTRL" })),
    },
  } or {
    {
      key = "c",
      mods = "CMD",
      action = tui_quit_or(act.CopyTo("Clipboard")),
    },
    {
      key = "c",
      mods = "CTRL",
      action = tui_quit_or(act.SendKey({ key = "c", mods = "CTRL" })),
    },
  }

config.keys = {
  -- Smart-splits: pane navigation (Ctrl + arrows)
  split_nav("move", "LeftArrow", "CTRL"),
  split_nav("move", "LeftArrow", "CTRL|SHIFT"),
  split_nav("move", "DownArrow", "CTRL"),
  split_nav("move", "DownArrow", "CTRL|SHIFT"),
  split_nav("move", "UpArrow", "CTRL"),
  split_nav("move", "UpArrow", "CTRL|SHIFT"),
  split_nav("move", "RightArrow", "CTRL"),
  split_nav("move", "RightArrow", "CTRL|SHIFT"),

  -- Smart-splits: pane resize (Ctrl + Alt + arrows)
  split_nav("resize", "LeftArrow"),
  split_nav("resize", "DownArrow"),
  split_nav("resize", "UpArrow"),
  split_nav("resize", "RightArrow"),

  -- Swap with neighbor in direction (see swap_with_neighbor)
  swap_with_neighbor("LeftArrow"),
  swap_with_neighbor("DownArrow"),
  swap_with_neighbor("UpArrow"),
  swap_with_neighbor("RightArrow"),

  -- Split creation: Cmd+d / Cmd+Shift+d (standard, no conflicts)
  -- Neovim uses Space+| / Space+- (different level: app vs editor)
  {
    key = "d",
    mods = mac_mods("CMD"),
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "d",
    mods = mac_mods("CMD|SHIFT"),
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },

  -- Close pane
  {
    key = "w",
    mods = mac_mods("CMD"),
    action = act.CloseCurrentPane({ confirm = true }),
  },

  -- Zoom pane (Cmd+Shift+Z so Cmd+Z passes through to undo in shell / vim)
  {
    key = "z",
    mods = mac_mods("CMD|SHIFT"),
    action = act.TogglePaneZoomState,
  },

  -- Rotate pane order (sizes stay fixed; contents move). Two panes = swap left/right or top/bottom.
  {
    key = "x",
    mods = mac_mods("CMD|SHIFT"),
    action = act.RotatePanes("Clockwise"),
  },

  -- Tab navigation — Cmd + Shift + left/right
  {
    key = "LeftArrow",
    mods = mac_mods("CMD|SHIFT"),
    action = act.ActivateTabRelative(-1),
  },
  {
    key = "RightArrow",
    mods = mac_mods("CMD|SHIFT"),
    action = act.ActivateTabRelative(1),
  },

  -- Tab reorder — Cmd + Shift + Ctrl + left/right (move the active tab itself).
  -- Wraps around the tab strip; press repeatedly to intercalate at any position.
  {
    key = "LeftArrow",
    mods = mac_mods("CMD|SHIFT|CTRL"),
    action = act.MoveTabRelative(-1),
  },
  {
    key = "RightArrow",
    mods = mac_mods("CMD|SHIFT|CTRL"),
    action = act.MoveTabRelative(1),
  },

  -- Scrollback semantic navigation — Cmd + Up/Down jumps to prev/next prompt.
  -- Requires OSC 133 markers from the shell (see zshrc `_osc133_precmd`).
  {
    key = "UpArrow",
    mods = mac_mods("CMD"),
    action = act.ScrollToPrompt(-1),
  },
  {
    key = "DownArrow",
    mods = mac_mods("CMD"),
    action = act.ScrollToPrompt(1),
  },

  -- Cmd+Shift+↑ — fast path: copy the latest output direct to clipboard
  -- (status bar flash, no picker). For the 80% case "I just want what I
  -- just saw" — single keystroke, zero friction.
  {
    key = "UpArrow",
    mods = mac_mods("CMD|SHIFT"),
    action = copy_last_output_action,
  },

  -- Ctrl+Shift+O — full picker over every output of this pane (fzf preview).
  -- Mnemonic: Output. Avoids plain Ctrl+O (zsh readline `operate-and-get-next`).
  -- Opens in a split pane below the current one; nothing hits clipboard until
  -- you press Enter on a selection (keeps the clipboard history clean).
  {
    key = "o",
    mods = "CTRL|SHIFT",
    action = pick_output_action,
  },

  -- Rename current tab (empty input clears the custom title and reverts to
  -- the pane title). Persisted across restarts by resurrect's tab_state.
  -- `phys:Comma` matches the physical key regardless of how Shift transforms
  -- it (Cmd+Shift+, would otherwise send Cmd+< on macOS layouts and miss).
  {
    key = "phys:Comma",
    mods = mac_mods("CMD|SHIFT"),
    action = act.PromptInputLine({
      description = "Rename tab (empty to reset)",
      action = wezterm.action_callback(function(window, _, line)
        if line == nil then return end -- Esc cancelled
        window:active_tab():set_title(line)
      end),
    }),
  },

  -- Copy mode — Cmd + Alt + Space (vim-like selection).
  -- Cmd+Shift+Space is grabbed by Slack to focus the active huddle window.
  {
    key = "Space",
    mods = mac_mods("CMD|ALT"),
    action = act.ActivateCopyMode,
  },

  -- Quick select (URLs, paths, hashes)
  {
    key = "f",
    mods = mac_mods("CMD|SHIFT"),
    action = act.QuickSelect,
  },

  -- CharSelect — Unicode / Nerd Font / emoji picker, matches the macOS system
  -- emoji shortcut (Cmd+Ctrl+Space) so muscle memory transfers from other apps.
  -- group=NerdFonts so the picker opens directly on the full Nerd Font glyph set
  -- (the implicit default is RecentlyUsed which is empty/sparse). Inside the
  -- picker: Tab cycles to Emoji/UnicodeNames/etc., fuzzy filter live as you type.
  {
    key = "Space",
    mods = mac_mods("CMD|CTRL"),
    action = act.CharSelect({
      group = "NerdFonts",
      copy_on_select = true,
      copy_to = "ClipboardAndPrimarySelection",
    }),
  },

  -- macOS text-field habit: terminals usually ignore Cmd+Backspace — send Ctrl+U instead
  -- (zsh emacs/vi insert: kill line backward; vim insert: delete to start of insert).
  {
    key = "Backspace",
    mods = mac_mods("CMD"),
    action = act.SendKey({ key = "u", mods = "CTRL" }),
  },

  -- Copy / interrupt: appended after config.keys (see copy_interrupt_bindings above).

  -- Disable Ctrl-based defaults that conflict with home-row mods (Kyria CAGS).
  -- Keep Ctrl+Tab available for terminal apps (Neovim buffer nav).
  -- We send Ctrl+PageDown/PageUp because those are reliably distinct in TUIs.
  { key = "Tab", mods = "CTRL", action = act.SendKey({ key = "PageDown", mods = "CTRL" }) },
  { key = "Tab", mods = "CTRL|SHIFT", action = act.SendKey({ key = "PageUp", mods = "CTRL" }) },
  { key = "t", mods = "CTRL", action = act.SendKey({ key = "t", mods = "CTRL" }) },
  { key = "t", mods = "CTRL|SHIFT", action = act.SendKey({ key = "t", mods = "CTRL|SHIFT" }) },
  { key = "w", mods = "CTRL", action = act.SendKey({ key = "w", mods = "CTRL" }) },
  { key = "w", mods = "CTRL|SHIFT", action = act.SendKey({ key = "w", mods = "CTRL|SHIFT" }) },

  -- Resurrect: save / restore — phys:S/O matches Cmd+Shift on US key positions (layout-independent).
  -- Also mapped s/S/o/O: macOS may emit different key/mods; see wezterm.org/config/keys.html (phys vs mapped).
  { key = "phys:S", mods = mac_mods("CMD|SHIFT"), action = resurrect_save_action },
  { key = "phys:O", mods = mac_mods("CMD|SHIFT"), action = resurrect_restore_action },
  { key = "s", mods = mac_mods("CMD|SHIFT"), action = resurrect_save_action },
  { key = "S", mods = mac_mods("CMD|SHIFT"), action = resurrect_save_action },
  { key = "o", mods = mac_mods("CMD|SHIFT"), action = resurrect_restore_action },
  { key = "O", mods = mac_mods("CMD|SHIFT"), action = resurrect_restore_action },

  -- Resurrect: delete saved session
  {
    key = "d",
    mods = mac_mods("CMD|SHIFT|CTRL"),
    action = wezterm.action_callback(function(win, pane)
      resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id)
        resurrect.state_manager.delete_state(id)
      end, {
        title = "Delete Session",
        description = "Select session to delete. Enter = accept, Esc = cancel",
        fuzzy_description = "Filter: ",
        is_fuzzy = true,
      })
    end),
  },

  -- Resurrect: wipe all saved states (type DELETE)
  {
    key = "x",
    mods = mac_mods("CMD|SHIFT|CTRL"),
    action = act.PromptInputLine({
      description = "Wipe ALL resurrect states. Type DELETE to confirm (Esc to cancel).",
      action = wezterm.action_callback(function(_, _, line)
        if line == "DELETE" then
          resurrect_wipe_all_saved_states()
          local gui = wezterm.gui.gui_windows()[1]
          if gui then
            gui:toast_notification("WezTerm", "All resurrect state files removed", nil, 3000)
          end
        end
      end),
    }),
  },

  -- Workspaces: switch is per-window (each window has its own active_workspace).
  -- Cmd+Shift+L: fuzzy switcher across existing workspaces (also lets you
  -- start a new one by typing a fresh name and confirming).
  -- Cmd+Shift+N: prompt for a workspace name; creates it if it doesn't exist
  --             and switches the current window to it.
  {
    key = "l",
    mods = mac_mods("CMD|SHIFT"),
    action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
  },

  -- Launch menu (config.launch_menu entries) — quick-launch CLIs in the current pane.
  -- Cmd+Shift+; is free in the existing keymap and sits next to Cmd+Shift+L (other launcher).
  {
    key = "phys:Semicolon",
    mods = mac_mods("CMD|SHIFT"),
    action = act.ShowLauncherArgs({ flags = "FUZZY|LAUNCH_MENU_ITEMS" }),
  },
  {
    key = "n",
    mods = mac_mods("CMD|SHIFT"),
    action = act.PromptInputLine({
      description = "Workspace name (new or existing)",
      action = wezterm.action_callback(function(window, pane, line)
        if line and #line > 0 then
          window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
        end
      end),
    }),
  },
}

for _, binding in ipairs(copy_interrupt_bindings) do
  table.insert(config.keys, binding)
end

-- search_mode: Enter → AcceptPattern (exit to copy_mode at current match);
-- Escape → Close. Wezterm's default Enter is PriorMatch (cycles inside
-- search_mode), so we override explicitly. Since wezterm/wezterm#4924
-- (merged 2024-07), `Close` no longer scrolls back to the prompt — the
-- `CloseWithoutClear` name from the PR description was renamed to `Close`
-- before merge and never shipped.
--
-- We hardcode the table instead of patching default_key_tables() because
-- some wezterm builds return mods values that fail our `mods == "NONE" or nil`
-- check, silently skipping the override and leaving Enter on PriorMatch.
-- Printable chars are appended to the search pattern by wezterm even without
-- an explicit binding, so this minimal table is sufficient.
local function build_search_mode_accept_pattern()
  return {
    -- Enter just AcceptPattern: wezterm auto-selects the current match (search
    -- mode default selection behavior). Press `y` to copy immediately, or
    -- `n`/`N` to navigate further. Forcing ClearSelectionMode here would fight
    -- against that and leave you with nothing selected.
    { key = "Enter",     mods = "NONE", action = act.CopyMode("AcceptPattern") },
    { key = "Escape",    mods = "NONE", action = act.CopyMode("Close") },
    { key = "n",         mods = "CTRL", action = act.CopyMode("NextMatch") },
    { key = "p",         mods = "CTRL", action = act.CopyMode("PriorMatch") },
    { key = "r",         mods = "CTRL", action = act.CopyMode("CycleMatchType") },
    { key = "u",         mods = "CTRL", action = act.CopyMode("ClearPattern") },
    { key = "PageUp",    mods = "NONE", action = act.CopyMode("PriorMatchPage") },
    { key = "PageDown",  mods = "NONE", action = act.CopyMode("NextMatchPage") },
    { key = "UpArrow",   mods = "NONE", action = act.CopyMode("PriorMatch") },
    { key = "DownArrow", mods = "NONE", action = act.CopyMode("NextMatch") },
  }
end

-- copy_mode default Escape = ScrollToBottom + Close, so after a scrollback
-- search you jump to the prompt. Replace with a vim-style smart Escape:
--   - if a selection is active → clear it (stay in copy mode, keep pattern
--     so n/N still navigate matches)
--   - otherwise → ClearPattern + Close. Clearing the pattern is critical:
--     wezterm retriggers the search on every terminal output (starship
--     redraw, async git, clock), which periodically teleports the cursor
--     back to the first match (wezterm/wezterm#5952). Dropping the buffer
--     on exit stops that behavior for subsequent sessions.
local function copy_mode_smart_escape()
  return wezterm.action_callback(function(window, pane)
    local sel = window:get_selection_text_for_pane(pane)
    if sel and #sel > 0 then
      window:perform_action(act.CopyMode("ClearSelectionMode"), pane)
    else
      window:perform_action(act.CopyMode("ClearPattern"), pane)
      window:perform_action(act.CopyMode("Close"), pane)
    end
  end)
end

local function build_copy_mode_smart_escape()
  if wezterm.gui then
    local defaults = wezterm.gui.default_key_tables()
    if defaults and defaults.copy_mode then
      local out = {}
      for _, b in ipairs(defaults.copy_mode) do
        -- Drop every existing Escape binding; ours is appended below
        if b.key ~= "Escape" then
          table.insert(out, b)
        end
      end
      table.insert(out, { key = "Escape", mods = "NONE", action = copy_mode_smart_escape() })
      return out
    end
  end
  return nil
end

config.key_tables = config.key_tables or {}
config.key_tables.search_mode = build_search_mode_accept_pattern()
config.key_tables.copy_mode = build_copy_mode_smart_escape()

-- Quick select — easymotion-like. Custom patterns are OR'd with WezTerm defaults
-- (URLs, paths, hashes, …). Do NOT use variable-width lookbehind (?<=\d+\s+) etc.:
-- one bad pattern breaks the whole alternation → zero highlights.
-- No raw `|` in a pattern (it splits the outer alternation); use [|] if needed.
config.quick_select_patterns = {
  "\\b\\w{3,}\\b",
  -- Absolute paths (/Users/…). No look-around.
  "/[A-Za-z0-9._~+/_-]+",
  -- atuin `12|cd /path` — whole tail after pipe (includes "cd "); pick `/…` label for path only
  "[|][^\\n]+",
  -- `cd /path` as one token (copies "cd " + path; path-only is the `/…` match above)
  "\\bcd /\\S+",
}
config.disable_default_quick_select_patterns = false

if config.key_tables.copy_mode then
  -- `s` triggers QuickSelect from copy mode (easymotion-style copy)
  table.insert(config.key_tables.copy_mode, { key = "s", mods = "NONE", action = act.QuickSelect })
  -- Defensive: ensure `/` opens search-mode from copy-mode. Some wezterm builds
  -- return incomplete defaults from gui.default_key_tables(), losing this binding.
  table.insert(config.key_tables.copy_mode, { key = "/", mods = "NONE", action = act.CopyMode("EditPattern") })
  -- Vim-style match navigation: `n` next, `Shift+n` previous. Defaults only
  -- provide Ctrl+n/Ctrl+p; keep those as fallback alongside arrows.
  table.insert(config.key_tables.copy_mode, { key = "n", mods = "NONE",  action = act.CopyMode("NextMatch") })
  table.insert(config.key_tables.copy_mode, { key = "n", mods = "SHIFT", action = act.CopyMode("PriorMatch") })
end

return config