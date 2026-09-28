---
name: feedback-never-touch-git-state
description: Never run git commands that change repo state (rm, add, mv, commit, stash, checkout, reset, etc.) unless user explicitly says git may be used; user owns commits
metadata:
  type: feedback
---

Never run git commands that change working tree, index, stash, or history unless the user
explicitly says git may be used in that request. Includes `git rm`, `git add`, `git mv`,
`git commit`, `git stash`, `git checkout`, `git restore`, `git reset`, `git rebase`, `git push`.

Agent never commits and never tracks changes unless user explicitly hands that over. User owns
commits. If user says "leave git to me": run no git at all, read-only included.

**How to apply:** Delete, rename, or move files with plain `rm` / `mv`. Read-only git in the
working dir (`status`, `log`, `diff`, `show`) is fine when user approves the call.
