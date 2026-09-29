---
name: feedback-presentation
description: Presenting code and files to user. Label each file as read-only reference or to-be-edited; quoted code keeps inline comments verbatim
metadata:
  type: feedback
---

When naming files in a plan, walkthrough, or summary, state which are read-only reference and
which will be edited. Never leave it implicit.

When quoting code snippets (tutorial, review, explain), copy inline comments verbatim.

When asked to review or check something, report the findings first and stop. Apply fixes only
after the user picks which ones.

**How to apply:** Tag each file inline, e.g. "(reference only)" vs "(edit)". If a file holds a
base abstraction the new work only implements, say so up front. Strip a comment only when it has
no bearing on what is being explained.
