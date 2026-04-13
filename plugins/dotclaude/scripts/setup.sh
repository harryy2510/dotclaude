#!/usr/bin/env bash
set -euo pipefail

# setup.sh -- Sync DotClaude conventions into ~/.claude/CLAUDE.md + install agent-analyzer
# Usage: setup.sh
#
# Conventions are wrapped between <!-- DOTCLAUDE:START --> and <!-- DOTCLAUDE:END -->
# in ~/.claude/CLAUDE.md. Re-running setup replaces that block in place, so updates
# in plugins/dotclaude/CLAUDE.md propagate without losing user content above or below.

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
PLUGIN_CLAUDE="$PLUGIN_DIR/CLAUDE.md"
START_MARK="<!-- DOTCLAUDE:START -->"
END_MARK="<!-- DOTCLAUDE:END -->"

echo "Setting up DotClaude..."

if [ ! -f "$PLUGIN_CLAUDE" ]; then
	echo "[ERROR] Plugin CLAUDE.md not found at $PLUGIN_CLAUDE" >&2
	exit 1
fi

if ! grep -qF "$START_MARK" "$PLUGIN_CLAUDE" || ! grep -qF "$END_MARK" "$PLUGIN_CLAUDE"; then
	echo "[ERROR] Plugin CLAUDE.md is missing $START_MARK / $END_MARK fences" >&2
	exit 1
fi

mkdir -p "$(dirname "$CLAUDE_MD")"

# Compute hash of the plugin block to detect changes
PLUGIN_HASH=$(shasum -a 256 "$PLUGIN_CLAUDE" | awk '{print $1}')

if [ ! -f "$CLAUDE_MD" ] || [ ! -s "$CLAUDE_MD" ]; then
	cp "$PLUGIN_CLAUDE" "$CLAUDE_MD"
	echo "[OK] Created ~/.claude/CLAUDE.md"
elif grep -qF "$START_MARK" "$CLAUDE_MD" && grep -qF "$END_MARK" "$CLAUDE_MD"; then
	# Replace existing fenced block in place
	TMP=$(mktemp)
	awk -v start="$START_MARK" -v end="$END_MARK" -v src="$PLUGIN_CLAUDE" '
		BEGIN { skip = 0 }
		index($0, start) == 1 {
			while ((getline line < src) > 0) print line
			close(src)
			skip = 1
			next
		}
		skip && index($0, end) == 1 { skip = 0; next }
		!skip { print }
	' "$CLAUDE_MD" > "$TMP"

	if cmp -s "$TMP" "$CLAUDE_MD"; then
		echo "[OK] DotClaude conventions already up to date (hash $PLUGIN_HASH)"
		rm -f "$TMP"
	else
		mv "$TMP" "$CLAUDE_MD"
		echo "[OK] Updated DotClaude conventions in CLAUDE.md (hash $PLUGIN_HASH)"
	fi
else
	# Legacy CLAUDE.md without fences -- prepend fenced block, preserve existing content
	TMP=$(mktemp)
	cat "$PLUGIN_CLAUDE" > "$TMP"
	echo "" >> "$TMP"
	cat "$CLAUDE_MD" >> "$TMP"
	mv "$TMP" "$CLAUDE_MD"
	echo "[OK] Prepended DotClaude conventions (preserved existing content)"
fi

# Install agent-analyzer
if [ ! -x "$HOME/.agent-sh/bin/agent-analyzer" ]; then
	bash "$SCRIPT_DIR/install-repo-map.sh"
else
	echo "[OK] agent-analyzer already installed"
fi

echo "[OK] DotClaude setup complete"
