# Shared truncation helpers for agnoster custom prompt segments.
# All functions print to stdout; total output length stays within max.
# Ellipsis marker is a single character (U+2026) for compactness.

OMZ_TRUNC_ELLIPSIS=${OMZ_TRUNC_ELLIPSIS:-…}

# Truncate at end with ellipsis: "longusername" max=10 -> "longuser…"
truncate_end() {
  local s=$1
  local max=$2
  local len=${#s}
  if (( max <= 0 || len <= max )); then
    echo -n "$s"
    return
  fi
  if (( max <= 1 )); then
    echo -n "${s:0:$max}"
    return
  fi
  local keep=$(( max - 1 ))
  echo -n "${s:0:$keep}${OMZ_TRUNC_ELLIPSIS}"
}

# Truncate at start with ellipsis: "/a/very/long/path" max=10 -> "…ery/long/path" trimmed
truncate_start() {
  local s=$1
  local max=$2
  local len=${#s}
  if (( max <= 0 || len <= max )); then
    echo -n "$s"
    return
  fi
  if (( max <= 1 )); then
    echo -n "${s[-$max,-1]}"
    return
  fi
  local keep=$(( max - 1 ))
  echo -n "${OMZ_TRUNC_ELLIPSIS}${s[-$keep,-1]}"
}

# Truncate in middle with ellipsis: "/a/very/long/path" max=10 -> "/a/ve…path"
truncate_middle() {
  local s=$1
  local max=$2
  local len=${#s}
  if (( max <= 0 || len <= max )); then
    echo -n "$s"
    return
  fi
  if (( max <= 1 )); then
    echo -n "${s:0:$max}"
    return
  fi
  local keep=$(( max - 1 ))
  local pre=$(( (keep + 1) / 2 ))
  local suf=$(( keep - pre ))
  if (( suf <= 0 )); then
    echo -n "${s:0:$pre}${OMZ_TRUNC_ELLIPSIS}"
  else
    echo -n "${s:0:$pre}${OMZ_TRUNC_ELLIPSIS}${s[-$suf,-1]}"
  fi
}
