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

2. If NOT_INSTALLED, install it:
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/install-repo-map.sh"
```

3. Generate the map (JSON to stdout, logs to stderr):
```bash
mkdir -p .claude && ~/.agent-sh/bin/agent-analyzer repo-intel init ${ARGUMENT:-.} --max-commits 200 2>/dev/null > .claude/repo-intel.json
```

4. Verify output:
```bash
python3 -c "import json; d=json.load(open('.claude/repo-intel.json')); print(f'{len(d.get(\"symbols\",{}))} files, {d.get(\"git\",{}).get(\"totalCommitsAnalyzed\",0)} commits analyzed')"
```

5. Add to .gitignore if not already there:
```bash
grep -q 'repo-intel' .gitignore 2>/dev/null || echo '.claude/repo-intel.json' >> .gitignore
```

## Rules

- The map is a LOCAL cache — never commit it.
- For incremental updates: `~/.agent-sh/bin/agent-analyzer repo-intel update --map-file .claude/repo-intel.json .`
