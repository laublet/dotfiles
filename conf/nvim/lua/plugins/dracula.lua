-- https://github.com/Mofiqul/dracula.nvim
-- =============================================================================
-- Dracula colorscheme — standalone Neovim only
-- =============================================================================

return {
  "Mofiqul/dracula.nvim",
  cond = not vim.g.vscode,
  lazy = false,
  priority = 1000,
  config = function()
    local dracula = require("dracula")
    local cross_bg = "#313442"
    local wk_float_bg = "#3d4060"

    local function which_key_hl(colors)
      return {
        WhichKeyNormal = { bg = wk_float_bg },
        WhichKeyBorder = { fg = colors.purple },
        WhichKeyTitle = { fg = colors.yellow, bold = true },
        WhichKey = { fg = colors.pink, bold = true },
        WhichKeyGroup = { fg = colors.purple, bold = true },
        WhichKeyDesc = { fg = colors.fg },
        WhichKeySeparator = { fg = colors.cyan },
      }
    end

    dracula.setup({
      overrides = function(colors)
        return vim.tbl_extend("force", which_key_hl(colors), {
          -- Crosshair: Dracula defaults differ (line = selection, column = black).
          CursorLine = { bg = cross_bg },
          CursorColumn = { bg = cross_bg },
          CursorLineSign = { bg = "NONE" },
          CursorLineFold = { bg = "NONE" },
          CursorLineNr = { fg = colors.fg, bold = true },
          -- Markdown headings: Dracula palette gradient instead of full-line green
          ["@markup.heading.1.markdown"] = { fg = colors.purple, bold = true },
          ["@markup.heading.2.markdown"] = { fg = colors.pink, bold = true },
          ["@markup.heading.3.markdown"] = { fg = colors.cyan, bold = true },
          ["@markup.heading.4.markdown"] = { fg = colors.orange, bold = true },
          ["@markup.heading.5.markdown"] = { fg = colors.yellow, bold = true },
          ["@markup.heading.6.markdown"] = { fg = colors.fg, bold = true },
          -- Also override legacy highlight groups (used by some parsers)
          markdownH1 = { fg = colors.purple, bold = true },
          markdownH2 = { fg = colors.pink, bold = true },
          markdownH3 = { fg = colors.cyan, bold = true },
          markdownH4 = { fg = colors.orange, bold = true },
          markdownH5 = { fg = colors.yellow, bold = true },
          markdownH6 = { fg = colors.fg, bold = true },
          -- Remove the green background on heading content
          ["@markup.heading"] = { fg = colors.purple, bold = true },
          markdownH1Delimiter = { fg = colors.purple, bold = true },
          markdownH2Delimiter = { fg = colors.pink, bold = true },
          markdownH3Delimiter = { fg = colors.cyan, bold = true },
          markdownH4Delimiter = { fg = colors.orange, bold = true },
          markdownH5Delimiter = { fg = colors.pink, bold = true },
          markdownH6Delimiter = { fg = colors.fg, bold = true },
        })
      end,
    })
    vim.cmd.colorscheme("dracula")

    -- Force link highlights after everything loads (obsidian.nvim / render-markdown can override)
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        local c = require("dracula.palette")
        vim.api.nvim_set_hl(0, "CursorLine", { bg = cross_bg })
        vim.api.nvim_set_hl(0, "CursorColumn", { bg = cross_bg })
        vim.api.nvim_set_hl(0, "CursorLineSign", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "CursorLineFold", { bg = "NONE" })
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.fg, bold = true })

        local link_hl = { fg = c.cyan, bg = "NONE", underline = true }
        local groups = {
          "@markup.link", "@markup.link.label", "@markup.link.label.markdown_inline",
          "@markup.link.url", "markdownLink", "markdownLinkText", "markdownUrl",
          "markdownWikiLink", "ObsidianRefText", "ObsidianExtLinkText",
          "RenderMarkdownLink", "RenderMarkdownWikiLink",
        }
        for _, g in ipairs(groups) do
          vim.api.nvim_set_hl(0, g, link_hl)
        end
        for name, hl in pairs(which_key_hl(c)) do
          vim.api.nvim_set_hl(0, name, hl)
        end
      end,
    })
    -- Also apply now (ColorScheme event already fired)
    local c = require("dracula.palette")
    vim.api.nvim_set_hl(0, "CursorLine", { bg = cross_bg })
    vim.api.nvim_set_hl(0, "CursorColumn", { bg = cross_bg })
    vim.api.nvim_set_hl(0, "CursorLineSign", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "CursorLineFold", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = c.fg, bold = true })

    local link_hl = { fg = c.cyan, bg = "NONE", underline = true }
    local groups = {
      "@markup.link", "@markup.link.label", "@markup.link.label.markdown_inline",
      "@markup.link.url", "markdownLink", "markdownLinkText", "markdownUrl",
      "markdownWikiLink", "ObsidianRefText", "ObsidianExtLinkText",
      "RenderMarkdownLink", "RenderMarkdownWikiLink",
    }
    for _, g in ipairs(groups) do
      vim.api.nvim_set_hl(0, g, link_hl)
    end
    for name, hl in pairs(which_key_hl(c)) do
      vim.api.nvim_set_hl(0, name, hl)
    end
  end,
}
