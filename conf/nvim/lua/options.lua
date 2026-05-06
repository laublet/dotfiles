-- https://neovim.io/doc/user/options.html
-- =============================================================================
-- Options
-- =============================================================================

local opt = vim.opt

-- General
opt.hidden = true
opt.backup = false
opt.swapfile = false
opt.writebackup = false
opt.undofile = true
opt.clipboard = "unnamedplus"
-- In SSH sessions (e.g. homeserver), the remote system clipboard is unreachable.
-- Use OSC 52: nvim emits an escape sequence, the local terminal (WezTerm, iTerm2, …)
-- writes it into the host clipboard. Requires terminal support for OSC 52 read/write.
if vim.env.SSH_TTY ~= nil then
  local osc52 = require("vim.ui.clipboard.osc52")
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = osc52.paste("+"),
      ["*"] = osc52.paste("*"),
    },
  }
end
opt.mouse = "a"
opt.fileencoding = "utf-8"
opt.updatetime = 300
opt.timeoutlen = 300
opt.ttimeoutlen = 5

-- Search
opt.hlsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Indent
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true

-- Splits
opt.splitbelow = true
opt.splitright = true

-- Wrapping
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Misc
opt.shortmess:append("c")
vim.cmd([[set iskeyword+=-]])
vim.cmd([[set formatoptions-=cro]])

-- Options only relevant in standalone Neovim (not VSCode)
if not vim.g.vscode then
  opt.termguicolors = true
  opt.number = true
  opt.relativenumber = true
  opt.cursorline = true
  -- Block in normal/visual; bar in insert (terminal); VSCode UI ignores this
  opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
  opt.signcolumn = "yes"
  opt.showmode = false
  opt.cmdheight = 1
  opt.pumheight = 10
  opt.conceallevel = 2
  opt.numberwidth = 4
  opt.autoread = true
  vim.cmd([[set whichwrap+=<,>,[,],h,l]])

  -- Auto-reload files changed outside Neovim (e.g. by Cursor, git, etc.)
  vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold" }, {
    callback = function()
      if vim.fn.getcmdwintype() == "" then
        vim.cmd("checktime")
      end
    end,
  })

  -- After switching WezTerm panes (or another app), terminal focus events move the
  -- cursor to the buffer under a float; the picker (fzf-lua, which-key, …) stays
  -- visible but no longer receives keys. Refocus the right floating window.
  local float = require("utils.float")
  vim.api.nvim_create_autocmd("FocusGained", {
    callback = function()
      if vim.fn.getcmdwintype() == "" then
        vim.cmd("checktime")
      end
      vim.schedule(function()
        float.refocus({ force = false })
      end)
    end,
  })

  -- Force conceallevel for markdown (some ftplugins reset it to 0)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown",
    callback = function()
      vim.opt_local.conceallevel = 2
    end,
  })
end
