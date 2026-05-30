-- Repeat the last "leader" action (e.g. <leader>hn then <leader>.).
-- Does not override Vim's `.` (text edits); use <leader>. for arbitrary leader maps.

local M = {}

local last = { fn = nil, desc = nil }

--- Wrap a zero-arg callback so the next <leader>. replays it.
function M.wrap(fn, desc)
  return function()
    last.fn = fn
    last.desc = desc
    fn()
  end
end

function M.repeat_last()
  if not last.fn then
    vim.notify("No leader action to repeat", vim.log.levels.INFO)
    return
  end
  last.fn()
end

function M.setup()
  vim.keymap.set("n", "<leader>.", M.repeat_last, { desc = "Repeat last leader action" })
end

return M
