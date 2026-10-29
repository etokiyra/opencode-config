<div align="center">

# ⚙️ opencode-config

A portable, preconfigured **[OpenCode](https://opencode.ai)** setup for the
**OpenCode Go** subscription — agents, skills, commands, free MCP servers, and
a permission policy that only asks when it matters.

*Clone it, run one script, and OpenCode comes out ready to work.*

![license](https://img.shields.io/badge/license-The%20Unlicense-4c9ee8?style=flat-square)
![bash](https://img.shields.io/badge/uses-bash%20%2B%20tar-121011?style=flat-square&logo=gnu-bash&logoColor=white)
![target](https://img.shields.io/badge/opencode-v2.2.x-5963fc?style=flat-square)
![provider](https://img.shields.io/badge/provider-OpenCode%20Go-90b99f?style=flat-square)

</div>

---

## ✦ Quick start

```bash
git clone git@github.com:<you>/opencode-config.git
cd opencode-config

./install.sh                        # global config + MCP layer for ~/Projects
./install.sh ~/some-other-projects  # …or point the MCP layer wherever you like
```

One-time, after installing:

```text
/connect   → OpenCode Go → paste your API key
/mcps      → github → sign in (optional, ships disabled)
```

**Safety net:** anything already in `~/.config/opencode` is copied to
`~/.config/opencode.backup-<timestamp>` first, and one `mv` puts it back.
The script is idempotent — rerun it any time after pulling updates. TUI
settings (`cli.json`) and your authentication are never touched.

## ✦ What gets installed

| Destination | Contents |
| --- | --- |
| `~/.config/opencode/opencode.jsonc` | Go-plan model assignments, permissions, agent overrides, MCP servers |
| `~/.config/opencode/agents/` | 8 agents — `quick`, `deep`, `free`, `reviewer`, `critic`, `tester`, `wordsmith`, `architect` |
| `~/.config/opencode/commands/` | `/review` · `/commit` · `/issue <n>` · `/design` |
| `~/.config/opencode/skills/` | `debugging` · `commits` · `tests` · `release` |
| `<workspace>/opencode.jsonc` | The workspace MCP layer — see [*Why the layer exists*](#-why-the-workspace-mcp-layer-exists) |

Everything reloads without restarting OpenCode: edit a file in
`~/.config/opencode/` and it applies immediately (or run `/reload`).

## ⚡ Model strategy — price ≫ performance on OpenCode Go

Assignments pick the *cheapest capable* model for each job, keeping premium
allowances (the low-`$15/month`-cap models) for the work that actually needs
them. Models that train on request data (Muse Spark, Iceman) are excluded
everywhere.

| Role | Model | Rationale |
| --- | --- | --- |
| **Daily driver** | `glm-5.3-flash` | Best quality-per-dollar flash tier, $60/mo allowance, zero data retention |
| Titles · summaries · explore | `mimo-v2.6-flash` | The cheapest model — constant housekeeping runs cost ~nothing |
| General subagent · compaction | `deepseek-v4.1-flash#high` | Capable cheap reasoning with the biggest allowance |
| Code review | `kimi-k2.7-code` | Coding specialist at mid price |
| Planning · deep work · critic · architect | `kimi-k3.1-pro#high` | Premium reasoning, deliberately rationed |
| Documentation | `minimax-m3.1-flash` | Cheap and competent prose |
| Free unlimited | `beam-free` | When a cap is hit — `/models` to switch (30-day provider retention) |

## 🤖 The agent roster

Three layers of firepower, switched in the TUI or invoked by name:

**Primary agents** (pick with Tab / the agent picker)

| Agent | Model | Use for |
| --- | --- | --- |
| `build` *(default)* | session model | everyday work |
| `plan` | kimi-k3.1-pro#high | pre-implementation planning mode |
| `quick` | mimo-v2.6-flash | small tasks, zero ceremony |
| `deep` | kimi-k3.1-pro#high | mystery bugs, gnarly refactors |
| `free` | beam-free | throwaway experiments at literal $0 |

**Subagents** (launched on demand)

| Agent | Model | Use for |
| --- | --- | --- |
| `reviewer` | kimi-k2.7-code | severity-ordered change review (read-only) |
| `critic` | kimi-k3.1-pro#high | adversarial pre-merge attacks on plans and diffs |
| `tester` | deepseek-v4.1-flash#high | conventions-first, runner-verified test writing |
| `wordsmith` | minimax-m3.1-flash | docs-only edits (denied from touching source) |
| `architect` | kimi-k3.1-pro#high | researches the repo, writes options + tradeoffs |

**Maintenance** (hidden, runs constantly)

`title` and `summary` on `mimo-v2.6-flash`, `compaction` on
`deepseek-v4.1-flash#high` — so housekeeping never burns premium allowance.

## 🔒 Permission philosophy

**Permissive by default.** Agents work freely and interruptions are reserved
for what can actually escape or destroy:

| Category | Rules | Effect |
| --- | --- | --- |
| Publishing | `git commit` · `git push` · `git tag` · `gh pr create`/`merge`/`close` · `gh release` | ask |
| History destroys | `git reset --hard` · `git clean -f` · `git filter-branch` | ask |
| Outside the workspace | writing/editing beyond the project — **except** scratch/toolchain zones: `/tmp/*`, `~/.opencode`, `~/.local/share/opencode`, `~/.cache`, `~/.cargo`, `~/go` | ask (zones ↑ are free) |
| Secrets & OS | `sudo`, `~/.ssh`, `~/.gnupg`, `~/.aws`, `~/.kube`, `/etc/shadow`, `/etc/sudoers`, token/credential files, OpenCode's `auth.json` | **deny** |
| Local network | `webfetch` to `localhost` / `127.0.0.1` | **deny** |

Secrets are never *asked about* — they are hard-denied outright.

## 🌐 Why the workspace MCP layer exists

In OpenCode v2.2.x, a project-level config file **replaces** the global `mcp`
map instead of merging it — servers configured only globally vanish inside any
project that has its own config. The workaround is to define the servers in a
workspace-level `opencode.jsonc` *above* your project directories, which every
project then inherits. `install.sh` writes that layer for you (and refuses to
overwrite a workspace config you already have, telling you which block to add).

Included free servers:

| Server | Purpose | Auth |
| --- | --- | --- |
| `context7` | Up-to-date library & framework docs | none |
| `deepwiki` | Q&A over a deep index of public GitHub repos | none |
| `github` | Official GitHub tools (issues, PRs, code search) | sign in once via `/mcps` |

## ✏️ Customizing

- **This repo** is the canonical source: edit `config/*`, then rerun
  `./install.sh` to re-apply.
- **Per-project tuning** (project commands like `/ci` or `/preview`) belongs in
  each project's own `.opencode/` directory, not here — OpenCode discovers and
  merges those automatically.
- **cli.json** (themes, keybinds) is TUI territory and intentionally left out.

## 📄 License

Released to the public domain under [The Unlicense](LICENSE) — use, modify,
and redistribute freely, no attribution required.
