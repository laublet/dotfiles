-- https://github.com/ThePrimeagen/harpoon (branch harpoon2)
-- Pin a small set of project files; jump without growing the buffer list.

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  cond = not vim.g.vscode,
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = (function()
    local keys = {
      {
        "<leader>ma",
        function()
          require("harpoon"):list():add()
          vim.notify("Harpoon: file added", vim.log.levels.INFO)
        end,
        desc = "Harpoon: add file",
      },
      {
        "<leader>mm",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon: toggle menu",
      },
      {
        "<leader>mn",
        function()
          require("harpoon"):list():next()
        end,
        desc = "Harpoon: next mark",
      },
      {
        "<leader>mp",
        function()
          require("harpoon"):list():prev()
        end,
        desc = "Harpoon: prev mark",
      },
    }
    for i = 1, 9 do
      keys[#keys + 1] = {
        "<leader>" .. i,
        function()
          require("harpoon"):list():select(i)
        end,
        desc = "Harpoon: slot " .. i,
      }
    end
    return keys
  end)(),
  config = function()
    local harpoon = require("harpoon")
    local extensions = require("harpoon.extensions")

    harpoon:setup({
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
      menu = {
        width = math.min(80, vim.api.nvim_win_get_width(0) - 4),
      },
    })

    harpoon:extend(extensions.builtins.highlight_current_file())

    harpoon:extend({
      UI_CREATE = function(cx)
        vim.keymap.set("n", "<C-v>", function()
          harpoon.ui:select_menu_item({ vsplit = true })
        end, { buffer = cx.bufnr, desc = "Harpoon menu: vertical split" })
        vim.keymap.set("n", "<C-x>", function()
          harpoon.ui:select_menu_item({ split = true })
        end, { buffer = cx.bufnr, desc = "Harpoon menu: horizontal split" })
        vim.keymap.set("n", "<C-t>", function()
          harpoon.ui:select_menu_item({ tabedit = true })
        end, { buffer = cx.bufnr, desc = "Harpoon menu: tab" })
      end,
    })
  end,
}
