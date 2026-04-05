---
description: Remove DotClaude — unregisters plugin and removes conventions from CLAUDE.md.
---

# /dotclaude:teardown

Reverse what `/dotclaude:setup` did.

## Steps

1. Read current `~/.claude/CLAUDE.md`:
```bash
cat ~/.claude/CLAUDE.md
```

2. Identify and remove DotClaude content. The DotClaude conventions start with `# Global Rules — All Projects`. Remove everything from that line until either the end of file or the next section that wasn't part of DotClaude (user-added content like vibe-kanban rules).

3. Write the cleaned file back. If nothing remains, leave the file empty rather than deleting it.

4. Tell the user: "DotClaude conventions removed from CLAUDE.md. To fully remove the plugin, run: `claude plugin remove DotClaude`"

## Rules

- Show the user what will be removed before doing it.
- Preserve any user-added content that wasn't part of the DotClaude CLAUDE.md.
- Do NOT run `claude plugin remove` automatically — let the user do that themselves.
