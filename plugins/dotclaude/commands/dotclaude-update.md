---
description: Update DotClaude plugin to latest version and refresh CLAUDE.md conventions.
---

# /dotclaude:update

Update DotClaude to the latest version.

## Steps

1. Update the plugin via Claude Code:
```bash
claude plugin update DotClaude
```

2. Re-copy conventions to ~/.claude/CLAUDE.md (preserving any user-added sections):
```bash
cat "${CLAUDE_PLUGIN_ROOT}/CLAUDE.md"
```

Read the updated CLAUDE.md from the plugin, then update `~/.claude/CLAUDE.md` with the new content. If the user has added custom sections (anything after the DotClaude content), preserve them.

3. Report what changed:
```bash
echo "DotClaude updated. Check /skill-lint to verify."
```

## Rules

- If `claude plugin update` fails, report the error.
- After update, suggest running `/skill-lint` to verify.
- Never silently drop user-added content from CLAUDE.md.
