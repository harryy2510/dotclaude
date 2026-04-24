<p align="center">
  <h1 align="center">DotClaude</h1>
  <p align="center">
    <strong>Your entire Claude Code setup in one plugin.</strong>
  </p>
  <p align="center">
    <code>18 skills</code> &middot; <code>19 agents</code> &middot; <code>6 commands</code> &middot; <code>zero bloat</code>
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

```bash
claude plugin marketplace add harryy2510/claude-toolkit
claude plugin install dotclaude@claude-toolkit
/dotclaude:setup
```

---

## How It Works

Skills load on demand. Only the relevant skill enters context -- the rest cost 0 tokens. Agents are specialists that know when to defer. Commands run bash scripts that do the work without burning tokens.

```
You: "Build a form"

  1. Loads forms-rhf-zod skill   ── react-hook-form + zod v4 patterns
  2. Loads ui skill              ── Tailwind v4, shadcn, CVA variants
  3. Generates correct code      ── follows conventions from CLAUDE.md
  4. Pre-commit hook catches     ── ESLint + Prettier enforce the rest
```

---

## Skills

Loaded on-demand. Each skill is a reference guide with exact patterns, APIs, and conventions.

| | Skill | What |
|---|---|---|
| 🏗️ | `scaffold` | Full project scaffolding -- TanStack Start + Supabase + Cloudflare |
| 🔧 | `project-setup` | ESLint, Prettier, Husky, dotenvx encrypted env, CI/CD |
| ✅ | `conventions` | One-time ESLint + pre-commit setup -- enforces style via tooling |
| 🎨 | `ui` | Tailwind v4, shadcn/base-ui, CVA variants, dark mode, animations |
| 🧩 | `shadcn` | Adding, searching, fixing, composing shadcn/ui components |
| 📝 | `forms-rhf-zod` | react-hook-form + zod v4, create/edit modes, useWatch |
| 🔄 | `react-query-mutative` | QueryClient config, key factories, optimistic updates |
| 📦 | `zustand-x-ui-state` | zustand-x v6 stores, boundary rules, theme system |
| 🛣️ | `tanstack-start-cloudflare` | Routes, layouts, server functions, deploy config |
| 🔐 | `supabase-auth-data` | 3 Supabase clients, auth flow, migrations, RLS |
| ☁️ | `cloudflare` | Workers best practices, Wrangler CLI, wrangler.jsonc |
| ⚡ | `vite` | Vite config, plugin API, SSR, Rolldown migration |
| 🚀 | `react-best-practices` | 57 performance rules + composition patterns |
| 🗄️ | `supabase-postgres-best-practices` | Indexing, query plans, RLS perf, connection pooling |
| 🗺️ | `repo-map` | agent-analyzer symbol index -- map a codebase without reading every file |
| 🧹 | `deslop` | Detect AI slop -- debug stmts, placeholders, hardcoded secrets |
| 🧪 | `testing` | Vitest + Testing Library + Playwright, file conventions |
| 📄 | `readme` | Generate visually appealing READMEs with proper information flow |

---

## Agents

19 specialists. All under 80 lines. Pure signal.

| Category | Agents |
|---|---|
| **Engineering** | Backend Architect, Frontend Developer, Senior Developer, Database Optimizer, DevOps Automator, Security Engineer, Rapid Prototyper, Software Architect, Code Reviewer, Git Workflow Master, Technical Writer, MCP Builder |
| **Testing** | API Tester, Performance Benchmarker, E2E Test Writer, E2E Test Runner |
| **Product** | Product Manager, UX Architect |
| **Orchestration** | Agents Orchestrator (8-phase workflow with approval gate) |

### Orchestrator flow

```
Discovery  →  Explore  →  Plan  →  ⛔ APPROVE  →  Implement  →  Review  →  Validate  →  Ship
```

---

## Commands

| Command | What |
|---|---|
| `/repo-map` | Runs agent-analyzer, builds symbol index |
| `/deslop` | Scans codebase for AI slop, reports + offers fixes |
| `/skill-lint` | Validates skills + agents (frontmatter, size, refs) |
| `/dotclaude:setup` | One-time: copies conventions to `~/.claude/CLAUDE.md` |
| `/dotclaude:update` | Updates plugin + refreshes conventions |
| `/dotclaude:uninstall` | Removes conventions from CLAUDE.md |

```
/deslop src/

  commands/deslop.md     ← agent reads the playbook
  scripts/deslop.sh      ← bash does the work (0 tokens)
  Report + fix offers    ← agent interprets, you decide
```

---

## Three-Layer Convention Defense

Run `conventions` skill once per project. Done forever.

```
Layer 1: CLAUDE.md          AI reads rules → generates correct code
Layer 2: ESLint + Prettier  Catches mistakes at save/lint time
Layer 3: Pre-commit hooks   Hard gate -- wrong code never gets committed
```

---

## Install

```bash
# Add marketplace (one time)
claude plugin marketplace add harryy2510/claude-toolkit

# Install
claude plugin install dotclaude@claude-toolkit

# Setup (in Claude Code)
/dotclaude:setup
```

### Update

```bash
claude plugin marketplace update claude-toolkit
claude plugin update dotclaude@claude-toolkit
```

Or in Claude Code: `/dotclaude:update`

### Uninstall

Run `/dotclaude:uninstall` first, then:

```bash
claude plugin uninstall dotclaude@claude-toolkit
```

---

## Adding skills

1. Create `skills/<name>/SKILL.md` with frontmatter (`name`, `description`)
2. Heavy reference content goes in `skills/<name>/references/`
3. Run `/skill-lint skills`

## Adding agents

1. Create `agents/<name>.md` with frontmatter (`name`, `description`, `color`)
2. Under 80 lines. Role, rules, patterns.
3. Run `/skill-lint agents`

---

## Author

**Hariom Sharma** -- [github.com/harryy2510](https://github.com/harryy2510)

## License

MIT
