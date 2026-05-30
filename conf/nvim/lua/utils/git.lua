-- Git helpers for Neovim plugins (diffview, fzf-lua, …).

local M = {}

--- Git toplevel for the buffer's repo (worktree-safe via rev-parse).
---@param buf? integer
---@return string|nil
function M.root(buf)
  buf = buf or 0
  local path = vim.api.nvim_buf_get_name(buf)

  local start
  if path ~= "" and not path:match("^%w+://") and vim.loop.fs_stat(path) then
    start = vim.fs.dirname(path)
  else
    start = vim.fn.getcwd()
  end

  local result = vim.system({ "git", "-C", start, "rev-parse", "--show-toplevel" }, { text = true }):wait()
  if result.code ~= 0 then
    return nil
  end

  local root = vim.trim(result.stdout or "")
  if root == "" then
    return nil
  end
  return root
end

--- Diffview `-C{path}` flag (path glued to -C per diffview CLI).
---@param root string
---@return string
function M.diffview_c_flag(root)
  return "-C" .. root
end

return M
