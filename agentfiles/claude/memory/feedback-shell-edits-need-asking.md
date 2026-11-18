---
name: feedback-shell-edits-need-asking
description: File changes go through the editing tool whose diff the user approves; a shell-side edit (sed -i, perl -i, redirects, scripted rewrites) only after asking and getting a yes for that specific edit
metadata:
  type: feedback
---

File changes go through the editing tool whose diff the user sees and approves. A shell-side
edit of the user's files (`sed -i`, `perl -i`, `>` / `>>` redirects, scripted rewrites, in-place
formatters) is never run without asking first and getting a yes for that specific edit. The user
must know about every change before it happens.

**How to apply:** conflict hunks, block deletions, mass renames: editing tool, exact old text as
the match, in pieces when long. When a shell edit is clearly the better tool, name the command,
the file and the line range, then wait for the yes. Never overwrite an existing file wholesale.
