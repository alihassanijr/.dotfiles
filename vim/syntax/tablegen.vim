" Vim syntax file
" Language:   TableGen
" Maintainer: The LLVM team, http://llvm.org/
" Version:    $Revision$

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" May be changed if you have a really slow machine
syntax sync minlines=100

syn case match

syn keyword tgKeyword   def let in code dag field include defm foreach defset defvar if then else assert dump
syn keyword tgType      class int string list bit bits multiclass

syn match   tgNumber    /\<\d\+\>/
syn match   tgNumber    /\<\d\+\.\d*\>/
syn match   tgNumber    /\<0b[01]\+\>/
syn match   tgNumber    /\<0x[0-9a-fA-F]\+\>/
syn region  tgString    start=/"/ skip=/\\"/ end=/"/    oneline

syn region  tgCode      start=/\[{/ end=/}\]/

" (ali): detect cpp-like preprocessor macros (#ifndef, #define, ...)
syn match   tgPreProc   /^\s*#\(define\|undef\|include\|if\|ifdef\|ifndef\|elif\|else\|endif\|error\|warning\|pragma\)\>.*/ contains=@NoSpell

" (ali): match (not keyword) + @NoSpell so TODO/FIXME aren't spell-underlined
syn match   tgTodo      contained /\<\(TODO\|FIXME\)\>/ contains=@NoSpell
syn match   tgComment   /\/\/.*$/         contains=tgTodo
" Handle correctly imbricated comment
syn region  tgComment2 matchgroup=tgComment2  start=+/\*+ end=+\*/+ contains=tgTodo,tgComment2

if version >= 508 || !exists("did_c_syn_inits")
  if version < 508
    let did_c_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  " (ali): choose better colors for my ghdark.vim
  " HiLink tgKeyword Statement
  " HiLink tgType Type
  " HiLink tgNumber Number
  " HiLink tgComment Comment
  " HiLink tgComment2 Comment
  " HiLink tgString String
  " " May find a better Hilight group...
  " HiLink tgCode Special
  " HiLink tgTodo Todo
  HiLink tgKeyword GhGreen
  HiLink tgType GhRed
  HiLink tgNumber GhOrange
  HiLink tgComment GhBase3
  HiLink tgComment2 Todo
  HiLink tgString GhLightBlue
  HiLink tgCode GhPurp
  " (ali): cpp-like preprocessor macros, blue (cpp PreProc equivalent)
  HiLink tgPreProc GhBlue
  HiLink tgTodo Todo

  delcommand HiLink
endif

let b:current_syntax = "tablegen"
