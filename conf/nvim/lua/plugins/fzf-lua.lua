-- https://github.com/ibhagwan/fzf-lua

return {
  "ibhagwan/fzf-lua",
  cond = not vim.g.vscode,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = "FzfLua",
  keys = (function()
    local fz = function() return require("fzf-lua") end

    -- fd (see cheatsheets/fd.md) — passed as fd_opts to files()
    local fd = {
      default = [[--color=never --type f --type l --exclude .git]],
      hidden = [[--color=never --hidden --type f --type l --exclude .git]],
      no_ignore = [[--color=never --no-ignore --type f --type l --exclude .git]],
      dirs = [[--color=never --type d --exclude .git]],
      files_only = [[--color=never --type f --exclude .git]],
      glob = [[--color=never --glob --type f --type l --exclude .git]],
    }

    -- rg (see cheatsheets/ripgrep.md). Flags MUST come before the final `-e` (fzf-lua appends the pattern
    -- after rg_opts). Putting `-e` then `--ignore-case` breaks rg and can yield "IO error" on the query word.
    local function rg_icase()
      return "--column --line-number --no-heading --color=always --ignore-case --max-columns=4096 -e"
    end
    local function rg_word()
      return "--column --line-number --no-heading --color=always --smart-case --word-regexp --max-columns=4096 -e"
    end
    local function rg_hidden()
      return "--column --line-number --no-heading --color=always --smart-case --hidden --max-columns=4096 -e"
    end
    local function rg_no_ignore()
      return "--column --line-number --no-heading --color=always --smart-case --no-ignore --max-columns=4096 -e"
    end
    local function rg_fixed()
      return "--column --line-number --no-heading --color=always --fixed-strings --max-columns=4096 -e"
    end

    local function files(opts)
      return function()
        fz().files(opts or {})
      end
    end

    local function live_grep_native(opts)
      return function()
        fz().live_grep_native(opts or {})
      end
    end

    -- Neovim 0.11 + Bob: do NOT set multiprocess=false — stringify_mt returns nil and
    -- fzf falls back to headless spawn (`nvim -u NONE -l spawn.lua`), which shows
    -- "Command failed: …/bob/v0.11.x/bin/nvim". Use 1 (optional) + fn_* = false so git
    -- status is piped raw to fzf (no headless child).
    local git_status_opts = {
      fn_preprocess = false,
      fn_transform = false,
      fn_postprocess = false,
      previewer = false,
      file_icons = false,
      color_icons = false,
      git_icons = false,
      multiprocess = 1,
    }

    local pick_default = files({})

    return {
      -- Quick open (same as <leader>pp) — editor-style
      { "<C-p>", pick_default, desc = "Quick open files" },

      -- Find / fd — prefix <leader>p (pp, pH, …)
      { "<leader>pp", pick_default, desc = "Find files (default)" },
      { "<leader>pH", files({ fd_opts = fd.hidden }), desc = "Find files (include hidden)" },
      { "<leader>pI", files({ fd_opts = fd.no_ignore }), desc = "Find files (no .gitignore)" },
      { "<leader>pd", files({ fd_opts = fd.dirs }), desc = "Find directories" },
      { "<leader>pf", files({ fd_opts = fd.files_only }), desc = "Find files only" },
      { "<leader>pg", files({ fd_opts = fd.glob }), desc = "Find files (glob mode)" },

      -- Grep / rg — prefix <leader>f
      { "<leader>ff", function() fz().live_grep_native() end, desc = "Live grep (project)" },
      { "<leader>fi", live_grep_native({ rg_opts = rg_icase() }), desc = "Live grep (ignore case)" },
      { "<leader>fw", live_grep_native({ rg_opts = rg_word() }), desc = "Live grep (whole word)" },
      { "<leader>fh", live_grep_native({ rg_opts = rg_hidden() }), desc = "Live grep (hidden files)" },
      { "<leader>fn", live_grep_native({ rg_opts = rg_no_ignore() }), desc = "Live grep (no .gitignore)" },
      { "<leader>fF", live_grep_native({ rg_opts = rg_fixed() }), desc = "Live grep (fixed string)" },
      { "<leader>fg", function() fz().live_grep_glob() end, desc = "Live grep (glob in query)" },
      { "<leader>fr", function() fz().live_grep_resume() end, desc = "Resume live grep" },
      { "<leader>f/", function() fz().grep_curbuf() end, desc = "Search in buffer (alias of <leader>/)" },

      -- ast-grep (sg) — pattern library + custom; see lua/utils/ast-grep.lua
      {
        "<leader>fs",
        function()
          require("utils.ast-grep").search_cwd()
        end,
        desc = "ast-grep: pick pattern (project cwd)",
      },
      {
        "<leader>fS",
        function()
          require("utils.ast-grep").search_file_dir()
        end,
        desc = "ast-grep: pick pattern (file dir)",
      },
      {
        "<leader>fc",
        function()
          require("utils.ast-grep").search_cwd_custom()
        end,
        desc = "ast-grep: type pattern (project cwd)",
      },
      {
        "<leader>fC",
        function()
          require("utils.ast-grep").search_file_dir_custom()
        end,
        desc = "ast-grep: type pattern (file dir)",
      },

      -- Git — prefix <leader>g
      { "<leader>gs", function() fz().git_status(git_status_opts) end, desc = "Git status" },
      { "<leader>gc", function() fz().git_commits() end, desc = "Git commits" },
      { "<leader>gb", function() fz().git_branches() end, desc = "Git branches" },
      { "<leader>gf", function() fz().git_files() end, desc = "Git tracked files" },

      {
        "<leader>b",
        function()
          local actions = require("fzf-lua.actions")
          fz().buffers({
            _resume_reload = true,
            fzf_opts = {
              ["--header"] = "Enter=open | Ctrl-x=delete | Esc=cancel",
            },
            actions = {
              ["ctrl-x"] = {
                fn = function(selected, opts)
                  actions.buf_del(selected, opts)
                  actions.resume(selected, opts)
                end,
                noclose = true,
              },
            },
          })
        end,
        desc = "Buffers (fuzzy)",
      },
      { "<leader>r", function() fz().oldfiles() end, desc = "Recent files" },
      { "<leader>/", function() fz().grep_curbuf() end, desc = "Search in buffer (canonical)" },
      { "<leader>s", function() fz().lsp_document_symbols() end, desc = "Document symbols" },
      { "<leader>S", function() fz().lsp_workspace_symbols() end, desc = "Workspace symbols" },
      { "<leader>:", function() fz().command_history() end, desc = "Command history" },
      { "<leader>?", function() fz().keymaps() end, desc = "Keymaps" },
      {
        "<leader>vr",
        function()
          local actions = require("fzf-lua.actions")
          fz().registers({
            ignore_empty = true,
            fzf_opts = {
              ["--header"] = "Enter=paste | Ctrl-x=clear register | Esc=cancel",
            },
            actions = {
              ["enter"] = actions.paste_register,
              ["ctrl-x"] = {
                fn = function(selected)
                  local line = selected[1]
                  if not line then
                    return
                  end
                  local reg = line:match("^%[([^%]]+)%]")
                  if reg then
                    pcall(vim.fn.setreg, reg, "")
                  end
                end,
                reload = true,
              },
            },
          })
        end,
        desc = "Registers (fzf)",
      },
      {
        "<leader>vm",
        function()
          fz().marks({
            fzf_opts = { ["--header"] = "Enter=jump | Ctrl-x=delete mark | Esc=cancel" },
          })
        end,
        desc = "Marks (fzf, not harpoon)",
      },
      {
        "<leader>H",
        function()
          require("fzf-lua").files({
            cwd = vim.fn.expand("~/dev/perso/dotfiles/cheatsheets"),
            prompt = "Cheatsheets❯ ",
            actions = {
              ["default"] = function(selected)
                local file = selected[1]:match("[^%s]+$") or selected[1]
                local path = vim.fn.expand("~/dev/perso/dotfiles/cheatsheets/") .. file
                vim.cmd("edit " .. vim.fn.fnameescape(path))
              end,
            },
          })
        end,
        desc = "Cheatsheets",
      },
    }
  end)(),
  config = function()
    -- Neovim 0.11 + Bob: fzf-lua headless child (`nvim -u NONE -l spawn.lua`) breaks easily.
    -- Prefer piping fd/rg/git raw to fzf (file_icons/git_icons off; git.status: multiprocess=1,
    -- fn_*=false — not multiprocess=false, that nils stringify_mt and re-triggers headless).
    -- Grep uses live_grep_native() which avoids the wrapper entirely.
    vim.env.FZF_LUA_NVIM_BIN = vim.fn.exepath("nvim") or vim.v.progpath
    vim.env.FZF_LUA_NVIM_RUNTIME = vim.env.VIMRUNTIME
    require("fzf-lua").setup({
      defaults = {
        file_icons = false,
        git_icons = false,
      },
      winopts = {
        height = 0.85,
        width = 0.85,
        preview = { layout = "horizontal", horizontal = "right:55%" },
      },
      fzf_opts = { ["--layout"] = "reverse" },
      files = {
        file_icons = false,
        git_icons = false,
      },
      git = {
        status = {
          fn_preprocess = false,
          fn_transform = false,
          fn_postprocess = false,
          previewer = false,
          file_icons = false,
          color_icons = false,
          git_icons = false,
          multiprocess = 1,
        },
      },
      -- buffers picker opts live on <leader>b (noclose + resume — reload=true closes the float)
    })
  end,
}
