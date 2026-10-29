---
name: Debugging
description: Systematic root-cause debugging for bugs, errors, test failures, crashes, or "why does X happen" questions
---

Investigate every defect with this method. Do not jump to fixes.

## Workflow

1. **Reproduce.** Build the smallest reliable reproduction. If it cannot be reproduced, state the exact environment/files needed and instrument to observe it.
2. **Read the actual error.** With shell tools (grep, tail) locate the real exception/log line, not paraphrased versions of it. Check which component printed it.
3. **Isolate.** Binary-search the failing area: comment out code, add temporary logging, or use `git bisect` for temporal isolation. One variable at a time.
4. **Hypothesize.** Write the hypothesis explicitly ("function X returns null when ... because ..."). Predict what evidence would confirm or refute it.
5. **Verify with evidence** — experiments, breakpoints, or targeted reads — before editing anything.
6. **Fix the root cause,** not the visible symptom. A fix that masks the symptom (swallowing errors, adding null checks without understanding why the null happens) is not done.
7. **Prove it.** Add a regression test that fails without the fix and passes with it. Re-run the original reproduction to confirm, and check related paths for the same bug class.

## Rules

- Never declare a fix "working" without running the reproduction.
- If debugging exceeds ~10 fruitless steps, stop and re-derive the problem from first principles or ask the user for more context.
- Remove all temporary instrumentation before finishing.
