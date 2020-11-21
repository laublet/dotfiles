" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin()
""" Add to vim
"" Theme
Plug 'dracula/vim', { 'as': 'dracula' }
"" Status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
"" Ranger support
Plug 'kevinhwang91/rnvimr', {'do': 'make sync'}
"" Start screen
Plug 'mhinz/vim-startify'
"" See keys bindings with leader (spacew)
Plug 'liuchengxu/vim-which-key'
"" Floating terminal
Plug 'voldikss/vim-floaterm'
"" Scratch pad
Plug 'metakirby5/codi.vim'
"" Undo visual tree
Plug 'mbbill/undotree'
"" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" Icons must be last
Plug 'ryanoasis/vim-devicons'

" Visual
" Color parentheses
Plug 'luochen1990/rainbow'
" Show color in editor
Plug 'norcalli/nvim-colorizer.lua'
" Toggle indent visualisation
Plug 'nathanaelkane/vim-indent-guides'

""" IMPORTANTS
"" FZF (fuzzy search)
Plug 'junegunn/fzf.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"" COC - Intellisense and more
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"" Snippets
Plug 'honza/vim-snippets'
Plug 'sirver/ultisnips'
"" Tags
Plug 'majutsushi/tagbar'
" Tagbar alt (can be used with coc)
Plug 'liuchengxu/vista.vim'
"" Git
" Show git diff in column
Plug 'airblade/vim-gitgutter'
" Git support
Plug 'tpope/vim-fugitive'
" Find and replace multiples files
Plug 'brooth/far.vim'


""" Utils
" Delete whitespace on save
Plug 'ntpeters/vim-better-whitespace'
" Rename closing tags
Plug 'andrewradev/tagalong.vim'
" Editorconfig support
Plug 'editorconfig/editorconfig-vim'
" Prettier support
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
" Better comments
Plug 'tpope/vim-commentary'
" Repeat action from plugins
Plug 'tpope/vim-repeat'
" Autoclose with matching character
Plug 'townk/vim-autoclose'
" Surround
Plug 'tpope/vim-surround'
" ctrl-w & m to zoom split
Plug 'dhruvasagar/vim-zoom'


""" Languages
"" HTML
Plug 'mattn/emmet-vim'
"" Typescript
" Syntax highlight for typescript
Plug 'leafgarland/typescript-vim'
" Syntax highlighting for JSX in Typescript
Plug 'peitalin/vim-jsx-typescript'


call plug#end()

