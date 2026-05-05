-- Vim command navigator: <leader>v shows ALL Vim commands with descriptions.
-- Each entry opens the which-key popup (if sub-commands exist) or just shows the desc.

local M = {}

---@class VimCmdEntry
---@field key string Key after <leader>v.
---@field wk_keys string Argument for require("which-key").show({ keys = ... }).
---@field desc string Short description.

--- All Vim normal mode commands, alphabetically sorted.
--- Descriptions are concise reminders of what the key does.
local COMMANDS = {
  -- Symbols
  { key = "!", wk_keys = "!", desc = "filter through command" },
  { key = '"', wk_keys = '"', desc = "use register" },
  { key = "#", wk_keys = "#", desc = "search word backward" },
  { key = "$", wk_keys = "$", desc = "end of line" },
  { key = "%", wk_keys = "%", desc = "match bracket" },
  { key = "&", wk_keys = "&", desc = "repeat :s" },
  { key = "'", wk_keys = "'", desc = "jump to mark (line)" },
  { key = "(", wk_keys = "(", desc = "sentence backward" },
  { key = ")", wk_keys = ")", desc = "sentence forward" },
  { key = "*", wk_keys = "*", desc = "search word forward" },
  { key = "+", wk_keys = "+", desc = "line down (first non-blank)" },
  { key = ",", wk_keys = ",", desc = "reverse t/T/f/F" },
  { key = "-", wk_keys = "-", desc = "line up (first non-blank)" },
  { key = ".", wk_keys = ".", desc = "repeat last change" },
  { key = "/", wk_keys = "/", desc = "search forward" },
  { key = "0", wk_keys = "0", desc = "start of line" },
  { key = ":", wk_keys = ":", desc = "command line" },
  { key = ";", wk_keys = ";", desc = "repeat t/T/f/F" },
  { key = "<", wk_keys = "<", desc = "indent left" },
  { key = "=", wk_keys = "=", desc = "format / indent" },
  { key = ">", wk_keys = ">", desc = "indent right" },
  { key = "?", wk_keys = "?", desc = "search backward" },
  { key = "@", wk_keys = "@", desc = "execute macro" },
  { key = "[", wk_keys = "[", desc = "[ prefix (previous)" },
  { key = "]", wk_keys = "]", desc = "] prefix (next)" },
  { key = "^", wk_keys = "^", desc = "first non-blank" },
  { key = "_", wk_keys = "_", desc = "line down (first non-blank)" },
  { key = "`", wk_keys = "`", desc = "jump to mark (exact)" },
  { key = "{", wk_keys = "{", desc = "paragraph backward" },
  { key = "|", wk_keys = "|", desc = "go to column" },
  { key = "}", wk_keys = "}", desc = "paragraph forward" },
  { key = "~", wk_keys = "~", desc = "toggle case" },

  -- a-z
  { key = "a", wk_keys = "a", desc = "append after cursor" },
  { key = "b", wk_keys = "b", desc = "word backward" },
  { key = "c", wk_keys = "c", desc = "change" },
  { key = "d", wk_keys = "d", desc = "delete" },
  { key = "e", wk_keys = "e", desc = "end of word" },
  { key = "f", wk_keys = "f", desc = "find char forward" },
  { key = "g", wk_keys = "g", desc = "g prefix (goto, misc)" },
  { key = "h", wk_keys = "h", desc = "left" },
  { key = "i", wk_keys = "i", desc = "insert before cursor" },
  { key = "j", wk_keys = "j", desc = "down" },
  { key = "k", wk_keys = "k", desc = "up" },
  { key = "l", wk_keys = "l", desc = "right" },
  { key = "m", wk_keys = "m", desc = "set mark" },
  { key = "n", wk_keys = "n", desc = "next search match" },
  { key = "o", wk_keys = "o", desc = "open line below" },
  { key = "p", wk_keys = "p", desc = "paste after" },
  { key = "q", wk_keys = "q", desc = "record macro" },
  { key = "r", wk_keys = "r", desc = "replace char" },
  { key = "s", wk_keys = "s", desc = "substitute char" },
  { key = "t", wk_keys = "t", desc = "till char forward" },
  { key = "u", wk_keys = "u", desc = "undo" },
  { key = "v", wk_keys = "v", desc = "visual mode" },
  { key = "w", wk_keys = "w", desc = "word forward" },
  { key = "x", wk_keys = "x", desc = "delete char" },
  { key = "y", wk_keys = "y", desc = "yank" },
  { key = "z", wk_keys = "z", desc = "z prefix (folds, spell)" },

  -- A-Z
  { key = "A", wk_keys = "A", desc = "append at end of line" },
  { key = "B", wk_keys = "B", desc = "WORD backward" },
  { key = "C", wk_keys = "C", desc = "change to end of line" },
  { key = "D", wk_keys = "D", desc = "delete to end of line" },
  { key = "E", wk_keys = "E", desc = "end of WORD" },
  { key = "F", wk_keys = "F", desc = "find char backward" },
  { key = "G", wk_keys = "G", desc = "go to line (or last)" },
  { key = "H", wk_keys = "H", desc = "top of screen" },
  { key = "I", wk_keys = "I", desc = "insert at first non-blank" },
  { key = "J", wk_keys = "J", desc = "join lines" },
  { key = "K", wk_keys = "K", desc = "keyword lookup" },
  { key = "L", wk_keys = "L", desc = "bottom of screen" },
  { key = "M", wk_keys = "M", desc = "middle of screen" },
  { key = "N", wk_keys = "N", desc = "previous search match" },
  { key = "O", wk_keys = "O", desc = "open line above" },
  { key = "P", wk_keys = "P", desc = "paste before" },
  { key = "Q", wk_keys = "Q", desc = "ex mode" },
  { key = "R", wk_keys = "R", desc = "replace mode" },
  { key = "S", wk_keys = "S", desc = "substitute line" },
  { key = "T", wk_keys = "T", desc = "till char backward" },
  { key = "U", wk_keys = "U", desc = "undo line" },
  { key = "V", wk_keys = "V", desc = "visual line mode" },
  { key = "W", wk_keys = "W", desc = "WORD forward" },
  { key = "X", wk_keys = "X", desc = "delete char before" },
  { key = "Y", wk_keys = "Y", desc = "yank line" },
  { key = "Z", wk_keys = "Z", desc = "Z prefix (ZZ, ZQ)" },

  -- Ctrl-W (special entry)
  { key = "<C-w>", wk_keys = "<C-w>", desc = "window commands" },
}

M.ENTRIES = COMMANDS

--- Build LHS for keymap (handle special chars).
local function lhs(key)
  local map = {
    ["<"] = "<leader>v<lt>",
    [">"] = "<leader>v<gt>",
    ["|"] = "<leader>v<bar>",
    ["<C-w>"] = "<leader>v<C-w>",
  }
  return map[key] or ("<leader>v" .. key)
end

--- Generate which-key.nvim spec entries.
function M.get_which_key_spec()
  local out = {}
  for _, entry in ipairs(M.ENTRIES) do
    local wk_keys = entry.wk_keys
    out[#out + 1] = {
      lhs(entry.key),
      function()
        require("which-key").show({ keys = wk_keys })
      end,
      desc = entry.desc,
      mode = "n",
    }
  end
  return out
end

return M
