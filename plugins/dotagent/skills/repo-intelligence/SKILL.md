---
name: repo-intelligence
description: "Use when exploring a codebase, reviewing code, planning a refactor, enforcing agent rules, or finishing work; load before broad inspection."
---

# Repo Intelligence

Use one toolkit entrypoint for context and enforcement.

Before building unfamiliar capability, search existing repo patterns and current official docs. Prefer proven local/library behavior over inventing a bespoke path.

## Preferred Workflow

```bash
bunx @harryy/agent-toolkit repo intel
bunx @harryy/agent-toolkit repo check
```

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
3. If deeper symbol data is needed, use focused source search and local code-reading tools after reading the summary.

## Quality Gate

`repo check` owns the combined enforcement path:

- AGENTS.md and `.agents/agents.json` presence.
- Toolchain rules: Bun, TypeScript, oxlint, oxfmt.
- Deslop patterns: debug statements, placeholders, empty catches, likely secrets.
- Generated agent output drift when supported.
- Conventional commit hook support when bootstrapped.

Do not manually juggle separate context tools as default setup. Use the toolkit first, then inspect focused source files as needed.
