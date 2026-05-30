-- https://github.com/MeanderingProgrammer/render-markdown.nvim — inline headings/tables (no Mermaid graphics)
-- utils/glow-preview.lua — terminal preview via termopen (colors; no Mermaid)
-- https://github.com/selimacerbas/markdown-preview.nvim — browser preview with Mermaid + scroll sync

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
    "selimacerbas/markdown-preview.nvim",
    cond = not vim.g.vscode,
    dependencies = { "selimacerbas/live-server.nvim" },
    ft = { "markdown", "mermaid", "mmd" },
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewRefresh" },
    opts = function()
      return {
        instance_mode = "takeover",
        open_browser = true,
        default_theme = "dark",
        debounce_ms = 300,
        scroll_sync = true,
        mermaid_renderer = "js",
        hooks = {
          on_start = function()
            vim.g.markdown_preview_active = true
          end,
          on_stop = function()
            vim.g.markdown_preview_active = false
          end,
        },
      }
    end,
    keys = {
      {
        "<leader>nv",
        function()
          if vim.g.markdown_preview_active then
            vim.cmd.MarkdownPreviewStop()
          else
            vim.cmd.MarkdownPreview()
          end
        end,
        desc = "Markdown preview + Mermaid (browser)",
      },
      { "<leader>nV", "<cmd>MarkdownPreviewRefresh<CR>", desc = "Refresh markdown browser preview" },
    },
  },
}
