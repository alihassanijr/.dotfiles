#!/usr/bin/env bash
# Syntax-check every shell script in the repo (`make check`).
# Author: Ali Hassani (@alihassanijr)
#
# Runs `<shell> -n` on every *.sh file, picking the shell from the shebang;
# shebang-less files under config/zsh/ are zsh, anything else defaults to bash.
# Skips .git and the installer's tmp_* build dirs. Exits 1 if anything fails.

cd "$(dirname "$0")/.." || exit 1
source installer/colors.sh

shell_for() {
  local FILE=$1 FIRST_LINE
  IFS= read -r FIRST_LINE < "$FILE"
  case "$FIRST_LINE" in
    '#!'*bash*) echo bash ;;
    '#!'*zsh*)  echo zsh ;;
    '#!'*sh*)   echo sh ;;
    *) case "$FILE" in */zsh/*) echo zsh ;; *) echo bash ;; esac ;;
  esac
}

PASS=0 FAIL=0 SKIP=0
while IFS= read -r FILE; do
  SHELL_NAME=$(shell_for "$FILE")
  if ! command -v "$SHELL_NAME" >/dev/null 2>&1; then
    warn "SKIP $FILE ($SHELL_NAME not found)"
    SKIP=$((SKIP + 1))
    continue
  fi
  if OUT=$("$SHELL_NAME" -n "$FILE" 2>&1); then
    PASS=$((PASS + 1))
  else
    err "FAIL $FILE"
    printf '%s\n' "$OUT"
    FAIL=$((FAIL + 1))
  fi
done < <(find . -path ./.git -prune -o -name 'tmp_*' -prune -o -name '*.sh' -print | sort)

echo ""
if [[ $FAIL -eq 0 ]]; then
  ok "check: $PASS passed, $SKIP skipped, 0 failed"
else
  err "check: $PASS passed, $SKIP skipped, $FAIL failed"
  exit 1
fi
