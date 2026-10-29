# opencode-config

My portable [OpenCode](https://opencode.ai) configuration for the
**OpenCode Go** subscription: model assignments tuned for price ≫ performance,
a full agent roster, safety-first-but-permissive permissions, free MCP servers,
slash commands, and task skills.

Run `install.sh` inside the cloned repo to install everything globally.

```bash
git clone git@github.com:<you>/opencode-config.git
cd opencode-config
./install.sh              # global config + MCP layer for ~/Projects
./install.sh ~/my-projects  # …or point the MCP layer somewhere else
```

The script backs up your existing state to `~/.config/opencode.backup-<timestamp>`
before touching anything, and is idempotent — rerun it after pulling updates.
TUI settings (`cli.json`) and your OpenCode auth are never modified.

## What gets installed

| Where | What |
| --- | --- |
| `~/.config/opencode/opencode.jsonc` | Model defaults, permissions, agent-model overrides, MCP servers |
| `~/.config/opencode/agents/` | `quick`, `deep`, `free`, `reviewer`, `critic`, `tester`, `wordsmith`, `architect` |
| `~/.config/opencode/commands/` | `/review`, `/commit`, `/issue <n>`, `/design` |
| `~/.config/opencode/skills/` | `debugging`, `commits`, `tests`, `release` |
| `<workspace>/opencode.jsonc` | Workspace-level MCP layer (see below) |

First-time only, afterward:

1. `/connect` → **OpenCode Go** → paste your API key.
2. Optional: `/mcps` → **github** → sign in (the server ships disabled).

## Model strategy (price ≫ performance on OpenCode Go)

| Role | Model | Why |
| --- | --- | --- |
| Daily driver | `glm-5.3-flash` | Best quality-per-dollar flash tier, big allowance, zero data retention |
| Titles, summaries, explore | `mimo-v2.6-flash` | Cheapest; runs on every message despite being bought from the floor |
| General subagent, compaction | `deepseek-v4.1-flash` | Capable cheap reasoning, biggest allowance |
| Reviewer | `kimi-k2.7-code` | Coding specialist |
| Plan, deep-work, critic, architect | `kimi-k3.1-pro#high` | Premium reasoning, used sparingly |
| Docs | `minimax-m3.1-flash` | Cheap writer |
| Unlimited free | `beam-free` | When you hit a cap (`/models` — beware 30-day provider retention) |

Models that train on request data (Muse Spark, Iceman) are not used anywhere.

### Switching agents

| Agent | Type | Use for |
| --- | --- | --- |
| `build` (default) / `plan` | primary | everyday work / pre-implementation planning |
| `quick` | primary | small tasks with minimal ceremony |
| `deep` | primary | mystery bugs, gnarly refactors |
| `free` | primary | literal-scale free unlimited throwaway work |
| `reviewer` / `critic` | subagent | change review / adversarial pre-merge attacks |
| `tester` / `wordsmith` / `architect` | subagent | tests / docs-only edits / design docs |

## Permissions philosophy

Permissive by default. Agents run shell freely; the only prompts are:

- **Publishing**: `git commit`, `git push`, `git tag`, `gh pr create`/`merge`/`close`, `gh release`
- **History destroys**: `git reset --hard`, `git clean -f`, `git filter-branch`
- **Outside the workspace**: writing/editing files beyond the project

Hard-denied without asking: `sudo`, `~/.ssh`, `~/.gnupg`, `~/.aws`, `~/.kube`,
`/etc/shadow`, `/etc/sudoers`, token/credential files, and OpenCode's own
`auth.json`. Agents also cannot fetch `localhost`/`127.0.0.1` URLs.

## The workspace MCP layer (why it exists)

In OpenCode v2.2.x, a project-level config file **replaces** the global `mcp`
map instead of merging it, so servers configured only in the global config
vanish inside any project that has its own config. The workaround: define the
servers in a workspace-level `opencode.jsonc` above your project directories —
every project then inherits them. `install.sh` writes that layer for you.

Included free servers: **context7** (library docs), **deepwiki** (GitHub repo
Q&A), **github** (disabled until you sign in at `/mcps`).

## Layout

```
install.sh                  installer (backup + idempotent copy + MCP layer)
config/
├── opencode.jsonc          global configuration (canonical source)
├── agents/                 8 markdown agents
├── commands/               4 global slash commands
└── skills/                 debugging, commits, tests, release
```

Project-specific `.opencode/` configs (per-project commands, permissions)
live in each project repository, not here.
