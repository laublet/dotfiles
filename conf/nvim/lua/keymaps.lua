-- https://neovim.io/doc/user/map.html
-- =============================================================================
-- Keymaps
-- =============================================================================

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Space as leader: Nop in normal/visual only (not insert — would steal Space or add latency).
map({ "n", "v", "x", "s", "o" }, "<Space>", "<Nop>", opts)

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

-- Buffer navigation (bufferline tabs)
map("n", "<C-Tab>", ":bnext<CR>", opts)
map("n", "<C-S-Tab>", ":bprevious<CR>", opts)
-- Terminal fallback: Ctrl+Tab is translated to Ctrl+PageDown/PageUp in WezTerm
map("n", "<C-PageDown>", ":bnext<CR>", opts)
map("n", "<C-PageUp>", ":bprevious<CR>", opts)

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

  -- Leader layer — files & navigation (align with Neovim: pp = quick open, like Cmd+P)
  map("n", "<C-p>", function() vscode.action("workbench.action.quickOpen") end, opts)
  map("n", "<leader>pp", function() vscode.action("workbench.action.quickOpen") end, opts)
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
  -- Clear search highlight — not <leader>c (neotest prefix ct/cf/…)
  map("n", "<leader>nh", ":noh<CR>", { desc = "Clear search highlight" })

  local function yank_path(text)
    if text == "" then
      vim.notify("Not a file on disk", vim.log.levels.WARN)
      return
    end
    vim.fn.setreg("+", text)
    vim.notify(text, vim.log.levels.INFO, { title = "Yanked path" })
  end
  map("n", "<leader>yp", function()
    yank_path(vim.fn.expand("%:p"))
  end, { desc = "Yank absolute file path" })
  map("n", "<leader>yr", function()
    yank_path(vim.fn.expand("%:."))
  end, { desc = "Yank relative file path (from cwd)" })

  map("n", "<leader>Uk", function()
    require("utils.keylog").toggle()
  end, { desc = "Toggle keystroke log (analysis)" })

  -- Save
  map("n", "<C-s>", ":w<CR>", opts)
  map("n", "<leader>w", ":w!<CR>", opts)
  -- Close buffer while keeping the window/split alive: switch to the previous
  -- buffer first, then delete the original. Without this, `:bd` closes the
  -- window too (annoying when a split layout is set up).
  map("n", "<leader>q", function()
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].modified then
      vim.notify("Buffer has unsaved changes (use :bd! to force)", vim.log.levels.WARN)
      return
    end
    vim.cmd("bprevious")
    if vim.api.nvim_buf_is_valid(buf) then
      pcall(vim.api.nvim_buf_delete, buf, { force = false })
    end
  end, { desc = "Close buffer (keep window)" })
  map("n", "<leader>Q", ":bd!<CR>", { desc = "Close buffer + window (force)" })

  -- Split creation (| = vertical line, - = horizontal line)
  map("n", "<leader>|", ":vsplit<CR>", { desc = "Vertical split" })
  map("n", "<leader>-", ":split<CR>", { desc = "Horizontal split" })
  map("n", "<leader>x", "<C-w>q", { desc = "Close split" })

  -- Tab pages (<leader>t = terminal; T = tabpage). Tn/Tp = next/prev; TN = new (rare).
  map("n", "<leader>Tn", ":tabnext<CR>", { desc = "Tab next" })
  map("n", "<leader>Tp", ":tabprevious<CR>", { desc = "Tab previous" })
  map("n", "<leader>TN", ":tabnew<CR>", { desc = "New tab" })
  map("n", "<leader>Tc", ":tabclose<CR>", { desc = "Close tab" })
  map("n", "<leader>To", ":tabonly<CR>", { desc = "Close other tabs" })

  -- Stuck float / fzf after pane switch: refocus (force) or close all floats.
  -- Not mapped in insert: leader is Space, so <leader>U* in insert would delay every Space by timeoutlen.
  local float = require("utils.float")
  map({ "n", "t" }, "<leader>Ur", function()
    float.refocus({ force = true })
  end, { desc = "Refocus float UI (fzf, which-key, …)" })
  map({ "n", "t" }, "<leader>Ux", function()
    float.close_all_floats()
  end, { desc = "Close all floating windows (escape hatch)" })
  map("i", "<M-Esc>", function()
    float.close_all_floats()
  end, { desc = "Close all floating windows (insert, no leader)" })

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
  map("n", "<leader>t", toggle_terminal, { desc = "Toggle floating terminal" })
  map("t", "<C-\\>", toggle_terminal, { desc = "Toggle floating terminal" })

  -- Bottom-split terminal toggle (persistent buffer, same shell across toggles).
  -- Differs from the floating one above: stays visible while you code, takes a
  -- horizontal slice at the bottom (uses `splitbelow = true` from options.lua).
  local bterm_buf, bterm_win
  local function toggle_bottom_terminal()
    if bterm_win and vim.api.nvim_win_is_valid(bterm_win) then
      vim.api.nvim_win_close(bterm_win, true)
      bterm_win = nil
      return
    end
    if not bterm_buf or not vim.api.nvim_buf_is_valid(bterm_buf) then
      bterm_buf = vim.api.nvim_create_buf(false, true)
    end
    vim.cmd("botright " .. math.floor(vim.o.lines * 0.3) .. "split")
    bterm_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(bterm_win, bterm_buf)
    if vim.bo[bterm_buf].buftype ~= "terminal" then
      vim.fn.termopen(vim.o.shell)
    end
    vim.cmd("startinsert")
  end
  -- <leader>; for bottom terminal: avoids the <leader>T group conflict with tab
  -- pages (<leader>Tn/Tc/To). Mnemonic: ; sits on the home row, mirrors the
  -- statusline position visually (bottom edge).
  map("n", "<leader>;", toggle_bottom_terminal, { desc = "Toggle bottom terminal (split)" })

  -- cursor-agent in a vertical split on the right (raw CLI TUI). Complements
  -- Avante (<leader>at / aa) which uses the same binary via ACP with a sidebar UI.
  local cursor_agent_buf, cursor_agent_win
  local cursor_agent_cmd = (os.getenv("HOME") or "") .. "/.local/bin/cursor-agent"
  local function toggle_cursor_agent_split()
    if cursor_agent_win and vim.api.nvim_win_is_valid(cursor_agent_win) then
      vim.api.nvim_win_close(cursor_agent_win, true)
      cursor_agent_win = nil
      return
    end
    if vim.fn.executable(cursor_agent_cmd) ~= 1 then
      vim.notify("cursor-agent not found at " .. cursor_agent_cmd, vim.log.levels.ERROR)
      return
    end
    if not cursor_agent_buf or not vim.api.nvim_buf_is_valid(cursor_agent_buf) then
      cursor_agent_buf = vim.api.nvim_create_buf(false, true)
    end
    vim.cmd("vsplit")
    cursor_agent_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(cursor_agent_win, cursor_agent_buf)
    vim.cmd("vertical resize " .. math.floor(vim.o.columns * 0.42))
    if vim.bo[cursor_agent_buf].buftype ~= "terminal" then
      vim.fn.termopen(cursor_agent_cmd, { cwd = vim.fn.getcwd() })
    end
    vim.cmd("startinsert")
  end
  map("n", "<leader>ac", toggle_cursor_agent_split, { desc = "Toggle cursor-agent (vsplit right)" })

  -- Fluid one-key exit from ANY terminal (floating, bottom split, cursor-agent).
  -- <C-q> chosen because:
  --   - <C-t> is widely used by fzf-lua / oil (open-in-new-tab action)
  --   - <C-\> is awkward on the user's Kyria layout
  --   - Q = Quit is mnemonic, and <C-q> is unused in normal mode workflows
  local function close_active_terminal()
    local cur_win = vim.api.nvim_get_current_win()
    if term_win and vim.api.nvim_win_is_valid(term_win) and cur_win == term_win then
      toggle_terminal()
    elseif bterm_win and vim.api.nvim_win_is_valid(bterm_win) and cur_win == bterm_win then
      toggle_bottom_terminal()
    elseif cursor_agent_win and vim.api.nvim_win_is_valid(cursor_agent_win) and cur_win == cursor_agent_win then
      toggle_cursor_agent_split()
    else
      vim.cmd([[stopinsert]])
      pcall(vim.api.nvim_win_close, cur_win, false)
    end
  end
  map("t", "<C-q>", close_active_terminal, { desc = "Close active terminal" })
  map("n", "<C-q>", close_active_terminal, { desc = "Close active terminal" })

  -- Easy exit from terminal-insert mode WITHOUT closing the window: Esc Esc
  -- → normal mode (then you can scroll, copy, use :q, switch splits…). Single
  -- Esc stays untouched so it still reaches TUIs (htop, fzf, vim inside term).
  map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal-insert mode" })

  -- Git: <leader>g* prefix handled in lua/plugins/neogit.lua (status, commit,
  -- log, diffview) and lua/plugins/fzf-lua.lua (branches, commits, files).
end
