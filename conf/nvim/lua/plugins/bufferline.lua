-- https://github.com/akinsho/bufferline.nvim
-- Tab bar at the top (replaces the built-in tabline). Uses colors from dracula.nvim.
--
-- mode = "buffers" — one "tab" per open buffer (typical IDE-style tab bar).
-- mode = "tabs"   — one tab per Vim :tabpage only (pairs with :tabedit / <leader>T*).
--
-- Load on VimEnter (not VeryLazy): user commands (:BufferLine*) must exist right after
-- startup; VeryLazy defers loading and :BufferLine* can be "Not an editor command".
-- Requires Neovim (not legacy Vim). Disabled in Cursor vscode-neovim (cond below).

return {
  "akinsho/bufferline.nvim",
  version = "*",
  cond = not vim.g.vscode,
  dependencies = { "nvim-tree/nvim-web-devicons", "Mofiqul/dracula.nvim" },
  event = "VimEnter",
  opts = {
    options = {
      mode = "buffers",
      separator_style = "thin",
      diagnostics = "nvim_lsp",
      always_show_bufferline = true,
      offsets = {
        {
          filetype = "neo-tree",
          text = "File tree",
          text_align = "center",
          separator = true,
        },
      },
    },
  },
}
