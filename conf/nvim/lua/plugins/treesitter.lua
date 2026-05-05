-- https://github.com/nvim-treesitter/nvim-treesitter
-- https://github.com/windwp/nvim-ts-autotag

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    cond = not vim.g.vscode,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "typescript", "tsx", "javascript",
        "lua", "rust",
        "json", "yaml", "toml",
        "html", "css",
        "bash", "markdown", "markdown_inline",
        "vim", "vimdoc",
        "gitcommit", "diff",
        "regex",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    cond = not vim.g.vscode,
    event = "InsertEnter",
    opts = {},
  },
}
