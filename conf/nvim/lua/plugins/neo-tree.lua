-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- E95 "Buffer with this name already exists" (renderer.lua nvim_buf_set_name): orphan neo-tree
-- buffers left after :close/:q or races with follow_current_file + debounced navigate (#1415, #1365).
-- Match by bufname prefix too: ft may not be set yet on a stale buffer; name is what nvim_buf_set_name collides on.
local function neo_tree_cleanup_orphan_buffers()
  local shown = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local b = vim.api.nvim_win_get_buf(win)
    if vim.api.nvim_buf_is_valid(b) then
      shown[b] = true
    end
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if not shown[buf] and vim.api.nvim_buf_is_valid(buf) then
      local ok_bt, bt = pcall(vim.api.nvim_get_option_value, "buftype", { buf = buf })
      if ok_bt and bt == "nofile" then
        local name = vim.fn.bufname(buf)
        local ok_ft, ft = pcall(vim.api.nvim_get_option_value, "filetype", { buf = buf })
        local looks_neo_tree = (ok_ft and ft == "neo-tree") or (name ~= "" and name:match("^neo-tree "))
        if looks_neo_tree then
          pcall(vim.api.nvim_buf_delete, buf, { force = true })
        end
      end
    end
  end
end

local function neo_tree_cleanup_orphan_buffers_scheduled()
  neo_tree_cleanup_orphan_buffers()
  vim.schedule(neo_tree_cleanup_orphan_buffers)
end

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
            neo_tree_cleanup_orphan_buffers_scheduled()
            vim.cmd("Neotree show")
          end)
        end
      end,
    })
  end,
  opts = {
    close_if_last_window = true,
    filesystem = {
      bind_to_cwd = true,
      follow_current_file = { enabled = true },
      -- Libuv watcher + debounced navigate can race and trigger E95 (duplicate buffer name). Prefer stable fs polling.
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
      -- Before (re)open: drop orphan buffers so nvim_buf_set_name cannot hit E95.
      {
        event = "neo_tree_window_before_open",
        handler = neo_tree_cleanup_orphan_buffers_scheduled,
      },
      {
        event = "neo_tree_window_after_close",
        handler = neo_tree_cleanup_orphan_buffers,
      },
      {
        event = "neo_tree_buffer_leave",
        handler = neo_tree_cleanup_orphan_buffers,
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
