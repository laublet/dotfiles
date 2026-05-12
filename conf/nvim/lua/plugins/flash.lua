-- https://github.com/folke/flash.nvim
-- Easymotion-style jumps with the upstream defaults: `s` jump, `S` treesitter,
-- `r`/`R` in operator/visual, `<C-s>` in command. Vanilla `s` (substitute char)
-- can be reproduced with `cl`; `S` (substitute line) with `cc`.

return {
  {
    "folke/flash.nvim",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    opts = {
      -- f/t/;/, are augmented with labels (vim semantics preserved)
      modes = {
        char = { enabled = true, jump_labels = true },
        search = { enabled = true },
      },
    },
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
}
