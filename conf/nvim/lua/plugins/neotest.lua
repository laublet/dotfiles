-- https://github.com/nvim-neotest/neotest
-- Jest + Vitest: auto-picked per repo config.

return {
  "nvim-neotest/neotest",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  dependencies = {
    "nvim-neotest/neotest-jest",
    "marilari88/neotest-vitest",
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  keys = {
    { "<leader>ct", function() require("neotest").run.run() end, desc = "Test: run nearest" },
    { "<leader>cf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test: run file" },
    { "<leader>cS", function() require("neotest").run.run(vim.fn.getcwd()) end, desc = "Test: run suite (cwd)" },
    { "<leader>cw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Test: toggle watch" },
    { "<leader>co", function() require("neotest").output.open({ enter = true, auto_close = false }) end, desc = "Test: output" },
    { "<leader>cp", function() require("neotest").output_panel.toggle() end, desc = "Test: output panel" },
    { "<leader>cn", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Test: next failure" },
    { "<leader>cN", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Test: prev failure" },
    { "<leader>cy", function() require("neotest").summary.toggle() end, desc = "Test: summary" },
    {
      "<leader>cD",
      function()
        require("neotest").run.run({ strategy = "dap" })
      end,
      desc = "Test: debug nearest (DAP)",
    },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-jest")({
          dap = { enabled = true },
        }),
        require("neotest-vitest")({
          dap = { enabled = true },
        }),
      },
      status = { virtual_text = true },
      summary = {
        enabled = true,
        animated = false,
      },
      floating = {
        border = "rounded",
      },
    })
  end,
}
