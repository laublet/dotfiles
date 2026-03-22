-- =============================================================================
-- smart-splits.nvim — seamless Neovim ↔ WezTerm split navigation
-- =============================================================================
-- Ctrl+arrows       = move between splits (Neovim ↔ WezTerm)
-- Ctrl+Alt+arrows   = resize splits (adjacent modifiers on Kyria)
--
-- Cross-boundary nav uses user var signaling (no wezterm cli subprocess).
-- When Neovim is at edge, it sets SMART_SPLITS_MOVE=<direction> via escape
-- sequence. WezTerm reacts to user-var-changed and switches panes instantly.
-- IS_NVIM is managed manually since we disable multiplexer_integration.
-- =============================================================================

return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  cond = not vim.g.vscode,
  -- Set BEFORE plugin loads to prevent WezTerm auto-detection and mux caching
  init = function()
    vim.g.smart_splits_multiplexer_integration = false
  end,
  config = function()
    -- Clear any cached mux module (belt and suspenders)
    require("smart-splits.mux").__mux = nil

    -- Manually manage IS_NVIM user var (normally done by mux.wezterm.on_init,
    -- but we disable multiplexer_integration to avoid slow wezterm cli calls)
    local function set_user_var(name, val)
      io.write(string.format("\x1b]1337;SetUserVar=%s=%s\x07", name, vim.base64.encode(val)))
      io.flush()
    end
    set_user_var("IS_NVIM", "true")
    vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
      callback = function() set_user_var("IS_NVIM", "false") end,
    })
    vim.api.nvim_create_autocmd("VimResume", {
      callback = function() set_user_var("IS_NVIM", "true") end,
    })

    require("smart-splits").setup({
      ignored_filetypes = { "nofile", "quickfix", "prompt" },
      ignored_buftypes = { "NvimTree" },
      default_amount = 3,
      multiplexer_integration = false,
      at_edge = function(ctx)
        set_user_var("SMART_SPLITS_MOVE", ctx.direction)
      end,
    })
  end,
  keys = {
    { "<C-Left>",  function() require("smart-splits").move_cursor_left() end,  mode = { "n", "i", "v" }, desc = "Move to left split" },
    { "<C-Down>",  function() require("smart-splits").move_cursor_down() end,  mode = { "n", "i", "v" }, desc = "Move to below split" },
    { "<C-Up>",    function() require("smart-splits").move_cursor_up() end,    mode = { "n", "i", "v" }, desc = "Move to above split" },
    { "<C-Right>", function() require("smart-splits").move_cursor_right() end, mode = { "n", "i", "v" }, desc = "Move to right split" },

    { "<C-A-Left>",  function() require("smart-splits").resize_left() end,  mode = { "n", "i", "v" }, desc = "Resize left" },
    { "<C-A-Down>",  function() require("smart-splits").resize_down() end,  mode = { "n", "i", "v" }, desc = "Resize down" },
    { "<C-A-Up>",    function() require("smart-splits").resize_up() end,    mode = { "n", "i", "v" }, desc = "Resize up" },
    { "<C-A-Right>", function() require("smart-splits").resize_right() end, mode = { "n", "i", "v" }, desc = "Resize right" },
  },
}
