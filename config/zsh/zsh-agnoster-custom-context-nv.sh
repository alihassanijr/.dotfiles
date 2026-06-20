# Context for machines with an NVIDIA GPU
# User, hostname, and NVIDIA GPU name

prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    local user_disp host_disp
    user_disp=$(truncate_end "$user" "${OMZ_MAX_USER_LENGTH:-10}")
    host_disp=$(truncate_middle "${(%):-%m}" "${OMZ_MAX_HOST_LENGTH:-20}")
    prompt_segment "#21262d" white "%(!.%{%F{#ffffff}%}.)$user_disp"
    prompt_segment "#77bdfb" black "%(!.%{%F{#000000}%}.)$host_disp"
    prompt_segment "#1e4839" white "%(!.%{%F{#ffffff}%}.)$NV_NAME"
  fi
}
