-- https://neovim.io/doc/user/api.html#nvim_open_win()
-- Floating UI helpers (fzf-lua, which-key, LSP hovers, etc.)
-- Used on FocusGained and via <leader>ur / <leader>ux.

local M = {}

--- Prefer fzf's terminal window, else highest z-index float.
---@param opts? { force?: boolean } If force, refocus even when already on a float (e.g. wrong float).
function M.refocus(opts)
  opts = opts or {}
  local force = opts.force == true

  if vim.fn.getcmdwintype() ~= "" then
    return
  end

  local cur = vim.api.nvim_get_current_win()
  if not force and vim.api.nvim_win_get_config(cur).relative ~= "" then
    return
  end

  local candidates = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ok, cfg = pcall(vim.api.nvim_win_get_config, win)
    if ok and cfg.relative ~= "" and cfg.relative ~= "mouse" and cfg.focusable ~= false then
      local buf = vim.api.nvim_win_get_buf(win)
      local z = cfg.zindex or 0
      table.insert(candidates, { win = win, z = z, bt = vim.bo[buf].buftype })
    end
  end
  if #candidates == 0 then
    return
  end

  for _, c in ipairs(candidates) do
    if c.bt == "terminal" then
      vim.api.nvim_set_current_win(c.win)
      return
    end
  end

  table.sort(candidates, function(a, b)
    return a.z > b.z
  end)
  vim.api.nvim_set_current_win(candidates[1].win)
end

--- Close fzf-lua if open, then close every floating window (emergency escape).
function M.close_all_floats()
  pcall(function()
    local fz = package.loaded["fzf-lua"]
    if fz and fz.win and type(fz.win.close) == "function" then
      fz.win.close()
    end
  end)

  local wins = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local ok, cfg = pcall(vim.api.nvim_win_get_config, win)
    if ok and cfg.relative ~= "" and cfg.relative ~= "mouse" then
      table.insert(wins, { win = win, z = cfg.zindex or 0 })
    end
  end
  table.sort(wins, function(a, b)
    return a.z > b.z
  end)
  for _, w in ipairs(wins) do
    pcall(vim.api.nvim_win_close, w.win, true)
  end
end

return M
