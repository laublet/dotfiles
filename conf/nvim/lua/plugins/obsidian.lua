-- https://github.com/epwalsh/obsidian.nvim

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
      { name = "main", path = "~/dev/perso/vaults/Main" },
      { name = "research", path = "~/dev/perso/vaults/Research", notes_subdir = "Notes", new_notes_location = "notes_subdir" },
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
    { "<leader>nf", "<cmd>ObsidianQuickSwitch<CR>", desc = "Obsidian: find note" },
    { "<leader>nd", "<cmd>ObsidianToday<CR>",       desc = "Obsidian: daily note" },
    { "<leader>nn", "<cmd>ObsidianNew<CR>",          desc = "Obsidian: new note" },
    { "<leader>nb", "<cmd>ObsidianBacklinks<CR>",    desc = "Obsidian: backlinks" },
    { "<leader>ns", "<cmd>ObsidianSearch<CR>",       desc = "Obsidian: search text" },
    { "<leader>nt", "<cmd>ObsidianTags<CR>",         desc = "Obsidian: tags" },
    { "<leader>nl", "<cmd>ObsidianLinks<CR>",        desc = "Obsidian: links in note" },
    { "<leader>nw", "<cmd>ObsidianWorkspace research<CR>", desc = "Obsidian: Research vault" },
    { "<leader>no", "<cmd>ObsidianWorkspace main<CR>",    desc = "Obsidian: Main vault" },

    { "gd",         "<cmd>ObsidianFollowLink<CR>",   desc = "Obsidian: follow link", ft = "markdown" },
  },
}
