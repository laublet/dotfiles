if exists('g:vscode')
  " VSCode extension
else
  " ordinary neovim
endif


" set leader key
let g:mapleader = "\<Space>"
" " Make space the leader key
" nnoremap <SPACE> <Nop>
" let mapleader=" "

" Enables syntax highlighing
syntax enable

" if !exists('g:syntax_on')
" 	syntax enable
" endif

set hidden                              " Required to keep multiple buffers open multiple buffers
set encoding=utf-8                      " The encoding displayed
set pumheight=10                        " Makes popup menu smaller
set fileencoding=utf-8                  " The encoding written to file
set ruler              			            " Show the cursor position all the time
set iskeyword+=-                      	" treat dash separated words as a word text object"
set mouse=a                             " Enable your mouse
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set t_Co=256                            " Support 256 colors
set conceallevel=0                      " So that I can see `` in markdown files
set tabstop=2                           " Insert 2 spaces for a tab
set shiftwidth=2                        " Number of auto-indent spaces
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set expandtab                           " Converts tabs to spaces
set smartindent                         " Makes indenting smart
set autoindent                          " When opening a new line and no filetype-specific indenting is enabled, keep the same indent as the line you're currently on. Useful for READMEs, etc.
set laststatus=2                        " Always display the status line, even if only one window is displayed
set number                              " Show line numbers
set relativenumber                      " Show numbers relatively
set cursorline                          " Enable highlighting of the current line
set showtabline=2                       " Always show tabs
set noshowmode                          " We don't need to see things like -- INSERT -- anymore
set showcmd                             " Show partial commands in the last line of the screen
set nobackup                            " This is recommended by coc
set nowritebackup                       " This is recommended by coc
set updatetime=300                      " Faster completion
set timeoutlen=500                      " By default timeoutlen is 1000 ms
set formatoptions-=cro                  " Stop newline continution of comments
set clipboard=unnamedplus               " Copy paste between vim and everything else
set nocompatible                        " Set 'nocompatible' to ward off unexpected things that your distro might have made, as well as sanely reset options when re-sourcing .vimrc
set wildmenu                            " Better command-line completion
set hlsearch                            " Highlight all search results
set incsearch                           " Searches for strings incrementally
set ignorecase                          " Use case insensitive search
set smartcase                           " Except when using capital letters
set confirm                             " Instead of failing a command because of unsaved changes, instead raise a dialogue asking if you wish to save changed files.
set visualbell                          " Use visual bell instead of beeping when doing something wrong
set cmdheight=2                         " Set the command window height to 2 lines, to avoid many cases of having to "press <Enter> to continue"
set backspace=indent,eol,start          " Allow backspacing over autoindent, line breaks and start of insert action
set undolevels=1000                     " Number of undo levels
set showmatch                           " Highlight matching brace
"set autochdir                           " Your working directory will always be the same as your working directory
set nowrap                              " Display long lines as just one line
"set linebreak                           " Break lines at word (requires Wrap lines)
"set showbreak=+++                       " Wrap-broken line prefix
"set textwidth=100                       " Line wrap (number of cols)

" Replace grep with RG
set grepprg=rg\ --vimgrep\ --smart-case\ --follow

au! BufWritePost $MYVIMRC source %      " auto source when writing to init.vm alternatively you can run :source $MYVIMRC

" You can't stop me
cmap w!! w !sudo tee %

" Enable true colors
" https://github.com/alacritty/alacritty/issues/109
if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" trigger autoread (refresh buffer) when changing buffer
" in combinaison with tmux (set -g focus-events on) refresh when file is saved ouside of vim
au FocusGained,BufEnter * :checktime

