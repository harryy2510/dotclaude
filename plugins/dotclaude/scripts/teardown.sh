#!/usr/bin/env bash
set -euo pipefail

# teardown.sh — Remove DotClaude conventions from ~/.claude/CLAUDE.md
# Usage: teardown.sh

CLAUDE_MD="$HOME/.claude/CLAUDE.md"

echo "Removing DotClaude conventions..."

if [ ! -f "$CLAUDE_MD" ]; then
	echo "[OK] No CLAUDE.md found — nothing to do"
	exit 0
fi

# Remove everything from "# Global Rules" to either end-of-file or next user section
TMP=$(mktemp)
awk '
	/^# Global Rules — All Projects/ { skip=1; next }
	skip && /^## / && !/^## (Skills|Hard Rules|Database|General|API Module|Forms|Data Fetching|State Management|UI|React|Package|Never Run|External|Utilities|Code Style)/ { skip=0 }
	!skip { print }
' "$CLAUDE_MD" > "$TMP"
mv "$TMP" "$CLAUDE_MD"

echo "[OK] DotClaude conventions removed from ~/.claude/CLAUDE.md"
echo "To fully remove the plugin: claude plugin uninstall dotclaude@dotclaude"
