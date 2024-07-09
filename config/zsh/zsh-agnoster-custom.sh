# Ali's modifications to agnoster colors

# Custom colors for agnoster theme
prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment "#21262d" white "%(!.%{%F{#ecf2f8}%}.)$user"
    prompt_segment "#77bdfb" black "%(!.%{%F{#77bdfb}%}.)%m"
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
      prompt_segment "#faa356" "#161b22"
    else
      prompt_segment white black
    fi
    echo -n "${ref/refs\/heads\//⭠ }$dirty"
  fi
}
prompt_dir() {
  prompt_segment "#fa7970" black '%~'
}
