# Route agnoster segments between the inline PROMPT and the tmux pane title,
# and mirror colors into the title.
#
# Every segment can render in BOTH targets: prompt_segment/prompt_end below
# branch on _TMUX_MODE to emit either zsh prompt escapes (inline) or tmux
# "#[fg=,bg=]" directives (title). On top of that, build_prompt classifies
# each segment to a destination (prompt | tmux | both) via the OMZ_DEST_*
# knobs, so where a segment shows is independent of how it draws.
#
# build_prompt runs once per target:
#   - inline:  $(build_prompt)            (theme PROMPT, _TMUX_MODE unset)
#   - title:   _TMUX_MODE=1 build_prompt  (precmd, OSC 2)
# A segment routed to one target is skipped in the other, so nothing is
# computed twice.
#
# When no tmux is detected the title pass never runs and every segment falls
# back to the inline prompt -- i.e. the original behavior.

### Feature switch ###########################################################
# Master on/off for the tmux-title feature (set in zshrc). When 0, the title
# is left alone and every segment renders inline -- exactly the no-tmux path.
: ${OMZ_TMUX_TITLE:=1}

# Is the feature producing a title right now? True when enabled and the bytes
# can reach a local tmux: either we're inside a tmux, or $REMOTE_TMUX=1 -- a
# contract you opt into on a remote host to say "a tmux is listening up the
# ssh pipe", so a remote shell's title bounces up to the local tmux border.
#
# NOTE: a *remote* tmux still swallows the title instead of forwarding it, so
# `tmux local -> ssh -> tmux remote` doesn't bounce yet. Crossing a nested
# remote tmux needs passthrough -- TODO.
_omz_tmux_active() {
  [[ $OMZ_TMUX_TITLE == 1 ]] || return 1
  [[ -n $TMUX || $REMOTE_TMUX == 1 ]]
}

# Segment destinations (OMZ_DEST_*) are defined in init.sh -- the one place to
# choose what goes inline vs the tmux title. Meanings:
#   prompt   = inline only
#   tmux     = pane title; falls back to inline when there's no tmux
#   tmuxonly = pane title; hidden entirely when there's no tmux
#   both     = everywhere

# Should a segment with destination $1 draw in the current pass?
_omz_route() {
  if ! _omz_tmux_active; then
    # Feature off or no tmux: tmux-only segments vanish; rest renders inline.
    [[ $1 == tmuxonly ]] && return 1
    [[ -z $_TMUX_MODE ]]
    return
  fi
  case $1 in
    both)          return 0 ;;
    tmux|tmuxonly) [[ -n $_TMUX_MODE ]] ;;
    *)             [[ -z $_TMUX_MODE ]] ;;   # prompt (default)
  esac
}

# Draw segment function $2 only if its destination $1 matches this pass.
_omz_seg() { _omz_route "$1" && "$2"; }

# Classification layer. Same order as the stock theme; reroute by setting
# the OMZ_DEST_* vars above.
build_prompt() {
  RETVAL=$?
  _omz_seg "$OMZ_DEST_STATUS"     prompt_status
  _omz_seg "$OMZ_DEST_VIRTUALENV" prompt_virtualenv
  _omz_seg "$OMZ_DEST_AWS"        prompt_aws
  _omz_seg "$OMZ_DEST_USER"       prompt_user
  _omz_seg "$OMZ_DEST_HOST"       prompt_host
  _omz_seg "$OMZ_DEST_NVGPU"      prompt_nvgpu
  _omz_seg "$OMZ_DEST_NPROC"      prompt_nproc
  _omz_seg "$OMZ_DEST_ARCH"       prompt_arch
  _omz_seg "$OMZ_DEST_DIR"        prompt_dir
  _omz_seg "$OMZ_DEST_GIT"        prompt_git
  _omz_seg "$OMZ_DEST_VCS"        prompt_bzr
  _omz_seg "$OMZ_DEST_VCS"        prompt_hg
  prompt_end
}

### Cached static facts ######################################################
# build_prompt runs inside subshells, which cannot persist a cache, so the
# slow facts are computed once in a precmd (main shell) and the segments read
# the cached vars. Invalidate with `prompt_cache_clear` to force a refresh.
_omz_cache_warm() {
  [[ -n $_OMZ_USER ]] || typeset -g _OMZ_USER=$(whoami)
  [[ -n $_OMZ_HOST ]] || typeset -g _OMZ_HOST=${(%):-%m}
  [[ -n $_OMZ_ARCH ]] || typeset -g _OMZ_ARCH=$(uname -m)
  # nproc isn't everywhere; leave the cache empty (segment skips) if missing.
  if (( $+commands[nproc] )); then
    [[ -n $_OMZ_NPROC ]] || typeset -g _OMZ_NPROC=$(nproc)
  fi
  if [[ $HAS_NV_SMI = 1 ]]; then
    [[ -n $_OMZ_NV_NAME ]] || typeset -g _OMZ_NV_NAME=$NV_NAME
  fi
}

# Drop cached facts so the next prompt recomputes them. With no args, clears
# all of them; otherwise clears the named vars (e.g. prompt_cache_clear _OMZ_HOST).
prompt_cache_clear() {
  if (( $# )); then
    unset "$@"
  else
    unset _OMZ_USER _OMZ_HOST _OMZ_NV_NAME _OMZ_NPROC _OMZ_ARCH
  fi
}

### Color / escape helpers ###################################################
# Map an agnoster color (name, #hex, or empty) to a tmux color.
# tmux accepts the same 8 base names and #rrggbb; empty -> default.
_omz_tmux_color() {
  [[ -n $1 ]] && print -rn -- "$1" || print -rn -- default
}

# Strip zsh prompt escapes from segment text, leaving only visible chars.
# Handles %F{..}/%K{..}, single-char flags (%f %k %b ..), %{ %}, and
# %(..) ternaries. Colors are carried by the tmux directives instead.
_omz_strip_prompt() {
  setopt localoptions extendedglob
  local s=$1
  s=${s//\%[FK]\{[^\}]#\}/}
  s=${s//\%[fkbBuUsSeES]/}
  s=${s//(\%\{|\%\})/}
  s=${s//\%\([^\)]#\)/}
  print -rn -- "$s"
}

### Dual-mode segment primitives ############################################
# Re-define the segment primitives to branch on _TMUX_MODE. The non-tmux
# path is the original agnoster behavior, verbatim, so the inline prompt
# is unchanged.
prompt_segment() {
  if [[ -n $_TMUX_MODE ]]; then
    local tbg tfg
    tbg=$(_omz_tmux_color "$1")
    tfg=$(_omz_tmux_color "$2")
    if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
      local tprev=$(_omz_tmux_color "$CURRENT_BG")
      echo -n " #[fg=${tprev},bg=${tbg}]${SEGMENT_SEPARATOR}#[fg=${tfg},bg=${tbg}] "
    else
      echo -n "#[fg=${tfg},bg=${tbg}] "
    fi
    CURRENT_BG=$1
    [[ -n $3 ]] && echo -n "$(_omz_strip_prompt "$3")"
    return
  fi

  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

prompt_end() {
  if [[ -n $_TMUX_MODE ]]; then
    if [[ -n $CURRENT_BG ]]; then
      echo -n " #[fg=$(_omz_tmux_color "$CURRENT_BG"),bg=default]${SEGMENT_SEPARATOR}#[default]"
    else
      echo -n "#[default]"
    fi
    CURRENT_BG=''
    return
  fi

  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Title emission ###########################################################
# Push string $1 to the pane title as OSC 2, choosing how it reaches the
# *local* tmux:
#   - inside a remote tmux ($REMOTE_TMUX=1 && $TMUX): wrap in tmux passthrough
#     so the remote tmux spits it outward, up the ssh pipe, to the local tmux
#     -- the "bounceback". Needs `set -g allow-passthrough on` on the remote.
#   - otherwise: plain OSC 2 (local tmux consumes it, or it rides a transparent
#     ssh pipe up to the local tmux).
_omz_emit_title() {
  local osc=$'\e]2;'"$1"$'\e\\'
  print -rn -- "$osc"
  if [[ $REMOTE_TMUX == 1 && -n $TMUX ]]; then
    # tmux passthrough: ESC P tmux ; <payload, every ESC doubled> ESC \
    osc=${osc//$'\e'/$'\e\e'}
    print -rn -- $'\ePtmux;'"$osc"$'\e\\'
  fi
}

# Render the prompt in tmux mode and push it to the pane title.
# (exit $_ret) restores the just-finished command's status so prompt_status
# still renders the error mark in the title.
_omz_tmux_set_title() {
  local _ret=$?
  _omz_tmux_active || return
  local title
  title=$( (exit $_ret); _TMUX_MODE=1 build_prompt )
  _omz_emit_title "$title"
}

# On shell exit, blank the pane title so the last prompt doesn't linger on the
# tmux border after the shell is gone.
#
# zsh fires zshexit for command-substitution subshells too (every $(build_prompt)
# in PROMPT and in the title precmd), so guard on ZSH_SUBSHELL==0 -- otherwise
# the clear sequence leaks into the captured prompt/title and blanks the title
# on every command.
_omz_tmux_clear_title() {
  [[ $ZSH_SUBSHELL == 0 ]] || return
  _omz_tmux_active || return
  _omz_emit_title ""
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _omz_cache_warm       # warm cache before either build
add-zsh-hook precmd _omz_tmux_set_title
add-zsh-hook zshexit _omz_tmux_clear_title

# Stop mini-omz termsupport from overwriting the pane title each
# prompt/command (see lib/termsupport.zsh).
DISABLE_AUTO_TITLE=true
