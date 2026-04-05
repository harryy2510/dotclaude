---
name: repo-map
description: "Use when exploring a new codebase, onboarding to a repo, or needing a symbol index (functions, classes, exports, imports) without reading every file. Installs and runs agent-analyzer."
---

# Repo Map — agent-analyzer

Generates a symbol index of any codebase using the `agent-analyzer` Rust binary. Gives agents a map of the codebase (functions, exports, imports, call graphs) without reading every file. Saves massive context.

## First-Time Setup

Run the install script (downloads ~5MB binary):

```bash
bash scripts/install-repo-map.sh
```

This downloads `agent-analyzer` from [agent-sh/agent-analyzer](https://github.com/agent-sh/agent-analyzer) to `~/.agent-sh/bin/`.

## Usage

### Generate full repo map
```bash
~/.agent-sh/bin/agent-analyzer scan . --format json > .claude/repo-map.json
```

### Incremental update (only changed files)
```bash
~/.agent-sh/bin/agent-analyzer scan . --format json --incremental --cache .claude/repo-map.json > .claude/repo-map.json
```

### Query symbols
```bash
# Find all exports
~/.agent-sh/bin/agent-analyzer query .claude/repo-map.json --exports

# Find function definitions
~/.agent-sh/bin/agent-analyzer query .claude/repo-map.json --functions

# Find imports of a specific module
~/.agent-sh/bin/agent-analyzer query .claude/repo-map.json --imports-of "src/utils"
```

## When to Use

- **Onboarding to a new repo** — scan first, then ask targeted questions
- **Large refactors** — find all callers/importers of a function before changing it
- **Architecture review** — understand module boundaries and dependency flow
- **Before implementing** — check what already exists to avoid duplication

## Integration

Add to project's `package.json` scripts:

```json
{
  "repo-map": "~/.agent-sh/bin/agent-analyzer scan . --format json > .claude/repo-map.json",
  "repo-map:update": "~/.agent-sh/bin/agent-analyzer scan . --format json --incremental --cache .claude/repo-map.json > .claude/repo-map.json"
}
```

Add `.claude/repo-map.json` to `.gitignore` — it's a local cache.
