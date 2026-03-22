return {
  "folke/trouble.nvim",
  cond = not vim.g.vscode,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "Trouble",
  keys = {
    { "<leader>d", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (workspace)" },
    { "<leader>D", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Diagnostics (buffer)" },
  },
  opts = {},
}
