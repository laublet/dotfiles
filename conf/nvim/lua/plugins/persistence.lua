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
        -- Auto-restore session (per cwd) when nvim is opened either with no
        -- arguments (`nvim`) or with a single directory argument (`nvim .`,
        -- `nvim ~/dev/foo`). Skip when a file is given so `nvim file.lua`
        -- stays a focused edit and doesn't pull the whole session in.
        local argc = vim.fn.argc()
        if argc == 0 then
          require("persistence").load()
        elseif argc == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
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
