---
name: repo-map
description: "Use when exploring a new codebase, onboarding to a repo, or needing a symbol index (functions, classes, exports, imports) without reading every file. Installs and runs agent-analyzer."
---

# Repo Map — agent-analyzer

Generates a full repository intelligence map using the `agent-analyzer` Rust binary. Extracts symbols (functions, exports, imports), analyzes git history, and builds a queryable index — without reading every file. Saves massive context.

## First-Time Setup

Run the install script with an explicit pinned version:

```bash
AGENT_ANALYZER_VERSION=<version> bash scripts/install-repo-map.sh
```

This downloads `agent-analyzer` from [agent-sh/agent-analyzer](https://github.com/agent-sh/agent-analyzer) to `~/.agent-sh/bin/`.

Set `AGENT_ANALYZER_SHA256=<sha256>` when you have the release checksum.

## Usage

### Generate repo intelligence map (primary command)
```bash
~/.agent-sh/bin/agent-analyzer repo-intel init . --max-commits 200
```

Creates `.agents/intel/repo-map/repo-intel.json` with full symbol index, import graph, and git history analysis.

### Update existing map (incremental)
```bash
~/.agent-sh/bin/agent-analyzer repo-intel update .
```

### Query symbols for a specific file
```bash
~/.agent-sh/bin/agent-analyzer repo-map symbols --map-file .agents/intel/repo-map/repo-intel.json src/api/auth/hooks.ts
```

### Other commands
```bash
# AST symbol extraction only (summary)
~/.agent-sh/bin/agent-analyzer repo-map generate .

# Project data collection
~/.agent-sh/bin/agent-analyzer collect .

# Doc-code sync analysis
~/.agent-sh/bin/agent-analyzer sync-check .
```

## When to Use

- **Onboarding to a new repo** — generate map first, then ask targeted questions
- **Large refactors** — find all callers/importers of a function before changing it
- **Architecture review** — understand module boundaries and dependency flow
- **Before implementing** — check what already exists to avoid duplication

## Integration

Add to project's `package.json` scripts:

```json
{
  "repo-map": "~/.agent-sh/bin/agent-analyzer repo-intel init . --max-commits 200",
  "repo-map:update": "~/.agent-sh/bin/agent-analyzer repo-intel update ."
}
```

Generated repo-map files live under `.agents/intel/repo-map/`, which Agent Toolkit ignores as a local cache.
