---
description: Scan the codebase for AI-generated slop patterns (debug statements, placeholders, hardcoded secrets, empty catches).
argument-hint: [path|--staged]
---

# /deslop

Run code quality scan for slop patterns.

## Steps

1. Determine the scan target:
   - If argument provided, use it (e.g., `src/`, `--staged`)
   - If no argument, scan the current directory

2. Run the deslop scanner:
```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/deslop.sh" ${ARGUMENT:-.}
```

3. If critical issues found (exit code 1):
   - List each critical finding with file and line number
   - Suggest fixes for each one
   - Ask if the user wants you to auto-fix the safe ones (remove debug statements, flag secrets)

4. If clean (exit code 0):
   - Report "Clean — no slop detected"

## Rules

- Report ALL findings before offering to fix anything.
- Never auto-fix hardcoded secrets — only flag them. The user decides the replacement.
- Debug statement removal (console.log, print) is safe to auto-fix if user approves.
- Empty catch blocks need real error handling added, not just a comment.
