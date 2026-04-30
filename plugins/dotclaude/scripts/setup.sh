#!/usr/bin/env bash
set -euo pipefail

# setup.sh: sync DotClaude conventions into Claude and Codex global instruction files.
# Usage: setup.sh
#
# Conventions are wrapped in managed fences. Re-running setup replaces only the
# managed block and preserves user content above or below it.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"

CLAUDE_MD="$HOME/.claude/CLAUDE.md"
CODEX_AGENTS="$HOME/.codex/AGENTS.md"
PLUGIN_CLAUDE="$PLUGIN_DIR/CLAUDE.md"
PLUGIN_CODEX="$PLUGIN_DIR/AGENTS.md"

CLAUDE_START="<!-- DOTCLAUDE:START -->"
CLAUDE_END="<!-- DOTCLAUDE:END -->"
CODEX_START="<!-- DOTCLAUDE-AGENTS:START -->"
CODEX_END="<!-- DOTCLAUDE-AGENTS:END -->"

sync_managed_file() {
	local source_file="$1"
	local target_file="$2"
	local start_mark="$3"
	local end_mark="$4"
	local label="$5"

	if [ ! -f "$source_file" ]; then
		echo "[ERROR] $label source not found at $source_file" >&2
		exit 1
	fi

	if ! grep -qF "$start_mark" "$source_file" || ! grep -qF "$end_mark" "$source_file"; then
		echo "[ERROR] $label source is missing managed fences" >&2
		exit 1
	fi

	mkdir -p "$(dirname "$target_file")"

	local source_hash
	source_hash=$(shasum -a 256 "$source_file" | awk '{print $1}')

	if [ ! -f "$target_file" ] || [ ! -s "$target_file" ]; then
		cp "$source_file" "$target_file"
		echo "[OK] Created $target_file ($label hash $source_hash)"
		return
	fi

	local tmp
	tmp=$(mktemp)

	if grep -qF "$start_mark" "$target_file" && grep -qF "$end_mark" "$target_file"; then
		awk -v start="$start_mark" -v end="$end_mark" -v src="$source_file" '
			BEGIN { skip = 0 }
			index($0, start) == 1 {
				while ((getline line < src) > 0) print line
				close(src)
				skip = 1
				next
			}
			skip && index($0, end) == 1 { skip = 0; next }
			!skip { print }
		' "$target_file" > "$tmp"
	else
		local unfenced_tmp
		unfenced_tmp=$(mktemp)
		awk -v start="$start_mark" -v end="$end_mark" '
			index($0, start) == 1 { next }
			index($0, end) == 1 { next }
			{ print }
		' "$source_file" > "$unfenced_tmp"

		if cmp -s "$unfenced_tmp" "$target_file"; then
			cp "$source_file" "$tmp"
		else
			cat "$source_file" > "$tmp"
			echo "" >> "$tmp"
			cat "$target_file" >> "$tmp"
		fi
		rm -f "$unfenced_tmp"
	fi

	if cmp -s "$tmp" "$target_file"; then
		echo "[OK] $label conventions already up to date (hash $source_hash)"
		rm -f "$tmp"
	else
		mv "$tmp" "$target_file"
		echo "[OK] Updated $label conventions in $target_file (hash $source_hash)"
	fi
}

echo "Setting up DotClaude..."

sync_managed_file "$PLUGIN_CLAUDE" "$CLAUDE_MD" "$CLAUDE_START" "$CLAUDE_END" "Claude"
sync_managed_file "$PLUGIN_CODEX" "$CODEX_AGENTS" "$CODEX_START" "$CODEX_END" "Codex"

if [ ! -x "$HOME/.agent-sh/bin/agent-analyzer" ]; then
	bash "$SCRIPT_DIR/install-repo-map.sh"
else
	echo "[OK] agent-analyzer already installed"
fi

echo "[OK] DotClaude setup complete"
