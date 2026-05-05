-- https://github.com/yetone/avante.nvim

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
  -- Default prefix is <leader>a (e.g. <leader>at toggle). LSP code actions use <leader>la instead.
  opts = {
    provider = "claude",
    providers = {
      claude = {
        model = "claude-sonnet-4-20250514",
        extra_request_body = {
          max_tokens = 8192,
        },
      },
    },
  },
}
