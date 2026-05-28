-- https://github.com/mbbill/undotree
-- WindowLayout = 3 → undotree on the RIGHT, diff panel just below it.
-- Default layout (1) opens on the left and collides with neo-tree's sidebar.

return {
  "mbbill/undotree",
  cond = not vim.g.vscode,
  cmd = "UndotreeToggle",
  keys = {
    { "<leader>U", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
  },
  init = function()
    vim.g.undotree_WindowLayout = 3
    vim.g.undotree_SplitWidth = 35
    vim.g.undotree_DiffpanelHeight = 12
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
}
