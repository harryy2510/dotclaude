---
description: Validate skill and agent quality — checks frontmatter, triggers, size, broken references, orphan files, and duplicates.
argument-hint: [skills|agents|path]
---

# /skill-lint

Run quality validation on skills and agents.

## Steps

1. Determine what to lint:
   - `skills` → lint `${CLAUDE_PLUGIN_ROOT}/skills/`
   - `agents` → lint `${CLAUDE_PLUGIN_ROOT}/agents/`
   - A specific path → lint that path
   - No argument → lint both skills and agents

2. Run the linter:
```bash
if [ -z "${ARGUMENT}" ] || [ "${ARGUMENT}" = "all" ]; then
  echo "=== Skills ===" && bash "${CLAUDE_PLUGIN_ROOT}/scripts/skill-lint.sh" "${CLAUDE_PLUGIN_ROOT}/skills/"
  echo "" && echo "=== Agents ===" && bash "${CLAUDE_PLUGIN_ROOT}/scripts/skill-lint.sh" "${CLAUDE_PLUGIN_ROOT}/agents/"
elif [ "${ARGUMENT}" = "skills" ]; then
  bash "${CLAUDE_PLUGIN_ROOT}/scripts/skill-lint.sh" "${CLAUDE_PLUGIN_ROOT}/skills/"
elif [ "${ARGUMENT}" = "agents" ]; then
  bash "${CLAUDE_PLUGIN_ROOT}/scripts/skill-lint.sh" "${CLAUDE_PLUGIN_ROOT}/agents/"
else
  bash "${CLAUDE_PLUGIN_ROOT}/scripts/skill-lint.sh" "${ARGUMENT}"
fi
```

3. Report results. If errors found, suggest fixes for each one.

## Rules

- Show the full output — don't summarize away individual findings.
- For WARN items, explain what to fix. For ERROR items, fix them if the user asks.
