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
      local map = function(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end
      map({ "n", "v" }, "<leader>h", "<Nop>", "Git hunks (gitsigns)")
      map("n", "]h", gs.next_hunk, "Next hunk")
      map("n", "[h", gs.prev_hunk, "Previous hunk")
      map("n", "<leader>hn", gs.next_hunk, "Git hunk: next")
      map("n", "<leader>hN", gs.prev_hunk, "Git hunk: previous")
      map("n", "<leader>hp", gs.preview_hunk, "Git hunk: preview")
      map("n", "<leader>hs", gs.stage_hunk, "Git hunk: stage")
      map("n", "<leader>hr", gs.reset_hunk, "Git hunk: reset")
      map("n", "<leader>hu", gs.undo_stage_hunk, "Git hunk: undo stage")
      map("n", "<leader>hS", gs.stage_buffer, "Git hunk: stage buffer")
      map("n", "<leader>hR", gs.reset_buffer, "Git hunk: reset buffer")
      map("n", "<leader>hb", gs.blame_line, "Git hunk: blame line")
      map("n", "<leader>hB", function() gs.blame_line({ full = true }) end, "Git hunk: blame line (full)")
      map("n", "<leader>hd", gs.diffthis, "Git hunk: diff this")
      map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Git hunk: stage selection")
      map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Git hunk: reset selection")
    end,
  },
}
