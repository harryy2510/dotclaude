#!/usr/bin/env bash
set -euo pipefail

# deslop.sh — Detect AI-generated code slop
# Patterns from agentsys (MIT, tested on 1,000+ repos)
# Usage: deslop.sh [path|--staged]

TARGET="${1:-.}"
STAGED=false
[ "$TARGET" = "--staged" ] && STAGED=true

RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

critical=0
medium=0
low=0

# Use rg if available, fall back to grep
if command -v rg &>/dev/null; then
	RG="rg --no-heading -n"
else
	RG="grep -rn -E"
fi

# Get files to scan
get_files() {
	local glob="$1"
	if $STAGED; then
		git diff --cached --name-only --diff-filter=ACM | grep -E "$glob" || true
	else
		find "$TARGET" -type f | grep -E "$glob" | grep -v node_modules | grep -v '\.git/' | grep -v dist/ | grep -v vendor/ || true
	fi
}

scan() {
	local severity="$1"
	local label="$2"
	local pattern="$3"
	local file_glob="${4:-.}"
	local exclude="${5:-}"

	local files
	files=$(get_files "$file_glob")
	[ -z "$files" ] && return

	local results
	if [ -n "$exclude" ]; then
		results=$(echo "$files" | xargs $RG "$pattern" 2>/dev/null | grep -v -E "$exclude" || true)
	else
		results=$(echo "$files" | xargs $RG "$pattern" 2>/dev/null || true)
	fi

	if [ -n "$results" ]; then
		local count
		count=$(echo "$results" | wc -l | tr -d ' ')
		case "$severity" in
			critical) echo -e "${RED}[CRITICAL]${NC} $label ($count hits)"; critical=$((critical + count)) ;;
			medium)   echo -e "${YELLOW}[MEDIUM]${NC}   $label ($count hits)"; medium=$((medium + count)) ;;
			low)      echo -e "${CYAN}[LOW]${NC}      $label ($count hits)"; low=$((low + count)) ;;
		esac
		echo "$results" | head -5 | sed 's/^/  /'
		[ "$count" -gt 5 ] && echo "  ... and $((count - 5)) more"
		echo ""
	fi
}

if $STAGED; then echo "Scanning staged files for slop patterns..."; else echo "Scanning $TARGET for slop patterns..."; fi
echo ""

# === CRITICAL ===

scan critical "Hardcoded secrets" \
	'(password|secret|api[_-]?key|token|credential)[_-]?(key|token|secret|pass)?[[:space:]]*[:=][[:space:]]*["'"'"'`][^"'"'"'`[:space:]]{8,}["'"'"'`]' \
	'\.(ts|tsx|js|jsx|py|rs|go|java)$' \
	'\.(test|spec|example|sample)\.'

scan critical "JWT tokens" \
	'eyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}\.' \
	'\.(ts|tsx|js|jsx|py|rs|go|java)$' \
	'\.(test|spec)\.'

scan critical "API keys (OpenAI/GitHub/AWS/Stripe)" \
	'(sk-[a-zA-Z0-9]{32,}|ghp_[a-zA-Z0-9]{36}|AKIA[0-9A-Z]{16}|sk_live_[a-zA-Z0-9]{24,})' \
	'\.(ts|tsx|js|jsx|py|rs|go|java|env)$' \
	'\.(test|spec)\.'

scan critical "Placeholder: throw Error TODO/not implemented" \
	'throw\s+new\s+Error\s*\(.*\b(TODO|implement|not.impl)' \
	'\.(ts|tsx|js|jsx)$' \
	'\.(test|spec)\.'

scan critical "Empty function bodies" \
	'(function\s+\w+\s*\([^)]*\)|=>)\s*\{\s*\}' \
	'\.(ts|tsx|js|jsx)$' \
	'\.(test|spec)\.|\.d\.ts$'

scan critical "Empty catch blocks" \
	'catch\s*(\([^)]*\))?\s*\{\s*\}' \
	'\.(ts|tsx|js|jsx)$' \
	'\.(test|spec)\.'

scan critical "Python: raise NotImplementedError" \
	'raise\s+NotImplementedError' \
	'\.py$' \
	'(test_|_test\.py|conftest)'

scan critical "Python: pass-only functions" \
	'def\s+\w+\s*\([^)]*\)\s*:\s*pass' \
	'\.py$' \
	'(test_|_test\.py|conftest)'

scan critical "Python: except pass (swallowed errors)" \
	'except\s*[^:]*:\s*pass' \
	'\.py$' \
	'(test_|_test\.py|conftest)'

scan critical "Rust: todo!/unimplemented! macros" \
	'(todo|unimplemented)!\s*\(' \
	'\.rs$' \
	'(_test\.rs|/tests/)'

scan critical "Go: panic TODO" \
	'panic\s*\(.*TODO' \
	'\.go$' \
	'(_test\.go|/testdata/)'

# === MEDIUM ===

scan medium "console.log/debug" \
	'console\.(log|debug)\(' \
	'\.(ts|tsx|js|jsx)$' \
	'\.(test|spec|config)\.|/bin/|/scripts/|/cli'

scan medium "Python debug prints" \
	'(^[^#]*print\(|import pdb|breakpoint\(\))' \
	'\.py$' \
	'(test_|_test\.py|conftest)'

scan medium "Rust debug macros" \
	'(println!|dbg!|eprintln!)\(' \
	'\.rs$' \
	'(_test\.rs|/tests/)'

scan medium "Rust bare .unwrap()" \
	'\.unwrap\(\s*\)' \
	'\.rs$' \
	'(_test\.rs|/tests/|/examples/)'

scan medium "Placeholder text" \
	'(lorem ipsum|test test test|asdf asdf|replace (this|me)|todo:?\s+implement|this is a placeholder)' \
	'\.(ts|tsx|js|jsx|py|rs|go)$' \
	'\.(test|spec)\.|README'

# === LOW ===

scan low "TODO/FIXME/HACK comments" \
	'(TODO|FIXME|HACK|XXX):' \
	'\.(ts|tsx|js|jsx|py|rs|go|java)$' \
	''

scan low "Disabled linter rules" \
	'(eslint-disable|pylint:\s*disable|#\s*noqa|@SuppressWarnings|#\[allow\()' \
	'\.(ts|tsx|js|jsx|py|rs|java)$' \
	'\.(test|spec)\.'

scan low "Mixed indentation" \
	'^\t+ +|^ +\t' \
	'\.(ts|tsx|js|jsx|py|rs|go)$' \
	'Makefile'

# === SUMMARY ===

total=$((critical + medium + low))
echo "---"
if [ "$total" -eq 0 ]; then
	echo "[OK] Clean — no slop detected"
	exit 0
else
	echo "Summary: $critical critical, $medium medium, $low low ($total total)"
	[ "$critical" -gt 0 ] && exit 1
	exit 0
fi
