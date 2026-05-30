-- Fast lint via oxlint CLI (brew install oxlint). ESLint LSP in lsp.lua handles
-- project rules and code actions; oxlint gives quick feedback on save.

return {
  "mfussenegger/nvim-lint",
  cond = not vim.g.vscode,
  version = "d48f3a76189d03b2239f6df1b2f7e3fa8353743b",
  event = { "BufReadPost", "BufWritePost", "InsertLeave" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "oxlint" },
      javascriptreact = { "oxlint" },
      typescript = { "oxlint" },
      typescriptreact = { "oxlint" },
      vue = { "oxlint" },
      svelte = { "oxlint" },
    }

    local group = vim.api.nvim_create_augroup("oxlint-lint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      group = group,
      callback = function()
        lint.try_lint()
      end,
    })
    vim.api.nvim_create_autocmd("BufReadPost", {
      group = group,
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
