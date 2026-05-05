-- https://github.com/folke/persistence.nvim

return {
  "folke/persistence.nvim",
  cond = not vim.g.vscode,
  event = "BufReadPre",
  opts = {},
  init = function()
    vim.api.nvim_create_autocmd("VimEnter", {
      nested = true,
      callback = function()
        -- Only auto-restore when nvim is opened with no file arguments
        if vim.fn.argc() == 0 then
          require("persistence").load()
        end
      end,
    })
  end,
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Restore session (cwd)" },
    { "<leader>qS", function() require("persistence").select() end, desc = "Select a session" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save current session" },
  },
}
