-- https://github.com/lewis6991/gitsigns.nvim

return {
  "lewis6991/gitsigns.nvim",
  cond = not vim.g.vscode,
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local lr = require("utils.leader_repeat").wrap
      local map = function(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end
      map({ "n", "v" }, "<leader>h", "<Nop>", "Git hunks (gitsigns)")
      -- ]c / [c: gitsigns jumps; `;` / `,` repeat (diff buffers use vim's ]c / [c)
      vim.keymap.set("n", "]c", function()
        if vim.wo.diff then
          return "]c"
        end
        gs.next_hunk()
      end, { buffer = bufnr, expr = true, desc = "Git hunk: next (repeat with ;)" })
      vim.keymap.set("n", "[c", function()
        if vim.wo.diff then
          return "[c"
        end
        gs.prev_hunk()
      end, { buffer = bufnr, expr = true, desc = "Git hunk: prev (repeat with ,)" })
      map("n", "]h", gs.next_hunk, "Next hunk")
      map("n", "[h", gs.prev_hunk, "Previous hunk")
      map("n", "<leader>hn", lr(gs.next_hunk, "Git hunk: next"), "Git hunk: next")
      map("n", "<leader>hN", lr(gs.prev_hunk, "Git hunk: prev"), "Git hunk: previous")
      map("n", "<leader>hp", lr(gs.preview_hunk, "Git hunk: preview"), "Git hunk: preview")
      map("n", "<leader>hs", lr(gs.stage_hunk, "Git hunk: stage"), "Git hunk: stage")
      map("n", "<leader>hr", lr(gs.reset_hunk, "Git hunk: reset"), "Git hunk: reset")
      map("n", "<leader>hu", lr(gs.undo_stage_hunk, "Git hunk: undo stage"), "Git hunk: undo stage")
      map("n", "<leader>hS", lr(gs.stage_buffer, "Git hunk: stage buffer"), "Git hunk: stage buffer")
      map("n", "<leader>hR", lr(gs.reset_buffer, "Git hunk: reset buffer"), "Git hunk: reset buffer")
      map("n", "<leader>hb", lr(gs.blame_line, "Git hunk: blame line"), "Git hunk: blame line")
      map("n", "<leader>hB", lr(function() gs.blame_line({ full = true }) end, "Git hunk: blame full"), "Git hunk: blame line (full)")
      map("n", "<leader>hd", lr(gs.diffthis, "Git hunk: diff this"), "Git hunk: diff this")
      map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Git hunk: stage selection")
      map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Git hunk: reset selection")
    end,
  },
}
