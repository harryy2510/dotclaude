#!/usr/bin/env bash
set -euo pipefail

# teardown.sh: remove DotAgent managed convention blocks from global instruction files.
# Usage: teardown.sh

CLAUDE_MD="$HOME/.claude/CLAUDE.md"
CODEX_AGENTS="$HOME/.codex/AGENTS.md"

MANAGED_START="<!-- DOTAGENT:START -->"
MANAGED_END="<!-- DOTAGENT:END -->"

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
		echo "[OK] No DotAgent managed block found in $target_file"
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
	echo "[OK] Removed DotAgent conventions from $target_file"
}

echo "Removing DotAgent conventions..."

remove_managed_block "$CLAUDE_MD" "$MANAGED_START" "$MANAGED_END" "Claude"
remove_managed_block "$CODEX_AGENTS" "$MANAGED_START" "$MANAGED_END" "Codex"

echo "[OK] DotAgent conventions removed"
