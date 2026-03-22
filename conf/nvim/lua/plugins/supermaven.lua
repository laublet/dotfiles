return {
  "supermaven-inc/supermaven-nvim",
  cond = not vim.g.vscode,
  event = "InsertEnter",
  opts = {
    keymaps = {
      accept_suggestion = "<Tab>",
      clear_suggestion = "<C-]>",
      accept_word = "<C-j>",
    },
    log_level = "off",
  },
}
