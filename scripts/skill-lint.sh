#!/usr/bin/env bash
set -euo pipefail

# skill-lint.sh — Validate skill and agent quality
# Usage: skill-lint.sh <directory>
# Examples:
#   skill-lint.sh ~/.claude/skills/
#   skill-lint.sh ~/.claude/agents/
#   skill-lint.sh ~/.claude/skills/ui/

DIR="${1:-.}"
errors=0
warns=0
ok=0
total=0

RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

error() { echo -e "${RED}[ERROR]${NC} $1"; errors=$((errors + 1)); }
warn() { echo -e "${YELLOW}[WARN]${NC}  $1"; warns=$((warns + 1)); }
pass() { echo -e "${GREEN}[OK]${NC}    $1"; ok=$((ok + 1)); }

lint_file() {
	local file="$1"
	local dir
	dir=$(dirname "$file")
	local basename
	basename=$(basename "$file")
	local label="${file#$DIR/}"
	local issues=0

	total=$((total + 1))

	# Check frontmatter exists
	if ! head -1 "$file" | grep -q '^---$'; then
		error "$label — missing frontmatter"
		return
	fi

	# Extract frontmatter
	local frontmatter
	frontmatter=$(awk '/^---$/{n++; next} n==1{print} n==2{exit}' "$file")

	# Check name field
	local name
	name=$(echo "$frontmatter" | grep '^name:' | sed 's/^name: *//' | tr -d '"'"'" || true)
	if [ -z "$name" ]; then
		error "$label — missing 'name' in frontmatter"
		issues=$((issues + 1))
	fi

	# Check description field (handles single-line and multi-line YAML > or |)
	local desc
	desc=$(echo "$frontmatter" | awk '
		/^description:/ {
			sub(/^description: */, "")
			if ($0 == ">" || $0 == "|" || $0 == ">-" || $0 == "|-") {
				# Multi-line: collect continuation lines (indented)
				while ((getline line) > 0) {
					if (line !~ /^[[:space:]]/) break
					sub(/^[[:space:]]+/, "", line)
					printf "%s ", line
				}
			} else {
				print
			}
			exit
		}
	' | tr -d '"'"'" || true)
	if [ -z "$desc" ]; then
		error "$label — missing 'description' in frontmatter"
		issues=$((issues + 1))
	elif echo "$desc" | grep -qiE '^(a skill for|a agent for|todo|tbd)'; then
		error "$label — empty/generic description: '$desc'"
		issues=$((issues + 1))
	fi

	# Check description has trigger hint
	if [ -n "$desc" ]; then
		if ! echo "$desc" | grep -qiE '(use when|use for|use once|use this|use if|invoke when|load when|applies when)'; then
			warn "$label — description has no trigger hint (add 'Use when...')"
			issues=$((issues + 1))
		fi
	fi

	# Check line count
	local lines
	lines=$(wc -l < "$file" | tr -d ' ')
	local size_limit=200
	local size_label="BLOATED_SKILL"
	if [ "$basename" != "SKILL.md" ]; then
		size_limit=150
		size_label="BLOATED_AGENT"
	fi
	if [ "$lines" -gt "$size_limit" ]; then
		warn "$label — ${lines}L exceeds ${size_limit}L target ($size_label)"
		issues=$((issues + 1))
	fi

	# Check for TODOs/TBDs in content (not frontmatter)
	local todos
	todos=$(tail -n +3 "$file" | grep -ciE '\bTODO\b|\bTBD\b|\bFIXME\b|\bHACK\b' || true)
	if [ "$todos" -gt 0 ]; then
		warn "$label — $todos TODO/TBD/FIXME found"
		issues=$((issues + 1))
	fi

	# For SKILL.md files: check references
	if [ "$basename" = "SKILL.md" ]; then
		local refdir="$dir/references"
		if [ -d "$refdir" ]; then
			# Check for orphan references (files not mentioned in SKILL.md)
			local ref_count=0
			local orphan_count=0
			for ref in "$refdir"/*.md; do
				[ -f "$ref" ] || continue
				ref_count=$((ref_count + 1))
				local refname
				refname=$(basename "$ref")
				if ! grep -q "$refname" "$file"; then
					warn "$label — orphan reference: references/$refname"
					orphan_count=$((orphan_count + 1))
					issues=$((issues + 1))
				fi
			done
		fi

		# Check for broken reference links in SKILL.md
		local mentioned_refs
		mentioned_refs=$(grep -oE 'references/[a-zA-Z0-9_-]+\.md' "$file" || true)
		if [ -n "$mentioned_refs" ]; then
			while IFS= read -r ref; do
				if [ ! -f "$dir/$ref" ]; then
					error "$label — broken reference: $ref"
					issues=$((issues + 1))
				fi
			done <<< "$mentioned_refs"
		fi
	fi

	# Report
	if [ "$issues" -eq 0 ]; then
		local ref_info=""
		if [ "$basename" = "SKILL.md" ] && [ -d "$dir/references" ]; then
			local rc
			rc=$(find "$dir/references" -name '*.md' 2>/dev/null | wc -l | tr -d ' ')
			ref_info=", ${rc} refs"
		fi
		pass "$label — ${lines}L${ref_info}"
	fi
}

# Check for duplicate names
check_duplicates() {
	local names_file
	names_file=$(mktemp)
	for file in "$@"; do
		local name
		name=$(awk '/^---$/{n++; next} n==1{print} n==2{exit}' "$file" | grep '^name:' | sed 's/^name: *//' | tr -d '"'"'" || true)
		if [ -n "$name" ]; then
			echo "$name|$file" >> "$names_file"
		fi
	done

	local dupes
	dupes=$(cut -d'|' -f1 "$names_file" | sort | uniq -d || true)
	if [ -n "$dupes" ]; then
		while IFS= read -r dup; do
			local files
			files=$(grep "^${dup}|" "$names_file" | cut -d'|' -f2 | tr '\n' ', ' | sed 's/,$//')
			error "Duplicate name '$dup' in: $files"
		done <<< "$dupes"
	fi

	rm -f "$names_file"
}

# Collect files
files=()
if [ -f "$DIR/SKILL.md" ]; then
	files+=("$DIR/SKILL.md")
elif [ -d "$DIR" ]; then
	# Find SKILL.md files (skills)
	while IFS= read -r f; do
		files+=("$f")
	done < <(find "$DIR" -name 'SKILL.md' 2>/dev/null | sort)

	# Find agent .md files (direct children only)
	if [ ${#files[@]} -eq 0 ]; then
		while IFS= read -r f; do
			[ -f "$f" ] && [[ "$(basename "$f")" != "README.md" ]] && files+=("$f")
		done < <(find "$DIR" -maxdepth 1 -name '*.md' 2>/dev/null | sort)
	fi
fi

if [ ${#files[@]} -eq 0 ]; then
	echo "No skill or agent files found in: $DIR"
	exit 1
fi

# Lint each file
for file in "${files[@]}"; do
	lint_file "$file"
done

# Check duplicates
check_duplicates "${files[@]}"

# Summary
echo ""
echo "Summary: $total files, $ok OK, $warns WARN, $errors ERROR"

if [ "$errors" -gt 0 ]; then
	exit 1
fi
exit 0
