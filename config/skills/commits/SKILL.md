---
name: Commits
description: Conventions for commit messages and pull request descriptions
---

## Commit messages

Use Conventional Commits:

```
<type>(<scope>): <short imperative summary, <=50 chars, no period>

<optional body: what and why, not how; wrap at ~72 chars>

<optional footer: BREAKING CHANGE: ..., refs #123>
```

Types: `feat`, `fix`, `refactor`, `perf`, `test`, `docs`, `build`, `ci`, `chore`.
Scope: the module/package/area, lowercase, e.g. `fix(auth): rate-limit password attempts`.

Rules:
- Subject imperative mood: "add", not "added" or "adds".
- The body explains WHY when the why is not obvious from the diff.
- One logical change per commit; split mixed work.
- Never include secrets, large blob dumps, or "AI generated" type noise.
- Reference issues with `(#123)` at the end of the subject or `Refs #123` in the footer.

## Pull request descriptions

Structure: **What** (1–3 sentences), **Why** (motivation/issue link), **Testing** (what was run and how it was verified), **Notes** (breaking changes, migration, follow-ups).
