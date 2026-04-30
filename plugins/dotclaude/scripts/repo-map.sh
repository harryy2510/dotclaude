#!/usr/bin/env bash
set -euo pipefail

# repo-map.sh — Generate repo map using agent-analyzer
# Replicates agentsys/lib/repo-map flow:
#   1. Run agent-analyzer repo-intel init → stdout is JSON
#   2. Save raw intel to .claude/repo-intel.json
#   3. Convert to repo-map format → save to .claude/repo-map.json

TARGET="${1:-.}"
BINARY="$HOME/.agent-sh/bin/agent-analyzer"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STATE_DIR=".claude"

# Install binary if missing
if [ ! -x "$BINARY" ]; then
	bash "$SCRIPT_DIR/install-repo-map.sh"
fi

mkdir -p "$STATE_DIR"

# Step 1+2: Run agent-analyzer, save raw intel JSON
echo "Scanning $TARGET..."
$BINARY repo-intel init "$TARGET" --max-commits 200 > "$STATE_DIR/repo-intel.json"

# Step 3: Convert raw intel to repo-map format (replicates agentsys converter.js)
python3 "$SCRIPT_DIR/convert-repo-map.py" "$STATE_DIR/repo-intel.json" "$STATE_DIR/repo-map.json"

# Step 4: Gitignore
for f in repo-intel.json repo-map.json; do
	grep -q "$f" .gitignore 2>/dev/null || echo "$STATE_DIR/$f" >> .gitignore
done

echo "[OK] Saved $STATE_DIR/repo-intel.json + $STATE_DIR/repo-map.json"
