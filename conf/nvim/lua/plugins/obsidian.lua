return {
  "epwalsh/obsidian.nvim",
  version = "*",
  cond = not vim.g.vscode,
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    workspaces = {
      { name = "main", path = "~/Documents/Main" },
    },
    daily_notes = {
      folder = "Daily",
      date_format = "%d-%m-%Y",
      template = "Daily template.md",
    },
    templates = {
      folder = "Templates",
      date_format = "%d-%m-%Y",
      time_format = "%H:%M",
    },
    notes_subdir = "0 - Main Notes",
    new_notes_location = "notes_subdir",
    completion = {
      nvim_cmp = true,
      min_chars = 2,
    },
    wiki_link_func = "use_alias_only",
    preferred_link_style = "wiki",
    follow_url_func = function(url)
      vim.fn.jobstart({ "open", url })
    end,
    -- UI handled by render-markdown.nvim — disable obsidian.nvim's own rendering
    ui = { enable = false },
  },
  keys = {
    { "<leader>of", "<cmd>ObsidianQuickSwitch<CR>", desc = "Obsidian: find note" },
    { "<leader>od", "<cmd>ObsidianToday<CR>",       desc = "Obsidian: daily note" },
    { "<leader>on", "<cmd>ObsidianNew<CR>",          desc = "Obsidian: new note" },
    { "<leader>ob", "<cmd>ObsidianBacklinks<CR>",    desc = "Obsidian: backlinks" },
    { "<leader>os", "<cmd>ObsidianSearch<CR>",       desc = "Obsidian: search text" },
    { "<leader>ot", "<cmd>ObsidianTags<CR>",         desc = "Obsidian: tags" },
    { "<leader>ol", "<cmd>ObsidianLinks<CR>",        desc = "Obsidian: links in note" },
    { "gd",         "<cmd>ObsidianFollowLink<CR>",   desc = "Obsidian: follow link", ft = "markdown" },
  },
}
