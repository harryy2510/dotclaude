#!/usr/bin/env bash
set -euo pipefail

# Install agent-analyzer binary from GitHub releases
# https://github.com/agent-sh/agent-analyzer

REPO="agent-sh/agent-analyzer"
INSTALL_DIR="$HOME/.agent-sh/bin"
BINARY="agent-analyzer"

# Detect platform
case "$(uname -s)-$(uname -m)" in
	Darwin-arm64)  TARGET="aarch64-apple-darwin" ;;
	Darwin-x86_64) TARGET="x86_64-apple-darwin" ;;
	Linux-x86_64)  TARGET="x86_64-unknown-linux-gnu" ;;
	Linux-aarch64) TARGET="aarch64-unknown-linux-gnu" ;;
	*)
		echo "[ERROR] Unsupported platform: $(uname -s)-$(uname -m)"
		exit 1
		;;
esac

# Check if already installed
if [ -x "$INSTALL_DIR/$BINARY" ]; then
	version=$("$INSTALL_DIR/$BINARY" --version 2>/dev/null | head -1 || echo "unknown")
	echo "[OK] agent-analyzer already installed: $version"
	echo "     Location: $INSTALL_DIR/$BINARY"
	exit 0
fi

echo "Installing agent-analyzer for $TARGET..."

# Get latest release URL
RELEASE_URL=$(curl -sL "https://api.github.com/repos/$REPO/releases/latest" \
	| grep "browser_download_url.*$TARGET" \
	| head -1 \
	| cut -d '"' -f 4)

if [ -z "$RELEASE_URL" ]; then
	echo "[ERROR] Could not find release for $TARGET"
	echo "Check: https://github.com/$REPO/releases"
	exit 1
fi

# Download and install
mkdir -p "$INSTALL_DIR"
TMP=$(mktemp -d)
trap "rm -rf $TMP" EXIT

echo "Downloading from $RELEASE_URL..."
curl -sL "$RELEASE_URL" -o "$TMP/download"

# Handle .tar.gz or raw binary
if file "$TMP/download" | grep -q "gzip"; then
	tar -xzf "$TMP/download" -C "$TMP"
	find "$TMP" -name "$BINARY" -type f -exec cp {} "$INSTALL_DIR/$BINARY" \;
else
	cp "$TMP/download" "$INSTALL_DIR/$BINARY"
fi

chmod +x "$INSTALL_DIR/$BINARY"

# Verify
version=$("$INSTALL_DIR/$BINARY" --version 2>/dev/null | head -1 || echo "unknown")
echo "[OK] Installed agent-analyzer $version"
echo "     Location: $INSTALL_DIR/$BINARY"
echo ""
echo "Add to PATH (optional):"
echo "  export PATH=\"\$HOME/.agent-sh/bin:\$PATH\""
