# Custom git prompt with timeouts, branch name / head truncation, and more.
# Git: branch/detached head, dirty status

prompt_git() {
  local ref dirty

  OMZ_MAX_GIT_REF_LENGTH=${OMZ_MAX_GIT_REF_LENGTH:-50}

  # (ali): timeout limit on ALL git-related stuff
  OMZ_GIT_TIMEOUT=${OMZ_GIT_TIMEOUT:-1}
  timeout ${OMZ_GIT_TIMEOUT}s git rev-parse --is-inside-work-tree >/dev/null 2>&1
  exit_status=$?

  if [ "$exit_status" -eq 124 ]; then
    # Unclear if this is a git repo or not; light red bg
    # This is very unlikely
    prompt_segment "#fa7970" "#000000"
    echo -n " ⚠"
    return

  elif [ "$exit_status" -ne 0 ]; then
    # Not a girt repo; skip
  else
    # Git repo

    # Dirty status
    ZSH_THEME_GIT_PROMPT_DIRTY='±'
    dirty=$(parse_git_dirty)
    exit_status_dirty=$?
    if [ "$exit_status_dirty" -ne 0 ]; then
      # Dirty status unclear; red bg
      prompt_segment "#7b0c04" "#ffffff"
    elif [[ -n $dirty ]]; then
      # Dirty; orange bg
      prompt_segment "#faa356" "#161b22"
    else
      # Clean; white bg
      prompt_segment white black
    fi

    # Ref / head name
    ref=$(timeout ${OMZ_GIT_TIMEOUT}s git symbolic-ref HEAD 2> /dev/null) || 
      ref="➦ $(timeout ${OMZ_GIT_TIMEOUT}s sh -c
          'git show-ref --head -s --abbrev | head -n1' 2> /dev/null)"
    exit_status_ref=$?

    if [ "$exit_status_ref" -ne 0 ]; then
      echo -n "⚔ $dirty"
    else
      final_ref="${ref/refs\/heads\//⭠ }"
      final_ref="${final_ref:0:$OMZ_MAX_GIT_REF_LENGTH}"
      echo -n "$final_ref$dirty"
    fi
  fi
}
