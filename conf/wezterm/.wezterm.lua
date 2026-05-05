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
--   Cmd + Shift + Space      → copy mode; / ? = EditPattern (defaults); Enter validates pattern (search_mode override);
--                              Ctrl+n/p, arrows; Cmd+F = separate scrollback overlay (see cheatsheet)
--   Cmd + d/D                → split horizontal/vertical
--   Cmd + w                  → close pane
--   Cmd + z                  → zoom pane
--   Cmd + Shift + x          → rotate panes (2 panes = swap positions; 3+ = cycle)
--   Cmd + t / 1-9            → new tab / tab by number
--   Cmd + Shift + f          → quick select (URLs, paths, hashes)
--   Cmd + Shift + p          → command palette
--   (recharger la config : défauts WezTerm — Ctrl+Shift+R, Cmd+R)
--   Cmd + Shift + s/o        → save / restore session (resurrect; o/O for restore)
--   Cmd + Shift + Ctrl + d   → delete one saved state (fuzzy)
--   Cmd + Shift + Ctrl + x   → wipe all resurrect state (type DELETE to confirm)
--   Startup                  → restore last saved workspace (resurrect); fallback: new shell
--   Cmd + Backspace          → Ctrl+U (kill line backward — zsh / vim insert)
--
-- Status bar (right):
--   network ↓/↑, CPU%, RAM used/total (matches Activity Monitor "Memory Used"),
--   swap (if active), load avg, hostname, clock
--   Color-coded thresholds (orange → red) for CPU, RAM, load, swap
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
config.status_update_interval = 10000
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
-- Status bar — workspace/mode (left) + system metrics (right)
-- =============================================================================

local prev_net = { bytes_in = 0, bytes_out = 0, time = 0 }
local cached_metrics = {}
local cached_metrics_ts = 0
local static_info = nil

local function format_speed(bps)
  if bps >= 1048576 then return string.format("%.1fM", bps / 1048576) end
  if bps >= 1024 then return string.format("%.0fK", bps / 1024) end
  return "0K"
end

local function get_static_info()
  if static_info then return static_info end
  local is_mac = (wezterm.target_triple or ""):find("apple") ~= nil
  local script
  if is_mac then
    script = [[sysctl -n hw.ncpu hw.memsize && hostname -s]]
  else
    script = [[nproc && awk '/MemTotal/{printf "%d\n",$2*1024}' /proc/meminfo && hostname -s]]
  end
  local ok, stdout = wezterm.run_child_process({ "bash", "-c", script })
  if not ok then return { ncpu = 4, ram_total = 16, hostname = "" } end
  local lines = {}
  for line in stdout:gmatch("[^\r\n]+") do table.insert(lines, line) end
  static_info = {
    ncpu = tonumber(lines[1]) or 4,
    ram_total = math.floor((tonumber(lines[2]) or 0) / 1073741824),
    hostname = lines[3] or "",
  }
  return static_info
end

local function refresh_metrics()
  local now = os.time()
  if (now - cached_metrics_ts) < 10 then return cached_metrics end

  local si = get_static_info()
  local is_mac = (wezterm.target_triple or ""):find("apple") ~= nil
  local script
  if is_mac then
    script = [[
top -l 1 -n 0 -s 0 2>/dev/null | awk '/CPU usage/{gsub(/%/,"",$3); printf "%.0f\n",100-$7}'
vm_stat 2>/dev/null | awk 'BEGIN{ps=4096}/page size/{ps=$8}/Anonymous pages/{an=$3}/Pages purgeable/{p=$3}/Pages wired/{w=$4}/Pages occupied by compressor/{c=$5}END{gsub(/\./,"",an);gsub(/\./,"",p);gsub(/\./,"",w);gsub(/\./,"",c);printf "%.1f\n",(an-p+w+c)*ps/1073741824}'
netstat -ib 2>/dev/null | awk '/en0.*Link/{print $7,$10;exit}'
sysctl -n vm.loadavg vm.swapusage | awk 'NR==1{printf "%.2f\n",$2} NR==2{gsub(/[^0-9.]/,"",$6);printf "%.2f\n",$6/1024}'
]]
  else
    script = [[
top -bn1 2>/dev/null | awk '/^%Cpu/{printf "%.0f\n",100-$8}'
awk '/MemTotal/{t=$2}/MemAvailable/{a=$2}END{printf "%.1f\n",(t-a)/1048576}' /proc/meminfo
awk 'NR>2&&!/lo/{print $2,$10;exit}' /proc/net/dev
awk '{printf "%.2f\n",$1}' /proc/loadavg
awk '/SwapTotal/{t=$2}/SwapFree/{f=$2}END{printf "%.1f\n",(t-f)/1048576}' /proc/meminfo
]]
  end

  local ok, stdout = wezterm.run_child_process({ "bash", "-c", script })
  if not ok then return cached_metrics end

  local lines = {}
  for line in stdout:gmatch("[^\r\n]+") do table.insert(lines, line) end

  local m = {}
  m.cpu = (lines[1] or ""):match("%d+") or "?"
  m.ram_used = (lines[2] or ""):match("[%d%.]+") or "?"
  m.ram_total = tostring(si.ram_total)

  local net_str = lines[3] or ""
  local bin, bout = net_str:match("(%d+)%s+(%d+)")
  if bin and bout then
    bin, bout = tonumber(bin), tonumber(bout)
    if prev_net.time > 0 then
      local dt = now - prev_net.time
      if dt > 0 then
        m.dl = format_speed((bin - prev_net.bytes_in) / dt)
        m.ul = format_speed((bout - prev_net.bytes_out) / dt)
      end
    end
    prev_net.bytes_in = bin
    prev_net.bytes_out = bout
    prev_net.time = now
  end

  m.load = (lines[4] or ""):match("[%d%.]+") or nil
  local swap_val = tonumber((lines[5] or ""):match("[%d%.]+"))
  m.swap = swap_val and swap_val > 0.1 and swap_val or nil
  m.hostname = si.hostname
  m.ncpu = si.ncpu

  cached_metrics = m
  cached_metrics_ts = now
  return m
end

wezterm.on("update-status", function(window, _)
  -- Left: workspace + key table
  local workspace = window:active_workspace()
  local key_table = window:active_key_table()
  local left = " " .. workspace
  if key_table then left = left .. "  " .. key_table end
  window:set_left_status(wezterm.format({
    { Foreground = { Color = "#6272a4" } },
    { Text = left .. " " },
  }))

  -- Right: system metrics
  local m = refresh_metrics()
  local elements = {}
  local purple = { Foreground = { Color = "#bd93f9" } }
  local fg = { Foreground = { Color = "#f8f8f2" } }
  local muted = { Foreground = { Color = "#6272a4" } }
  local red = { Foreground = { Color = "#ff5555" } }
  local orange = { Foreground = { Color = "#ffb86c" } }

  local function sep()
    table.insert(elements, muted)
    table.insert(elements, { Text = "  │  " })
  end

  if m.dl then
    table.insert(elements, purple)
    table.insert(elements, { Text = "↓ " })
    table.insert(elements, fg)
    table.insert(elements, { Text = m.dl .. " " })
    table.insert(elements, purple)
    table.insert(elements, { Text = "↑ " })
    table.insert(elements, fg)
    table.insert(elements, { Text = m.ul })
    sep()
  end

  if m.cpu then
    local cpu_n = tonumber(m.cpu) or 0
    table.insert(elements, purple)
    table.insert(elements, { Text = "CPU " })
    table.insert(elements, cpu_n > 80 and red or (cpu_n > 50 and orange or fg))
    table.insert(elements, { Text = m.cpu .. "%" })
    sep()
  end

  if m.ram_used then
    local used = tonumber(m.ram_used) or 0
    local total = tonumber(m.ram_total) or 1
    local pct = used / total
    table.insert(elements, purple)
    table.insert(elements, { Text = "RAM " })
    table.insert(elements, pct > 0.85 and red or (pct > 0.70 and orange or fg))
    table.insert(elements, { Text = m.ram_used .. "/" .. m.ram_total .. "G" })
    sep()
  end

  if m.swap then
    table.insert(elements, red)
    table.insert(elements, { Text = "SWAP " .. string.format("%.1f", m.swap) .. "G" })
    sep()
  end

  if m.load then
    local load_n = tonumber(m.load) or 0
    local ncpu = m.ncpu or 4
    table.insert(elements, purple)
    table.insert(elements, { Text = "LOAD " })
    table.insert(elements, load_n > ncpu and red or (load_n > ncpu * 0.7 and orange or fg))
    table.insert(elements, { Text = m.load })
    sep()
  end

  if m.hostname ~= "" then
    table.insert(elements, muted)
    table.insert(elements, { Text = m.hostname })
    sep()
  end

  table.insert(elements, purple)
  table.insert(elements, { Text = wezterm.strftime("%H:%M") .. " " })

  window:set_right_status(wezterm.format(elements))
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

  -- Zoom pane
  {
    key = "z",
    mods = "CMD",
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

  -- Copy mode — Cmd + Shift + Space (vim-like selection)
  {
    key = "Space",
    mods = "CMD|SHIFT",
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
}

-- Copy mode: / ? → EditPattern (defaults).
-- search_mode: Enter → AcceptPattern; Escape → CloseWithoutClear (#3502 / #4924 — default_key_tables still expose Close).
-- copy_mode default Escape = ScrollToBottom + Close, so after a scrollback search you jump to the prompt; use CloseWithoutClear.
-- Fallback when wezterm.gui is nil at config load: do not bind plain `n` in search_mode — it would steal pattern typing.
local function build_search_mode_accept_pattern()
  if wezterm.gui then
    local defaults = wezterm.gui.default_key_tables()
    if defaults and defaults.search_mode then
      local out = {}
      for _, b in ipairs(defaults.search_mode) do
        if b.key == "Enter" and (b.mods == "NONE" or b.mods == nil) then
          table.insert(out, { key = "Enter", mods = "NONE", action = act.CopyMode("AcceptPattern") })
        elseif b.key == "Escape" and (b.mods == "NONE" or b.mods == nil) then
          table.insert(out, { key = "Escape", mods = "NONE", action = act.CopyMode("CloseWithoutClear") })
        else
          table.insert(out, b)
        end
      end
      return out
    end
  end
  return {
    { key = "Enter", mods = "NONE", action = act.CopyMode("AcceptPattern") },
    { key = "Escape", mods = "NONE", action = act.CopyMode("CloseWithoutClear") },
    { key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
    { key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
    { key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
    { key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
    { key = "PageUp", mods = "NONE", action = act.CopyMode("PriorMatchPage") },
    { key = "PageDown", mods = "NONE", action = act.CopyMode("NextMatchPage") },
    { key = "UpArrow", mods = "NONE", action = act.CopyMode("PriorMatch") },
    { key = "DownArrow", mods = "NONE", action = act.CopyMode("NextMatch") },
  }
end

local function build_copy_mode_escape_close_without_clear()
  if wezterm.gui then
    local defaults = wezterm.gui.default_key_tables()
    if defaults and defaults.copy_mode then
      local out = {}
      for _, b in ipairs(defaults.copy_mode) do
        if b.key == "Escape" and (b.mods == "NONE" or b.mods == nil) then
          table.insert(out, { key = "Escape", mods = "NONE", action = act.CopyMode("CloseWithoutClear") })
        else
          table.insert(out, b)
        end
      end
      return out
    end
  end
  return nil
end

config.key_tables = config.key_tables or {}
config.key_tables.search_mode = build_search_mode_accept_pattern()
config.key_tables.copy_mode = build_copy_mode_escape_close_without_clear()

return config