return {
  {
    "neovim/nvim-lspconfig",
    cond = not vim.g.vscode,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "folke/lazydev.nvim", ft = "lua", opts = {} },
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Native Neovim 0.11 LSP API (no require("lspconfig") needed)
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("ts_ls", {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
      })

      vim.lsp.config("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("rust_analyzer", {
        cmd = { "rust-analyzer" },
        filetypes = { "rust" },
        root_markers = { "Cargo.toml", ".git" },
      })

      vim.lsp.enable({ "ts_ls", "lua_ls", "rust_analyzer" })

      -- Keybindings on LSP attach
      -- Navigation uses fzf-lua for floating picker + preview
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
          end
          local fzf = require("fzf-lua")
          map("gd", fzf.lsp_definitions, "Go to definition")
          map("gD", fzf.lsp_declarations, "Go to declaration")
          map("gr", fzf.lsp_references, "Go to references")
          map("gi", fzf.lsp_implementations, "Go to implementation")
          map("gt", fzf.lsp_typedefs, "Go to type definition")
          map("gh", vim.lsp.buf.hover, "Hover")
          map("gs", vim.lsp.buf.signature_help, "Signature help")
          map("<leader>r", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>a", fzf.lsp_code_actions, "Code action")
          map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
          map("]d", vim.diagnostic.goto_next, "Next diagnostic")
        end,
      })

      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = true },
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    cond = not vim.g.vscode,
    cmd = "Mason",
    opts = {},
  },
  {
    "williamboman/mason-lspconfig.nvim",
    cond = not vim.g.vscode,
    opts = {
      ensure_installed = { "ts_ls", "lua_ls", "rust_analyzer" },
      automatic_enable = false,
    },
  },
  {
    "stevearc/conform.nvim",
    cond = not vim.g.vscode,
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      { "<leader>lf", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
    },
    opts = {
      formatters_by_ft = {
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        lua = { "stylua" },
        rust = { "rustfmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
}
