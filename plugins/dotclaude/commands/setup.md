---
description: One-time setup after installing DotClaude. Copies conventions to ~/.claude/CLAUDE.md and ~/.codex/AGENTS.md.
---

Run the setup script:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/setup.sh"
```

Legacy repo-map binary install is opt-in:

```bash
DOTCLAUDE_INSTALL_REPO_MAP=1 AGENT_ANALYZER_VERSION=<version> bash "${CLAUDE_PLUGIN_ROOT}/scripts/setup.sh"
```
