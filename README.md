<p align="center">
  <h1 align="center">⚡ DotClaude</h1>
  <p align="center">
    <strong>Your agent setup: skills, agents, commands, tooling, and shared rules in one plugin.</strong>
  </p>
  <p align="center">
    <code>20 skills</code> · <code>19 agents</code> · <code>6 commands</code> · <code>zero bloat</code>
  </p>
</p>

<p align="center">
  <a href="https://react.dev"><img src="https://img.shields.io/badge/React_19-61DAFB?style=flat-square&logo=react&logoColor=black" alt="React 19"></a>
  <a href="https://www.typescriptlang.org"><img src="https://img.shields.io/badge/TypeScript-3178C6?style=flat-square&logo=typescript&logoColor=white" alt="TypeScript"></a>
  <a href="https://tanstack.com/start"><img src="https://img.shields.io/badge/TanStack_Start-FF4154?style=flat-square&logo=reactquery&logoColor=white" alt="TanStack Start"></a>
  <a href="https://supabase.com"><img src="https://img.shields.io/badge/Supabase-3FCF8E?style=flat-square&logo=supabase&logoColor=white" alt="Supabase"></a>
  <a href="https://workers.cloudflare.com"><img src="https://img.shields.io/badge/Cloudflare_Workers-F38020?style=flat-square&logo=cloudflare&logoColor=white" alt="Cloudflare Workers"></a>
  <a href="https://tailwindcss.com"><img src="https://img.shields.io/badge/Tailwind_v4-06B6D4?style=flat-square&logo=tailwindcss&logoColor=white" alt="Tailwind v4"></a>
  <a href="https://ui.shadcn.com"><img src="https://img.shields.io/badge/shadcn/ui-000000?style=flat-square&logo=shadcnui&logoColor=white" alt="shadcn/ui"></a>
  <a href="https://tanstack.com/query"><img src="https://img.shields.io/badge/React_Query-FF4154?style=flat-square&logo=reactquery&logoColor=white" alt="React Query"></a>
  <a href="https://react-hook-form.com"><img src="https://img.shields.io/badge/React_Hook_Form-EC5990?style=flat-square&logo=reacthookform&logoColor=white" alt="React Hook Form"></a>
  <a href="https://zod.dev"><img src="https://img.shields.io/badge/Zod_v4-3E67B1?style=flat-square&logo=zod&logoColor=white" alt="Zod v4"></a>
  <a href="https://bun.sh"><img src="https://img.shields.io/badge/Bun-000000?style=flat-square&logo=bun&logoColor=white" alt="Bun"></a>
  <a href="https://oxc.rs"><img src="https://img.shields.io/badge/Oxlint-111827?style=flat-square" alt="Oxlint"></a>
  <a href="https://oxc.rs"><img src="https://img.shields.io/badge/Oxfmt-111827?style=flat-square" alt="Oxfmt"></a>
  <a href="https://vite.dev"><img src="https://img.shields.io/badge/Vite-646CFF?style=flat-square&logo=vite&logoColor=white" alt="Vite"></a>
  <a href="https://playwright.dev"><img src="https://img.shields.io/badge/Playwright-2EAD33?style=flat-square&logo=playwright&logoColor=white" alt="Playwright"></a>
</p>

---

> **Note:** DotClaude is distributed through the [agent-toolkit](https://github.com/harryy2510/agent-toolkit) marketplace.

```
┌────────────────────────────────────────────────────────────────────────────┐
│                                                                            │
│   claude plugin marketplace add harryy2510/agent-toolkit                  │
│   claude plugin install dotclaude@agent-toolkit                           │
│   /dotclaude:setup                                                 │
│                                                                            │
│   That's it. Every project. Every agent. Same standards.                   │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

---

## 🧠 Skills

Loaded on-demand. Only the relevant skill enters context — the rest cost 0 tokens.

| | Skill | What it teaches |
|---|---|---|
| 🏗️ | `scaffold` | Full project scaffolding — TanStack Start + Supabase + Cloudflare |
| 🔧 | `toolchain` | Bun, TypeScript, oxlint, oxfmt, hooks, Conventional Commits |
| 🧭 | `repo-intelligence` | Unified CodeSight, repo-map, deslop context and checks |
| 🤖 | `agent-routing` | Role activation, skill routing, native subagent fallback |
| 🔧 | `project-setup` | DX tooling, dotenvx encrypted env, CI/CD |
| ✅ | `conventions` | One-time convention setup — enforces style via tooling forever |
| 🎨 | `ui` | Tailwind v4, shadcn/base-ui, CVA variants, dark mode, animations |
| 🧩 | `shadcn` | Adding, searching, fixing, composing shadcn/ui components |
| 📝 | `forms-rhf-zod` | react-hook-form + zod v4, create/edit modes, useWatch patterns |
| 🔄 | `react-query-mutative` | QueryClient config, key factories, optimistic updates |
| 📦 | `zustand-x-ui-state` | zustand-x v6 stores, boundary rules, theme system |
| 🛣️ | `tanstack-start-cloudflare` | Routes, layouts, server functions, deploy config |
| 🔐 | `supabase-auth-data` | 3 Supabase clients, auth flow, migrations, RLS |
| ☁️ | `cloudflare` | Workers best practices, Wrangler CLI, wrangler.jsonc |
| ⚡ | `vite` | Vite config, plugin API, SSR, Rolldown migration |
| 🚀 | `react-best-practices` | 57 performance rules + composition patterns |
| 🗄️ | `supabase-postgres-best-practices` | Indexing, query plans, RLS perf, connection pooling |
| 🗺️ | `repo-map` | Legacy fallback symbol index when toolkit repo intelligence is insufficient |
| 🧹 | `deslop` | Legacy fallback slop scanner when toolkit checks are unavailable |
| 🧪 | `testing` | Vitest + Testing Library + Playwright, file conventions, what to test |

---

## 🤖 Agents

**19 specialists. All under 80 lines. Pure signal, no fluff.**

```
╔══════════════════════════════════════════════════════════════════════╗
║                                                                      ║
║  💻 ENGINEERING          🧪 TESTING         📋 PRODUCT              ║
║  ─────────────           ─────────          ──────────               ║
║  Backend Architect       API Tester         Product Manager          ║
║  Frontend Developer      Perf Benchmarker   UX Architect             ║
║  Senior Developer        E2E Test Writer                             ║
║  Database Optimizer      E2E Test Runner    🎛️ ORCHESTRATION         ║
║  DevOps Automator                           ────────────────         ║
║  Security Engineer                          Agents                   ║
║  Rapid Prototyper                           Orchestrator             ║
║  Software Architect                         (8-phase workflow)       ║
║  Code Reviewer                                                       ║
║  Git Workflow Master                                                 ║
║  Technical Writer                                                    ║
║  MCP Builder                                                         ║
║                                                                      ║
╚══════════════════════════════════════════════════════════════════════╝
```

---

## ⚡ Commands

Type these directly in Claude Code:

| Command | What happens |
|---|---|
| `/repo-map` | 🗺️ Legacy fallback: runs agent-analyzer → builds symbol index |
| `/deslop` | 🧹 Legacy fallback: scans codebase for slop |
| `/skill-lint` | ✅ Validates skills + agents → checks frontmatter, size, refs, triggers |
| `/dotclaude:setup` | 🔧 One-time: installs managed global rules for Claude and Codex |
| `/dotclaude:update` | 🔄 Updates plugin + refreshes Claude and Codex conventions |
| `/dotclaude:uninstall` | 🗑️ Removes DotClaude conventions from Claude and Codex global instruction files |

```
  bunx @harryy/agent-toolkit repo intel   ← builds local repo context
       │
       ▼
  .agents/intel/summary.md                ← agents read this first
       │
       ▼
  bunx @harryy/agent-toolkit repo check   ← rules, tooling, slop checks
       │
       ▼
  Report + fix offers                     ← agent interprets, you decide
```

---

## 🛡️ Three-Layer Convention Defense

Run Agent Toolkit once per project. Done forever.

```
  ┌─────────────────────────────────────────────┐
  │  Layer 1: CLAUDE.md / AGENTS.md             │
  │  AI reads the rules → generates correct     │
  │  code on first try                          │
  ├─────────────────────────────────────────────┤
  │  Layer 2: oxlint + oxfmt                    │
  │  Fast lint, type-check, and formatting      │
  │  Type-aware checks without tsc              │
  ├─────────────────────────────────────────────┤
  │  Layer 3: Pre-commit hooks                  │
  │  Hard gate — wrong code NEVER gets          │
  │  committed                                  │
  └─────────────────────────────────────────────┘
```

```bash
bunx @harryy/agent-toolkit repo bootstrap
bunx @harryy/agent-toolkit repo intel
bunx @harryy/agent-toolkit repo check
```

---

## 🎯 Agent Orchestration

The `agents-orchestrator` enforces an 8-phase workflow:

```
  ┌──────────────┐
  │ 1. Discovery │ ──→  Read spec/issue, understand scope
  ├──────────────┤
  │ 2. Explore   │ ──→  Read code, check existing patterns
  ├──────────────┤
  │ 3. Plan      │ ──→  Propose approach, identify changes
  ├──────────────┤
  │ 4. APPROVE   │ ──→  ⛔ HARD GATE — user must approve
  ├──────────────┤
  │ 5. Implement │ ──→  Spawn specialist agents, write code
  ├──────────────┤
  │ 6. Review    │ ──→  Code reviewer agent, fix findings
  ├──────────────┤
  │ 7. Validate  │ ──→  Run check command (deterministic)
  ├──────────────┤
  │ 8. Ship      │ ──→  Commit/PR — only if you say so
  └──────────────┘
```

---

## 📁 Project Structure

```
dotclaude/
├── CLAUDE.md                ← Claude-specific plugin compatibility rules
├── AGENTS.md                ← Shared agent conventions for global symlinks
├── .claude-plugin/          ← Claude Code plugin manifest
├── .codex-plugin/           ← Codex plugin manifest
├── gemini-extension/        ← Gemini CLI extension wrapper
│   ├── gemini-extension.json
│   ├── AGENTS.md            ← symlink to ../AGENTS.md
│   └── skills               ← symlink to ../skills
├── agents/                  ← 19 specialist agents
│   ├── agents-orchestrator.md
│   ├── engineering-*.md
│   ├── testing-*.md
│   ├── product-manager.md
│   └── design-ux-architect.md
├── skills/                  ← 20 on-demand skills
│   ├── conventions/
│   ├── scaffold/
│   ├── ui/
│   ├── ...
│   └── deslop/
│       ├── SKILL.md
│       └── references/
├── commands/                ← Slash commands
│   ├── repo-map.md
│   ├── deslop.md
│   ├── skill-lint.md
│   ├── dotclaude-setup.md
│   ├── dotclaude-update.md
│   └── dotclaude-uninstall.md
└── scripts/                 ← Pure bash tooling (0 tokens)
    ├── deslop.sh
    ├── install-repo-map.sh
    └── skill-lint.sh
```

---

## 🔧 Install / Update / Uninstall

Claude Code uses its native plugin system. Codex and other agents can consume the shared instructions through `AGENTS.md`, `.agents/agents.json`, and the Codex plugin manifest.

### Install

Claude Code:

```bash
# 1. Add the marketplace
claude plugin marketplace add harryy2510/agent-toolkit

# 2. Install the plugin
claude plugin install dotclaude@agent-toolkit

# 3. Run setup in Claude Code
/dotclaude:setup
```

Gemini CLI:

```bash
gemini extensions link plugins/dotclaude/gemini-extension
```

Codex:

```bash
bunx @harryy/agent-toolkit setup --yes
bunx @harryy/agent-toolkit repo migrate
```

Codex consumes `AGENTS.md` directly and can read the local plugin metadata at `plugins/dotclaude/.codex-plugin/plugin.json`.

For repo-local agent sync:

```bash
agents sync --path .
agents watch --path .
```

### Update

```bash
claude plugin marketplace update agent-toolkit
claude plugin update dotclaude@agent-toolkit
```

The marketplace update fetches the latest agent-toolkit index. The plugin update pulls the new version. Both steps needed.

Or from Claude Code: `/dotclaude:update`

### Uninstall

Run `/dotclaude:uninstall` first (removes managed conventions from Claude and Codex global instruction files), then:

```bash
claude plugin uninstall dotclaude@agent-toolkit
```

### What happens where

```
  marketplace add           →  Registers harryy2510/agent-toolkit as a plugin source
  plugin install              →  Installs dotclaude from the marketplace
                                 Skills, agents, commands available immediately

  /dotclaude:setup →  Managed rules inserted into ~/.claude/CLAUDE.md and ~/.codex/AGENTS.md

  plugin update              →  Plugin cache refreshed from git
  /dotclaude:update → Same + refreshes global conventions

  /dotclaude:uninstall → Removes managed conventions from global instruction files
  plugin uninstall              →  Removes plugin from cache
```

---

## ✅ Validate

```
/skill-lint              Lint everything
/skill-lint skills       Lint skills only
/skill-lint agents       Lint agents only
bunx @harryy/agent-toolkit repo check
```

---

## 👥 For the Team

### Adding a skill

1. Create `skills/<name>/SKILL.md`:
   ```yaml
   ---
   name: my-skill
   description: "Use when [trigger condition]."
   ---
   ```
2. Heavy content → `skills/<name>/references/`
3. Add to skill table in `AGENTS.md` and compatibility docs when needed
4. Run `/skill-lint skills`

### Adding an agent

1. Create `agents/<name>.md`:
   ```yaml
   ---
   name: My Agent
   description: Use when [trigger]. Does [what].
   color: blue
   ---
   ```
2. Under 80 lines. Role, rules, patterns. No fluff.
3. Run `/skill-lint agents`

### Contributing rules

The plugin follows its own conventions:

```
  ✅  Single quotes, no semicolons, trailing commas
  ✅  type not interface, inline type imports
  ✅  Named imports from react (never React.xxx)
  ✅  bunx not npx, bun not npm
```

---
