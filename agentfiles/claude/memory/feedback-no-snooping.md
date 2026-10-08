---
name: feedback-no-snooping
description: Never use git or poke around the environment needlessly; asked to implement something, implement it, do not go browsing git history, unrelated files, or system state
metadata:
  type: feedback
---

Do not use git and do not snoop around the environment needlessly. Asked to implement something:
implement it. Do not read git history, status, diffs, blame, or logs to "get context". Do not
browse directories, configs, or files the request does not touch. Unless explicitly requested by
user!

**How to apply:**
- Read only files the request names or the change directly depends on.
- No `git log`, `git status`, `git diff`, `git blame`, `git show` unless user asks for git in
  the current request. Tightens [[feedback-never-touch-git-state]].
- Missing context: ask user. Do not go looking. See [[feedback-environment-never-assume]].
