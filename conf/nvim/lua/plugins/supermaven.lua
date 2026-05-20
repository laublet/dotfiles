-- https://github.com/supermaven-inc/supermaven-nvim

return {
  "supermaven-inc/supermaven-nvim",
  cond = not vim.g.vscode,
  event = "InsertEnter",
  cmd = {
    "SupermavenStart",
    "SupermavenStop",
    "SupermavenRestart",
    "SupermavenToggle",
    "SupermavenStatus",
    "SupermavenUseFree",
    "SupermavenUsePro",
    "SupermavenLogout",
    "SupermavenShowLog",
    "SupermavenClearLog",
  },
  opts = {
    keymaps = {
      accept_suggestion = false,
      clear_suggestion = "<C-]>",
      accept_word = "<C-j>",
    },
    disable_keymaps = true,
    log_level = "off",
    -- cmp handles completion menu; Supermaven = inline ghost in code only.
    -- Avante/markdown: no inline AI fighting prose or agent input.
    ignore_filetypes = {
      "markdown",
      "Avante",
      "AvanteInput",
      "AvanteSelectedCode",
      "AvanteSelectedFiles",
      "help",
      "alpha",
      "neo-tree",
      "oil",
    },
  },
}
