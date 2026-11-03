---
name: feedback-test-rules
description: Test runs always verbose; never quiet flags. Capture output with tee, never bare redirect
metadata:
  type: feedback
---

When giving or running test commands (lit, pytest, ctest), always use verbose output.
Capturing output to file: user must still see it live.

**How to apply:** lit: `-a` / `-v`, drop `-s`. pytest: `-v`. ctest: `-V`. Prefer flags that show
all commands and output. Save output with `cmd 2>&1 | tee out.txt`, never `cmd > out.txt 2>&1`.
