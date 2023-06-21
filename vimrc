"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""" Ali's Vim Config """""""""""""""""""""""""""""""
""""""""" Started off https://github.com/stevenwalton/.dotfiles """""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set langmenu=en_US
"let $LANG = 'en_US'
"set encoding=utf-8  " The encoding displayed.
"set fileencoding=utf-8  " The encoding written to file.


" Color scheme and related settings
syntax on                                               " Syntax highlighting 

" vim hardcodes background color erase even if the terminfo file does
" not contain bce. This causes incorrect background rendering when
" using a color theme with a background color in terminals such as
" kitty that do not support background color erase.
let &t_ut=''

" Truecolor support
let $TERM = "xterm-direct"                              " Uhhhh Vifm!
let &t_8f = "\e[38:2:%lu:%lu:%lum"
let &t_8b = "\e[48:2:%lu:%lu:%lum"
let &t_RF = "\e]10;?\e\\"
let &t_RB = "\e]11;?\e\\"


set cursorline                                          " Row highlighting
set cursorcolumn                                        " Column highlighting
set background=dark                                     " Dark mode
set t_Co=256
set termguicolors
let g:monokai_pro_highlight_active_window = 1           "
colorscheme monokai-pro                                 " Color Scheme (in ~/.vim/colors)

set mouse=a                                             " Mouse support for people that can't use vim
set path+=**                                            " Recursive path lookup

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
set shiftwidth=4                                        " Tab width 
set softtabstop=4

" Custom tab width for vim/lua/nginx files
autocmd FileType vim,lua,nginx set shiftwidth=2 softtabstop=2
" Custom tab width for C/CPP/CUDA
autocmd BufRead,BufEnter *.c,*.h,*.cpp,*.hpp,*.cu,*.cuh,*.cxx,*.hxx set shiftwidth=2 softtabstop=2
" Makefile forces tabs not spaces
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0
" ASM
autocmd FileType asm set noexpandtab shiftwidth=8 softtabstop=0 syntax=nasm

set backspace=indent,eol,start                          " backspace works through indents, end of line, etc

set number ruler                                        " Show line number
set showmode                                            " Shows mode in bottom left

set scrolloff=5                                         " Keep at lease 5 lines above and below
set colorcolumn=129                                     " Vertical white bar at 80 chars
set tw=128                                              " Line wrapping

"Error bells.  All are off
set noerrorbells                                        " Removes error bells
set novisualbell                                        " Removes visual bells
set t_vb=                                               " Sets visual bell

"searching
set incsearch                                           " Search command while typing
set hlsearch                                            " Highlights all misspelled words
set showmatch                                           " Shows matching brackets
nnoremap <silent> <Space> :silent noh<Bar>echo<CR>
set ignorecase                                          " ignore case. Same as /csearchterm
set smartcase                                           "for searching

"Splitting
set splitright                                          " Puts new window to right of current (vsplit)
set splitbelow                                          " Same but below (split)

" Undo history
set undofile                                            " Enables persistent undo files
set undodir=$HOME/.vimfiles/undodir                     " Sets the path to undo files (installer ensures it exists)

"Ctags
set tags="./.tags,../.tags,~/.tags"

" MARKDOWN
syn match markdownIgnore "\$.*_.*\$"                    " Doesn't highlight _ while in latex

"Spell checking
" Pressing \ss will toggle and untoggle spell checking
syntax spell toplevel   " Spell check fixing for tex
map <leader>ss :setlocal spell!<cr>
set spell                     "Turns on Spellcheck
set spell spelllang=en_us

"""""""""""""" Plugins """"""""""""""

" Lightline
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'monokai_pro',
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
map <leader>we :VimwikiTOC<cr>

" Git gutter
set updatetime=100

" FZF
set rtp+=~/.fzf


" Plugins I use on mac only
" macunix won't work because I'm building vim from source without the darwin flag.
"if has('macunix')
let g:os = substitute(system('uname'), '\n', '', '')
if g:os == 'Darwin'
  " Vim Markdown
  packadd vim-markdown-preview
  let vim_markdown_preview_github=1
  let vim_markdown_preview_toggle=1
  let vim_markdown_preview_browser='Google Chrome'

  " VimTeX
  packadd vimtex
  filetype plugin indent on
  let g:vimtex_view_method = 'zathura'

  " TermPDF split preview
  " Inspired by and based on:
  " https://github.com/camspiers/dotfiles
  " 
  " Expects `termpdf` to be recognizable and fetch the correct system paths
  " Otherwise it will kill the new split upon launch
  let g:vimtex_view_automatic = 0
  " Compute `expected width`
  " I don't want the pdf to take half of my screen because it's usually too much for it.
  " This is just my messy little formula that just works out.
  let termpdf_exp_width  = float2nr(float2nr(winheight(0) * 15) / 2)
  let termpdf_curr_width = float2nr(float2nr(winwidth(0) * 8) / 2)
  let g:termpdf_resize_init = - float2nr((termpdf_curr_width - termpdf_exp_width) / 18)
  let g:termpdf_tab_prefix = 'tpdfv'
  let g:termpdf_enabled = 1

  function! TermPDFReset() abort
    call system('kitty @ resize-window --match title:' . g:termpdf_tab_prefix . b:vimtex.name . '.pdf -a reset')
  endfunction

  function! TermPDFResize(size) abort
    let g:termpdf_resize_init += a:size
    if a:size == 0
      call TermPDFReset()
      call system('kitty @ resize-window --match title:' . 
            \ g:termpdf_tab_prefix . b:vimtex.name . '.pdf -a horizontal -i ' . g:termpdf_resize_init)
    else
      call system('kitty @ resize-window --match title:' . 
            \ g:termpdf_tab_prefix . b:vimtex.name . '.pdf -a horizontal -i ' . a:size)
    endif
  endfunction

  function! TermPDFClose() abort
    call system('kitty @ close-window --match title:' . g:termpdf_tab_prefix . b:vimtex.name . '.pdf')
  endfunction

  function! TermPDF(status) abort

    if a:status
      call TermPDFClose()
      call system('kitty @ launch --keep_focus --copy_env --location=vsplit ' . 
            \ '--title ' . g:termpdf_tab_prefix  . b:vimtex.name . '.pdf ' . 
            \ 'termpdf ' .  b:vimtex.root . '/' . b:vimtex.name . '.pdf')
      call TermPDFResize(0)
    endif
  endfunction

  function! DisableTermPDF()
    call TermPDFClose()
    " let g:vimtex_view_general_callback = ''
    let g:termpdf_enabled = 0
    augroup VimtexTest
      autocmd!
    augroup end
  endfunction

  function! EnableTermPDF()
    " let g:vimtex_view_general_callback = 'TermPDF'
    let g:termpdf_enabled = 1
    augroup VimtexTest
      autocmd!
      "autocmd FileType tex :VimtexClean
      autocmd FileType tex :VimtexCompile
      autocmd! User VimtexEventCompileSuccess call TermPDF(1)
      autocmd! User VimtexEventCompileStopped call TermPDFClose()
      " autocmd! User VimtexEventCompileFailed call TermPDFClose()
    augroup end
  endfunction

  function! ToggleTermPDF()
    if g:termpdf_enabled
      call DisableTermPDF()
    else
      call EnableTermPDF()
      call TermPDF(1)
    endif
  endfunction

  " Enable by default
  " call EnableTermPDF()

  " Allow toggling TermPDF
  map <leader>lp :call ToggleTermPDF()<cr>
  map <leader>l= :call TermPDFResize(10)<cr>
  map <leader>l- :call TermPDFResize(-10)<cr>


  "" Back to VimTex
  "" Disable matchparen because it slows stuff down
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
      \   '-synctex=1',
      \ ],
        \}
endif

"" Toggles cursorline -- slow for some reason in certain files (i.e. tex)
let g:cursorline_enabled = 1
function! ToggleCursorLine()
if g:cursorline_enabled
    let g:cursorline_enabled = 0
    set nocursorline
    set nocursorcolumn
else
    let g:cursorline_enabled = 1
    set cursorline
    set cursorcolumn
endif
endfunction
map <leader>cc :call ToggleCursorLine()<cr>

" Goyo: focus mode
" \gg
let g:goyo_linenr = 1
let g:goyo_width = "60%"
let g:goyo_height = "100%"
map <leader>gg :Goyo<cr>

" Limelight
" Enhanced focus
" \gl
let g:limelight_default_coefficient = 0.7
map <leader>ge :Limelight!!<cr>
