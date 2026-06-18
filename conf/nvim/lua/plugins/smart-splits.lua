-- https://github.com/mrjones2014/smart-splits.nvim
-- =============================================================================
-- smart-splits.nvim — seamless Neovim ↔ terminal multiplexer splits
-- =============================================================================
-- Ctrl+arrows       = move between splits (Neovim ↔ WezTerm or Zellij)
-- Ctrl+Alt+arrows   = resize splits (adjacent modifiers on Kyria)
--
-- WezTerm: OSC user vars (zero-latency, no wezterm cli subprocess).
-- Zellij: vim-zellij-navigator WASM in conf/zellij/config.kdl.
-- multiplexer_integration omitted → plugin auto-detects (ZELLIJ env, TERM_PROGRAM, …).
-- =============================================================================

return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  cond = not vim.g.vscode,
  config = function()
    require("smart-splits.mux").__mux = nil

    local wezterm_dir = {
      left = "Left",
      right = "Right",
      up = "Up",
      down = "Down",
    }

    local function write_osc(var_name, value)
      local encoded = vim.base64.encode(value)
      local osc = string.format("\027]1337;SetUserVar=%s=%s\007", var_name, encoded)
      vim.fn["smart_splits#write_wezterm_var"](osc)
    end

    require("smart-splits").setup({
      ignored_filetypes = { "nofile", "quickfix", "prompt" },
      ignored_buftypes = { "NvimTree" },
      default_amount = 3,
      at_edge = function(ctx)
        local mux = require("smart-splits.mux").get()
        if not mux or mux.type ~= "wezterm" then
          return
        end
        local label = wezterm_dir[ctx.direction]
        if label then
          write_osc("SMART_SPLITS_MOVE", label)
        end
      end,
    })

    local mux = require("smart-splits.mux").get()
    if mux and mux.type == "wezterm" then
      -- Override to skip CLI call — always return true to trigger at_edge callback
      mux.current_pane_at_edge = function()
        return true
      end

      -- Override to send OSC instead of CLI call
      mux.resize_pane = function(direction, amount)
        local label = wezterm_dir[direction]
        if label then
          write_osc("SMART_SPLITS_RESIZE", string.format("%s:%d", label, amount or 3))
          return true
        end
        return false
      end

      if mux.on_init then
        mux.on_init()
        vim.api.nvim_create_autocmd("VimEnter", {
          once = true,
          callback = function()
            mux.on_init()
          end,
        })
        vim.api.nvim_create_autocmd("VimResume", {
          callback = function()
            mux.on_init()
          end,
        })
      end
      if mux.on_exit then
        vim.api.nvim_create_autocmd({ "VimSuspend", "VimLeavePre" }, {
          callback = function()
            mux.on_exit()
          end,
        })
      end
    end
  end,
  keys = {
    { "<C-Left>",  function() require("smart-splits").move_cursor_left() end,  mode = { "n", "i", "v", "c" }, desc = "Move to left split" },
    { "<C-Down>",  function() require("smart-splits").move_cursor_down() end,  mode = { "n", "i", "v", "c" }, desc = "Move to below split" },
    { "<C-Up>",    function() require("smart-splits").move_cursor_up() end,    mode = { "n", "i", "v", "c" }, desc = "Move to above split" },
    { "<C-Right>", function() require("smart-splits").move_cursor_right() end, mode = { "n", "i", "v", "c" }, desc = "Move to right split" },

    { "<C-A-Left>",  function() require("smart-splits").resize_left() end,  mode = { "n", "i", "v", "c" }, desc = "Resize left" },
    { "<C-A-Down>",  function() require("smart-splits").resize_down() end,  mode = { "n", "i", "v", "c" }, desc = "Resize down" },
    { "<C-A-Up>",    function() require("smart-splits").resize_up() end,    mode = { "n", "i", "v", "c" }, desc = "Resize up" },
    { "<C-A-Right>", function() require("smart-splits").resize_right() end, mode = { "n", "i", "v", "c" }, desc = "Resize right" },
  },
}
