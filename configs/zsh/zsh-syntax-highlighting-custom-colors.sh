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
ZSH_HIGHLIGHT_STYLES[alias]='fg=#77bdfb'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#77bdfb'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#77bdfb'
ZSH_HIGHLIGHT_STYLES[function]='fg=#77bdfb'
ZSH_HIGHLIGHT_STYLES[command]='fg=#77bdfb'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#77bdfb,italic'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=#faa356,italic'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#faa356'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#faa356'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#963cf6'

## Keywords
## Built ins
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#7ce38b'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#7ce38b'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=#7ce38b'
## Punctuation
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#ab9df2'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#ecf2f8'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#ecf2f8'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#ecf2f8'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=#ab9df2'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#ab9df2'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#ab9df2'

## Serializable / Configuration Languages
## Storage
## Strings
ZSH_HIGHLIGHT_STYLES[command-substitution-quoted]='fg=#a2d2fb'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#a2d2fb'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#a2d2fb'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]='fg=#fa7970'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#a2d2fb'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]='fg=#fa7970'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=#a2d2fb'

## Variables
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#ecf2f8'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument-unclosed]='fg=#fa7970'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=#ecf2f8'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#ecf2f8'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#ecf2f8'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#ecf2f8'

## No category relevant in spec
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#fa7970'
ZSH_HIGHLIGHT_STYLES[path]='fg=#ecf2f8'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]='fg=#ab9df2'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#ecf2f8'
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]='fg=#ab9df2'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#ecf2f8'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=#963cf6'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-unclosed]='fg=#fa7970'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#ecf2f8'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#ecf2f8'
ZSH_HIGHLIGHT_STYLES[default]='fg=#ecf2f8'
ZSH_HIGHLIGHT_STYLES[cursor]='standout'
