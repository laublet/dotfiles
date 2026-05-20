-- https://github.com/stevearc/oil.nvim
-- Buffer-based file explorer. Complements neo-tree (sidebar orientation only).
-- Use oil when you want to:
--   - Open a directory as a buffer (`-` from any file → parent dir)
--   - Bulk rename / create / move files by editing the buffer and `:w`
--   - Avoid the debounced renderer races that plague neo-tree's follow_current_file
--
-- Keymaps (intentionally NOT <leader>e, which stays on Neotree toggle):
--   -          → Oil at the parent of the current file (vim-vinegar style)
--   <leader>O  → Oil in a floating window (modal, q/<Esc> to close)
--   :Oil       → Oil for a specific path
--
-- Dracula highlight wiring: oil uses its own hl groups (OilDir, OilFile, ...)
-- which dracula.nvim does not theme — without these links the tree looks pale.
-- The ColorScheme autocmd below remaps them onto dracula-themed groups.

local function link_oil_to_dracula()
  local set = function(group, link)
    vim.api.nvim_set_hl(0, group, { link = link, default = false })
  end
  set("OilDir",         "Directory")
  set("OilDirIcon",     "Directory")
  set("OilLink",        "Constant")
  set("OilLinkTarget",  "Comment")
  set("OilCopy",        "DiagnosticSignHint")
  set("OilMove",        "DiagnosticSignWarn")
  set("OilChange",      "DiagnosticSignWarn")
  set("OilCreate",      "DiagnosticSignInfo")
  set("OilDelete",      "DiagnosticSignError")
  set("OilPermissionNone",     "NonText")
  set("OilPermissionRead",     "DiagnosticSignWarn")
  set("OilPermissionWrite",    "DiagnosticSignError")
  set("OilPermissionExecute",  "DiagnosticSignInfo")
  set("OilTypeDir",     "Directory")
  set("OilTypeFile",    "Normal")
  set("OilTypeLink",    "Constant")
  set("OilTypeSocket",  "Identifier")
  set("OilSize",        "Number")
  set("OilMtime",       "Comment")
  set("OilHidden",      "Comment")
end

return {
  "stevearc/oil.nvim",
  cond = not vim.g.vscode,
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "Oil" },
  keys = {
    { "-",         "<cmd>Oil<cr>",         desc = "File explorer (oil, parent dir)" },
    { "<leader>O", "<cmd>Oil --float<cr>", desc = "File explorer (oil, floating)" },
  },
  lazy = false, -- needed so :Oil works on `nvim <dir>` (hijacks netrw)
  config = function(_, opts)
    require("oil").setup(opts)
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("OilDraculaHl", { clear = true }),
      callback = link_oil_to_dracula,
    })
    link_oil_to_dracula()
  end,
  opts = {
    default_file_explorer = true,
    delete_to_trash = true,
    skip_confirm_for_simple_edits = false,
    prompt_save_on_select_new_entry = true,
    view_options = {
      show_hidden = true,
      is_always_hidden = function(name, _)
        return name == ".git" or name == "node_modules"
      end,
      natural_order = true,
    },
    float = {
      padding = 4,
      max_width = 100,
      max_height = 30,
      border = "rounded",
      win_options = { winblend = 0 },
    },
    preview_win = {
      update_on_cursor_moved = true,
      preview_method = "fast_scratch",
    },
    keymaps = {
      ["g?"]      = { "actions.show_help",                mode = "n" },
      ["<CR>"]    = "actions.select",
      ["<C-s>"]   = { "actions.select", opts = { vertical = true } },
      ["<C-h>"]   = { "actions.select", opts = { horizontal = true } },
      ["<C-t>"]   = { "actions.select", opts = { tab = true } },
      ["<C-p>"]   = "actions.preview",
      ["<C-c>"]   = { "actions.close", mode = "n" },
      ["<C-l>"]   = "actions.refresh",
      ["-"]       = { "actions.parent", mode = "n" },
      ["_"]       = { "actions.open_cwd", mode = "n" },
      ["`"]       = { "actions.cd", mode = "n" },
      ["~"]       = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
      ["gs"]      = { "actions.change_sort", mode = "n" },
      ["gx"]      = "actions.open_external",
      ["g."]      = { "actions.toggle_hidden", mode = "n" },
      ["g\\"]     = { "actions.toggle_trash", mode = "n" },
      ["q"]       = { "actions.close", mode = "n" },
    },
    use_default_keymaps = false,
  },
}
