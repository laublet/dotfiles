" https://github.com/liuchengxu/vim-which-key

" Map leader to which_key
nnoremap <silent> <leader> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>

" Create map to add keys to
let g:which_key_map =  {}
" Define a separator
let g:which_key_sep = '→'
" set timeoutlen=100


" Not a fan of floating windows for this
let g:which_key_use_floating_win = 0

" Change the colors if you want
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function

" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

" Single mappings
let g:which_key_map['.'] = [ ':e $MYVIMRC'                           , 'open init']
let g:which_key_map[';'] = [ ':Commands'                             , 'commands']
let g:which_key_map['='] = [ '<C-W>='                                , 'balance windows']
let g:which_key_map['d'] = [ ':Bdelete'                              , 'delete buffer']
let g:which_key_map['e'] = [ ':CocCommand explorer'                  , 'explorer']
let g:which_key_map['h'] = [ '<C-W>s'                                , 'split below']
let g:which_key_map['m'] = [ ':call WindowSwap#EasyWindowSwap()'     , 'move window']
let g:which_key_map['n'] = [ ':let @/ = ""'                          , 'no highlight']
let g:which_key_map['p'] = [ ':Files'                                , 'search files']
let g:which_key_map['q'] = [ 'q'                                     , 'quit']
let g:which_key_map['r'] = [ ':RnvimrToggle'                         , 'ranger']
let g:which_key_map['u'] = [ ':UndotreeToggle'                       , 'undo tree']
let g:which_key_map['v'] = [ '<C-W>v'                                , 'split right']
let g:which_key_map['W'] = [ 'w'                                     , 'save']
let g:which_key_map['/'] = [ 'Buffers'                               , 'fzf-buffer']

" a is for actions
let g:which_key_map.a = {
      \ 'name' : '+actions' ,
      \ 'c' : [':ColorizerToggle'           , 'colorizer'],
      \ 'e' : [':CocCommand explorer'       , 'explorer'],
      \ 'm' : [':MarkdownPreview'           , 'markdown preview'],
      \ 'M' : [':MarkdownPreviewStop'       , 'markdown preview stop'],
      \ 'n' : [':set nonumber!'             , 'line-numbers'],
      \ 'r' : [':set norelativenumber!'     , 'relative line nums'],
      \ 's' : [':let @/ = ""'               , 'remove search highlight'],
      \ 't' : [':FloatermToggle'            , 'terminal'],
      \ 'v' : [':Codi'                      , 'virtual repl on'],
      \ 'V' : [':Codi!'                     , 'virtual repl off'],
      \ 'w' : [':StripWhitespace'           , 'strip whitespace'],
      \ }

" b = buffer
let g:which_key_map.b = {
      \ 'name' : '+buffer' ,
      \ '1' : ['b1'            , 'buffer 1'],
      \ '2' : ['b2'            , 'buffer 2'],
      \ 'd' : [':Bdelete'      , 'delete-buffer'],
      \ 'f' : ['bfirst'        , 'first-buffer'],
      \ 'h' : ['Startify'      , 'home-buffer'],
      \ 'l' : ['blast'         , 'last-buffer'],
      \ 'n' : ['bnext'         , 'next-buffer'],
      \ 'p' : ['bprevious'     , 'previous-buffer'],
      \ '/' : ['Buffers'       , 'fzf-buffer'],
      \ }" f is for find and replace

" f = find and replace
let g:which_key_map.f = {
      \ 'name' : '+find & replace' ,
      \ 'b' : [':Farr --source=vimgrep'    , 'buffer'],
      \ 'p' : [':Farr --source=rgnvim'     , 'project'],
      \ }

" g = git
let g:which_key_map.g = {
      \ 'name' : '+git' ,
      \ 'a' : [':Git add .'                         , 'add all'],
      \ 'A' : [':Git add %'                         , 'add current'],
      \ 'b' : [':Git blame'                         , 'blame'],
      \ 'B' : [':GBrowse'                           , 'browse'],
      \ 'c' : [':Git commit'                        , 'commit'],
      \ 'd' : [':Git diff'                          , 'diff'],
      \ 'D' : [':Gdiffsplit'                        , 'diff split'],
      \ 'g' : [':GGrep'                             , 'git grep'],
      \ 'G' : [':Gstatus'                           , 'status'],
      \ 'h' : [':GitGutterLineHighlightsToggle'     , 'highlight hunks'],
      \ 'H' : ['<Plug>(GitGutterPreviewHunk)'       , 'preview hunk'],
      \ 'i' : [':Gist -b'                           , 'post gist'],
      \ 'j' : ['<Plug>(GitGutterNextHunk)'          , 'next hunk'],
      \ 'k' : ['<Plug>(GitGutterPrevHunk)'          , 'prev hunk'],
      \ 'l' : [':Git log'                           , 'log'],
      \ 'm' : ['<Plug>(git-messenger)'              , 'message'],
      \ 'p' : [':Git push'                          , 'push'],
      \ 'P' : [':Git pull'                          , 'pull'],
      \ 'r' : [':GRemove'                           , 'remove'],
      \ 's' : ['<Plug>(GitGutterStageHunk)'         , 'stage hunk'],
      \ 'S' : [':!git status'                       , 'status'],
      \ 't' : [':GitGutterSignsToggle'              , 'toggle signs'],
      \ 'u' : ['<Plug>(GitGutterUndoHunk)'          , 'undo hunk'],
      \ 'v' : [':GV'                                , 'view commits'],
      \ 'V' : [':GV!'                               , 'view buffer commits'],
      \ }

" l = server protocol
let g:which_key_map.l = {
      \ 'name' : '+lsp' ,
      \ '.' : [':CocConfig'                            , 'config'],
      \ ';' : ['<Plug>(coc-refactor)'                  , 'refactor'],
      \ 'a' : ['<Plug>(coc-codeaction)'                , 'line action'],
      \ 'A' : ['<Plug>(coc-codeaction-selected)'       , 'selected action'],
      \ 'b' : [':CocNext'                              , 'next action'],
      \ 'B' : [':CocPrev'                              , 'prev action'],
      \ 'c' : [':CocList commands'                     , 'commands'],
      \ 'd' : ['<Plug>(coc-definition)'                , 'definition'],
      \ 'D' : ['<Plug>(coc-declaration)'               , 'declaration'],
      \ 'e' : [':CocList extensions'                   , 'extensions'],
      \ 'f' : ['<Plug>(coc-format-selected)'           , 'format selected'],
      \ 'F' : ['<Plug>(coc-format)'                    , 'format'],
      \ 'h' : ['<Plug>(coc-float-hide)'                , 'hide'],
      \ 'i' : ['<Plug>(coc-implementation)'            , 'implementation'],
      \ 'I' : [':CocList diagnostics'                  , 'diagnostics'],
      \ 'j' : ['<Plug>(coc-float-jump)'                , 'float jump'],
      \ 'l' : ['<Plug>(coc-codelens-action)'           , 'code lens'],
      \ 'n' : ['<Plug>(coc-diagnostic-next)'           , 'next diagnostic'],
      \ 'N' : ['<Plug>(coc-diagnostic-next-error)'     , 'next error'],
      \ 'o' : [':Vista!!'                              , 'outline'],
      \ 'O' : [':CocList outline'                      , 'outline'],
      \ 'p' : ['<Plug>(coc-diagnostic-prev)'           , 'prev diagnostic'],
      \ 'P' : ['<Plug>(coc-diagnostic-prev-error)'     , 'prev error'],
      \ 'q' : ['<Plug>(coc-fix-current)'               , 'quickfix'],
      \ 'r' : ['<Plug>(coc-references)'                , 'references'],
      \ 'R' : ['<Plug>(coc-rename)'                    , 'rename'],
      \ 's' : [':CocList -I symbols'                   , 'references'],
      \ 'S' : [':CocList snippets'                     , 'snippets'],
      \ 't' : ['<Plug>(coc-type-definition)'           , 'type definition'],
      \ 'u' : [':CocListResume'                        , 'resume list'],
      \ 'U' : [':CocUpdate'                            , 'update CoC'],
      \ 'z' : [':CocDisable'                           , 'disable CoC'],
      \ 'Z' : [':CocEnable'                            , 'enable CoC'],
      \ }

" s = search
let g:which_key_map.s = {
      \ 'name' : '+search' ,
      \ '/' : [':History/'      , 'history'],
      \ ';' : [':Commands'      , 'commands'],
      \ 'a' : [':Ag'            , 'text Ag'],
      \ 'b' : [':BLines'        , 'current buffer'],
      \ 'B' : [':Buffers'       , 'open buffers'],
      \ 'c' : [':Commits'       , 'commits'],
      \ 'C' : [':BCommits'      , 'buffer commits'],
      \ 'f' : [':Files'         , 'files'],
      \ 'g' : [':GFiles'        , 'git files'],
      \ 'G' : [':GFiles?'       , 'modified git files'],
      \ 'h' : [':History'       , 'file history'],
      \ 'H' : [':History:'      , 'command history'],
      \ 'l' : [':Lines'         , 'lines'],
      \ 'm' : [':Marks'         , 'marks'],
      \ 'M' : [':Maps'          , 'normal maps'],
      \ 'p' : [':Helptags'      , 'help tags'],
      \ 'P' : [':Tags'          , 'project tags'],
      \ 's' : [':Snippets'      , 'snippets'],
      \ 'S' : [':Colors'        , 'color schemes'],
      \ 't' : [':Rg'            , 'text Rg'],
      \ 'T' : [':BTags'         , 'buffer tags'],
      \ 'w' : [':Windows'       , 'search windows'],
      \ 'y' : [':Filetypes'     , 'file types'],
      \ 'z' : [':FZF'           , 'FZF'],
      \ }

" s = Startify
let g:which_key_map.S = {
      \ 'name' : '+Session' ,
      \ 'c' : [':SClose'       , 'Close Session'],
      \ 'd' : [':SDelete'      , 'Delete Session'],
      \ 'l' : [':SLoad'        , 'Load Session'],
      \ 's' : [':Startify'     , 'Start Page'],
      \ 'S' : [':SSave'        , 'Save Session'],
      \ }

" s = Floaterm
let g:which_key_map.t = {
      \ 'name' : '+terminal' ,
      \ ';' : [':FloatermNew'                , 'terminal'],
      \ 'f' : [':FloatermNew fzf'            , 'fzf'],
      \ 'g' : [':FloatermNew lazygit'        , 'git'],
      \ 'd' : [':FloatermNew lazydocker'     , 'docker'],
      \ 'n' : [':FloatermNew node'           , 'node'],
      \ 'e' : [':FloatermNew iex'            , 'elixir'],
      \ 'p' : [':FloatermNew python3'        , 'python3'],
      \ 'r' : [':FloatermNew ranger'         , 'ranger'],
      \ 't' : [':FloatermToggle'             , 'toggle'],
      \ 'y' : [':FloatermNew ytop'           , 'ytop'],
      \ }

" Register which key map
call which_key#register('<Space>', "g:which_key_map")
