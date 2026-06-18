-- https://github.com/hrsh7th/nvim-cmp

return {
  "hrsh7th/nvim-cmp",
  cond = not vim.g.vscode,
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "rafamadriz/friendly-snippets",
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    require("luasnip.loaders.from_vscode").lazy_load()

    ---@return avante.Suggestion|nil
    local function avante_suggestion()
      local ok, api = pcall(require, "avante.api")
      if not ok then
        return nil
      end
      return api.get_suggestion()
    end

    cmp.setup({
      snippet = {
        expand = function(args) luasnip.lsp_expand(args.body) end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          local sg = avante_suggestion()
          if sg and sg:is_visible() then
            sg:accept()
            return
          end
          local ok, sm = pcall(require, "supermaven-nvim.completion_preview")
          if ok and sm.has_suggestion() then
            sm.on_accept_suggestion()
          elseif cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          local sg = avante_suggestion()
          if sg and sg:is_visible() then
            sg:prev()
            return
          end
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-e>"] = cmp.mapping.abort(),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "path" },
      }, {
        { name = "buffer" },
      }),
    })
  end,
}
