-- https://github.com/neovim/nvim-lspconfig
-- https://github.com/williamboman/mason.nvim
-- https://github.com/williamboman/mason-lspconfig.nvim
-- https://github.com/folke/lazydev.nvim
-- https://github.com/stevearc/conform.nvim

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

      local function mason_bin(name)
        local mason_path = vim.fn.stdpath("data") .. "/mason/bin/" .. name
        if vim.fn.executable(mason_path) == 1 then
          return mason_path
        end
        return name
      end

      -- Native Neovim 0.11 LSP API (no require("lspconfig") needed)
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("ts_ls", {
        cmd = { mason_bin("typescript-language-server"), "--stdio" },
        filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
        root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
      })

      vim.lsp.config("lua_ls", {
        cmd = { mason_bin("lua-language-server") },
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
        cmd = { mason_bin("rust-analyzer") },
        filetypes = { "rust" },
        root_markers = { "Cargo.toml", ".git" },
      })

      -- LTeX (LanguageTool): grammar/style for prose — NOT auto-started (no vim.lsp.enable).
      -- One language per LTeX instance — use :GrammarLang <code> (e.g. fr, en, es) for this buffer.
      -- Neovim spell can use multiple spelllang at once (see ftplugin/tex.lua); LTeX cannot.
      -- Toggle: <leader>lg or :GrammarCheck. Install: :MasonInstall ltex (Java required).
      local function ltex_cmd()
        local mason = vim.fn.stdpath("data") .. "/mason/bin/ltex-ls"
        if vim.fn.executable(mason) == 1 then
          return { mason }
        end
        return { "ltex-ls" }
      end

      local function ltex_root_dir(bufnr)
        local path = vim.api.nvim_buf_get_name(bufnr)
        if path == "" then
          return vim.fn.getcwd()
        end
        return vim.fs.root(path, { ".git", ".editorconfig" }) or vim.fn.fnamemodify(path, ":h")
      end

      local function ltex_language_for_buffer(bufnr)
        local ok, lang = pcall(vim.api.nvim_buf_get_var, bufnr, "ltex_language")
        if ok and type(lang) == "string" and lang ~= "" then
          return lang
        end
        return "fr"
      end

      vim.lsp.enable({ "ts_ls", "lua_ls", "rust_analyzer" })

      local function ltex_start(bufnr)
        local cmd = ltex_cmd()[1]
        if vim.fn.executable(cmd) == 0 then
          vim.notify("Install LTeX: :MasonInstall ltex (Java required)", vim.log.levels.ERROR)
          return
        end

        local ft = vim.bo[bufnr].filetype
        local ok_ft = {
          markdown = true,
          tex = true,
          text = true,
          gitcommit = true,
          mail = true,
          plaintext = true,
        }
        if not ok_ft[ft] then
          vim.notify(
            "LTeX: filetype '" .. ft .. "' — use :set ft=markdown or ft=text for drafts",
            vim.log.levels.WARN
          )
        end

        local lang = ltex_language_for_buffer(bufnr)
        vim.lsp.start({
          name = "ltex",
          cmd = ltex_cmd(),
          root_dir = ltex_root_dir(bufnr),
          capabilities = capabilities,
          settings = {
            ltex = {
              language = lang,
              additionalRules = { enablePickyRules = false },
            },
          },
        }, { bufnr = bufnr })

        vim.notify("LTeX started (grammar, language=" .. lang .. ")", vim.log.levels.INFO)
      end

      local function ltex_toggle()
        local bufnr = vim.api.nvim_get_current_buf()
        local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "ltex" })
        if #clients > 0 then
          for _, client in ipairs(clients) do
            client:stop(true)
          end
          vim.notify("LTeX stopped", vim.log.levels.INFO)
          return
        end

        ltex_start(bufnr)
      end

      vim.api.nvim_create_user_command("GrammarCheck", ltex_toggle, { desc = "Toggle LTeX grammar check (current buffer)" })

      vim.api.nvim_create_user_command("GrammarLang", function(opts)
        local lang = vim.trim(opts.args or "")
        if lang == "" then
          vim.notify("Usage: :GrammarLang fr | en | es | …", vim.log.levels.ERROR)
          return
        end
        local bufnr = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_var(bufnr, "ltex_language", lang)
        local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "ltex" })
        if #clients > 0 then
          for _, client in ipairs(clients) do
            client:stop(true)
          end
          ltex_start(bufnr)
        else
          vim.notify("LTeX language for this buffer: " .. lang .. " (start with :GrammarCheck or <leader>lg)", vim.log.levels.INFO)
        end
      end, {
        nargs = 1,
        desc = "Set LTeX grammar language for this buffer (restart LTeX if running)",
        complete = function()
          return { "fr", "en", "es" }
        end,
      })

      vim.keymap.set("n", "<leader>lg", ltex_toggle, { desc = "Toggle LTeX grammar check" })

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
          -- Code actions: <leader>la (LSP prefix l; not <leader>a — reserved for Avante)
          vim.keymap.set({ "n", "v" }, "<leader>la", fzf.lsp_code_actions, {
            buffer = bufnr,
            desc = "LSP code action",
          })
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
      ensure_installed = { "ts_ls", "lua_ls", "rust_analyzer", "ltex" },
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
