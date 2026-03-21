-- =============================================================================
-- smart-splits.nvim — seamless Neovim ↔ WezTerm split navigation
-- =============================================================================
-- Ctrl+arrows       = move between splits (Neovim ↔ WezTerm)
-- Ctrl+Alt+arrows   = resize splits (adjacent modifiers on Kyria)
-- =============================================================================

return {
  "mrjones2014/smart-splits.nvim",
  -- Don't lazy-load: the WezTerm integration needs the user var IS_NVIM
  -- to be set immediately so WezTerm knows to forward keys
  lazy = false,
  -- Only in standalone Neovim (no splits to navigate in VSCode)
  cond = not vim.g.vscode,
  opts = {
    ignored_filetypes = { "nofile", "quickfix", "prompt" },
    ignored_buftypes = { "NvimTree" },
    default_amount = 3,
    at_edge = "stop",
  },
  keys = {
    -- Navigation — Ctrl + arrows
    { "<C-Left>",  function() require("smart-splits").move_cursor_left() end,  mode = { "n", "i", "v" }, desc = "Move to left split" },
    { "<C-Down>",  function() require("smart-splits").move_cursor_down() end,  mode = { "n", "i", "v" }, desc = "Move to below split" },
    { "<C-Up>",    function() require("smart-splits").move_cursor_up() end,    mode = { "n", "i", "v" }, desc = "Move to above split" },
    { "<C-Right>", function() require("smart-splits").move_cursor_right() end, mode = { "n", "i", "v" }, desc = "Move to right split" },

    -- Resize — Ctrl+Alt + arrows (<C-A-*>)
    { "<C-A-Left>",  function() require("smart-splits").resize_left() end,  mode = { "n", "i", "v" }, desc = "Resize left" },
    { "<C-A-Down>",  function() require("smart-splits").resize_down() end,  mode = { "n", "i", "v" }, desc = "Resize down" },
    { "<C-A-Up>",    function() require("smart-splits").resize_up() end,    mode = { "n", "i", "v" }, desc = "Resize up" },
    { "<C-A-Right>", function() require("smart-splits").resize_right() end, mode = { "n", "i", "v" }, desc = "Resize right" },
  },
}
