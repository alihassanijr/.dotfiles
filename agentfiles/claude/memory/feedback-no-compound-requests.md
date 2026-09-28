---
name: feedback-no-compound-requests
description: One simple bash command per call (no &&, pipes, var capture); one MCP / external read request per turn, never batched
metadata:
  type: feedback
---

Bash: no compound commands. No chained `&&`, `VAR=$(...)` capture, pipes, or multi-step
one-liners. One logical operation per Bash call.

MCP and external read/fetch requests: one per turn. Do not fire several in one response even if
independent. Overrides harness "batch independent calls" nudges.

**How to apply:** Each count/grep/sed is its own Bash call. One MCP call, wait for result, then
next. Local file reads/writes in the working dir may be grouped.
