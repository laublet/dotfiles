-- =============================================================================
-- WezTerm Configuration — Loïc
-- =============================================================================
-- Architecture keybindings :
--   Ctrl + arrows            → navigate panes (smart-splits, Neovim ↔ WezTerm)
--   Ctrl + Alt + arrows      → resize panes (smart-splits)
--   Cmd + Shift + ←/→        → prev/next tab
--   Cmd + Shift + Space      → copy mode (vim-like selection)
--   Cmd + d/D                → split horizontal/vertical
--   Cmd + w                  → close pane
--   Cmd + z                  → zoom pane
--   Cmd + t / 1-9            → new tab / tab by number
--   Cmd + Shift + f          → quick select (URLs, paths, hashes)
--   Cmd + Shift + p          → command palette
--   Cmd + Shift + s/r        → save/restore session (resurrect)
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

-- Maximize on startup + macOS dev layout
local is_mac = (wezterm.target_triple or ""):find("apple") ~= nil

wezterm.on("gui-startup", function(cmd)
  if is_mac then
    local btop_tab, _, window = mux.spawn_window({ args = { "btop" } })
    btop_tab:set_title("btop")

    local work_dir = wezterm.home_dir .. "/dev/work/blank"
    local work_tab, work_pane, _ = window:spawn_tab({ cwd = work_dir })
    work_pane:split({ direction = "Right", cwd = work_dir })
    work_pane:send_text("nvim\n")

    local perso_dir = wezterm.home_dir .. "/dev/perso"
    local perso_tab, perso_pane, _ = window:spawn_tab({ cwd = perso_dir })
    perso_pane:split({ direction = "Right", cwd = perso_dir })
    perso_pane:send_text("nvim\n")

    work_tab:activate()
    window:gui_window():maximize()
  else
    local _, _, window = mux.spawn_window(cmd or {})
    window:gui_window():maximize()
  end
end)

-- =============================================================================
-- Smart-splits — Ctrl+arrows nav, Ctrl+Alt+arrows resize (ARROWS ONLY)
-- =============================================================================
-- No Ctrl+hjkl: avoids conflicts with shell keybindings (Ctrl+L=clear, etc.)
-- Kyria: Ctrl+Alt is comfortable (adjacent modifiers on left hand).
-- Ctrl+Cmd was NOT: non-adjacent on Kyria (Ctrl | Alt | Cmd | Shift).
--
-- Detects Neovim via IS_NVIM user var (set by smart-splits.nvim, lazy=false).
-- No process name fallback — get_foreground_process_name() adds 500ms+ latency.
--
-- Cross-boundary Neovim → WezTerm navigation uses user var signaling:
-- Neovim sets SMART_SPLITS_MOVE=<direction> via escape sequence (instant),
-- WezTerm reacts via user-var-changed event (no subprocess round-trip).

local function is_nvim(pane)
  return pane:get_user_vars().IS_NVIM == "true"
end

-- Handle cross-boundary navigation signal from Neovim's smart-splits
wezterm.on("user-var-changed", function(window, pane, name, value)
  if name == "SMART_SPLITS_MOVE" and value ~= "" then
    local dir_map = { left = "Left", right = "Right", up = "Up", down = "Down" }
    local dir = dir_map[value]
    if dir then
      window:perform_action(act.ActivatePaneDirection(dir), pane)
    end
  end
end)

local direction_keys = {
  LeftArrow = "Left",
  DownArrow = "Down",
  UpArrow = "Up",
  RightArrow = "Right",
}

local function split_nav(resize_or_move, key)
  local dir = direction_keys[key]
  return {
    key = key,
    mods = resize_or_move == "resize" and "CTRL|ALT" or "CTRL",
    action = wezterm.action_callback(function(win, pane)
      if is_nvim(pane) then
        win:perform_action({
          SendKey = {
            key = key,
            mods = resize_or_move == "resize" and "CTRL|ALT" or "CTRL",
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

wezterm.on("resurrect.state_manager.save_state.finished", function()
  local gui = wezterm.gui.gui_windows()[1]
  if gui then
    gui:toast_notification("WezTerm", "Session saved", nil, 2000)
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

config.keys = {
  -- Smart-splits: pane navigation (Ctrl + arrows)
  split_nav("move", "LeftArrow"),
  split_nav("move", "DownArrow"),
  split_nav("move", "UpArrow"),
  split_nav("move", "RightArrow"),

  -- Smart-splits: pane resize (Ctrl + Alt + arrows)
  split_nav("resize", "LeftArrow"),
  split_nav("resize", "DownArrow"),
  split_nav("resize", "UpArrow"),
  split_nav("resize", "RightArrow"),

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

  -- Disable Ctrl-based defaults that conflict with home-row mods (Kyria CAGS).
  -- Tab navigation already covered by Cmd+Shift+Left/Right, new tab by Cmd+t.
  { key = "Tab", mods = "CTRL", action = act.SendKey({ key = "Tab" }) },
  { key = "Tab", mods = "CTRL|SHIFT", action = act.SendKey({ key = "Tab" }) },
  { key = "t", mods = "CTRL", action = act.SendKey({ key = "t", mods = "CTRL" }) },
  { key = "t", mods = "CTRL|SHIFT", action = act.SendKey({ key = "t", mods = "CTRL|SHIFT" }) },
  { key = "w", mods = "CTRL", action = act.SendKey({ key = "w", mods = "CTRL" }) },
  { key = "w", mods = "CTRL|SHIFT", action = act.SendKey({ key = "w", mods = "CTRL|SHIFT" }) },

  -- Resurrect: save session
  {
    key = "s",
    mods = "CMD|SHIFT",
    action = wezterm.action_callback(function(win, pane)
      local state = resurrect.workspace_state.get_workspace_state()
      resurrect.state_manager.save_state(state)
    end),
  },

  -- Resurrect: restore session (fuzzy loader)
  {
    key = "r",
    mods = "CMD|SHIFT",
    action = wezterm.action_callback(function(win, pane)
      resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, opts)
        local state
        if opts.is_workspace then
          state = resurrect.state_manager.load_state(id, "workspace")
          resurrect.workspace_state.restore_workspace(state, {
            window = win,
            relative = true,
            restore_text = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
          })
        elseif opts.is_window then
          state = resurrect.state_manager.load_state(id, "window")
          resurrect.window_state.restore_window(pane:window(), state, {
            relative = true,
            restore_text = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
          })
        elseif opts.is_tab then
          state = resurrect.state_manager.load_state(id, "tab")
          resurrect.tab_state.restore_tab(pane:tab(), state, {
            relative = true,
            restore_text = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
          })
        end
      end, {
        title = "Restore Session",
        description = "Select session to restore. Enter = accept, Esc = cancel, / = filter",
        fuzzy_description = "Search: ",
        is_fuzzy = true,
      })
    end),
  },

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
        fuzzy_description = "Search: ",
        is_fuzzy = true,
      })
    end),
  },
}

return config