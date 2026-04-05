#!/usr/bin/env bash
set -euo pipefail

# setup.sh — One-time DotClaude setup: copy conventions to ~/.claude/CLAUDE.md + install agent-analyzer
# Usage: setup.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
PLUGIN_CLAUDE="$PLUGIN_DIR/CLAUDE.md"

echo "Setting up DotClaude..."

# Copy conventions to CLAUDE.md (preserve user sections like vibe-kanban)
if [ -f "$CLAUDE_MD" ] && [ -s "$CLAUDE_MD" ]; then
	EXISTING=$(cat "$CLAUDE_MD")
	# Check if DotClaude content is already there
	if grep -q "# Global Rules — All Projects" "$CLAUDE_MD" 2>/dev/null; then
		echo "[OK] DotClaude conventions already in CLAUDE.md"
	else
		cat "$PLUGIN_CLAUDE" > "$CLAUDE_MD"
		echo "" >> "$CLAUDE_MD"
		echo "$EXISTING" >> "$CLAUDE_MD"
		echo "[OK] Prepended DotClaude conventions (preserved existing content)"
	fi
else
	mkdir -p "$(dirname "$CLAUDE_MD")"
	cp "$PLUGIN_CLAUDE" "$CLAUDE_MD"
	echo "[OK] Created ~/.claude/CLAUDE.md"
fi

# Install agent-analyzer
if [ ! -x "$HOME/.agent-sh/bin/agent-analyzer" ]; then
	bash "$SCRIPT_DIR/install-repo-map.sh"
else
	echo "[OK] agent-analyzer already installed"
fi

echo "[OK] DotClaude setup complete"
