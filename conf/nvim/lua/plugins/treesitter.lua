-- https://github.com/nvim-treesitter/nvim-treesitter
-- https://github.com/windwp/nvim-ts-autotag

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    cond = not vim.g.vscode,
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      ensure_installed = {
        "typescript", "tsx", "javascript",
        "go",
        "lua",
        "json", "yaml", "toml",
        "html", "css",
        "bash", "markdown", "markdown_inline",
        "vim", "vimdoc",
        "gitcommit", "diff",
        "regex",
      },
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
      -- Treesitter folds (VS Code–like); files open unfolded (foldlevelstart).
      vim.o.foldmethod = "expr"
      vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.o.foldenable = true
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99

      -- Ensure parser is attached so foldexpr is not always 0.
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local buf = ev.buf
          if vim.api.nvim_buf_get_option(buf, "buftype") ~= "" then
            return
          end
          local ft = vim.bo[buf].filetype
          if ft == "" then
            return
          end
          pcall(vim.treesitter.start, buf, ft)
        end,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    cond = not vim.g.vscode,
    event = "InsertEnter",
    opts = {},
  },
}
