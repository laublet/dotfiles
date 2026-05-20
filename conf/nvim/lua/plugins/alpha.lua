-- https://github.com/goolord/alpha-nvim

return {
  "goolord/alpha-nvim",
  cond = not vim.g.vscode,
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
      [[                                                    ]],
      [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
      [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
      [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
      [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
      [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
      [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
    }

    dashboard.section.buttons.val = {
      dashboard.button("s", "  Restore session", [[<cmd>lua require("persistence").load()<cr>]]),
      dashboard.button("p", "  Quick open (pp / Ctrl+P)", "<cmd>FzfLua files<cr>"),
      dashboard.button("o", "  Recent files", "<cmd>FzfLua oldfiles<cr>"),
      dashboard.button("g", "  Live grep (ff)", "<cmd>FzfLua live_grep_native<cr>"),
      dashboard.button("e", "  File tree", "<cmd>Neotree toggle<cr>"),
      dashboard.button("?", "  Keymaps", "<cmd>FzfLua keymaps<cr>"),
      dashboard.button("h", "  Cheatsheets", "<cmd>FzfLua files cwd=~/dev/perso/dotfiles/cheatsheets<cr>"),
      dashboard.button("c", "  Config", "<cmd>e ~/.config/nvim/init.lua<cr>"),
      dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<cr>"),
      dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
    }

    -- Vim tip-of-the-session: passive spaced repetition for buffer/window/tab
    -- commands that Loïc forgets after a VS Code break. A random tip from the
    -- pool below appears under the plugin stats every time alpha shows.
    -- See cheatsheets/vim-fundamentals.md for the full reference.
    local vim_tips = {
      "Cycle buffers : `<leader>b` (fzf list + Ctrl-x delete, picker stays open) — or `<C-Tab>` for last-two toggle",
      "Stuck float / picker : `<leader>Ux` closes all floats — `<leader>Ur` refocuses the top one",
      "Diffview edit flow : `<leader>gv` → edit the right pane (B), `:w` saves — left pane is read-only git ref",
      "Close one buffer keeping the split : `<leader>q` (custom) — vim native `:bd` closes the window too",
      "List all buffers with markers : `:ls` (% = current, # = alternate, + = modified)",
      "Close all buffers except current : `:%bd|e#`",
      "Jump to buffer by name : `:b partial<Tab>` autocompletes",
      "Vertical split : `<C-w>v` — horizontal split : `<C-w>s`",
      "Navigate splits : `<C-w>h/j/k/l` (or `<C-Left/Right/Up/Down>` via smart-splits)",
      "Move (relocate) a window : `<C-w>H/J/K/L` (Shift) — different from navigation",
      "Equalize all splits : `<C-w>=` — maximize : `<C-w>|` (width) or `<C-w>_` (height)",
      "Close current split : `<C-w>c` (or `<leader>x`) — close all OTHERS : `<C-w>o`",
      "Toggle zoom on a split : `<leader>z` (saves layout, restores on second press)",
      "Tab pages : `<leader>Tn` / `<leader>Tp` next/prev — `<leader>TN` new (rare) — `<leader>Tc` close — `1gt` jump to tab N",
      "Move current window to a new tab : `<C-w>T`",
      "Re-source the file you are editing : `:source %` (great to reload nvim config live)",
      "Run a shell command from nvim : `:!ls -la` — read its output into buffer : `:r !date`",
      "Replace in lines 5-10 only : `:5,10s/old/new/g`",
      "Delete all lines matching a pattern : `:g/pattern/d` — keep ONLY matches : `:v/pattern/d`",
      "Show recent messages flashed too fast : `:messages`",
      "Inspect registers (clipboard, yanks, macros) : `:reg`",
      "Suspend nvim to shell : `<C-z>` — back to nvim : `fg`",
      "Open a file in a right split : `:vs path/to/file`",
      "Open current buffer in a new tab (keep here too) : `:tabedit %`",
      "Diagnose a plugin : `:checkhealth <plugin>` (try `:checkhealth persistence`)",
      "Force quit nvim without saving : `:qa!`",
      "Save all + quit all : `:wqa`",
      "Autosave : on when you leave insert / switch buffer / lose focus (2s debounce) — `:ASToggle` to disable",
      "Clear the search highlight : `:noh` (or `<leader>nh`)",
      "Toggle the last two files instantly : `<C-^>` (or `<C-6>`)",
      "Show your undo history as a tree : `<leader>u` (Undotree, opens on the right)",
      "Floating terminal : `<leader>t` — bottom split terminal : `<leader>;`",
      "Close any active terminal in one shot : `<C-q>`",
    }

    local function pick_tip()
      math.randomseed(os.time())
      return vim_tips[math.random(#vim_tips)]
    end

    local function build_footer()
      local stats = require("lazy").stats()
      local loaded = "⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins · " .. math.floor(stats.startuptime) .. "ms"
      return { loaded, "", "💡 " .. pick_tip() }
    end

    dashboard.section.footer.val = build_footer

    dashboard.section.header.opts.hl = "DraculaPurple"
    dashboard.section.buttons.opts.hl = "DraculaCyan"
    dashboard.section.footer.opts.hl = "DraculaYellow"

    alpha.setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      once = true,
      callback = function()
        dashboard.section.footer.val = build_footer()
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
