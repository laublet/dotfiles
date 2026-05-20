-- https://github.com/okuuva/auto-save.nvim
-- Saves when you leave insert, change buffer, or lose focus — aligned with Zed's
-- autosave habit without spamming on every keystroke in insert mode.

return {
  "okuuva/auto-save.nvim",
  version = "^1.0.0",
  cond = not vim.g.vscode,
  event = { "InsertLeave", "TextChanged", "BufLeave", "FocusLost" },
  opts = {
    enabled = true,
    trigger_events = {
      immediate_save = { "BufLeave", "FocusLost", "QuitPre", "VimSuspend" },
      defer_save = { "InsertLeave", "TextChanged" },
      cancel_deferred_save = { "InsertEnter" },
    },
    debounce_delay = 2000,
    condition = function(buf)
      if vim.fn.getbufvar(buf, "&modifiable") ~= 1 then
        return false
      end
      if vim.fn.getbufvar(buf, "&buftype") ~= "" then
        return false
      end
      local ft = vim.bo[buf].filetype
      local skip_ft = {
        "gitcommit",
        "alpha",
        "dashboard",
        "neo-tree",
        "NvimTree",
        "oil",
        "lazygit",
        "neogit",
        "toggleterm",
        "TelescopePrompt",
        "fzf",
        "prompt",
        "undotree",
        "diff",
      }
      return not vim.tbl_contains(skip_ft, ft)
    end,
  },
}
