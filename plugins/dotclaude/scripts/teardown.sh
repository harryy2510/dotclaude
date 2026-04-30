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
LEGACY_CODEX_START="<!-- DOTCLAUDE-CODEX:START -->"
LEGACY_CODEX_END="<!-- DOTCLAUDE-CODEX:END -->"

remove_managed_block() {
	local target_file="$1"
	local start_mark="$2"
	local end_mark="$3"
	local label="$4"
	local legacy_start="${5:-}"
	local legacy_end="${6:-}"

	if [ ! -f "$target_file" ]; then
		echo "[OK] No $target_file found for $label. Nothing to do"
		return
	fi

	if ! grep -qF "$start_mark" "$target_file" || ! grep -qF "$end_mark" "$target_file"; then
		if [ -n "$legacy_start" ] && [ -n "$legacy_end" ] && grep -qF "$legacy_start" "$target_file" && grep -qF "$legacy_end" "$target_file"; then
			local legacy_block_tmp
			legacy_block_tmp=$(mktemp)
			awk -v start="$legacy_start" -v end="$legacy_end" '
				BEGIN { skip = 0 }
				index($0, start) == 1 { skip = 1; next }
				skip && index($0, end) == 1 { skip = 0; next }
				!skip { print }
			' "$target_file" > "$legacy_block_tmp"
			mv "$legacy_block_tmp" "$target_file"
			echo "[OK] Removed legacy DotClaude conventions from $target_file"
			return
		fi

		if [ "$label" = "Claude" ]; then
			local legacy_tmp
			legacy_tmp=$(mktemp)
			awk '
				/^# Global Rules/ { skip=1; next }
				skip && /^## / && !/^## (Skills|Hard Rules|Database|General|API Module|Forms|Data Fetching|State Management|UI|React|Package|Never Run|External|Utilities|Code Style)/ { skip=0 }
				!skip { print }
			' "$target_file" > "$legacy_tmp"

			if ! cmp -s "$legacy_tmp" "$target_file"; then
				mv "$legacy_tmp" "$target_file"
				echo "[OK] Removed legacy DotClaude conventions from $target_file"
				return
			fi
			rm -f "$legacy_tmp"
		fi

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
remove_managed_block "$CODEX_AGENTS" "$CODEX_START" "$CODEX_END" "Codex" "$LEGACY_CODEX_START" "$LEGACY_CODEX_END"

echo "[OK] DotClaude conventions removed"
