#!/bin/sh
# Fail-closed wrapper for guard.py.
# - Interpreter is the system python3 only, absolute path, never PATH.
# - -I isolated mode: ignores PYTHON* env vars, no user site dir, no cwd on sys.path.
# - -S: skip the site module, so no sitecustomize/usercustomize can run.
# - Strict watchdog in this script, independent of python: /bin/sleep + kill. Claude
#   Code's own hook timeout is fail-open (the tool call continues), so this fires first.
# - Only shell builtins plus /bin/sleep by absolute path; nothing from PATH.
# - Any failure (no interpreter, crash, bad stdin, timeout) -> exit 2 -> Claude Code
#   blocks and shows the stderr message. Never falls back to ask.

PYTHONS="/usr/bin/python3 /bin/python3"
LIMIT=10

case $0 in
  */*) here=${0%/*} ;;
  *)   here=. ;;
esac

py=
for candidate in $PYTHONS; do
  if [ -x "$candidate" ]; then
    py=$candidate
    break
  fi
done
if [ -z "$py" ]; then
  echo "DENIED by guard hook: no system python3 at $PYTHONS" >&2
  exit 2
fi

# Slurp stdin with builtins; a background job would otherwise get /dev/null as stdin.
input=
while IFS= read -r line || [ -n "$line" ]; do
  input="$input$line
"
done

printf '%s' "$input" | "$py" -I -S "$here/guard.py" &
pid=$!

# Watchdog. Its stdout/stderr go to /dev/null: if it inherited the hook's stdout, the
# lingering sleep would hold the pipe open and the caller would wait for it.
(
  trap 'kill "$sleeper" 2>/dev/null; exit 0' TERM
  /bin/sleep "$LIMIT" &
  sleeper=$!
  wait "$sleeper"
  kill -KILL "$pid" 2>/dev/null
) >/dev/null 2>&1 </dev/null &
watchdog=$!

wait "$pid"
rc=$?
kill "$watchdog" 2>/dev/null

if [ "$rc" -ne 0 ]; then
  if [ "$rc" -ge 128 ]; then
    echo "DENIED by guard hook: guard.py exceeded ${LIMIT}s or was killed (exit $rc)" >&2
  else
    echo "DENIED by guard hook: guard.py failed (exit $rc)" >&2
  fi
  exit 2
fi
