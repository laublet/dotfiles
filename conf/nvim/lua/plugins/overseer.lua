-- https://github.com/stevearc/overseer.nvim
-- npm scripts, Makefile, .vscode/tasks.json — pick with :OverseerRun

return {
  "stevearc/overseer.nvim",
  cond = not vim.g.vscode,
  cmd = { "Overseer", "OverseerRun", "OverseerToggle", "OverseerShell", "OverseerRestartLast" },
  keys = {
    { "<leader>or", "<cmd>OverseerRun<cr>", desc = "Task: run (npm / make / vscode)" },
    { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Task: toggle task list" },
    { "<leader>oR", "<cmd>OverseerRestartLast<cr>", desc = "Task: restart last" },
  },
  opts = {
    task_list = {
      direction = "bottom",
      min_height = 8,
      max_height = 20,
    },
  },
  config = function(_, opts)
    require("overseer").setup(opts)

    vim.api.nvim_create_user_command("OverseerRestartLast", function()
      local overseer = require("overseer")
      local task_list = require("overseer.task_list")
      local tasks = overseer.list_tasks({
        status = {
          overseer.STATUS.SUCCESS,
          overseer.STATUS.FAILURE,
          overseer.STATUS.CANCELED,
        },
        sort = task_list.sort_finished_recently,
      })
      if vim.tbl_isempty(tasks) then
        vim.notify("No tasks found", vim.log.levels.WARN)
      else
        overseer.run_action(tasks[1], "restart")
      end
    end, { desc = "Restart most recent overseer task" })
  end,
}
