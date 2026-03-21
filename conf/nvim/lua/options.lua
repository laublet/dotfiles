-- =============================================================================
-- Options
-- =============================================================================

local opt = vim.opt

-- General
opt.backup = false
opt.swapfile = false
opt.writebackup = false
opt.undofile = true
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.fileencoding = "utf-8"
opt.updatetime = 300
opt.timeoutlen = 300

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
  opt.cursorcolumn = true
  -- Block in normal/visual; bar in insert (terminal); VSCode UI ignores this
  opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
  opt.signcolumn = "yes"
  opt.showmode = false
  opt.cmdheight = 1
  opt.pumheight = 10
  opt.conceallevel = 0
  opt.numberwidth = 4
  opt.autoread = true
  vim.cmd([[set whichwrap+=<,>,[,],h,l]])
end
