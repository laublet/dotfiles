-- =============================================================================
-- Keymaps
-- =============================================================================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Space as leader (already set in init.lua, but remap to Nop to avoid ghost inputs)
map("", "<Space>", "<Nop>", opts)

-- =============================================================================
-- Shared keymaps (work in both VSCode and standalone)
-- =============================================================================

-- Y yanks to end of line (like D and C)
map("n", "Y", "y$", opts)

-- Visual: keep selection after indent
map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

-- Visual block: move text up/down
map("x", "J", ":move '>+1<CR>gv-gv", opts)
map("x", "K", ":move '<-2<CR>gv-gv", opts)

-- Buffer navigation
map("n", "<S-h>", ":bprevious<CR>", opts)
map("n", "<S-l>", ":bnext<CR>", opts)

-- =============================================================================
-- VSCode-specific keymaps (via vscode-neovim)
-- =============================================================================

if vim.g.vscode then
  local vscode = require("vscode")

  -- LSP navigation
  map("n", "gd", function() vscode.action("editor.action.revealDefinition") end, opts)
  map("n", "gi", function() vscode.action("editor.action.goToImplementation") end, opts)
  map("n", "gr", function() vscode.action("editor.action.goToReferences") end, opts)
  map("n", "gh", function() vscode.action("editor.action.showHover") end, opts)

  -- Leader layer — files & navigation
  map("n", "<leader>f", function() vscode.action("workbench.action.quickOpen") end, opts)
  map("n", "<leader>g", function() vscode.action("workbench.action.findInFiles") end, opts)
  map("n", "<leader>b", function() vscode.action("workbench.action.showAllEditorsByMostRecentlyUsed") end, opts)
  map("n", "<leader>e", function() vscode.action("workbench.action.toggleSidebarVisibility") end, opts)

  -- Leader layer — actions
  map("n", "<leader>w", function() vscode.action("workbench.action.files.save") end, opts)
  map("n", "<leader>q", function() vscode.action("workbench.action.closeActiveEditor") end, opts)
  map("n", "<leader>t", function() vscode.action("workbench.action.terminal.toggleTerminal") end, opts)
  map("n", "<leader>z", function() vscode.action("workbench.action.toggleZenMode") end, opts)

  -- Leader layer — zones
  map("n", "<leader>v", function() vscode.action("workbench.view.scm") end, opts)
  map("n", "<leader>c", function() vscode.action("workbench.action.chat.open") end, opts)
  map("n", "<leader>d", function() vscode.action("workbench.view.debug") end, opts)

-- =============================================================================
-- Standalone Neovim keymaps
-- =============================================================================

else
  -- Save
  map("n", "<C-s>", ":w<CR>", opts)
  map("n", "<leader>w", ":w!<CR>", opts)
  -- Close buffer
  map("n", "<leader>q", ":bd<CR>", opts)

  -- Split creation (| = vertical line, - = horizontal line)
  map("n", "<leader>|", ":vsplit<CR>", { desc = "Vertical split" })
  map("n", "<leader>-", ":split<CR>", { desc = "Horizontal split" })
  map("n", "<leader>x", "<C-w>q", { desc = "Close split" })

  -- Zoom toggle (maximize current split / restore original sizes)
  local saved_layout = nil
  map("n", "<leader>z", function()
    if saved_layout then
      vim.cmd(saved_layout)
      saved_layout = nil
    else
      saved_layout = vim.fn.winrestcmd()
      vim.cmd("wincmd |")
      vim.cmd("wincmd _")
    end
  end, { desc = "Zoom toggle" })

  -- Split navigation — handled by smart-splits (Ctrl+arrows)
  -- File tree, fuzzy finder, LSP, git hunks → see lua/plugins/*.lua keys specs

  -- Terminal navigation (when inside :terminal)
  map("t", "<C-Left>",  [[<C-\><C-N><C-w>h]], opts)
  map("t", "<C-Down>",  [[<C-\><C-N><C-w>j]], opts)
  map("t", "<C-Up>",    [[<C-\><C-N><C-w>k]], opts)
  map("t", "<C-Right>", [[<C-\><C-N><C-w>l]], opts)

  -- Floating terminal toggle
  local term_buf, term_win
  local function toggle_terminal()
    if term_win and vim.api.nvim_win_is_valid(term_win) then
      vim.api.nvim_win_close(term_win, true)
      term_win = nil
      return
    end
    if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
      term_buf = vim.api.nvim_create_buf(false, true)
    end
    local w = math.floor(vim.o.columns * 0.8)
    local h = math.floor(vim.o.lines * 0.8)
    term_win = vim.api.nvim_open_win(term_buf, true, {
      relative = "editor",
      width = w,
      height = h,
      col = math.floor((vim.o.columns - w) / 2),
      row = math.floor((vim.o.lines - h) / 2),
      style = "minimal",
      border = "rounded",
    })
    if vim.bo[term_buf].buftype ~= "terminal" then
      vim.fn.termopen(vim.o.shell)
    end
    vim.cmd("startinsert")
  end
  map("n", "<leader>t", toggle_terminal, { desc = "Toggle terminal" })
  map("t", "<C-\\>", toggle_terminal, { desc = "Toggle terminal" })

  -- Lazygit in floating window
  map("n", "<leader>lg", function()
    local buf = vim.api.nvim_create_buf(false, true)
    local w = math.floor(vim.o.columns * 0.9)
    local h = math.floor(vim.o.lines * 0.9)
    local win = vim.api.nvim_open_win(buf, true, {
      relative = "editor",
      width = w,
      height = h,
      col = math.floor((vim.o.columns - w) / 2),
      row = math.floor((vim.o.lines - h) / 2),
      style = "minimal",
      border = "rounded",
    })
    vim.fn.termopen("lazygit", {
      on_exit = function()
        if vim.api.nvim_win_is_valid(win) then vim.api.nvim_win_close(win, true) end
        if vim.api.nvim_buf_is_valid(buf) then vim.api.nvim_buf_delete(buf, { force = true }) end
      end,
    })
    vim.cmd("startinsert")
  end, { desc = "Lazygit" })
end
