#!/bin/sh
# Time guard.sh on Bash commands of increasing size.
# Usage: sh time_guard.sh [runs]     (default 20 runs per case)
# Uses /usr/bin/time -p (POSIX; present on Linux and macOS) and awk (POSIX).
here=$(cd "$(dirname "$0")" && pwd)
cwd=$(mktemp -d)
trap 'rmdir "$cwd"' EXIT
n=${1:-20}

event() {  # $1 = command text, already JSON-escaped
  printf '{"cwd":"%s","transcript_path":"%s/.claude/projects/-fake/t.jsonl","tool_name":"Bash","tool_input":{"command":"%s"}}' \
    "$cwd" "$HOME" "$1"
}

bench() {  # $1 = label, $2 = command text
  ev=$(event "$2")
  printf '%-8s %6d chars, %d runs: ' "$1" "${#2}" "$n"
  { /usr/bin/time -p sh -c '
      i=0
      while [ "$i" -lt "$3" ]; do
        printf %s "$1" | sh "$2" >/dev/null 2>&1
        i=$((i + 1))
      done' _ "$ev" "$here/guard.sh" "$n"; } 2>&1 \
    | awk -v n="$n" '/^real/ { printf "%.2fs total, %.1f ms per call\n", $2, $2 * 1000 / n }'
}

short='ls -la'
medium='grep -rn foo src/ include/ && make -j8 2>&1 | tail -n 20; python3 -m pytest tests/ -v'
long=$(i=0; while [ "$i" -lt 200 ]; do printf 'cat src/dir%d/file%d.cpp ; ' "$i" "$i"; i=$((i + 1)); done)
nested='bash -c \"sh -c \\\"bash -c \\\\\\\"echo a b c d e f g h\\\\\\\"\\\"\"'

bench short "$short"
bench medium "$medium"
bench long "$long"
bench nested "$nested"
