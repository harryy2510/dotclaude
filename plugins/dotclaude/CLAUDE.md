<!-- DOTCLAUDE:START -->
# Global Claude Guidelines

These rules apply to Claude Code sessions unless a more specific repository instruction overrides them.

## Scope And Precedence

- Read repository instructions first: `AGENTS.md`, `CLAUDE.md`, `README.md`, and equivalent local guidance.
- If multiple instruction files exist, follow the most specific one first, then broader guidance.
- Local project rules override these global defaults.

## Mandatory Startup

- Before substantial work, activate the relevant role profile from `agents/` when available. If a native subagent is not needed, use the role profile as the current-agent operating mode.
- Before writing code, read every relevant skill. Do not rely on memory for skill contents.
- Always read `toolchain` for setup, scripts, linting, formatting, type checking, or new package work.
- Always read `repo-intelligence` before broad codebase exploration, refactors, reviews, or completion checks.
- Always read `agent-routing` when deciding which role profile, skill, or native subagent should handle work.

## Hard Rules

### Git

- Never run `git push` unless the user explicitly asks for it in the current message.
- Permission to push expires after that one push.
- Never push to `main` or `master` unless the user says the exact words and confirms after you warn them.
- Never skip git hooks with `--no-verify`, `--no-gpg-sign`, or similar flags.
- Any commit you create must use Conventional Commit format, for example `feat: add repo intelligence` or `fix(cli): preserve user files`.

### Environment Files

- Never edit, create, overwrite, or delete any file whose name starts with `.env`.
- This includes `.env`, `.env.local`, `.env.development`, `.env.production`, `.env.keys`, `.env.vault`, `.env.example`, encrypted env files, and every other variant.
- If the user needs env changes, tell them exactly what to change themselves.

### Toolchain

- Use Bun for JavaScript and TypeScript package management and execution.
- Use TypeScript for new JavaScript-platform code. Do not create `.js` or `.jsx` source files.
- Do not use `tsc` as the project check command. Use `oxlint --type-aware --type-check`.
- Use `oxlint` instead of ESLint.
- Use `oxfmt` instead of Prettier.
- Use Husky for git hooks. Do not introduce `.githooks` or ad hoc hook folders.
- Do not add npm, yarn, pnpm, npx, ESLint, Prettier, or `tsc --noEmit` workflows.

### Package Scripts

- Do not add, modify, or remove `package.json` scripts unless the user explicitly asks or the current task is package/tooling setup.
- Use existing scripts when they are present.
- If a needed script does not exist and the user did not ask for tooling changes, ask before adding one.

### Supabase

- Never run direct Supabase CLI commands in repos that require package scripts for Supabase.
- Use existing package scripts, such as `bun db-push-and-types`, when the repository provides them.
- Never hand-write types for Supabase tables, views, functions, or RPCs when generated database types are available.
- SQL functions must set `search_path = ''` or explicit schemas and schema-qualify references such as `public.users` and `auth.uid()`.

### Generated Files

- Do not edit generated files unless explicitly requested.
- Generated database types, Worker configuration types, route trees, and agent sync outputs should be regenerated through the owning tool.

## Common Skill Routing

- New project or tooling setup: `toolchain`, `project-setup`, `scaffold`
- Codebase exploration or reviews: `repo-intelligence`, `repo-map`, `deslop`
- Agent delegation or role selection: `agent-routing`
- React UI: `ui`, `shadcn`, `react-best-practices`
- Forms: `forms-rhf-zod`
- Data fetching: `react-query-mutative`
- Client state: `zustand-x-ui-state`
- Routes and server functions: `tanstack-start-cloudflare`
- Supabase auth, data, migrations, RLS: `supabase-auth-data`, `supabase-postgres-best-practices`
- Cloudflare Workers and Wrangler: `cloudflare`
- Vite: `vite`
- Testing: `testing`

## Completion

- Before claiming work is complete, run the repo's relevant check command when practical.
- Prefer `bun run check` when the repo defines it.
- Run `bunx @harryy/agent-toolkit repo check` in agentized repos once the toolkit is available.
- Run `agents sync --check` when `AGENTS.md` or `.agents/` changed.
- If checks are not run, state why.
<!-- DOTCLAUDE:END -->
