#!/usr/bin/env bash
set -euo pipefail

# teardown.sh -- Remove DotClaude conventions from ~/.claude/CLAUDE.md
# Usage: teardown.sh
#
# Deletes the fenced block between <!-- DOTCLAUDE:START --> and <!-- DOTCLAUDE:END -->.
# Falls back to the legacy heading-based removal for CLAUDE.md files written before fences existed.

CLAUDE_MD="$HOME/.claude/CLAUDE.md"
START_MARK="<!-- DOTCLAUDE:START -->"
END_MARK="<!-- DOTCLAUDE:END -->"

echo "Removing DotClaude conventions..."

if [ ! -f "$CLAUDE_MD" ]; then
	echo "[OK] No CLAUDE.md found -- nothing to do"
	exit 0
fi

TMP=$(mktemp)

if grep -qF "$START_MARK" "$CLAUDE_MD" && grep -qF "$END_MARK" "$CLAUDE_MD"; then
	awk -v start="$START_MARK" -v end="$END_MARK" '
		BEGIN { skip = 0 }
		index($0, start) == 1 { skip = 1; next }
		skip && index($0, end) == 1 { skip = 0; next }
		!skip { print }
	' "$CLAUDE_MD" > "$TMP"
else
	# Legacy fallback: remove from "# Global Rules" heading until next non-DotClaude H2
	awk '
		/^# Global Rules — All Projects/ { skip=1; next }
		skip && /^## / && !/^## (Skills|Hard Rules|Database|General|API Module|Forms|Data Fetching|State Management|UI|React|Package|Never Run|External|Utilities|Code Style)/ { skip=0 }
		!skip { print }
	' "$CLAUDE_MD" > "$TMP"
fi

mv "$TMP" "$CLAUDE_MD"

echo "[OK] DotClaude conventions removed from ~/.claude/CLAUDE.md"
echo "To fully remove the plugin: claude plugin uninstall dotclaude@dotclaude"
