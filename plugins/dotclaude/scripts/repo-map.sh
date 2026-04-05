#!/usr/bin/env bash
set -euo pipefail

# repo-map.sh — Generate repo intelligence map using agent-analyzer
# Usage: repo-map.sh [path]

TARGET="${1:-.}"
BINARY="$HOME/.agent-sh/bin/agent-analyzer"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT=".claude/repo-intel.json"

# Install binary if missing
if [ ! -x "$BINARY" ]; then
	bash "$SCRIPT_DIR/install-repo-map.sh"
fi

# Generate
mkdir -p .claude
echo "Generating repo intel map for $TARGET..."
$BINARY repo-intel init "$TARGET" --max-commits 200 2>/dev/null > "$OUTPUT"

# Verify
python3 -c "import json; d=json.load(open('$OUTPUT')); print(f'{len(d.get(\"symbols\",{}))} files, {d.get(\"git\",{}).get(\"totalCommitsAnalyzed\",0)} commits analyzed')"

# Gitignore
grep -q 'repo-intel' .gitignore 2>/dev/null || echo '.claude/repo-intel.json' >> .gitignore

echo "[OK] Saved to $OUTPUT"
