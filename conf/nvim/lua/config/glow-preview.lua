-- Local glow preview (not a Lazy.nvim plugin — no git repo).
local M = {}

function M.setup()
  if vim.g.vscode then
    return
  end

  local glow = require("utils.glow-preview")
  glow.setup({
    style = "dracula",
    width_ratio = 0.85,
    height_ratio = 0.85,
    border = "rounded",
  })
  glow.setup_commands()

  vim.keymap.set("n", "<leader>np", "<cmd>Glow<CR>", {
    desc = "Preview markdown (glow)",
  })
end

return M
