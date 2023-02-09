"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""" Ali's Vim Config """""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set langmenu=en_US
"let $LANG = 'en_US'
"set encoding=utf-8  " The encoding displayed.
"set fileencoding=utf-8  " The encoding written to file.



"source ~/.vim/custom/plugins.vim " Plugins and plugin options
source ~/.vim/custom/remaps.vim " Personal Remaps

" Keep loads above this so they don't mess with these settings
" These settings will override those from above
syntax on               "Turns on Syntax highlighting 
set background=dark
try
    colorscheme mypire   "Color Scheme (in ~/.vim/colors)
catch
    colorscheme peachpuff   "backup color scheme (in /usr/share/vim...)
endtry
set mouse=a             "For people that can't use vim
set path+=**            "Recursive path lookup

set t_Co=256
"set cursorline          "Highlight current line
set nocompatible        "Cool stuff in Vim. Makes vi non-compatible 
set lazyredraw          "Faster rendering
set showcmd             "Show command as typing
set wildmenu            "wildmenu buffer, auto completion

" Indenting
set autoindent          "Auto indent
" No indenting on # mark 
set cindent             " Uses C indenting rules (spaces)
set cinkeys-=0#
set indentkeys-=0#
set wrap                "Wraps text
set expandtab           "Spaces and not tabs
set smarttab            "Tries to figure out when to tab
set shiftwidth=4        "Tab width 
set softtabstop=4

autocmd FileType vim,lua,nginx set shiftwidth=2 softtabstop=2
autocmd BufRead,BufEnter *.c,*.h,*.cpp,*.hpp,*.cu,*.cuh,*.cxx set shiftwidth=2 softtabstop=2
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
autocmd FileType asm set noexpandtab shiftwidth=8 softtabstop=0 syntax=nasm

set backspace=indent,eol,start  " backspace works through indents, end of line, etc

set number ruler        "Show line number
set showmode            "Shows mode in bottom left

set scrolloff=5         "Keep at lease 5 lines above and below
set colorcolumn=129     " Vertical white bar at 80 chars
set tw=128              " Line wrapping

"Error bells.  All are off
set noerrorbells        "Removes error bells
set novisualbell        "Removes visual bells
set t_vb=               "Sets visual bell

"searching
set incsearch           "Search command while typing
set hlsearch            "Highlights all misspelled words
set showmatch           "Shows matching brackets
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>
set ignorecase          " ignore case. Same as /csearchterm
set smartcase           "for searching

"Splitting
set splitright          "Puts new window to right of current (vsplit)
set splitbelow          "Same but below (split)

"Ctags
set tags="./.tags,../.tags,~/.tags"

" MARKDOWN
syn match markdownIgnore "\$.*_.*\$" " Doesn't highlight _ while in latex

"Spell checking
" Pressing \ss will toggle and untoggle spell checking
syntax spell toplevel   " Spell check fixing for tex
map <leader>ss :setlocal spell!<cr>
set spell                     "Turns on Spellcheck
set spell spelllang=en_us
hi clear SpellBad             "Highlights misspelled words
hi SpellBad cterm=bold,underline ctermfg=red  "Makes misspelled words bold, underlined, and red
hi SpellCap cterm=bold ctermfg=red  "Makes words in caps bold and red
hi SpellLocal cterm=bold,underline ctermfg=magenta  "Makes local words bold, underlined, and magenta
hi SpellRare cterm=underline ctermfg=magenta  "Makes rare words bold and magenta

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Turn persistent undo on
" means that you can undo even when you close a buffer/VIM
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
    set undofile
    set undodir=~/.vim/undodir
catch
endtry

"""""""""""""" Plugins """"""""""""""

" Lightline
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'one',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }

" Vifm.vim
map <leader>vv :Vifm .<cr>
map <leader>vs :VsplitVifm .<cr>
map <leader>sp :SplitVifm .<cr>
map <leader>dv :DiffVifm .<cr>
map <leader>tv :TabVifm .<cr>

" Terminal
map <leader>vt :vert term<cr>
map <leader>st :term<cr>

" Vim wiki
set nocompatible
filetype plugin on
let g:vimwiki_list = [{'path': '~/.aliswiki/', 
    \ 'name': 'Ali`s Wiki', 
    \ 'path_html': '~/wiki/', 
    \ 'auto_export': 1, 
    \ 'auto_toc': 1}]

" Git gutter
set updatetime=100

" VimTeX
" This is necessary for VimTeX to load properly. The "indent" is optional.
" Note that most plugin managers will do this automatically.
filetype plugin indent on
