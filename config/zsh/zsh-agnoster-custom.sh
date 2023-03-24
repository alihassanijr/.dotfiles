# Ali's modifications to agnoster colors

# Custom colors for agnoster theme
prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment "#fd5188" black "%(!.%{%F{#ffd866}%}.)$user"
    prompt_segment "#a9dc76" black "%(!.%{%F{#ffd866}%}.)%m"
  fi
}
# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    ZSH_THEME_GIT_PROMPT_DIRTY='±'
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment "#ffd866" black
    else
      prompt_segment white black
    fi
    echo -n "${ref/refs\/heads\//⭠ }$dirty"
  fi
}
prompt_dir() {
  prompt_segment "#fe925b" black '%~'
}
