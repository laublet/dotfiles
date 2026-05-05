-- https://github.com/lukas-reineke/indent-blankline.nvim
-- https://github.com/stevearc/dressing.nvim
-- https://github.com/nvim-tree/nvim-web-devicons

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    cond = not vim.g.vscode,
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      indent = { char = "│" },
      scope = { enabled = true, show_start = false, show_end = false },
    },
  },
  {
    "stevearc/dressing.nvim",
    cond = not vim.g.vscode,
    event = "VeryLazy",
    opts = {},
  },
  {
    "nvim-tree/nvim-web-devicons",
    cond = not vim.g.vscode,
    lazy = true,
    opts = {},
  },
}
