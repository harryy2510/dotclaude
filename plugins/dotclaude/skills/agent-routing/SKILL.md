---
name: agent-routing
description: "Use when deciding which role profile, skill, native subagent, or agent-team pattern should handle work. Must be used before substantial work, broad exploration, reviews, implementation, testing, documentation, or any task that maps to a specialist agent."
---

# Agent Routing

Route work before doing work. The goal is that specialists are actually used when their domain appears, without wasting context on unrelated roles.

## Activation Flow

Before substantial work:

1. Identify the work type.
2. Pick every matching role profile from `agents/`.
3. If the host supports native subagents and policy/user permissions allow delegation, invoke the matching specialist for self-contained work. Do not merely mention the specialist.
4. If native subagents are unavailable or disallowed, read the role profile and operate in that mode yourself.
5. Read every skill named in the role profile `skills:` list, plus any skill required by repo instructions.
6. Announce one routing receipt: `Active role: <agent>; skills: <skills>; mode: <native|local>; reason: <trigger>`.

## Host Rules

- Claude Code: custom agents are selected by their frontmatter `description`; `MUST BE USED` and `Use PROACTIVELY` descriptions should be treated as routing requirements.
- Claude Code subagents cannot spawn other subagents. Keep coordination roles such as `agents-orchestrator` in the main thread when they need to invoke specialists; the main thread should call each specialist directly.
- Codex: current releases spawn subagents only when the user explicitly asks for subagents or parallel agent work. Without that explicit ask, use the matching role profile locally.
- Other hosts: use native delegation only when the tool exposes it and the current policy permits it.

## Routing Matrix

| Work type | Agent | Required skills |
|---|---|---|
| Multi-agent coordination, decomposition, specialist selection | `agents-orchestrator` | `agent-routing`, `repo-intelligence`, `toolchain` |
| Complex full-stack implementation | `engineering-senior-developer` | `toolchain`, `repo-intelligence`, `tanstack-start-cloudflare`, `react-best-practices`, `react-query-mutative`, `forms-rhf-zod`, `zustand-x-ui-state`, `supabase-auth-data`, `supabase-postgres-best-practices`, `cloudflare`, `ui`, `testing` |
| Architecture, domain modeling, ADRs, refactor planning | `engineering-software-architect` | `agent-routing`, `repo-intelligence`, `toolchain`, stack-specific skills |
| Frontend UI, React, accessibility, responsive work | `engineering-frontend-developer` | `ui`, `shadcn`, `react-best-practices`, `forms-rhf-zod`, `react-query-mutative`, `zustand-x-ui-state`, `testing` |
| Design systems, layouts, component hierarchy, UX handoff | `design-ux-architect` | `ui`, `shadcn`, `react-best-practices`, `repo-intelligence` |
| Backend, APIs, server functions, auth/data boundaries | `engineering-backend-architect` | `toolchain`, `repo-intelligence`, `tanstack-start-cloudflare`, `supabase-auth-data`, `supabase-postgres-best-practices`, `cloudflare` |
| Postgres, migrations, RLS, indexes, query plans | `engineering-database-optimizer` | `repo-intelligence`, `toolchain`, `supabase-auth-data`, `supabase-postgres-best-practices` |
| CI/CD, GitHub Actions, deployments, Wrangler | `engineering-devops-automator` | `toolchain`, `repo-intelligence`, `project-setup`, `cloudflare` |
| Security, authz, secrets, threat modeling | `engineering-security-engineer` | `repo-intelligence`, `toolchain`, `supabase-auth-data`, `supabase-postgres-best-practices`, `cloudflare` |
| Bugs, crashes, regressions, flaky tests, unclear root cause | `engineering-debugger` | `debugging`, `repo-intelligence`, `toolchain`, `testing` |
| Code review | `engineering-code-reviewer` | `repo-intelligence`, `toolchain`, `deslop`, `testing` |
| Git workflow, commits, branches, worktrees | `engineering-git-workflow-master` | `toolchain`, `repo-intelligence` |
| Prototype or MVP | `engineering-rapid-prototyper` | `toolchain`, `scaffold`, `ui`, `react-best-practices` |
| Developer docs, README, commands, migration guides | `engineering-technical-writer` | `repo-intelligence`, `toolchain` |
| Product specs, PRDs, priorities, acceptance criteria | `product-manager` | `repo-intelligence`, `agent-routing` |
| MCP servers and agent connectors | `specialized-mcp-builder` | `toolchain`, `repo-intelligence` |
| API tests and contracts | `testing-api-tester` | `testing`, `toolchain`, `repo-intelligence`, `supabase-auth-data`, `cloudflare` |
| New Playwright E2E tests | `testing-e2e-writer` | `testing`, `repo-intelligence`, `ui` |
| Running/debugging Playwright E2E | `testing-e2e-runner` | `debugging`, `testing`, `toolchain`, `repo-intelligence` |
| Performance/load/Core Web Vitals | `testing-performance-benchmarker` | `testing`, `repo-intelligence`, `react-best-practices`, `cloudflare`, `vite` |

## Multi-Role Tasks

- Prefer one lead role and one reviewer role.
- Use `agents-orchestrator` locally in the main thread for work that needs multiple specialists; do not bury coordination inside a spawned child agent.
- For cross-layer implementation, lead with `engineering-senior-developer`, then invoke focused specialists for independent backend, frontend, database, or testing slices.
- For risky code changes, use `engineering-code-reviewer` after implementation even if another specialist already reviewed locally.
- For research-only work, use read-only roles where possible and avoid write-capable agents unless edits are required.

## Delivery Gates

- Before shipping substantial work, run: deslop/code-quality pass, relevant tests, reviewer pass, delivery validation, and docs sync when behavior or commands changed.
- When agent, skill, command, or plugin config changes, run `skill-lint` and check for conflicting rules, overbroad tools, stale triggers, and broken references.
- Compare implementation against the approved plan or acceptance criteria; flag drift even when tests pass.
- For developer-facing APIs, CLIs, SDKs, docs, or setup flows, include a DX review: time-to-first-success, install friction, copy/paste command accuracy, error recovery, and examples.
- For complex or risky behavior, prefer a test-first loop: failing test, minimal implementation, passing test, refactor.
- If work reveals a durable repo convention or repeated pitfall, capture it in the appropriate rule/skill/reference instead of leaving it only in chat.

## Subagent Prompt Contract

When invoking a native specialist, include:

- task goal and non-goals
- files or directories it owns
- repo constraints and relevant user constraints
- required skills or checks
- expected output format
- instruction not to revert unrelated user changes
