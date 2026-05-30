-- https://github.com/sindrets/diffview.nvim
-- Repo-wide and per-file diffs (paired with Neogit). Edit the working-tree
-- pane (B / right in horizontal layout); the other side is read-only git state.

local function open_repo()
  local git = require("utils.git")
  local root = git.root()
  if not root then
    vim.notify("Diffview: not in a git repository", vim.log.levels.WARN)
    return
  end
  vim.cmd("DiffviewOpen " .. git.diffview_c_flag(root))
end

local function open_file_history()
  local git = require("utils.git")
  local root = git.root()
  if not root then
    vim.notify("Diffview: not in a git repository", vim.log.levels.WARN)
    return
  end
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    vim.notify("Diffview: buffer has no file path", vim.log.levels.WARN)
    return
  end
  vim.cmd("DiffviewFileHistory " .. git.diffview_c_flag(root) .. " " .. vim.fn.fnameescape(file))
end

return {
  "sindrets/diffview.nvim",
  cond = not vim.g.vscode,
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = {
    "DiffviewOpen",
    "DiffviewClose",
    "DiffviewFileHistory",
    "DiffviewToggleFiles",
    "DiffviewFocusFiles",
  },
  keys = {
    { "<leader>gd", open_repo,          desc = "Git: Diffview open (HEAD vs working)" },
    { "<leader>gD", open_file_history,  desc = "Git: Diffview file history (current)" },
    { "<leader>gx", "<cmd>DiffviewClose<cr>", desc = "Git: Diffview close" },
  },
  config = function()
    require("diffview").setup({
      default_args = {
        -- Local file on the "new" side when comparing revs (LSP + editable buffer).
        DiffviewOpen = { "--imply-local" },
        -- File history: right side = on-disk file so you can edit the current version.
        DiffviewFileHistory = { "--base=LOCAL" },
      },
      hooks = {
        diff_buf_read = function()
          vim.opt_local.wrap = false
          vim.opt_local.list = false
        end,
      },
    })
  end,
}
