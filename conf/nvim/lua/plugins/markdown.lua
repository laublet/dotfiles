-- https://github.com/MeanderingProgrammer/render-markdown.nvim
-- https://github.com/ellisonleao/glow.nvim

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    cond = not vim.g.vscode,
    ft = "markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      heading = {
        icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎰 ", "󰎵 " },
        sign = false,
        backgrounds = {},
      },
      checkbox = {
        unchecked = { icon = "󰄱 " },
        checked   = { icon = " " },
      },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      link = { enabled = false },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
        highlight_inline = "",
        highlight = "",
      },
      pipe_table = {
        style = "full",
      },
      win_options = {
        conceallevel = { rendered = 2, default = 0 },
      },
    },
    keys = {
      { "<leader>nm", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle markdown render" },
    },
  },

  {
    "ellisonleao/glow.nvim",
    cond = not vim.g.vscode,
    cmd = "Glow",
    opts = {
      width_ratio = 0.85,
      height_ratio = 0.85,
      border = "rounded",
    },
    keys = {
      { "<leader>np", "<cmd>Glow<CR>", desc = "Preview markdown (glow)" },
    },
  },
}
