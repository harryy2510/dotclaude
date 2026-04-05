---
name: repo-map
description: "Use when exploring a new codebase, onboarding to a repo, or needing a symbol index (functions, classes, exports, imports) without reading every file. Installs and runs agent-analyzer."
---

# Repo Map — agent-analyzer

Generates a symbol index of any codebase using the `agent-analyzer` Rust binary. Gives agents a map of the codebase (functions, exports, imports) without reading every file. Saves massive context.

## First-Time Setup

Run the install script (downloads ~5MB binary):

```bash
bash scripts/install-repo-map.sh
```

This downloads `agent-analyzer` from [agent-sh/agent-analyzer](https://github.com/agent-sh/agent-analyzer) to `~/.agent-sh/bin/`.

## Usage

### Generate repo map
```bash
~/.agent-sh/bin/agent-analyzer repo-map generate . > .claude/repo-map.json
```

### Available commands
```bash
# Full repo intelligence (extraction + aggregation)
~/.agent-sh/bin/agent-analyzer repo-intel extract .
~/.agent-sh/bin/agent-analyzer repo-intel aggregate .

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
  "repo-map": "~/.agent-sh/bin/agent-analyzer repo-map generate . > .claude/repo-map.json"
}
```

Add `.claude/repo-map.json` to `.gitignore` — it's a local cache.
