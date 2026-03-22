return {
  "folke/which-key.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>a", group = "ai (avante)" },
      { "<leader>h", group = "git hunk" },
      { "<leader>l", group = "lsp" },
      { "<leader>o", group = "obsidian" },
      { "<leader>q", group = "session" },
      { "<leader>?", desc = "keymaps" },
      { "<leader>H", desc = "cheatsheets" },
    },
  },
}
