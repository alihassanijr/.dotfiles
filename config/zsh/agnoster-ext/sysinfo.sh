# System-info segments: who/where am I, plus static hardware facts. Expensive
# or constant values are cached in _omz_cache_warm (see tmux.sh); these
# functions only render.

# TODO(ali): i actually don't remember this... why do we need this rule?
# ignoring for now
# User / host / gpu show only for non-default users or over SSH -- the original
# agnoster context rule, kept here so splitting it into separate segments does
# not change when they appear.
_omz_context_visible() {
  [[ "${_OMZ_USER:-$(whoami)}" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]
}

# Username.
prompt_user() {
  #_omz_context_visible || return
  local user_disp
  user_disp=$(truncate_end "${_OMZ_USER:-$(whoami)}" "${OMZ_MAX_USER_LENGTH:-10}")
  prompt_segment "#21262d" white "%(!.%{%F{#ffffff}%}.)$user_disp"
}

# Hostname.
prompt_host() {
  #_omz_context_visible || return
  local host_disp
  host_disp=$(truncate_middle "${_OMZ_HOST:-${(%):-%m}}" "${OMZ_MAX_HOST_LENGTH:-20}")
  prompt_segment "#77bdfb" black "%(!.%{%F{#000000}%}.)$host_disp"
}

# NVIDIA GPU name (only on GPU machines).
prompt_nvgpu() {
  #_omz_context_visible || return
  [[ $HAS_NV_SMI = 1 ]] || return
  prompt_segment "#1e4839" white "%(!.%{%F{#ffffff}%}.)${_OMZ_NV_NAME:-$NV_NAME}"
}

# Cpu count, e.g. "nproc=12". Skipped when nproc is unavailable (empty cache).
prompt_nproc() {
  [[ -n $_OMZ_NPROC ]] && prompt_segment "#3d2d52" white "nproc=$_OMZ_NPROC"
}

# Cpu architecture (uname -m), e.g. arm64 / x86_64.
prompt_arch() {
  [[ -n $_OMZ_ARCH ]] && prompt_segment "#264b5d" white "$_OMZ_ARCH"
}
