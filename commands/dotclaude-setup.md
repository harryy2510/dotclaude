---
description: One-time setup after installing DotClaude. Copies conventions to ~/.claude/CLAUDE.md and installs agent-analyzer.
---

# /dotclaude:setup

Run once after `claude plugin add`. Sets up conventions and tooling.

## Steps

1. Read the plugin's CLAUDE.md:
```bash
cat "${CLAUDE_PLUGIN_ROOT}/CLAUDE.md"
```

2. Check if `~/.claude/CLAUDE.md` already exists and has content:
```bash
[ -f ~/.claude/CLAUDE.md ] && wc -l ~/.claude/CLAUDE.md || echo "EMPTY"
```

3. If it exists and has content, show the user what's there and ask: "Replace with DotClaude conventions, or append?" Then either replace or append based on their answer.

4. If it doesn't exist or is empty, copy directly:
```bash
cp "${CLAUDE_PLUGIN_ROOT}/CLAUDE.md" ~/.claude/CLAUDE.md
```

5. Install agent-analyzer if not present:
```bash
if [ ! -x "$HOME/.agent-sh/bin/agent-analyzer" ]; then
  bash "${CLAUDE_PLUGIN_ROOT}/scripts/install-repo-map.sh"
else
  echo "agent-analyzer already installed"
fi
```

6. Confirm: "DotClaude setup complete. Conventions loaded. Commands available: /repo-map, /deslop, /skill-lint"

## Rules

- Always show the user what will change in CLAUDE.md before overwriting.
- If they have existing content (like vibe-kanban rules), offer to append rather than replace.
