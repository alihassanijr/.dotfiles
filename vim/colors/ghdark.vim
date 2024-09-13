if version > 580
    hi clear
    if exists('syntax_on')
        syntax reset
    endif
endif

let g:colors_name='ghdark'

let g:github_colors = {
  \ "base0"        : ["#0d1117", 233],
  \ "base1"        : ["#161b22", 235],
  \ "base2"        : ["#21262d", 237],
  \ "base3"        : ["#89929b", 243],
  \ "base4"        : ["#c6cdd5", 249],
  \ "base5"        : ["#ecf2f8", 252],
  \ "red"          : ["#fa7970", 210],
  \ "orange"       : ["#faa356", 178],
  \ "green"        : ["#7ce38b", 114],
  \ "lightblue"    : ["#a2d2fb", 153],
  \ "blue"         : ["#77bdfb", 75],
  \ "darkblue"     : ["#0887f7", 27],
  \ "white"        : ["#ffffff", 255],
  \ "purp"         : ["#cea5fb", 183],
  \ "darkpurp"     : ["#963cf6", 54],
  \ "darkgreen"    : ["#1e4839", 28],
  \ "grey"         : ["#525960", 241],
  \ "verydarkblue" : ["#033663", 18],
  \ "darkred"      : ["#7b0c04", 52],
  \ "none"         : ["NONE", "NONE"]
  \ }

" if doesn't support termguicolors or < 256 colors exit
if !(has('termguicolors') && &termguicolors) && !has('gui_running') && &t_Co != 256
  finish
endif

"########################################
" Terminal colors for NeoVim

if has('nvim')
    let g:terminal_color_0 = g:github_colors["base0"][0]
    let g:terminal_color_8 = g:github_colors["base3"][0]

    let g:terminal_color_1 = g:github_colors["red"][0]
    let g:terminal_color_9 = g:github_colors["red"][0]

    let g:terminal_color_2 = g:github_colors["green"][0]
    let g:terminal_color_10 = g:github_colors["green"][0]

    let g:terminal_color_3 = g:github_colors["orange"][0]
    let g:terminal_color_11 = g:github_colors["orange"][0]

    let g:terminal_color_4 = g:github_colors["blue"][0]
    let g:terminal_color_12 = g:github_colors["lightblue"][0]

    let g:terminal_color_5 = g:github_colors["purp"][0]
    let g:terminal_color_13 = g:github_colors["purp"][0]

    let g:terminal_color_6 = g:github_colors["blue"][0]
    let g:terminal_color_14 = g:github_colors["lightblue"][0]

    let g:terminal_color_7 = g:github_colors["base4"][0]
    let g:terminal_color_15 = g:github_colors["base5"][0]
endif

" Terminal colors for Vim
if has('*term_setansicolors')
    let g:terminal_ansi_colors = repeat([0], 16)

    let g:terminal_ansi_colors[0] = g:github_colors["base0"][0]
    let g:terminal_ansi_colors[8] = g:github_colors["base3"][0]

    let g:terminal_ansi_colors[1] = g:github_colors["red"][0]
    let g:terminal_ansi_colors[9] = g:github_colors["red"][0]

    let g:terminal_ansi_colors[2] = g:github_colors["green"][0]
    let g:terminal_ansi_colors[10] = g:github_colors["green"][0]

    let g:terminal_ansi_colors[3] = g:github_colors["orange"][0]
    let g:terminal_ansi_colors[11] = g:github_colors["orange"][0]

    let g:terminal_ansi_colors[4] = g:github_colors["blue"][0]
    let g:terminal_ansi_colors[12] = g:github_colors["lightblue"][0]

    let g:terminal_ansi_colors[5] = g:github_colors["purp"][0]
    let g:terminal_ansi_colors[13] = g:github_colors["purp"][0]

    let g:terminal_ansi_colors[6] = g:github_colors["blue"][0]
    let g:terminal_ansi_colors[14] = g:github_colors["lightblue"][0]

    let g:terminal_ansi_colors[7] = g:github_colors["base4"][0]
    let g:terminal_ansi_colors[15] = g:github_colors["base5"][0]
endif

if !exists("g:gh_color")
    let g:gh_color = "hard"
endif

if g:gh_color ==# "soft"
    let g:github_colors["base0"] = g:github_colors["base1"]
    let g:github_colors["base1"] = g:github_colors["base2"]
    let g:github_colors["base2"] = ["#30353c", 238]
endif

"########################################
" funcs

function! s:ghhl(group, guifg, ...)
    " Arguments: group, guifg, guibg, style

    let fg = g:github_colors[a:guifg]

    if a:0 >= 1
        let bg = g:github_colors[a:1]
    else
        let bg = g:github_colors["none"]
    endif

    if a:0 >= 2
        let style = a:2
    else
        let style = "NONE"
    endif

    let hi_str = [ "hi", a:group,
            \ 'guifg=' . fg[0], "ctermfg=" . fg[1],
            \ 'guibg=' . bg[0], "ctermbg=" . bg[1],
            \ 'gui=' . style, "cterm=" . style
            \ ]

    execute join(hi_str, ' ')
endfunction

"########################################
" clear any previous highlighting and syntax

let s:t_Co = exists('&t_Co') && !empty(&t_Co) && &t_Co > 1 ? &t_Co : 2

"########################################
" set the colors
"
call s:ghhl("GhBase0", "base0")
call s:ghhl("GhBase1", "base1")
call s:ghhl("GhBase2", "base2")
call s:ghhl("GhBase3", "base3")
call s:ghhl("GhBase4", "base4")
call s:ghhl("GhBase5", "base5")
call s:ghhl("GhRed", "red")
call s:ghhl("GhRedItalic", "red", "none", "italic")
call s:ghhl("GhPurp", "purp")
call s:ghhl("GhPurpUnder", "purp", "none", "underline")
call s:ghhl("GhBlue", "blue")
call s:ghhl("GhBlueUnder", "blue", "none", "underline")
call s:ghhl("GhBlueBold", "blue", "none", "bold")
call s:ghhl("GhBlueItalic", "blue", "none", "italic")
call s:ghhl("GhOrange", "orange")
call s:ghhl("GhOrangeBold", "orange", "none", "bold")
call s:ghhl("GhLightBlue", "lightblue")
call s:ghhl("GhGreen", "green")
call s:ghhl("GhUnder", "none", "none", "underline")
call s:ghhl("GhBold", "none", "none", "bold")
call s:ghhl("GhItalic", "none", "none", "italic")

call s:ghhl("Cursor", "base4", "none", "reverse")
call s:ghhl("iCursor", "base0", "red")
call s:ghhl("vCursor", "base0", "purp")
call s:ghhl("CursorColumn", "none", "base1")
call s:ghhl("CursorLine", "none", "base1")
call s:ghhl("CursorLineNr", "lightblue", "base2")
"call s:ghhl("DiffAdd", "none", "green")
"call s:ghhl("DiffChange", "none", "orange")
"call s:ghhl("DiffDelete", "none", "red")
call s:ghhl("ErrorMsg", "red", "base1")
call s:ghhl("Error", "none", "red")
call s:ghhl("Folded", "blue", "base1")
call s:ghhl("FoldColumn", "green", "base3")
call s:ghhl("MatchParen", "darkgreen", "base4", "underline")
call s:ghhl("Normal", "base5", "base0")
call s:ghhl("Pmenu", "base4", "base1")
call s:ghhl("PmenuSel", "base4", "base2")
call s:ghhl("Search", "white", "darkblue", "bold")
call s:ghhl("CurSearch", "white", "darkpurp", "bold")
call s:ghhl("SignColumn", "none", "base0")
call s:ghhl("StatusLine", "base5", "base2")
call s:ghhl("StatusLineNC", "base3", "base1")
call s:ghhl("Todo", "white", "orange", "bold")
call s:ghhl("VertSplit", "base1", "base1")
call s:ghhl("Visual", "none", "base0", "reverse")
call s:ghhl("WarningMsg", "orange", "base1")


call s:ghhl("ColorColumn", "base0", "base3")


call s:ghhl("DiffChange", "none", "base2")
call s:ghhl("DiffText", "none", "grey", "bold")

call s:ghhl("DiffAdd", "none", "darkgreen")

call s:ghhl("DiffDelete", "none", "red")

call s:ghhl("diffAdded", "none", "darkgreen")
call s:ghhl("diffRemoved", "none", "darkred")
call s:ghhl("diffLine", "none", "base2", "bold")
call s:ghhl("diffIndexLine", "none", "darkpurp", "bold")

call s:ghhl("diffFile", "none", "darkred", "bold")
call s:ghhl("diffSubname", "none", "darkpurp", "bold")

"########################################
" links

hi! link Boolean Constant
hi! link Character Constant
hi! link Comment GhBase3
hi! link Conceal Ignore
hi! link Conditional Statement
hi! link Constant GhLightBlue
hi! link Debug Special
hi! link Define PreProc
hi! link Delimiter GhBase5
hi! link Directory GhBlue
hi! link Exception Statement
hi! link Float Number
hi! link FunctionDef Function
hi! link Function GhPurp
hi! link Identifier GhBlue
hi! link Include Statement
hi! link IncSearch CurSearch
hi! link Keyword GhRed
hi! link Label GhBlue
hi! link LibraryFunc Function
hi! link LibraryIdent Identifier
hi! link LibraryType Type
hi! link LineNr GhBase3
hi! link LocalFunc Function
hi! link LocalIdent Identifier
hi! link LocalType Type
hi! link Macro PreProc
hi! link ModeMsg GhBase4
hi! link MoreMsg GhBase4
hi! link MsgArea Title
hi! link Noise Delimiter
hi! link NonText GhBase3
hi! link NonText Ignore
hi! link Number GhOrange
hi! link Operator GhBlue
hi! link PreCondit PreProc
hi! link PreProc GhBlue
hi! link Question GhBase4
hi! link Quote StringDelimiter
hi! link Repeat GhPurp
hi! link Searchlight CurSearch
hi! link SignifySignAdd Signify
hi! link SignifySignChange Signify
hi! link SignifySignDelete Signify
hi! link SpecialChar Special
hi! link Special GhBlue
hi! link SpecialKey GhBase3
hi! link SpecialKey Ignore
hi! link Statement GhRed
hi! link StatusLineTermNC StatusLineNC
hi! link StatusLineTerm StatusLine
hi! link StorageClass GhRed
hi! link String Constant
hi! link StringDelimiter String
hi! link Structure GhGreen
hi! link TabLineFill StatusLineNC
hi! link TabLineSel StatusLine
hi! link TabLine StatusLineNC
hi! link Tag Special
hi! link Terminal Normal
hi! link Title GhBase4
hi! link Type GhRed


""" alih:
""" Underscore misspelled words, don't ever highlight
hi! clear SpellBad
hi! link SpellBad GhRed
hi! link SpellCap GhRed
hi! link SpellLocal GhOrange
hi! link SpellRare GhOrange
