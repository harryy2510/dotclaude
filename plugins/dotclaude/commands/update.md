---
description: Update DotClaude plugin to latest version and refresh CLAUDE.md conventions.
---

Update the plugin and re-run setup:

```bash
claude plugin marketplace update claude-toolkit && claude plugin update dotclaude@claude-toolkit
```

Then refresh conventions:

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/setup.sh"
```
