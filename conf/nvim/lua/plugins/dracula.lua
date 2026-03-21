-- =============================================================================
-- Dracula colorscheme — standalone Neovim only
-- =============================================================================

return {
  "Mofiqul/dracula.nvim",
  cond = not vim.g.vscode,
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("dracula")
  end,
}
