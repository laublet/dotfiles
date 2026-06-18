-- https://github.com/nvim-treesitter/nvim-treesitter
-- https://github.com/windwp/nvim-ts-autotag
-- https://github.com/nvim-treesitter/nvim-treesitter-textobjects

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    cond = not vim.g.vscode,
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
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
      -- Semantic text objects: af/if (function), ac/ic (class), aa/ia (parameter)
      -- Movements: ]m/[m next/prev function start, ]M/[M end
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "around function" },
            ["if"] = { query = "@function.inner", desc = "inner function" },
            ["ac"] = { query = "@class.outer", desc = "around class" },
            ["ic"] = { query = "@class.inner", desc = "inner class" },
            ["aa"] = { query = "@parameter.outer", desc = "around argument" },
            ["ia"] = { query = "@parameter.inner", desc = "inner argument" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = { query = "@function.outer", desc = "Next function start" },
            ["]c"] = { query = "@class.outer", desc = "Next class start" },
          },
          goto_next_end = {
            ["]M"] = { query = "@function.outer", desc = "Next function end" },
            ["]C"] = { query = "@class.outer", desc = "Next class end" },
          },
          goto_previous_start = {
            ["[m"] = { query = "@function.outer", desc = "Prev function start" },
            ["[c"] = { query = "@class.outer", desc = "Prev class start" },
          },
          goto_previous_end = {
            ["[M"] = { query = "@function.outer", desc = "Prev function end" },
            ["[C"] = { query = "@class.outer", desc = "Prev class end" },
          },
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
          local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
          if buftype ~= "" and not vim.api.nvim_buf_get_name(buf):match("^diffview://") then
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
