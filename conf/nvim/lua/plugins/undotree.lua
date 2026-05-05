-- https://github.com/mbbill/undotree

return {
  "mbbill/undotree",
  cond = not vim.g.vscode,
  cmd = "UndotreeToggle",
  keys = {
    { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Undo tree" },
  },
}
