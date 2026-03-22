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
      dashboard.button("f", "  Find file", "<cmd>FzfLua files<cr>"),
      dashboard.button("o", "  Recent files", "<cmd>FzfLua oldfiles<cr>"),
      dashboard.button("g", "  Live grep", "<cmd>FzfLua live_grep<cr>"),
      dashboard.button("e", "  File tree", "<cmd>Neotree toggle<cr>"),
      dashboard.button("?", "  Keymaps", "<cmd>FzfLua keymaps<cr>"),
      dashboard.button("h", "  Cheatsheets", "<cmd>FzfLua files cwd=~/dev/perso/dotfiles/cheatsheets<cr>"),
      dashboard.button("c", "  Config", "<cmd>e ~/.config/nvim/init.lua<cr>"),
      dashboard.button("l", "󰒲  Lazy", "<cmd>Lazy<cr>"),
      dashboard.button("q", "  Quit", "<cmd>qa<cr>"),
    }

    dashboard.section.footer.val = function()
      local stats = require("lazy").stats()
      return "⚡ " .. stats.loaded .. "/" .. stats.count .. " plugins loaded in " .. math.floor(stats.startuptime) .. "ms"
    end

    dashboard.section.header.opts.hl = "DraculaPurple"
    dashboard.section.buttons.opts.hl = "DraculaCyan"

    alpha.setup(dashboard.opts)

    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      once = true,
      callback = function()
        dashboard.section.footer.val = dashboard.section.footer.val()
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
