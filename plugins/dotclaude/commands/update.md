---
description: Update DotClaude plugin to latest version and refresh Claude and Codex conventions.
---

Update the plugin and re-run setup:

```bash
claude plugin marketplace update agent-toolkit && claude plugin update dotclaude@agent-toolkit
```

Then refresh conventions:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/setup.sh"
```
