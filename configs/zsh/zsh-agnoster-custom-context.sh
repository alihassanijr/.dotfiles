# Default context
# Just user and hostname

prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment "#21262d" white "%(!.%{%F{#ffffff}%}.)$user"
    prompt_segment "#77bdfb" black "%(!.%{%F{#000000}%}.)%m"
  fi
}
