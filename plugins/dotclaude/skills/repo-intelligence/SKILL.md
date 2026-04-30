---
name: repo-intelligence
description: "Use before exploring a codebase, reviewing code, planning a refactor, enforcing agent rules, or finishing work."
---

# Repo Intelligence

Use one toolkit entrypoint for context and enforcement.

## Preferred Workflow

```bash
bunx @harryy/agent-toolkit repo intel
bunx @harryy/agent-toolkit repo check
```

If the package is not published or available in the current environment, use the repo-local Agent Toolkit binary or set `AGENT_TOOLKIT_BIN=/path/to/agent-toolkit` and run `scripts/agent-check`.

`repo intel` creates local ignored context:

```text
.agents/intel/summary.md
.agents/intel/repo.json
```

Agents should read `.agents/intel/summary.md` before broad source exploration.

## Context Order

1. If `.codesight/` exists, prefer it:
   - Read `.codesight/wiki/index.md`.
   - Read `.codesight/CODESIGHT.md`.
   - Open focused `.codesight/*` files only when needed.
2. If `.codesight/` does not exist, use generated `.agents/intel/summary.md`.
3. If deeper symbol data is needed and the toolkit summary is insufficient, use the legacy `repo-map` skill as a fallback.

## Quality Gate

`repo check` owns the combined enforcement path:

- AGENTS.md and `.agents/agents.json` presence.
- Toolchain rules: Bun, TypeScript, oxlint, oxfmt.
- Deslop patterns: debug statements, placeholders, empty catches, likely secrets.
- Generated agent output drift when supported.
- Conventional commit hook support when bootstrapped.

Do not manually juggle CodeSight, repo-map, and deslop as separate default steps. Use the toolkit first, then fall back only when needed.
