-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- Sidebar file tree (orientation only). `follow_current_file` is OFF on purpose:
-- it triggers a debounced `filesystem_navigate` whose internal renderer calls
-- `nvim_buf_set_name` and races into E95 "Buffer with this name already exists"
-- (#1415, #1365). Manual reveal via <leader>E is fine because it runs once,
-- not on every BufEnter, so no race.
--
-- For filesystem manipulation (bulk rename, create, move, etc.), use oil.nvim
-- (open via `g-` / `<leader>O`). Neo-tree stays read-mostly: navigate + open files.

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  cond = not vim.g.vscode,
  main = "neo-tree", -- explicit so lazy.nvim picks the right module to setup()
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file tree" },
    { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal current file in tree" },
  },
  -- Explicit config callback (instead of opts) makes setup failures visible
  -- as errors instead of silently leaving config = nil.
  config = function(_, opts)
    require("neo-tree").setup(opts)
    -- Global timeoutlen is 300ms (options.lua), too short to type `zR`/`zM`
    -- in two keystrokes on a Kyria with layered tap-holds. Bump it locally
    -- to 600ms inside the neo-tree buffer so multi-char fold mappings fire.
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("NeoTreeTimeoutlen", { clear = true }),
      pattern = "neo-tree",
      callback = function() vim.opt_local.timeoutlen = 600 end,
    })
  end,
  opts = {
    close_if_last_window = true,
    filesystem = {
      bind_to_cwd = true,
      follow_current_file = { enabled = false }, -- DO NOT enable: source of E95 race
      use_libuv_file_watcher = false,
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
        -- Fold-style expand/collapse, mirrors vim fold mnemonics.
        -- Uppercase (zR/zM) = whole tree; lowercase (zr/zm) = current subtree only.
        -- zo/zc toggle the node under cursor. NOTE: neo-tree has no `open_node`
        -- action; `toggle_node` is the right one (no-op if already open/closed).
        ["zR"] = "expand_all_nodes",
        ["zM"] = "close_all_nodes",
        ["zr"] = "expand_all_subnodes",
        ["zm"] = "close_all_subnodes",
        ["zo"] = "toggle_node",
        ["zc"] = "close_node",
        -- Single-key alternatives (no timeoutlen risk on Kyria layers):
        -- Shift+arrows expand/collapse the whole tree; +/= work on current node.
        ["<S-Right>"] = "expand_all_nodes",
        ["<S-Left>"]  = "close_all_nodes",
        ["+"]         = "expand_all_subnodes",
        ["="]         = "close_all_subnodes",
      },
    },
    event_handlers = {
      {
        event = "neo_tree_window_after_open",
        handler = function(args)
          if args.position == "left" or args.position == "right" then
            vim.cmd("wincmd =")
          end
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
