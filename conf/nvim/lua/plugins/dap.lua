-- https://github.com/mfussenegger/nvim-dap
-- Node/TS debugging via Mason js-debug-adapter (vscode-js-debug DAP server).

return {
  "mfussenegger/nvim-dap",
  cond = not vim.g.vscode,
  event = "VeryLazy",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<F5>", function() require("dap").continue() end, desc = "Debug: continue / launch" },
    { "<F10>", function() require("dap").step_over() end, desc = "Debug: step over" },
    { "<F11>", function() require("dap").step_into() end, desc = "Debug: step into" },
    { "<F12>", function() require("dap").step_out() end, desc = "Debug: step out" },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: toggle breakpoint" },
    { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug: conditional breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Debug: continue" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Debug: step into" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Debug: step over" },
    { "<leader>dO", function() require("dap").step_out() end, desc = "Debug: step out" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: toggle UI" },
    { "<leader>dr", function() require("dapui").open({ enter = true, reset = true }) end, desc = "Debug: open REPL" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Debug: terminate" },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "Debug: re-run last configuration",
    },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    local function mason_bin(name)
      local path = vim.fn.stdpath("data") .. "/mason/bin/" .. name
      if vim.fn.executable(path) == 1 then
        return path
      end
      return name
    end

    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = mason_bin("js-debug-adapter"),
        args = { "${port}" },
      },
    }

    local js_configs = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        skipFiles = { "<node_internals>/**", "node_modules/**" },
      },
      {
        type = "pwa-node",
        request = "attach",
        name = "Attach to port 9229",
        port = 9229,
        cwd = "${workspaceFolder}",
        sourceMaps = true,
        skipFiles = { "<node_internals>/**", "node_modules/**" },
      },
    }

    for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
      dap.configurations[ft] = js_configs
    end

    -- .vscode/launch.json is picked up automatically (:help dap-providers).

    dapui.setup({
      icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
      floating = { border = "rounded" },
    })

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        dapui.close({})
      end,
      once = true,
    })

    dap.listeners.after.event_initialized["dapui_open"] = function()
      dapui.open({})
    end
    dap.listeners.before.event_terminated["dapui_close"] = function()
      dapui.close({})
    end
    dap.listeners.before.event_exited["dapui_close"] = function()
      dapui.close({})
    end

    require("nvim-dap-virtual-text").setup({
      commented_virtual_text = true,
    })
  end,
}
