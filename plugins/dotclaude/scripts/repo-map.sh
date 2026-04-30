#!/usr/bin/env bash
set -euo pipefail

# repo-map.sh — Generate repo map using agent-analyzer
# Replicates agentsys/lib/repo-map flow:
#   1. Run agent-analyzer repo-intel init → stdout is JSON
#   2. Save raw intel to .agents/intel/repo-map/repo-intel.json
#   3. Convert to repo-map format → save to .agents/intel/repo-map/repo-map.json

TARGET="${1:-.}"
BINARY="$HOME/.agent-sh/bin/agent-analyzer"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STATE_DIR="${AGENT_TOOLKIT_REPO_MAP_DIR:-.agents/intel/repo-map}"

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

echo "[OK] Saved $STATE_DIR/repo-intel.json + $STATE_DIR/repo-map.json"
