-- https://github.com/folke/persistence.nvim

local function session_file()
  local p = require("persistence")
  local file = p.current()
  if vim.fn.filereadable(file) == 0 then
    file = p.current({ branch = false })
  end
  return file
end

local function session_exists()
  return vim.fn.filereadable(session_file()) ~= 0
end

local function should_auto_restore()
  local argc = vim.fn.argc()
  if argc == 0 then
    return true
  end
  return argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1
end

-- Neovim starts with an empty buffer; sourcing a session adds real buffers but
-- leaves that scratch buffer (and sometimes alpha). Drop them after restore.
local function prune_startup_buffers()
  vim.schedule(function()
    local named = {}
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.api.nvim_buf_get_name(buf) ~= "" then
        named[#named + 1] = buf
      end
    end
    if #named > 0 then
      local cur = vim.api.nvim_get_current_buf()
      local cur_name = vim.api.nvim_buf_get_name(cur)
      if vim.bo.filetype == "alpha" or cur_name == "" then
        vim.api.nvim_set_current_buf(named[1])
      end
    end
    local current = vim.api.nvim_get_current_buf()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
        local name = vim.api.nvim_buf_get_name(buf)
        if vim.bo[buf].filetype == "alpha" or (name == "" and vim.bo[buf].buftype == "") then
          pcall(vim.api.nvim_buf_delete, buf, { force = true })
        end
      end
    end
  end)
end

return {
  "folke/persistence.nvim",
  cond = not vim.g.vscode,
  event = "VimEnter",
  priority = 1200,
  opts = {},
  init = function()
    vim.api.nvim_create_autocmd("VimEnter", {
      nested = true,
      callback = function()
        if not should_auto_restore() or not session_exists() then
          return
        end
        require("persistence").load()
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      pattern = "PersistenceLoadPost",
      callback = prune_startup_buffers,
    })
  end,
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore session (cwd)" },
    { "<leader>qS", function() require("persistence").select() end, desc = "Select a session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save current session" },
  },
}
