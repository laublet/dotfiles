return {
  "folke/which-key.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>h", group = "git hunk" },
      { "<leader>l", group = "lsp" },
      { "<leader>o", group = "obsidian" },
      { "<leader>?", desc = "keymaps" },
      { "<leader>H", desc = "cheatsheets" },
    },
  },
}
