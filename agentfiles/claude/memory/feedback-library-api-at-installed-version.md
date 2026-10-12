---
name: feedback-library-api-at-installed-version
description: When reading a library's source to learn its API, read the release tag matching the installed/locked version, not the default branch
metadata:
  type: feedback
---

When reading a library's source to learn its API, read the release tag matching the installed or
locked version, not the default branch. The default branch may have unreleased API.

**How to apply:** Find the version in the lock file or requirements (do not probe the environment).
Fetch or clone that exact tag. If the version is unknown, ask. Code against that tag only.
