call plug#begin(stdpath('data') . '/plugged')
source $HOME/.config/nvim/plugins.vim
Plug 'sheerun/vim-polyglot'
Plug 'srcery-colors/srcery-vim'
call plug#end()
set termguicolors
colorscheme srcery
set background=dark

"""""""""""""""""""""""""""
" COMANDOS PERSONALIZADOS "
"""""""""""""""""""""""""""
command! -nargs=0 Prettier :CocCommand prettier.formatFile
function Searching(view)
  let config = {
  \    'options': ['--layout=reverse', '--preview', 'pygmentize -g -O style=monokai {}'],
  \    'window': { 'width': 1, 'height': 1 }
  \  }
  if a:view == 'git'
    let source = {
      \    "source": "xonsh -c 'echo @($(git ls-files --exclude-standard --others) + $(git ls-files))'",
      \    "sink": "e"
      \  }
    call fzf#run(extend(config, source))
  endif
  if a:view == 'buffer'
    call fzf#vim#buffers(config)
  endif
endfunction

""""""""""""""""""
" AUTOCOMPLETADO "
""""""""""""""""""
" KITE
let g:kite_supported_languages = ['javascript', 'php']
autocmd FileType javascript let b:coc_suggest_disable = 1
"autocmd FileType php let b:coc_suggest_disable = 1

" COC
autocmd FileType scss setl iskeyword+=@-@
function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction
autocmd FileType php nmap <silent> gi :call IPhpInsertUse()<CR>

" COC NAVEGAR CON EL TAB
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" COC AUTOPRETTIER EN VUE
function ExecPrettier()
    Prettier
    write
endfunction
autocmd BufWritePost *.vue call ExecPrettier()

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

let g:lightline = {
    \   'active' : {
    \     'left': [['mode', 'paste'], ['relativepath'], ['modified', 'method']],
    \     'right': [['gitbranch'], ['ggstatus','filetype', 'percent', 'lineinfo'], ['kitestatus']]
    \   },
    \   'inactive': {
    \     'left': [['inactive'], ['relativepath']],
    \     'right': [['bufnum']]
    \   },
    \   'component': {
    \     'bufnum': '%n',
    \     'inactive': 'inactive'
    \   },
    \   'component_function': {
    \     'kitestatus': 'kite#statusline',
    \     'gitbranch': 'gitbranch#name',
    \     'ggstatus': 'GitStatus',
    \     'method': 'NearestMethodOrFunction'
    \   },
    \   'subseparator': {
    \     'left': '',
    \     'right': ''
    \   }
    \ }

" GITGUTTER
function! GitStatus()
  let summary = GitGutterGetHunkSummary()
  let estados = map(['+','~','-'], {k, v -> {'count': summary[k], 'display': printf("%s%d", v, summary[k])}})
  return join(map(filter(estados, {k,v -> v['count'] > 0}), {k,v -> v['display']}), ' ')
endfunction

" GIT CONFIG
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
"let g:blamer_enabled = 1
"let g:blamer_prefix = " \ue702 "
"let g:blamer_template = "<commit-short> <committer>, <committer-time> • <summary>"
"let g:indentLine_bgcolor_gui = '#FF00FF'

" Set variables to Python
let g:python3_host_prog='/usr/bin/python3'
autocmd BufNewFile,BufRead *xonshrc,*.xsh set filetype=python

set shell=/usr/bin/xonsh
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

" Identado
set autoindent
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

" AJUSTES PARA ARCHIVOS ESPECIFICOS
autocmd FileType gitcommit set cc=72

" AJUSTES GENERALES
set encoding=utf-8
syntax enable
set colorcolumn=80
set backspace=indent,eol,start
set hidden
set number
set relativenumber
set nowrap
set nobackup
set noswapfile
set noshowmode " IMPIDE VER EL MODO POR DEFAULT NEOVIM (INSERT,VISUAL,NORMAL).
set showmatch
set listchars=trail:·,eol:<,nbsp:%,tab:\ \ 
set list
set eol
let mapleader="\<C-h>"

" NerdTree
let g:NERDTreeDirArrowExpandable = '+'
let g:NERDTreeDirArrowCollapsible = '-'
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
let NERDTreeShowLineNumber=1
autocmd FileType nerdtree setlocal relativenumber

" #####################
" # SUPPORT LANGUAGES #
" #####################
let g:vue_pre_processors = ['pug', 'scss']

" ###########
" # Mapping #
" ###########

source $HOME/.config/nvim/mappings.vim

