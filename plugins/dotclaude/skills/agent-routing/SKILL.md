---
name: agent-routing
description: "Use when deciding which role, skill, or native subagent should handle work."
---

# Agent Routing

Use role profiles to make agents useful even when the host does not support native subagents.

## Activation Flow

Before substantial work:

1. Identify the work type.
2. Pick the matching role profile from `agents/` when available.
3. Read that role profile.
4. Read every skill referenced by the role profile and by the repo instructions.
5. Announce the active role and skills in one short sentence.
6. Use native subagents only when the current host supports them and the task benefits from parallel work.

## Common Roles

- Broad implementation: `engineering-senior-developer`
- Frontend work: `engineering-frontend-developer`, plus `ui`, `shadcn`, `react-best-practices`
- Backend or APIs: `engineering-backend-architect`, plus data and server skills
- Database work: `engineering-database-optimizer`, plus Supabase and Postgres skills
- DevOps or CI: `engineering-devops-automator`, plus `toolchain`, `project-setup`, `cloudflare`
- Review: `engineering-code-reviewer`, plus `repo-intelligence`
- Testing: `testing-e2e-writer`, `testing-e2e-runner`, or `testing-api-tester`, plus `testing`
- Planning or triage: `agents-orchestrator`, plus the relevant domain skills

## Rule

If native subagents are unavailable, do not skip the role. Read the role profile and operate in that mode yourself.
