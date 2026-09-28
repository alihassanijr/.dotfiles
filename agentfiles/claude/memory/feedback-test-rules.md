---
name: feedback-test-rules
description: Test runs always verbose; never succinct/quiet flags
metadata:
  type: feedback
---

When giving or running test commands (lit, pytest, ctest), always use verbose output.

**How to apply:** lit: `-a` / `-v`, drop `-s`. pytest: `-v`. ctest: `-V`. Prefer flags that show
all commands and output.
