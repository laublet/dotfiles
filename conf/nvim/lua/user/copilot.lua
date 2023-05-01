-- OPTIONS FOR COPILOT.LUA (https://github.com/zbirenbaum/copilot.lua)

-- Default setup with panel & suggestion disabled for cpm completion
-- See https://github.com/zbirenbaum/copilot-cmp
local cmp_status_ok, copilot = pcall(require, "copilot")
if not cmp_status_ok then
  return
end

require('copilot').setup({
  panel = {
    enabled = false,
    auto_refresh = false,
    keymap = {
      jump_prev = "[[",
      jump_next = "]]",
      accept = "<CR>",
      refresh = "gr",
      open = "<M-CR>"
    },
    layout = {
      position = "bottom", -- | top | left | right
      ratio = 0.4
    },
  },
  suggestion = {
    enabled = false,
    auto_trigger = false,
    debounce = 75,
    keymap = {
      accept = "<M-l>",
      accept_word = false,
      accept_line = false,
      next = "<M-]>",
      prev = "<M-[>",
      dismiss = "<C-]>",
    },
  },
  filetypes = {
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = 'node', -- Node.js version must be > 16.x
  server_opts_overrides = {},
})

--[[ copilot.setup { ]]
--[[   cmp = { ]]
--[[     enabled = true, ]]
--[[     method = "getCompletionsCycling", ]]
--[[   }, ]]
--[[   panel = { -- no config options yet ]]
--[[     enabled = true, ]]
--[[   }, ]]
--[[   ft_disable = { "markdown" }, ]]
--[[   -- plugin_manager_path = vim.fn.stdpath "data" .. "/site/pack/packer", ]]
--[[   server_opts_overrides = { ]]
--[[     -- trace = "verbose", ]]
--[[     settings = { ]]
--[[       advanced = { ]]
--[[         -- listCount = 10, -- #completions for panel ]]
--[[         inlineSuggestCount = 3, -- #completions for getCompletions ]]
--[[       }, ]]
--[[     }, ]]
--[[   }, ]]
--[[ } ]]

-- COPILOT CMP OPTIONS
--[[ require("copilot_cmp").setup( ]]
--[[ { ]]
--[[   formatters = { ]]
--[[     label = require("copilot_cmp.format").format_label_text, ]]
--[[     insert_text = require("copilot_cmp.format").format_insert_text, ]]
--[[     preview = require("copilot_cmp.format").deindent, ]]
--[[   }, ]]
--[[ }) ]]
