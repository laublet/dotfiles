-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- Sidebar file tree (orientation only). `follow_current_file` is OFF on purpose:
-- it triggers a debounced `filesystem_navigate` whose internal renderer calls
-- `nvim_buf_set_name` and races into E95 "Buffer with this name already exists"
-- (#1415, #1365). Manual reveal via <leader>E is fine because it runs once,
-- not on every BufEnter, so no race.
--
-- For filesystem manipulation (bulk rename, create, move, etc.), use oil.nvim
-- (open via `g-` / `<leader>O`). Neo-tree stays read-mostly: navigate + open files.
--
-- Workaround for intermittent E95 ("Buffer with this name already exists"):
-- prune hidden/orphan neo-tree buffers after leaving/closing the tree window.
local function cleanup_hidden_neotree_buffers()
  local shown = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    shown[vim.api.nvim_win_get_buf(win)] = true
  end

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if not shown[buf] and vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
      local ok_filetype, filetype = pcall(vim.api.nvim_get_option_value, "filetype", { buf = buf })
      local ok_buftype, buftype = pcall(vim.api.nvim_get_option_value, "buftype", { buf = buf })
      if ok_filetype and ok_buftype and filetype == "neo-tree" and buftype == "nofile" then
        pcall(vim.api.nvim_buf_delete, buf, { force = true })
      end
    end
  end
end

local function safe_neotree_close()
  -- Use Neo-tree's close path so internal state is updated consistently.
  vim.cmd("Neotree close")
  vim.schedule(cleanup_hidden_neotree_buffers)
end

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
      callback = function(args)
        vim.opt_local.timeoutlen = 600
        -- Wipe hidden neo-tree buffers to avoid E95 on reopening.
        vim.bo[args.buf].bufhidden = "wipe"
        -- Force safe close paths when user is inside the neo-tree window.
        vim.keymap.set("n", "q", safe_neotree_close, { buffer = args.buf, silent = true, desc = "Neo-tree close" })
        vim.keymap.set("n", "<Esc>", safe_neotree_close, { buffer = args.buf, silent = true, desc = "Neo-tree close" })
        vim.keymap.set("n", "ZQ", safe_neotree_close, { buffer = args.buf, silent = true, desc = "Neo-tree close" })
        vim.keymap.set("n", "ZZ", safe_neotree_close, { buffer = args.buf, silent = true, desc = "Neo-tree close" })
      end,
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
        -- Neo-tree uses virtual ids ending with `_hidden_message` to display
        -- hidden-count hints. Real files named `*_hidden_message` then collide.
        show_hidden_count = false,
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
        ["<C-v>"] = "open_vsplit",
        ["<C-x>"] = "open_split",
        ["<C-t>"] = "open_tabnew",
        ["q"] = "close_window",
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
      {
        event = "neo_tree_buffer_leave",
        handler = cleanup_hidden_neotree_buffers,
      },
      {
        event = "neo_tree_window_after_close",
        handler = cleanup_hidden_neotree_buffers,
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
