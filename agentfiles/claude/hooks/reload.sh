#!/bin/sh
# SessionStart hook (matcher: compact). Stdout is added to the model's context after
# compaction, which otherwise keeps only a summary. Prints CLAUDE.md and MEMORY.md
# verbatim and orders the ALWAYS READ memories to be read again.
# Builtins only; paths are lexical from this script's location (~/.claude/hooks/).

case $0 in
  */*) here=${0%/*} ;;
  *)   here=. ;;
esac
claude_dir=${here%/*}

emit() {
  printf '===== %s =====\n' "$1"
  while IFS= read -r line || [ -n "$line" ]; do
    printf '%s\n' "$line"
  done < "$2"
  printf '\n'
}

printf 'CONTEXT WAS COMPACTED. Rules below are in force again, verbatim. They override\n'
printf 'anything in the summary. Do not act on any assumption from before compaction\n'
printf 'about tools, environment, build, or run permissions.\n\n'

emit "~/.claude/CLAUDE.md" "$claude_dir/CLAUDE.md"
emit "~/.claude/MEMORY.md" "$claude_dir/MEMORY.md"

printf 'REQUIRED NOW, before any other tool call: Read every file listed under\n'
printf '"# ALWAYS READ" in MEMORY.md above. Not optional. Not "already known".\n'
printf 'Then continue the task.\n'
