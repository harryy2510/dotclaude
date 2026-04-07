<p align="center">
  <h1 align="center">⚡ DotClaude</h1>
  <p align="center">
    <strong>Your entire Claude Code setup — skills, agents, commands, tooling — in one plugin.</strong>
  </p>
  <p align="center">
    <code>16 skills</code> · <code>19 agents</code> · <code>6 commands</code> · <code>zero bloat</code>
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
  <a href="https://eslint.org"><img src="https://img.shields.io/badge/ESLint-4B32C3?style=flat-square&logo=eslint&logoColor=white" alt="ESLint"></a>
  <a href="https://prettier.io"><img src="https://img.shields.io/badge/Prettier-F7B93E?style=flat-square&logo=prettier&logoColor=black" alt="Prettier"></a>
  <a href="https://vite.dev"><img src="https://img.shields.io/badge/Vite-646CFF?style=flat-square&logo=vite&logoColor=white" alt="Vite"></a>
  <a href="https://playwright.dev"><img src="https://img.shields.io/badge/Playwright-2EAD33?style=flat-square&logo=playwright&logoColor=white" alt="Playwright"></a>
</p>

---

> **Note:** DotClaude is distributed through the [claude-toolkit](https://github.com/harryy2510/claude-toolkit) marketplace.

```
┌────────────────────────────────────────────────────────────────────────────┐
│                                                                            │
│   claude plugin marketplace add harryy2510/claude-toolkit                  │
│   claude plugin install claude-toolkit@dotclaude                           │
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
| 🔧 | `project-setup` | ESLint, Prettier, Husky, dotenvx encrypted env, CI/CD |
| ✅ | `conventions` | One-time ESLint + pre-commit setup — enforces style via tooling forever |
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
| 🗺️ | `repo-map` | agent-analyzer symbol index — map a codebase without reading every file |
| 🧹 | `deslop` | Detect AI-generated slop — debug stmts, placeholders, hardcoded secrets |

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
| `/repo-map` | 🗺️ Runs agent-analyzer → builds symbol index → saves to `.claude/repo-map.json` |
| `/deslop` | 🧹 Scans codebase for slop → reports findings → offers to fix |
| `/skill-lint` | ✅ Validates skills + agents → checks frontmatter, size, refs, triggers |
| `/dotclaude:setup` | 🔧 One-time: copies conventions to `~/.claude/CLAUDE.md` + installs agent-analyzer |
| `/dotclaude:update` | 🔄 Updates plugin + refreshes CLAUDE.md conventions |
| `/dotclaude:uninstall` | 🗑️ Removes DotClaude conventions from CLAUDE.md |

```
  /deslop src/              ← you type this
       │
       ▼
  commands/deslop.md        ← agent reads the playbook
       │
       ▼
  scripts/deslop.sh         ← bash does the work (0 tokens)
       │
       ▼
  Report + fix offers       ← agent interprets, you decide
```

---

## 🛡️ Three-Layer Convention Defense

Run the `conventions` skill once per project. Done forever.

```
  ┌─────────────────────────────────────────────┐
  │  Layer 1: CLAUDE.md                         │
  │  AI reads the rules → generates correct     │
  │  code on first try                          │
  ├─────────────────────────────────────────────┤
  │  Layer 2: ESLint + Prettier                 │
  │  Catches mistakes at save/lint time         │
  │  Full IDE integration                       │
  ├─────────────────────────────────────────────┤
  │  Layer 3: Pre-commit hooks                  │
  │  Hard gate — wrong code NEVER gets          │
  │  committed                                  │
  └─────────────────────────────────────────────┘
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
├── CLAUDE.md                ← Conventions (copied to ~/.claude/CLAUDE.md by /dotclaude:setup)
├── agents/                  ← 19 specialist agents
│   ├── agents-orchestrator.md
│   ├── engineering-*.md
│   ├── testing-*.md
│   ├── product-manager.md
│   └── design-ux-architect.md
├── skills/                  ← 16 on-demand skills
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

Uses Claude Code's native plugin system. No custom scripts needed.

### Install

```bash
# 1. Add the marketplace
claude plugin marketplace add harryy2510/claude-toolkit

# 2. Install the plugin
claude plugin install claude-toolkit@dotclaude

# 3. Run setup in Claude Code
/dotclaude:setup
```

### Update

```bash
claude plugin marketplace update claude-toolkit
claude plugin update claude-toolkit@dotclaude
```

The marketplace update fetches the latest claude-toolkit index. The plugin update pulls the new version. Both steps needed.

Or from Claude Code: `/dotclaude:update`

### Uninstall

Run `/dotclaude:uninstall` first (removes conventions from CLAUDE.md), then:

```bash
claude plugin uninstall claude-toolkit@dotclaude
```

### What happens where

```
  marketplace add           →  Registers harryy2510/claude-toolkit as a plugin source
  plugin install              →  Installs dotclaude from the marketplace
                                 Skills, agents, commands available immediately

  /dotclaude:setup →  Conventions copied to ~/.claude/CLAUDE.md
                                 agent-analyzer binary installed

  plugin update              →  Plugin cache refreshed from git
  /dotclaude:update → Same + refreshes CLAUDE.md conventions

  /dotclaude:uninstall → Removes conventions from ~/.claude/CLAUDE.md
  plugin uninstall              →  Removes plugin from cache
```

---

## ✅ Validate

```
/skill-lint              Lint everything
/skill-lint skills       Lint skills only
/skill-lint agents       Lint agents only
/deslop .                Deslop the plugin itself
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
3. Add to skill table in `CLAUDE.md`
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
