#!/usr/bin/env bash
set -euo pipefail

# teardown.sh: remove DotClaude managed convention blocks from global instruction files.
# Usage: teardown.sh

CLAUDE_MD="$HOME/.claude/CLAUDE.md"
CODEX_AGENTS="$HOME/.codex/AGENTS.md"

CLAUDE_START="<!-- DOTCLAUDE:START -->"
CLAUDE_END="<!-- DOTCLAUDE:END -->"
CODEX_START="<!-- DOTCLAUDE-AGENTS:START -->"
CODEX_END="<!-- DOTCLAUDE-AGENTS:END -->"

remove_managed_block() {
	local target_file="$1"
	local start_mark="$2"
	local end_mark="$3"
	local label="$4"

	if [ ! -f "$target_file" ]; then
		echo "[OK] No $target_file found for $label. Nothing to do"
		return
	fi

	if ! grep -qF "$start_mark" "$target_file" || ! grep -qF "$end_mark" "$target_file"; then
		echo "[OK] No DotClaude managed block found in $target_file"
		return
	fi

	local tmp
	tmp=$(mktemp)

	awk -v start="$start_mark" -v end="$end_mark" '
		BEGIN { skip = 0 }
		index($0, start) == 1 { skip = 1; next }
		skip && index($0, end) == 1 { skip = 0; next }
		!skip { print }
	' "$target_file" > "$tmp"

	mv "$tmp" "$target_file"
	echo "[OK] Removed DotClaude conventions from $target_file"
}

echo "Removing DotClaude conventions..."

remove_managed_block "$CLAUDE_MD" "$CLAUDE_START" "$CLAUDE_END" "Claude"
remove_managed_block "$CODEX_AGENTS" "$CODEX_START" "$CODEX_END" "Codex"

echo "[OK] DotClaude conventions removed"
