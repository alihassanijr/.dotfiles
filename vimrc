"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""" Ali's Vim Config """""""""""""""""""""""""""""""
""""""""" Started off https://github.com/stevenwalton/.dotfiles """""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Color scheme and related settings
syntax on                                               " Syntax highlighting 

let g:os = substitute(system('uname'), '\n', '', '')

if g:os != 'Darwin'
  " Truecolor support
  " $TERM has to be set for vifm to support true color.
  " Since I typically open vifm inside vim, it needs to be set here.
  " And I of course can't override the environment variable because then
  " all hell breaks loose.
  let $TERM = "xterm-direct"                              " Uhhhh Vifm!
endif


set cursorline                                          " Row highlighting
set cursorcolumn                                        " Column highlighting
set background=dark                                     " Dark mode
set t_Co=256
set termguicolors
colorscheme ghdark                                      " Color Scheme (in ~/.vim/colors)

set mouse=a                                             " Mouse support for people that can't use vim

set nocompatible                                        " Cool stuff in Vim. Makes vi non-compatible 
set lazyredraw                                          " Faster rendering
set showcmd                                             " Show command as typing
set wildmenu                                            " wildmenu buffer, auto completion

" Indenting
set autoindent                                          " Auto indent

" No indenting on # mark 
set cindent                                             " Uses C indenting rules (spaces)
set cinkeys-=0#
set indentkeys-=0#
set wrap                                                " Wraps text
set expandtab                                           " Spaces and not tabs
set smarttab                                            " Tries to figure out when to tab
set shiftwidth=2                                        " Tab width 
set softtabstop=2

" Makefile forces tabs not spaces
autocmd FileType makefile setlocal noexpandtab

set backspace=indent,eol,start                          " backspace works through indents, end of line, etc

set number ruler                                        " Show line number
set showmode                                            " Shows mode in bottom left

set scrolloff=5                                         " Keep at lease 5 lines above and below
set colorcolumn=100                                     " Vertical white bar at 100 chars
set tw=100                                              " Line wrapping

" Disable all error bells
set noerrorbells                                        " Removes error bells
set novisualbell                                        " Removes visual bells
set t_vb=                                               " Sets visual bell

" Searching
set incsearch                                           " Search command while typing
set hlsearch                                            " Highlights all misspelled words
set showmatch                                           " Shows matching brackets
set ignorecase                                          " ignore case. Same as /csearchterm
set smartcase                                           " for searching
set matchpairs+=<:>                                     " match angle brackets

" Splitting
set splitright                                          " Puts new window to right of current (vsplit)
set splitbelow                                          " Same but below (split)

" Persistent undo history
set undofile                                            " Enables persistent undo files
set undodir=$HOME/.vimfiles/undodir                     " Sets the path to undo files (installer ensures it exists)

" Swap dir
set directory=$HOME/.vimfiles/swapdir//                 " Sets swap directory path

" Markdown
syn match markdownIgnore "\$.*_.*\$"                    " Doesn't highlight _ while in latex

" Spell checking

if filereadable("./vim/spell/en.utf-8.add")
  set spellfile+=./vim/spell/en.utf-8.add
  silent! echo "Custom dictionary loaded."
else
  silent! echo "No custom dictionary found."
endif

" Pressing \ss will toggle and untoggle spell checking
syntax spell toplevel                                   " Spell check fixing for tex
map <leader>ss :setlocal spell!<cr>
set spell                                               " Turns on Spellcheck
set spell spelllang=en_us

" Line break on Ctrl + J
nnoremap <C-J> i<CR><ESC>

" Silence search on space
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>
" Clear search on leader + space
nnoremap <silent> <Leader><Space> :let @/ = "/\b\B"<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""
""" shift delay helpers
"""""""""""""""""""""""""""""""""""""""""""""""""
:command -nargs=* Q q <args>
:command -nargs=* Qall qall <args>
:command -nargs=* Tabnew tabnew <args>
:command -nargs=* Tab tab <args>
:command -nargs=* Tabm tabm <args>
:command -nargs=* Bd bd <args>
:command -nargs=* Vsp vsp <args>


""""""""""""""""""""""""""""""""""" PLUGINS AND THEIR SETTINGS """"""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""
""" Polyglot: extended syntax highlighting
"""""""""""""""""""""""""""""""""""""""""""""""""
" Polyglot's auto-indent breaks a lot of things for me; vim + formatting tools is enough!
" CSV formatting is also disabled; it is ANNOYING!!!
let g:polyglot_disabled = ["autoindent", "csv"]
"-------------------------------------------------


"""""""""""""""""""""""""""""""""""""""""""""""""
" Lightline
"""""""""""""""""""""""""""""""""""""""""""""""""
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'ghdark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ 'component': {
      \   'filename': '%n:%t'
      \ },
      \ }
"-------------------------------------------------

"""""""""""""""""""""""""""""""""""""""""""""""""
" Vifm: vim file manager
"""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>vv :Vifm .<cr>
map <leader>vs :VsplitVifm .<cr>
map <leader>sp :SplitVifm .<cr>
map <leader>dv :DiffVifm .<cr>
map <leader>tv :TabVifm .<cr>
"-------------------------------------------------

"""""""""""""""""""""""""""""""""""""""""""""""""
" Git gutter
"""""""""""""""""""""""""""""""""""""""""""""""""
set updatetime=100
"-------------------------------------------------

"""""""""""""""""""""""""""""""""""""""""""""""""
" FZF: Fuzzy finder
"""""""""""""""""""""""""""""""""""""""""""""""""
set rtp+=~/.fzf
"-------------------------------------------------

"""""""""""""""""""""""""""""""""""""""""""""""""
""" Goyo: focus mode
"""""""""""""""""""""""""""""""""""""""""""""""""
let g:goyo_linenr = 1
let g:goyo_width = "60%"
let g:goyo_height = "100%"

map <leader>gg :Goyo<cr>

"-------------------------------------------------

"""""""""""""""""""""""""""""""""""""""""""""""""
" Limelight: enhanced focus
"""""""""""""""""""""""""""""""""""""""""""""""""
let g:limelight_default_coefficient = 0.7

map <leader>ge :Limelight!!<cr>
"-------------------------------------------------


"""""""""""""""""""""""""""""""""" MAC / PERSONAL DEVICE PLUGINS """"""""""""""""""""""""""""""""""

if g:os == 'Darwin'
  """""""""""""""""""""""""""""""""""""""""""""""""
  " VimTeX
  """""""""""""""""""""""""""""""""""""""""""""""""
  packadd vimtex
  filetype plugin indent on
  let g:vimtex_view_method = 'zathura'

  " Disable matchparen because it slows stuff down
  let g:vimtex_matchparen_enabled = 0
  let loaded_matchparen = 1

  let g:vimtex_compiler_latexmk = {
      \ 'build_dir' : '',
      \ 'callback' : 1,
      \ 'continuous' : 1,
      \ 'executable' : 'latexmk',
      \ 'hooks' : [],
      \ 'options' : [
      \   '-verbose',
      \   '-file-line-error',
      \   '-shell-escape',
      \   '-synctex=1',
      \ ],
        \}
  "-------------------------------------------------
endif


"""""""""""""""""""""""""""""""""" NON-PLUGIN / PERSONAL SETTINGS """"""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""
""" Cursor line toggle
"""""""""""""""""""""""""""""""""""""""""""""""""
""" Poor connections, slow system, and many other reasons why
""" I sometimes need to disable the cursor line highlights.
""" It can get annoying because the setting is not global.
"""
""" Solution: use a global variable, g:cursorline_enabled, to
""" track, when <leader>cc, toggle, and on WinEnter/BufEnter,
""" check the global variable and apply the appropriate settings.

let g:cursorline_enabled = 1

" Toggle cursorlines for the CURRENT buffer, and set global variable
function! ToggleCursorLine()
if g:cursorline_enabled
    let g:cursorline_enabled = 0

    set nocursorline
    set nocursorcolumn

    echom "Cursor line is DISABLED"
else
    let g:cursorline_enabled = 1

    set cursorline
    set cursorcolumn

    echom "Cursor line is ENABLED"

endif
endfunction

" Check global variable and apply the appropriate settings
function! CheckCursorLineStatus()
if !g:cursorline_enabled
    set nocursorline
    set nocursorcolumn
else
    set cursorline
    set cursorcolumn
endif
endfunction

" On switching windows/buffers, CheckCursorLineStatus
autocmd WinEnter,BufEnter * call CheckCursorLineStatus()

" Key mapping: \cc
map <leader>cc :call ToggleCursorLine()<cr>

"-------------------------------------------------
