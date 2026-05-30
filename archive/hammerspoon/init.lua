-- Encoder scroll: macOS sends wheel to the window under the cursor.
-- Warp only (AeroSpace + optional HS). Cursor hide APIs do not work reliably on this Mac
-- (CGDisplay/NSCursor no-op; CGAssociateMouseAndMouseCursorPosition caused click lag).

local skip_apps = {
  Hammerspoon = true,
}

local last_win_id = nil
local app_watcher = nil
local focus_timer = nil

local function warp_to_window(win)
  local f = win:frame()
  hs.mouse.absolutePosition({ x = f.x + f.w / 2, y = f.y + f.h / 2 })
end

local function on_window_focused(win, app_name)
  if not win or skip_apps[app_name] then
    return
  end
  warp_to_window(win)
end

local function poll_focused_window()
  if not hs.accessibilityState() then
    return
  end
  local win = hs.window.focusedWindow()
  if not win then
    return
  end
  local wid = win:id()
  if wid == last_win_id then
    return
  end
  last_win_id = wid
  local app = win:application()
  on_window_focused(win, app and app:name())
end

local function start_focus_watchers()
  if app_watcher then
    return
  end
  app_watcher = hs.application.watcher.new(function(_, eventType)
    if eventType == hs.application.watcher.activated then
      hs.timer.doAfter(0.05, poll_focused_window)
    end
  end)
  app_watcher:start()
  focus_timer = hs.timer.doEvery(0.25, poll_focused_window)
end

local function stop_focus_watchers()
  if app_watcher then
    app_watcher:stop()
    app_watcher = nil
  end
  if focus_timer then
    focus_timer:stop()
    focus_timer = nil
  end
end

local function on_accessibility_changed()
  local ax = hs.accessibilityState(true)
  hs.printf("Hammerspoon accessibility: %s (warp only, no cursor hide)", tostring(ax))
  if ax then
    start_focus_watchers()
  else
    stop_focus_watchers()
  end
end

hs.accessibilityStateCallback = on_accessibility_changed
on_accessibility_changed()
