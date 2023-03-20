"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""" Ali's Vim Config """""""""""""""""""""""""""""""
""""""""" Started off https://github.com/stevenwalton/.dotfiles """""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"set langmenu=en_US
"let $LANG = 'en_US'
"set encoding=utf-8  " The encoding displayed.
"set fileencoding=utf-8  " The encoding written to file.



" source ~/.vim/custom/remaps.vim " Personal Remaps

" Color scheme and related settings
syntax on                       "Turns on Syntax highlighting 
let &t_ut=''
set t_Co=256
set background=dark             "Dark mode
colorscheme vim-monokai-tasty   "Color Scheme (in ~/.vim/colors)
hi Normal ctermbg=black

set mouse=a                     "For people that can't use vim
set path+=**                    "Recursive path lookup

"set cursorline                  "Highlight current line
set nocompatible                "Cool stuff in Vim. Makes vi non-compatible 
set lazyredraw                  "Faster rendering
set showcmd                     "Show command as typing
set wildmenu                    "wildmenu buffer, auto completion

" Indenting
set autoindent                  "Auto indent
" No indenting on # mark 
set cindent                     " Uses C indenting rules (spaces)
set cinkeys-=0#
set indentkeys-=0#
set wrap                        "Wraps text
set expandtab                   "Spaces and not tabs
set smarttab                    "Tries to figure out when to tab
set shiftwidth=4                "Tab width 
set softtabstop=4

autocmd FileType vim,lua,nginx set shiftwidth=2 softtabstop=2
autocmd BufRead,BufEnter *.c,*.h,*.cpp,*.hpp,*.cu,*.cuh,*.cxx set shiftwidth=2 softtabstop=2 "C/CXX/CPP/CUDA
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0 "Make forces tabs not spaces
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

" Undo history
set undofile                          " Enables persistent undo files
set undodir=$HOME/.vimfiles/undodir   " Sets the path to undo files (installer ensures it exists)

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
hi clear SpellBad
hi SpellBad cterm=bold,underline ctermbg=None ctermfg=red  "Makes misspelled words bold, underlined, and red
hi SpellCap cterm=bold ctermfg=red ctermbg=None  "Makes words in caps bold and red
hi SpellLocal cterm=bold,underline ctermbg=None ctermfg=magenta  "Makes local words bold, underlined, and magenta
hi SpellRare cterm=underline ctermbg=None ctermfg=magenta  "Makes rare words bold and magenta

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
  " Inspired by and heavily based on:
  " https://github.com/camspiers/dotfiles
  " 
  " Expects `termpdf` to be recognizable and fetch the correct system paths
  " Otherwise it will kill the new split upon launch
  let g:vimtex_view_automatic = 0
  let g:termpdf_exp_width  = float2nr(float2nr(winheight(0) * 15) / 2)
  let g:termpdf_curr_width = float2nr(float2nr(winwidth(0) * 8) / 2)
  let g:termpdf_resize_init = - float2nr((g:termpdf_curr_width - g:termpdf_exp_width) / 18)

  function! TermPDFReset() abort
    call system('kitty @ resize-window --match title:tpdfv'. b:vimtex.name . '.pdf -a reset')
  endfunction

  function! TermPDFResize(size) abort
    let g:termpdf_resize_init += a:size
    if a:size == 0
      call TermPDFReset()
      call system('kitty @ resize-window --match title:tpdfv'. b:vimtex.name . '.pdf -a horizontal -i ' . g:termpdf_resize_init)
    else
      call system('kitty @ resize-window --match title:tpdfv'. b:vimtex.name . '.pdf -a horizontal -i ' . a:size)
    endif
  endfunction

  function! TermPDFClose() abort
    call system('kitty @ close-window --match title:tpdfv'. b:vimtex.name . '.pdf')
  endfunction

  function! TermPDF(status) abort

    if a:status
      call system('kitty @ launch --keep_focus --copy_env --location=vsplit --title tpdfv' . b:vimtex.name . '.pdf termpdf ' .  b:vimtex.root . '/' . b:vimtex.name . '.pdf')
      call TermPDFResize(0)
    endif
  endfunction

  function! DisableTermPDF()
    call TermPDFClose()
    let g:vimtex_view_general_callback = ''
    augroup VimtexTest
      autocmd!
    augroup end
  endfunction

  function! EnableTermPDF()
    let g:vimtex_view_general_callback = 'TermPDF'
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
    if g:vimtex_view_general_callback == 'TermPDF'
      call DisableTermPDF()
    else
      call EnableTermPDF()
      call TermPDF(1)
    endif
  endfunction

  " Enable by default
  call EnableTermPDF()

  " Allow toggling TermPDF
  map <leader>lp :call ToggleTermPDF()<cr>
  map <leader>l= :call TermPDFResize(10)<cr>
  map <leader>l- :call TermPDFResize(-10)<cr>

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
