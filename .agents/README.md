# .agents

This repository uses `@agents-dev/cli` for shared agent instructions and local tool synchronization.

Commit these files:

- `../AGENTS.md`
- `agents.json`
- `plugins/marketplace.json`

Do not commit local or generated outputs:

- `local.json`
- `generated/`
- `intel/`
- root `CLAUDE.md`
- tool folders such as `.codex/`, `.claude/`, `.cursor/`, `.gemini/`, `.windsurf/`, `.opencode/`

Useful commands:

```bash
agent-toolkit repo migrate
agent-toolkit repo check
agent-toolkit repo sync --check
agents status --path .
agents sync --path .
agents sync --path . --check
agents watch --path .
```

`agents sync --check` can report generated local or user-level integration drift. Treat it as a local maintenance check unless CI is explicitly configured for a clean sync environment.

Note: Windsurf writes user-level MCP config when synced. Antigravity is enabled for generated snapshots, but global sync is disabled by default.
