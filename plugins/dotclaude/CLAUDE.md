# Global Rules — All Projects

These rules apply to EVERY session, EVERY project, EVERY agent.

## Skills — MUST Reference Before Coding

Before writing any code, check if a relevant skill exists by reading the skill file. Skills live in `skills/` and contain exact patterns, APIs, and conventions. **Do not guess — read the skill.**

### Mandatory Skills (always check these)

| When doing... | Load this skill |
|---|---|
| React components, UI work | `ui` — Tailwind v4, shadcn/base-ui, CVA, dark mode, animations, web design guidelines |
| Forms | `forms-rhf-zod` — react-hook-form + zod v4, zod-empty init(), useWatch rules |
| Data fetching, mutations | `react-query-mutative` — QueryClient config, key factories, optimistic updates |
| Client-side state | `zustand-x-ui-state` — zustand-x v6 API, boundary rules, theme system |
| Routes, layouts, server fns | `tanstack-start-cloudflare` — routing, breadcrumbs, server functions, vite config |
| Supabase clients, auth, types | `supabase-auth-data` — 3 clients, auth flow, migrations, RLS |
| Cloudflare deploy, wrangler, DX tooling | `project-setup` — ESLint/Prettier, Husky, encrypted env, CI workflows, sync-env, GitHub Actions |
| New project scaffold | `scaffold` — fullstack (TanStack Start + Supabase + Cloudflare) |
| Performance review | `react-best-practices` — 57 perf rules + composition patterns |
| Convention enforcement setup | `conventions` — one-time ESLint rules + pre-commit hooks that enforce coding standards via tooling |
| Cloudflare Workers | `cloudflare` — Workers best practices, Wrangler CLI, wrangler.jsonc config |
| shadcn/ui components | `shadcn` — adding, searching, fixing, debugging, styling, composing UI components |
| Postgres optimization | `supabase-postgres-best-practices` — indexing, query plans, RLS performance, connection pooling |
| Vite config | `vite` — Vite build tool, plugin API, SSR, Rolldown migration |
| Exploring a new codebase | `repo-map` — agent-analyzer symbol index (functions, exports, imports) |
| Code quality scan | `deslop` — detect AI-generated slop patterns (debug stmts, placeholders, secrets) |

## Hard Rules (Non-Negotiable)

### Code Style & TypeScript (also enforced by ESLint + Prettier)
Strict mode. `type` not `interface`. No `any`/`as`. Inline type imports. Named exports only (except configs). Kebab-case filenames. `.ts/.tsx` only. Tabs, single quotes, no semicolons, trailing commas. Perfectionist sorting. Tailwind only — no inline styles, CSS modules, or CSS files. No `React.xxx` namespace — use named imports.

### Package Manager
`bun` always. `bunx` instead of `npx`. Never npm/yarn.

### Never Run `bunx supabase` Directly
Every Supabase operation has a `package.json` script. Use it. If one doesn't exist, create it first.

### React
- `Link` from router with `params`/`search` props — never template strings, never raw `<a>`.

### UI & Styling
- shadcn/ui with **base-ui** primitives. **NEVER radix-ui.**
- Icons: `lucide-react`. Class merging: `cn()` from `@/libs/cn`.
- Animations: `motion/react` only. Never CSS keyframes or Tailwind animate.

### State Management
- **zustand-x** (v6) for UI state. NEVER plain `zustand` directly.
- Use `useStoreValue(store, 'field')` for reads, `useTracked(store, 'field')` for proxy-based minimal re-renders on nested objects. Never `.use.*()`.
- Use `mutative` for immutable updates inside stores.

### Data Fetching
- React Query for ALL server data. `staleTime: Infinity`, manual invalidation.
- Query key factories per domain: `keys.all`, `keys.list(params)`, `keys.detail(id)`.
- Never call server functions directly from components — always wrap in `useQuery`/`useMutation`.

### Forms
- react-hook-form + zod v4 always.
- Create mode: `defaultValues: init(schema)` from `zod-empty`. ALWAYS.
- Edit mode: `defaultValues: init(schema)` + `values: existingData`. Never put actual data in `defaultValues`.
- Never `form.watch()` — always `useWatch()`.
- `useWatch` in same component as `useForm` MUST pass `control: form.control`.

### External APIs
- `axios` always. One instance per integration. Flow: axios → server function → React Query → component.

### Utilities
- `es-toolkit` for complex operations (groupBy, keyBy, pick, omit, uniqBy). **Never lodash.**
- `startCase` from `es-toolkit/string` for snake_case display. Never manual regex.
- `dayjs` for dates. Never date-fns, never raw Date.

### API Module Structure
Four files per domain in `src/api/<domain>/`:
1. `schemas.ts` — Zod schemas + inferred types
2. `functions.ts` — `createServerFn` with `.inputValidator(schema)`
3. `keys.ts` — Query key factory
4. `hooks.ts` — `useQuery`/`useMutation` wrappers

### Database
- Never run direct SQL. All changes through migration files only.
- Database types are single source of truth. Never hand-roll types duplicating DB columns.
- UNIQUE timestamps on every migration. Check existing files first.

### General
- `@/*` path alias = `src/*`.
- Run the project's check command before considering work complete.
