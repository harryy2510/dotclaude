<!-- DOTCLAUDE:START -->
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
| Testing | `testing` — Vitest + Testing Library + Playwright, file conventions, what to test |

## Hard Rules (Non-Negotiable)

### Code Style & TypeScript (also enforced by ESLint + Prettier)
Strict mode. `type` not `interface`. No `any`/`as`. Inline type imports. Named exports only (except configs). Kebab-case filenames. `.ts/.tsx` only. Tabs, single quotes, no semicolons, trailing commas. Perfectionist sorting. Tailwind only -- no inline styles, CSS modules, or CSS files. No `React.xxx` namespace -- use named imports.

**NEVER patch errors by disabling ESLint or TypeScript lint** (`eslint-disable`, `@ts-ignore`, `@ts-expect-error`, `as any`) unless absolutely necessary and justified with a comment explaining why. Always fix the root cause and properly type things.

### Text Content
Do not use em dashes anywhere when generating text content. Use `--` or rewrite the sentence instead. This applies to comments, commit messages, PR descriptions, docs, UI copy, and any other generated text. Only use em dashes where syntactically mandatory (e.g., Markdown table separators).

### Environment Files -- ABSOLUTE PROHIBITION
**NEVER edit, create, overwrite, or delete ANY file whose name starts with `.env`** -- not local, not development, not encrypted, not keys, not examples. This includes `.env`, `.env.local`, `.env.development`, `.env.production`, `.env.keys`, `.env.vault`, `.env.example`, and every other variant. No matter what happens, no matter what the task is, do not touch them. If the user needs env changes, instruct them to do it themselves.

### Package Manager
`bun` always. `bunx` instead of `npx`. Never npm/yarn.

### package.json Scripts -- DO NOT ADD
**NEVER add, modify, or remove scripts in `package.json`.** The existing scripts are the only commands you have access to. If a script you need does not exist, ask the user -- do not invent one.

### Supabase -- Scripts Only
- **NEVER run any `supabase` or `bunx supabase` command directly.** Only use scripts already defined in `package.json`.
- **NEVER hand-write types for any Supabase table, view, function, or RPC.** Always import from the generated database types file. If types are stale, run `bun types` to regenerate. If you just wrote a migration and types are missing, run `bun db-push-and-types` to push the migration to local Supabase and regenerate types.

### Git Hooks -- NEVER Skip
**NEVER skip git hooks** (`--no-verify`, `--no-gpg-sign`, etc.) when they fail. Hooks fail for a reason. Diagnose the actual failure and fix it properly. Bypassing hooks is not an acceptable shortcut.

### React
- `Link` from router with `params`/`search` props -- never template strings, never raw `<a>`.
- React 19: ref is a regular prop -- never `forwardRef`. Use `use()` instead of `useContext()`.
- No default React import; use named imports.
- No JSX `style` attribute. No default exports (except config files, route files, and `routeTree.gen.ts`).
- Derive state during render -- never sync with `useEffect`. Subscribe to derived booleans, not raw values.
- Use ternary (not `&&`) for conditional rendering. Hoist static JSX outside components.
- Use functional `setState` for stable callbacks; pass an initializer function to `useState` for expensive defaults.
- Avoid boolean prop proliferation -- prefer compound components, explicit variants, or composition with `children`.
- Use `Promise.all()` for independent awaits; move `await` into branches that actually use it.
- Import directly from modules, not barrel files.

### UI & Styling
- shadcn/ui with **base-ui** primitives. **NEVER radix-ui** (enforced by ESLint).
- Icons: `lucide-react`. Class merging: `cn()` = `twMerge(clsx(...))` from `@/libs/cn`.
- Animations: `motion/react` only. Never CSS keyframes or Tailwind `animate-*`.
- Tailwind v4: config lives in CSS via `@theme` + `@custom-variant dark (&:is(.dark *))`. No `tailwind.config.ts`.
- Color tokens defined in OKLCH in `:root` / `.dark` as CSS variables. Use semantic tokens only (`bg-primary`, `text-muted-foreground`) -- never raw colors (`bg-blue-500`).
- No manual `dark:` overrides (use semantic tokens). No manual `z-index` on Dialog/Sheet/Popover.
- Variants built with `cva()` from `class-variance-authority`.
- Components live in `src/components/ui/`. `components.json` aliases: `components: @/components`, `utils: @/libs/cn`, `ui: @/components/ui`, `hooks: @/hooks`.
- Use `flex` + `gap-*`, never `space-x-*`/`space-y-*`. Use `size-*` when width=height. Use `truncate` shorthand.
- `className` on shadcn components is for layout only -- never override component colors/typography.
- Forms use `FieldGroup` + `Field`. `InputGroup` uses `InputGroupInput`/`InputGroupTextarea` (never raw `Input` inside). Buttons inside inputs use `InputGroupAddon`.
- Dialog/Sheet/Drawer always need a Title (use `sr-only` if hidden). Dialog/AlertDialog content must include `max-h-[90vh] overflow-y-auto` to prevent viewport overflow. Avatar always needs `AvatarFallback`.
- Button has no `isPending`/`isLoading` prop -- compose with Spinner + `data-icon` + `disabled`.
- Icons in Button use `data-icon="inline-start|inline-end"`; no sizing classes on icons inside components.
- Option sets (2-7) use `ToggleGroup`, not looped Button with manual active state.
- Never fetch shadcn files from GitHub. Use the CLI with `--dry-run`/`--diff`. Never `--overwrite` without user approval.

### State Management
- **zustand-x** (v6) for UI state. NEVER plain `zustand` directly.
- Import from `zustand-x` -- never `@zustand-x/core`.
- Create stores with `createStore(initial, { name, mutative: true })`. One store file per concern.
- Use `useStoreValue(store, 'field')` for reads, `useTracked(store, 'field')` for proxy-based minimal re-renders on nested objects. Never `.use.*()`.
- Use `mutative` for immutable updates inside stores.
- Never put server data, auth/session, form state, or URL state in a store.
- Prefer URL search params over zustand for state that should survive refresh (theme is the exception).
- Theme system = 3 layers: SSR blocking script in `<head>`, zustand-x store post-hydration, `matchMedia` listener for `mode === 'auto'`.

### Data Fetching
- React Query for ALL server data. `staleTime: Infinity`, manual invalidation.
- Query key factories per domain: `keys.all`, `keys.list(params)`, `keys.detail(id)`.
- Never call server functions directly from components -- always wrap in `useQuery`/`useMutation`.
- QueryClient defaults: `gcTime: Infinity`, `refetchOnMount: false`, `refetchOnWindowFocus: false`, `retry: false`.
- Global `MutationCache.onError` + `QueryCache.onError` wired to sonner `toast.error`.
- Optimistic updates go through `libs/query/optimistic.ts` using `create()` from `mutative`. Never hand-rolled `setQueryData` with spread.
- Use `refetchQueries` (not `invalidateQueries`) when the user navigates away after mutating and the destination list must already have fresh data. Use `invalidateQueries` when staying on the same page.
- Rapid successive mutations: share a `mutationKey`, guard with `isMutating()`, call `router.invalidate()` in `onSettled`.

### Forms
- react-hook-form + zod v4 always.
- Use zod v4 shorthand: `z.email()`, `z.uuid()`, `z.url()` -- never `z.string().email()`.
- Zod error syntax: `{ error: '...' }` -- never `{ message: '...' }`.
- Use `zodFormResolver` wrapper from `libs/form.ts` when schemas contain `z.coerce`.
- Create mode: `defaultValues: init(schema)` from `zod-empty`. ALWAYS.
- Edit mode: `defaultValues: init(schema)` + `values: existingData`. Never put actual data in `defaultValues`.
- Never `form.watch()` -- always `useWatch()`.
- `useWatch` in the same component as `useForm` MUST pass `control: form.control`.
- Multi-step forms use a `step` field with optional step sub-schemas.

### External APIs
- `axios` always. One instance per integration. Flow: axios -> server function -> React Query -> component.
- No `fetch` global (enforced by ESLint).

### Utilities
- `es-toolkit` for complex operations (groupBy, keyBy, pick, omit, uniqBy). **Never lodash** (enforced by ESLint).
- `startCase` from `es-toolkit/string` for snake_case display. Never manual regex.
- `dayjs` for dates. **Never date-fns** (enforced by ESLint), never raw `Date`.

### API Module Structure
Four files per domain in `src/api/<domain>/`:
1. `schemas.ts` -- Zod schemas + inferred types
2. `functions.ts` -- `createServerFn` with `.inputValidator(schema)`
3. `keys.ts` -- Query key factory
4. `hooks.ts` -- `useQuery`/`useMutation` wrappers

### TanStack Start / Routing
- Route components read cache via `useQuery()` -- never `useLoaderData()`.
- Never run `npx @tanstack/router-cli generate` -- the dev server generates the route tree.
- Server functions must NOT re-check auth -- `_authed.tsx` `beforeLoad` handles it.
- Server functions always use `getSupabaseServerClient()` -- never `createClient()` or the browser client.
- Breadcrumbs come from route `staticData.breadcrumb` + dynamic via `beforeLoad` returning `breadcrumb`. No `useEffect`, no global store.
- Never use `app.config.ts` or vinxi. Cloudflare **Workers** only (not Pages). Deploy scripts live in CI, not `package.json`.

### Supabase Clients & Types
- Three clients only:
  - `getSupabaseServerClient()` -- SSR / server functions.
  - `getSupabaseBrowserClient()` -- singleton; **only** for `onAuthStateChange` + `refreshSession`.
  - `getSupabaseAdminClient()` -- server-only, bypasses RLS.
- Browser client NEVER used for data fetching -- route through React Query + server functions.
- Admin client reads `SUPABASE_SECRET_KEY` from Cloudflare env bindings, **not** `process.env`.
- `worker-configuration.d.ts` and `database.types.ts` are auto-generated -- NEVER edit (enforced by pre-commit hook).
- Use `.overrideTypes<T>()` for new/incomplete types: object form for `.single()`/`.maybeSingle()`, Array form otherwise.
- `onAuthStateChange` listener mounted exactly once in the root shell.
- **Calling Edge Functions** (from client/server code): always use `supabase.functions.invoke()` -- never `fetch`/`axios` directly. Exception: streaming Edge Functions where `invoke()` doesn't support streaming.
- **Inside Edge Functions** (calling external APIs): use `fetch` directly (Deno runtime). Shared utilities go in `supabase/functions/_shared/`.

### Database & Migrations
- Never run direct SQL. All changes through migration files only.
- Database types are single source of truth. Never hand-roll types duplicating DB columns.
- UNIQUE timestamps on every migration. Check existing files first.
- Migrations are immutable -- never edit executed migrations (enforced by pre-commit hook).
- Foreign key columns must always be indexed.
- Default column types: `timestamptz`, `bigint`, `text` (not `varchar`).
- Identifiers always lowercase (no quoted mixed-case identifiers).
- RLS policies must wrap `auth.uid()` in `(select auth.uid())` for cacheable plans.
- Use cursor-based pagination, not `OFFSET`, for large lists.
- Use `ON CONFLICT` upserts -- never SELECT-then-INSERT.
- Use `FOR UPDATE SKIP LOCKED` for queue processing.
- SQL functions must `SET search_path = ''` (or explicit schemas). Schema-qualify all references (`public.users`, `auth.uid()`). Prevents search_path injection.

### Cloudflare Workers
- Set `compatibility_date` on new projects. Enable `nodejs_compat`. Generate `Env` via `bunx wrangler types` -- never hand-write binding interfaces.
- Enable `observability` in `wrangler.jsonc`. Use structured JSON logging.
- Every Promise must be awaited, returned, voided, or passed to `ctx.waitUntil()` -- no floating promises.
- Never destructure `ctx` (loses `this` binding). Use `extends` (not `implements`) on `DurableObject`/`WorkerEntrypoint`/`Workflow`. Inside platform base classes use `this.env.X`.
- Never store request-scoped data in module-level variables.
- `crypto.randomUUID()` / `crypto.getRandomValues()` / `crypto.subtle.timingSafeEqual` -- never `Math.random()` or direct string compare for secrets.
- Stream large/unknown payloads -- never `await response.text()` on unbounded data.
- Use bindings (KV, R2, D1, Queues, Hyperdrive, service bindings) over REST/public HTTP. Hyperdrive is mandatory for external Postgres/MySQL.
- No `ctx.passThroughOnException()` -- use explicit try/catch with structured error responses.
- Local secrets go in `.dev.vars` (which YOU still must not edit). Production secrets via `wrangler secret put`.

### Project Setup & Tooling
- ESLint v9 flat config (`eslint.config.ts`). Required TS flags: `strict`, `noUnusedLocals`, `noUnusedParameters`, `noFallthroughCasesInSwitch`, `noUncheckedSideEffectImports`, `verbatimModuleSyntax` -- all true.
- `vite.config.ts` + TypeScript. ESM only, never CommonJS.
- Vite build for dev deploys MUST pass `--mode development`; otherwise it defaults to production.
- Use `wrangler versions secret bulk` for secret sync. Never individual `wrangler secret put` in CI (races).
- GitHub Actions deploys use reusable `workflow_call` workflows from shared infra repo. `concurrency.cancel-in-progress: false`. Supabase workflow requires `fetch-depth: 0`.
- CI workflows include `actions/setup-node@v6` (node 24) + `oven-sh/setup-bun@v2`. Use `cloudflare/wrangler-action@v3` for deploys.
- Env tier detection: workflows auto-detect `multi` (`.env.development`/`.env.production`), `single` (`.env`), or `none`. Use `DOTENV_PRIVATE_KEY` for single-tier, `DOTENV_PRIVATE_KEY_{DEVELOPMENT,PRODUCTION}` for multi-tier.
- Mask secrets in CI: always `::add-mask::$value` before writing to `GITHUB_ENV`.

### Pre-commit Enforcement (do not bypass)
- Blocks `.js`/`.jsx` files in `src/`.
- Blocks `package-lock.json` / `yarn.lock`.
- Blocks modifications to existing migrations.
- Blocks edits to `database.types.ts`, `worker-configuration.d.ts`, `routeTree.gen.ts`.
- Blocks new `.css` files in `src/` (except `styles.css`).
- Runs `bash scripts/deslop.sh --staged`: no hardcoded secrets, no placeholder `throw new Error("TODO")`, no empty catches, no debug prints, no lorem ipsum.

### General
- `@/*` path alias = `src/*`.
- Run the project's check command before considering work complete.
<!-- DOTCLAUDE:END -->
