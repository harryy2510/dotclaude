---
description: Generate a symbol index of the codebase using agent-analyzer. Saves to .claude/repo-map.json.
argument-hint: [path]
---

# /repo-map

Generate a repo map (symbol index) of the codebase.

## Steps

1. Check if agent-analyzer is installed:
```bash
~/.agent-sh/bin/agent-analyzer --version 2>/dev/null || echo "NOT_INSTALLED"
```

2. If NOT_INSTALLED, run the installer:
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/install-repo-map.sh"
```

3. Create .claude directory if it doesn't exist:
```bash
mkdir -p .claude
```

4. Run the scan on the target path (default: current directory):
```bash
~/.agent-sh/bin/agent-analyzer scan ${ARGUMENT:-.} --format json > .claude/repo-map.json
```

5. Report results:
```bash
echo "Repo map saved to .claude/repo-map.json"
wc -l .claude/repo-map.json | awk '{print $1 " lines indexed"}'
```

6. Add to .gitignore if not already there:
```bash
grep -q 'repo-map.json' .gitignore 2>/dev/null || echo '.claude/repo-map.json' >> .gitignore
```

## Rules

- Always check if binary exists before trying to scan.
- If scan fails, report the error — don't silently skip.
- The repo map is a LOCAL cache — never commit it.
