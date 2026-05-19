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
--   Cmd + Shift + ,          → rename current tab (empty = reset, persisted via resurrect)
--   Cmd + Alt + Space        → copy mode; / ? = EditPattern (defaults); Enter validates pattern + auto-selects match;
--                              n / Shift+n (or Ctrl+n/p, arrows) cycle matches; y copies; Esc clears pattern + closes;
--                              Cmd+F = separate scrollback overlay (see cheatsheet)
--   Cmd + d/D                → split horizontal/vertical
--   Cmd + w                  → close pane
--   Cmd + Shift + z          → zoom pane (Cmd+z stays free for undo)
--   Cmd + Shift + x          → rotate panes (2 panes = swap positions; 3+ = cycle)
--   Cmd + t / 1-9            → new tab / tab by number
--   Cmd + Shift + f          → quick select (URLs, paths, hashes, words 3+)
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
local act = wezterm.action
local mux = wezterm.mux
local config = wezterm.config_builder()

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

-- Scrollback
config.scrollback_lines = 50000

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
        end
      end
    end),
  }
end

-- Neovim smart-splits: OSC user vars for zero-latency cross-boundary navigation/resize
-- SMART_SPLITS_MOVE=<Direction> → ActivatePaneDirection
-- SMART_SPLITS_RESIZE=<Direction>:<Amount> → AdjustPaneSize
wezterm.on("user-var-changed", function(window, pane, name, value)
  if not value or value == "" then
    return
  end

  if name == "SMART_SPLITS_MOVE" then
    window:perform_action({ ActivatePaneDirection = value }, pane)
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

-- Auto-save every 5 minutes
resurrect.state_manager.periodic_save({
  interval_seconds = 300,
  save_tabs = true,
  save_windows = true,
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
-- When a custom title is set, we still want to surface the running process'
-- spinner/status icon (cursor-agent's "⠋ Thinking…", "⏳ Running tool", etc.).
-- Scan every whitespace-separated token of the pane title and keep the first
-- one that contains a UTF-8 multibyte char (byte ≥ 0x80). This catches spinners
-- whether they appear at the start, middle or end of the title: "⠋ Thinking",
-- "Thinking ⠋", "cursor-agent ⠋ tool-call" all yield the braille glyph.
-- Pure ASCII tokens (zsh, nvim, the agent's name, …) are filtered out.
local function extract_status_glyph(pane_title)
  if not pane_title or #pane_title == 0 then return nil end
  for token in pane_title:gmatch("%S+") do
    if token:find("[\128-\255]") then return token end
  end
  return nil
end

wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
  local title = tab.tab_title
  if title and #title > 0 then
    local glyph = extract_status_glyph(tab.active_pane.title)
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

wezterm.on("update-status", function(window, _)
  local workspace = window:active_workspace()
  local key_table = window:active_key_table()
  local left = " " .. workspace
  if key_table then left = left .. "  " .. key_table end
  window:set_left_status(wezterm.format({
    { Foreground = { Color = "#6272a4" } },
    { Text = left .. " " },
  }))
  window:set_right_status("")
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
    mods = "CMD",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  {
    key = "d",
    mods = "CMD|SHIFT",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },

  -- Close pane
  {
    key = "w",
    mods = "CMD",
    action = act.CloseCurrentPane({ confirm = true }),
  },

  -- Zoom pane (Cmd+Shift+Z so Cmd+Z passes through to undo in shell / vim)
  {
    key = "z",
    mods = "CMD|SHIFT",
    action = act.TogglePaneZoomState,
  },

  -- Rotate pane order (sizes stay fixed; contents move). Two panes = swap left/right or top/bottom.
  {
    key = "x",
    mods = "CMD|SHIFT",
    action = act.RotatePanes("Clockwise"),
  },

  -- Tab navigation — Cmd + Shift + left/right
  {
    key = "LeftArrow",
    mods = "CMD|SHIFT",
    action = act.ActivateTabRelative(-1),
  },
  {
    key = "RightArrow",
    mods = "CMD|SHIFT",
    action = act.ActivateTabRelative(1),
  },

  -- Rename current tab (empty input clears the custom title and reverts to
  -- the pane title). Persisted across restarts by resurrect's tab_state.
  -- `phys:Comma` matches the physical key regardless of how Shift transforms
  -- it (Cmd+Shift+, would otherwise send Cmd+< on macOS layouts and miss).
  {
    key = "phys:Comma",
    mods = "CMD|SHIFT",
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
    mods = "CMD|ALT",
    action = act.ActivateCopyMode,
  },

  -- Quick select (URLs, paths, hashes)
  {
    key = "f",
    mods = "CMD|SHIFT",
    action = act.QuickSelect,
  },

  -- macOS text-field habit: terminals usually ignore Cmd+Backspace — send Ctrl+U instead
  -- (zsh emacs/vi insert: kill line backward; vim insert: delete to start of insert).
  {
    key = "Backspace",
    mods = "CMD",
    action = act.SendKey({ key = "u", mods = "CTRL" }),
  },

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
  { key = "phys:S", mods = "CMD|SHIFT", action = resurrect_save_action },
  { key = "phys:O", mods = "CMD|SHIFT", action = resurrect_restore_action },
  { key = "s", mods = "CMD|SHIFT", action = resurrect_save_action },
  { key = "S", mods = "CMD|SHIFT", action = resurrect_save_action },
  { key = "o", mods = "CMD|SHIFT", action = resurrect_restore_action },
  { key = "O", mods = "CMD|SHIFT", action = resurrect_restore_action },

  -- Resurrect: delete saved session
  {
    key = "d",
    mods = "CMD|SHIFT|CTRL",
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
    mods = "CMD|SHIFT|CTRL",
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
    mods = "CMD|SHIFT",
    action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
  },
  {
    key = "n",
    mods = "CMD|SHIFT",
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

-- Quick select — easymotion-like jump-to-word. Defaults already match URLs,
-- paths, hashes, IPs, file:line; we add plain words (3+ chars) so any visible
-- token gets a label. Trigger: Cmd+Shift+F (top-level), or `s` inside copy mode.
config.quick_select_patterns = {
  "\\b\\w{3,}\\b",
}

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