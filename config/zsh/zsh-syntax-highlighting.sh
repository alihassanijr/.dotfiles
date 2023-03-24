# Sort of Monokai
# Based on:
# Dracula Theme (for zsh-syntax-highlighting)
#
# https://github.com/zenorocha/dracula-theme
#
# Copyright 2021, All rights reserved
#
# Code licensed under the MIT license
# http://zenorocha.mit-license.org
#
# @author George Pickering <@bigpick>
# @author Zeno Rocha <hi@zenorocha.com>
# Paste this files contents inside your ~/.zshrc before you activate zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main cursor)
typeset -gA ZSH_HIGHLIGHT_STYLES
# Default groupings per, https://spec.draculatheme.com, try to logically separate
# possible ZSH_HIGHLIGHT_STYLES settings accordingly...?
#
# Italics not yet supported by zsh; potentially soon:
#    https://github.com/zsh-users/zsh-syntax-highlighting/issues/432
#    https://www.zsh.org/mla/workers/2021/msg00678.html
# ... in hopes that they will, labelling accordingly with ,italic where appropriate
#
# Main highlighter styling: https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md
#
## General
### Diffs
### Markup
## Classes
## Comments
ZSH_HIGHLIGHT_STYLES[comment]='fg=#6272A4'
## Constants
## Entitites
## Functions/methods
ZSH_HIGHLIGHT_STYLES[alias]='fg=#a9dc76'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#a9dc76'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#a9dc76'
ZSH_HIGHLIGHT_STYLES[function]='fg=#a9dc76'
ZSH_HIGHLIGHT_STYLES[command]='fg=#a9dc76'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#a9dc76,italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#fe925b,italic'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#fe925b'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#fe925b'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#ab9df2'

## Keywords
## Built ins
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#4adfea'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#4adfea'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#4adfea'
## Punctuation
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#ff79c6'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#fffaeb'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#fffaeb'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#fffaeb'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#ff79c6'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#ff79c6'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#ff79c6'

## Serializable / Configuration Languages
## Storage
## Strings
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#ffd866'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#ffd866'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#ffd866'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#ff6188'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#ffd866'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#ff6188'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#ffd866'

## Variables
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#fffaeb'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#ff6188'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#fffaeb'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#fffaeb'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#fffaeb'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#fffaeb'

## No category relevant in spec
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#ff6188'
ZSH_HIGHLIGHT_STYLES[path]='fg=#fffaeb'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#ff79c6'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#fffaeb'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#ff79c6'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#fffaeb'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#ab9df2'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#ff6188'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#fffaeb'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#fffaeb'
ZSH_HIGHLIGHT_STYLES[default]='fg=#fffaeb'
ZSH_HIGHLIGHT_STYLES[cursor]='standout'
