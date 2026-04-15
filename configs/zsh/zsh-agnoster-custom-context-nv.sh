# Context for machines with an NVIDIA GPU
# User, hostname, and NVIDIA GPU name

prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment "#21262d" white "%(!.%{%F{#ffffff}%}.)$user"
    prompt_segment "#77bdfb" black "%(!.%{%F{#000000}%}.)%m"
    prompt_segment "#1e4839" white "%(!.%{%F{#ffffff}%}.)$NV_NAME"
  fi
}
