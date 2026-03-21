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

-- =============================================================================
-- Standalone Neovim keymaps
-- =============================================================================

else
  -- Save
  map("n", "<C-s>", ":w<CR>", opts)
  map("n", "<leader>w", ":w!<CR>", opts)
  -- Close buffer
  map("n", "<leader>q", ":bd<CR>", opts)

  -- Split navigation — handled by smart-splits (Ctrl+arrows)
  -- See plugins/smart-splits.lua for the actual bindings

  -- Leader layer — standalone equivalents
  -- These will be expanded when we add telescope/fzf-lua later
  map("n", "<leader>e", ":Lex 30<CR>", opts)

  -- Terminal navigation (when inside :terminal)
  map("t", "<C-Left>",  [[<C-\><C-N><C-w>h]], opts)
  map("t", "<C-Down>",  [[<C-\><C-N><C-w>j]], opts)
  map("t", "<C-Up>",    [[<C-\><C-N><C-w>k]], opts)
  map("t", "<C-Right>", [[<C-\><C-N><C-w>l]], opts)
end
