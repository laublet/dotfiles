-- https://github.com/NeogitOrg/neogit
-- Magit-inspired git interface for Neovim. Paired with diffview.nvim for
-- full diff view (commit ranges, file history). Replaces lazygit as the
-- in-editor git workflow.

return {
  "NeogitOrg/neogit",
  cond = not vim.g.vscode,
  cmd = { "Neogit" },
  keys = {
    { "<leader>gg", "<cmd>Neogit<cr>",        desc = "Git: Neogit (status)" },
    { "<leader>gC", "<cmd>Neogit commit<cr>", desc = "Git: Neogit commit popup" },
    { "<leader>gP", "<cmd>Neogit pull<cr>",   desc = "Git: Neogit pull" },
    { "<leader>gp", "<cmd>Neogit push<cr>",   desc = "Git: Neogit push" },
    { "<leader>gl", "<cmd>Neogit log<cr>",    desc = "Git: Neogit log" },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
  },
  opts = {
    integrations = {
      diffview = true,
    },
    graph_style = "unicode",
    disable_commit_confirmation = false,
    disable_insert_on_commit = "auto",
    signs = {
      hunk = { "", "" },
      item = { "", "" },
      section = { "", "" },
    },
  },
}
