" https://github.com/nathanaelkane/vim-indent-guides

" Enable vim indent guide
let g:indent_guides_enable_on_vim_startup = 0

" Change colors
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=100
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=96
