---
description: Stage changes and create a conventional commit
agent: build
---
Commit the current changes.

1. Run `git status` and `git diff` (and `git diff --staged`) to understand the change set.
2. Load the `commits` skill and follow it exactly for the commit message.
3. Stage only files that belong to the change (be selective; never stage unrelated files blindly).
4. Show me the proposed commit message before running `git commit`.
5. Never push — pushing always stays a manual, explicit step.
