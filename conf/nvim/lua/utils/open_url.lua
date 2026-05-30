-- Open URL or file under cursor (replaces built-in gx).
-- Built-in gx uses <cfile> with commas in isfname, so CSV / bookmark lines open as one bogus "URL".

local M = {}

-- Stop at comma/space (bookmark CSV, Firefox exports); commas are not valid bare URL chars.
local URL_PAT = "https?://[%w%-%._%~:/?#%[%]@!$&'()*+;=%%]+"

local function do_open(uri)
  local cmd, err = vim.ui.open(uri)
  if err then
    return err
  end
  if cmd then
    local rv = cmd:wait(1000)
    if rv and rv.code ~= 0 then
      return ("vim.ui.open: command %s (%d): %s"):format(
        rv.code == 124 and "timeout" or "failed",
        rv.code,
        vim.inspect(cmd.cmd)
      )
    end
  end
  return nil
end

--- http(s) URL on `line` that contains byte index `col` (0-based), else first on line.
local function url_on_line(line, col)
  local at_cursor
  local first
  for url in line:gmatch(URL_PAT) do
    first = first or url
    local s, e = line:find(url, 1, true)
    if s and col + 1 >= s and col + 1 <= e then
      at_cursor = url
      break
    end
  end
  return at_cursor or first
end

function M.get_uri()
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = vim.api.nvim_win_get_cursor(0)[1] - 1, vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ""

  local http = url_on_line(line, col)
  if http then
    return http
  end

  for _, url in ipairs(require("vim.ui")._get_urls()) do
    if url:match("^https?://") and not url:find(",") then
      return url
    end
  end

  local path = vim.fn.expand("<cfile>")
  if path ~= "" and (vim.fn.filereadable(path) == 1 or path:match("^[%w+.-]+://")) then
    return path
  end

  local blob = require("vim.ui")._get_urls()[1]
  if blob then
    return blob:match("(" .. URL_PAT .. ")")
  end
end

function M.open()
  local uri = M.get_uri()
  if not uri then
    vim.notify("No URL or file under cursor", vim.log.levels.WARN)
    return
  end
  local err = do_open(uri)
  if err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end

function M.setup()
  local desc = "Open http(s) URL or file at cursor (system handler)"
  vim.keymap.set({ "n" }, "gx", M.open, { desc = desc })
  vim.keymap.set({ "x" }, "gx", function()
    local lines =
      vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = vim.fn.mode() })
    local text = table.concat(vim.iter(lines):map(vim.trim):totable())
    local uri = text:match("(" .. URL_PAT .. ")") or text:match("^%s*(%S+)%s*$")
    if not uri then
      vim.notify("No URL in selection", vim.log.levels.WARN)
      return
    end
    local err = do_open(uri)
    if err then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end, { desc = desc })
end

return M
