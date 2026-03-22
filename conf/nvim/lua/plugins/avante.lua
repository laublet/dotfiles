return {
  "yetone/avante.nvim",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  build = "make",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
    "stevearc/dressing.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    provider = "claude",
    claude = {
      model = "claude-sonnet-4-20250514",
      max_tokens = 8192,
    },
  },
}
