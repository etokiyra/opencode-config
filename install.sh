#!/usr/bin/env bash
# install.sh — install the OpenCode configuration carried by this repository.
#
# Usage:
#   ./install.sh                # install global config + workspace MCP layer
#   ./install.sh ~/SomeDir      # also install the workspace MCP layer into another directory
#
# What it does:
#   1. Backs up existing ~/.config/opencode state next to it (timestamped).
#   2. Installs the global opencode.jsonc, agents/, commands/, skills/.
#   3. Installs the MCP servers into the workspace-level opencode.jsonc of
#      your projects directory (~/Projects by default). This layer is required:
#      project-level configs REPLACE the global `mcp` map instead of merging.
#   4. Leaves cli.json (TUI settings) and auth untouched.
#
# The script is idempotent — rerun it any time after pulling updates.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
SRC="$REPO_ROOT/config"
DEST="${XDG_CONFIG_HOME:-$HOME/.config}/opencode"
STAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$DEST.backup-$STAMP"
WORKSPACE="${1:-$HOME/Projects}"

banner() { printf '\n▸ %s\n' "$*"; }

# ── Sanity ─────────────────────────────────────────────────────────────────
if [ ! -f "$SRC/opencode.jsonc" ]; then
    echo "error: $SRC/opencode.jsonc not found — run this from the cloned repository" >&2
    exit 1
fi
if ! command -v opencode >/dev/null 2>&1; then
    echo "warning: opencode is not on PATH; files will still be installed." >&2
    echo "         Install it from https://opencode.ai, then run /connect → OpenCode Go." >&2
fi

# ── Backup ─────────────────────────────────────────────────────────────────
if [ -e "$BACKUP" ]; then
    echo "error: backup path already exists: $BACKUP" >&2
    exit 1
fi
mkdir -p "$BACKUP"
for entry in opencode.jsonc opencode.json agents commands skills cli.json; do
    [ -e "$DEST/$entry" ] && cp -a "$DEST/$entry" "$BACKUP/" || true
done
banner "Backed up existing state to $BACKUP"

# ── Global install ─────────────────────────────────────────────────────────
mkdir -p "$DEST/agents" "$DEST/commands" "$DEST/skills"
install -m 600 "$SRC/opencode.jsonc" "$DEST/opencode.jsonc"
rm -rf "$DEST/agents"/* "$DEST/commands"/* "$DEST/skills"/*
for entry in agents commands; do
    for file in "$SRC/$entry"/*.md; do
        install -m 644 "$file" "$DEST/$entry/$(basename "$file")"
    done
done
for skill in "$SRC/skills"/*/; do
    name="$(basename "$skill")"
    mkdir -p "$DEST/skills/$name"
    cp -a "$skill"/* "$DEST/skills/$name/"
done
banner "Installed global config, agents, commands, skills → $DEST"

# ── Workspace MCP layer ────────────────────────────────────────────────────
if [ -d "$WORKSPACE" ]; then
    ws_file="$WORKSPACE/opencode.jsonc"
    ws_file_alt="$WORKSPACE/opencode.json"
    if [ -e "$ws_file" ] || [ -e "$ws_file_alt" ]; then
        existing="$ws_file"; [ -e "$ws_file_alt" ] && existing="$ws_file_alt"
        echo "warning: $existing already exists — not overwriting." >&2
        echo "         Make sure it contains the \"mcp\" block from" >&2
        echo "         $SRC/opencode.jsonc (see README: workspace MCP layer)." >&2
    else
        {
            echo '{'
            echo '  "$schema": "https://opencode.ai/config.json",'
            echo '  // Workspace-level MCP layer: project configs replace the global'
            echo '  // `mcp` map, so free servers live here to be inherited everywhere.'
            sed -n '/"mcp": {/,/^  }$/p' "$SRC/opencode.jsonc"
            echo '}'
        } > "$ws_file"
        banner "Installed workspace MCP layer → $ws_file"
    fi
else
    echo "warning: workspace directory '$WORKSPACE' not found — skipping MCP layer." >&2
    echo "         Re-run with: ./install.sh /path/to/your/projects" >&2
fi

# ── Done ───────────────────────────────────────────────────────────────────
banner "Done. OpenCode is preconfigured:"
echo '    model      glm-5.3-flash   (switch anytime with /models)'
echo '    agents     build / plan / general / explore  +  quick deep free'
echo '    subagents  reviewer critic tester wordsmith architect'
echo '    commands   /review /commit /issue <n> /design  (+ per-project ones)'
echo '    skills     debugging commits tests release'
echo '    mcp        context7 · deepwiki · github(disabled)'
echo
echo '    First time only: run /connect → OpenCode Go → paste your API key,'
echo '    and /mcps → github → sign in if you want GitHub tools.'
echo "    Restore any time with: rm -rf $DEST && mv $BACKUP $DEST"
