"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""" VIM Remaps """""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Remove trailing whitespaces on write
"autocmd BufWrite * :%s/\s\+$//g
command CleanFile normal! :%s/\s\+$//g<CR>

" Open all buffers in a new tab (open bunch of files then run this)
command Buf2Tab normal! :bufdo tab split<CR>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

" Map for version incrementation.
" Will save and update version
map <Leader>x  :g/Version/norm! $h <C-A><CR>:x<CR>
map <Leader>w  :g/Version/norm! $h <C-A><CR>:call feedkeys("``")<CR>:w<CR>
map <Leader>v+ :g/Version/norm! $h <C-A><CR>:call feedkeys("``")<CR>:w<CR>
map <Leader>v- :g/Version/norm! $h <C-X><CR>:call feedkeys("``")<CR>:w<CR>

" C shortcuts \m executes make, \mc executes make clean
autocmd FileType cpp call MapCShortcuts()
function MapCShortcuts()
    map <leader>m :make<cr>
    map <leader>mc :make clean<cr>
endfunction

autocmd BufReadPost *   "Return to last edit position
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \ exe "normal! g`\"" |
    \ endif

"Search and replace text
vnoremap <silent> <leader>r :call VisualSelection('replace', '')<CR>
" When you press gv you vimgrep after the selected text
vnoremap <silent> gv :call VisualSelection('gv', '')<CR>
" Open vimgrep and put the cursor in the right position
map <leader>g :vimgrep // **/*.<left><left><left><left><left><left><left>

" Vimgrep in the current file
map <leader><space> :vimgrep // <C-R>%<C-A><right><right><right><right><right><right><right><right><right>

"" Make
map <Leader>mm :make<CR>
map <Leader>mc :make clean<CR>
map <Leader>md :make distclean<CR>

""LaTeX  \tex builds latex file
map <Leader>tex :!pdflatex %<CR>
cnoremap texmake :make<CR> touch %<CR> make<CR>
" C++ \cpp builds C++ file with no extension, using g++
map <Leader>cpp :!g++ % -o %:r<CR>
" C \gcc builds C file with no extensions, using gcc
map <Leader>gcc :!gcc % -o %:r<CR>

"" Git commands (Uses command line mode ":")
command Add normal! :!git add %<CR>
command Commit normal! :!git commit<CR>
command Push normal! :!git push<CR>
command Log normal! :!git log --graph --oneline --decorate<CR>
command Pull normal! :!git pull<CR>
command Status normal! :!git status<CR>

" Turn into a hex editor
command Hex normal! :%!xxd<CR>
