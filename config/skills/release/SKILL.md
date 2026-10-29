---
name: Release
description: Prepare version bumps, changelogs, tags, and release notes
---

## Workflow

1. **Gather the change set:** `git log <previous-tag>..HEAD --no-merges --oneline` (consult the commits skill for type prefixes). Confirm `HEAD` is on the intended branch and `git status` is clean.
2. **Propose the version bump before editing anything** (user approval required before changing files):
   - `major` 1.0.0 → includes a breaking change (`BREAKING CHANGE:` footer, `!` in subject, or incompatible API)
   - `minor` 1.0.0 → new user-facing features (+ semver pre-1.0: bump the appropriate slot per project's own history)
   - `patch` 1.0.0 → fixes and performance work
3. **Update the version** in the project's canonical location(s) per language — check `pyproject.toml`, `package.json`, `Cargo.toml`, `VERSION`, etc. Bump every place the version appears.
4. **Update the changelog:** prepend a section dated today with the repo's existing format (look at previous sections with `rg "## " CHANGELOG.md` if unsure). Group by Added/Changed/Fixed/Removed; write user-facing summaries, not commit subjects.
5. **Tag and summarize:** present the tag command and a short release-notes summary (2–6 bullet points) for the user to run/publish — do not push or publish anything yourself.
