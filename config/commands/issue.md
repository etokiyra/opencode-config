---
description: Investigate and fix a GitHub issue by number
---
Investigate and fix GitHub issue #$1 in this repository.

Issue details: !`gh issue view $1 --comments`

1. Read the issue and reproduce or verify the report against the actual code.
2. Find the root cause before changing anything — use the `debugging` skill.
3. Implement the smallest correct fix.
4. Add or update a test that fails before the fix and passes after.
5. Summarize what was wrong, what you changed, and how to verify it.
