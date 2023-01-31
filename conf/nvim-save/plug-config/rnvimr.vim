" https://github.com/kevinhwang91/rnvimr

" See: https://github.com/kevinhwang91/rnvimr
" Make Ranger replace netrw and be the file explorer
let g:rnvimr_ex_enable = 0

" Make Ranger to be hidden after picking a file
let g:rnvimr_enable_picker = 1
"
" Disable a border for floating window
let g:rnvimr_draw_border = 1

" Make Neovim wipe the buffers corresponding to the files deleted by Ranger
let g:rnvimr_enable_bw = 1

let g:rnvimr_ranger_cmd = 'ranger --cmd="set column_ratios 1,1"'
            " \ --cmd="set draw_borders separators"'

" nmap <leader>r :RnvimrToggle<CR>
