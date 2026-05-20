-- https://github.com/sindrets/diffview.nvim
-- Repo-wide and per-file diffs (paired with Neogit). Edit the working-tree
-- pane (B / right in horizontal layout); the other side is read-only git state.

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
