return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cond = not vim.g.vscode,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  event = "VimEnter",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file tree" },
    { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal current file" },
  },
  init = function()
    -- Open neo-tree on startup (only when opening a directory or no file args)
    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if vim.fn.argc() == 0 or vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
          vim.schedule(function()
            vim.cmd("Neotree show")
          end)
        end
      end,
    })
  end,
  opts = {
    close_if_last_window = true,
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = { "node_modules", ".git" },
      },
    },
    window = {
      width = 35,
      mappings = {
        ["<space>"] = "none",
        ["<Right>"] = "open",
        ["<Left>"] = "close_node",
        ["<CR>"] = "open",
        ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = false } },
      },
    },
    event_handlers = {
      {
        event = "neo_tree_window_after_open",
        handler = function(args)
          if args.position == "left" or args.position == "right" then
            vim.cmd("wincmd =")
          end
          -- Auto-enable float preview on first open
          vim.defer_fn(function()
            local preview = require("neo-tree.sources.common.preview")
            if not preview.is_active() then
              vim.api.nvim_feedkeys("P", "m", false)
            end
          end, 100)
        end,
      },
    },
    default_component_configs = {
      git_status = {
        symbols = {
          added = "✚",
          modified = "",
          deleted = "✖",
          renamed = "󰁕",
          untracked = "",
          ignored = "",
          unstaged = "󰄱",
          staged = "",
          conflict = "",
        },
      },
    },
  },
}
