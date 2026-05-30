-- Platform-specific WezTerm settings (Linux vs macOS).
-- Loaded from wezterm.lua via require("platform").
-- Bindings in .wezterm.lua are authored with "CMD" (Mac Cmd key); on Linux map to SUPER.

local wezterm = require("wezterm")

local M = {}

M.is_linux = wezterm.target_triple:find("linux") ~= nil

-- Kyria Cmd = GUI. macOS: CMD; Linux: SUPER (no keyd remap).
function M.mac_mods(chord)
  if not M.is_linux then
    return chord
  end
  return chord:gsub("CMD", "SUPER")
end

function M.environment_variables()
  local home = os.getenv("HOME") or ""
  if M.is_linux then
    return {
      PATH = table.concat({
        home .. "/.local/bin",
        "/usr/local/bin",
        "/usr/bin",
        "/bin",
        "/usr/sbin",
        "/sbin",
      }, ":"),
    }
  end
  return {
    PATH = table.concat({
      "/opt/homebrew/bin",
      "/opt/homebrew/sbin",
      "/usr/local/bin",
      home .. "/.local/bin",
      "/usr/bin",
      "/bin",
      "/usr/sbin",
      "/sbin",
    }, ":"),
  }
end

function M.close_pane_binding(act)
  return {
    key = "w",
    mods = M.mac_mods("CMD"),
    action = act.CloseCurrentPane({ confirm = true }),
  }
end

function M.ctrl_w_passthrough_bindings(act)
  return {
    {
      key = "w",
      mods = "CTRL",
      action = act.SendKey({ key = "w", mods = "CTRL" }),
    },
    {
      key = "w",
      mods = "CTRL|SHIFT",
      action = act.SendKey({ key = "w", mods = "CTRL|SHIFT" }),
    },
  }
end

function M.launch_menu_bindings(act)
  return {
    {
      key = "phys:Semicolon",
      mods = M.mac_mods("CMD|SHIFT"),
      action = act.ShowLauncherArgs({ flags = "FUZZY|LAUNCH_MENU_ITEMS" }),
    },
  }
end

function M.launch_menu()
  local menu = {
    { label = "btop",       args = { "btop" } },
    { label = "gitui",      args = { "gitui" } },
    { label = "glab-pick",  args = { "glab-pick" } },
    { label = "lazydocker", args = { "lazydocker" } },
  }
  if not M.is_linux then
    table.insert(menu, { label = "nettop",            args = { "nettop" } })
    table.insert(menu, { label = "mac-startup-clean", args = { "mac-startup-clean" } })
  end
  return menu
end

-- macOS: Cmd+C copy, Ctrl+C SIGINT. Linux: same split (Cmd=SUPER, Ctrl=CTRL).
function M.terminal_copy_bindings(act, tui_quit_or)
  return {
    {
      key = "c",
      mods = M.mac_mods("CMD"),
      action = tui_quit_or(act.CopyTo("Clipboard")),
    },
    {
      key = "c",
      mods = "CTRL",
      action = tui_quit_or(act.SendKey({ key = "c", mods = "CTRL" })),
    },
  }
end

return M
