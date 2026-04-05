---
description: Generate a full repository intelligence map using agent-analyzer. Saves to .claude/repo-intel.json.
argument-hint: [path]
---

# /repo-map

Generate a repo intelligence map (symbols, imports, git history) of the codebase.

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

4. Generate the repo intelligence map (JSON goes to stdout, logs to stderr):
```bash
~/.agent-sh/bin/agent-analyzer repo-intel init ${ARGUMENT:-.} --max-commits 200 2>/dev/null > .claude/repo-intel.json
```

5. Verify:
```bash
python3 -c "import json; d=json.load(open('.claude/repo-intel.json')); print(f'{len(d.get(\"symbols\",{}))} files indexed')"
```

6. Add to .gitignore if not already there:
```bash
grep -q 'repo-intel.json' .gitignore 2>/dev/null || echo '.claude/repo-intel.json' >> .gitignore
```

## Rules

- Always check if binary exists before running.
- The repo intel map is a LOCAL cache — never commit it.
