-- =============================================================================
-- mini.surround — add/delete/change surroundings (brackets, quotes, tags)
-- =============================================================================
-- sa = add surrounding       (e.g. saiw" → surround inner word with ")
-- sd = delete surrounding    (e.g. sd"   → delete surrounding ")
-- sr = replace surrounding   (e.g. sr"'  → replace " with ')
-- =============================================================================

return {
  "echasnovski/mini.surround",
  version = "*",
  -- Works in both VSCode and standalone
  opts = {
    -- Use sa/sd/sr instead of default sa/sd/sr (same defaults actually)
    mappings = {
      add = "sa",
      delete = "sd",
      replace = "sr",
      find = "",           -- disable (not useful enough)
      find_left = "",      -- disable
      highlight = "",      -- disable
      update_n_lines = "", -- disable
    },
  },
}
