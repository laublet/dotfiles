-- =============================================================================
-- Comment.nvim — toggle comments
-- =============================================================================
-- gcc = toggle line comment
-- gc  = toggle comment (visual mode / motion)
-- gbc = toggle block comment
-- =============================================================================

return {
  "numToStr/Comment.nvim",
  -- Works in both VSCode and standalone
  event = "VeryLazy",
  opts = {},
}
