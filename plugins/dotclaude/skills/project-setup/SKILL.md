---
name: project-setup
description: "Use when setting up DX tooling (linting, formatting, git hooks, type checking), dotenvx encrypted env management, env sync scripts, CI/CD deploy workflows (Cloudflare + Supabase via GitHub Actions), or answering GitHub Actions documentation questions."
---

# Project Setup

Covers three domains: DX tooling (lint/format/hooks), encrypted environment management (dotenvx), and GitHub Actions CI/CD.

---

## 1. DX Tooling

### ESLint + Prettier

Lint with ESLint v9 (flat config), format with Prettier.

```bash
bun add -d eslint @eslint/js typescript-eslint eslint-plugin-perfectionist prettier
```

**eslint.config.ts** (flat config):

```ts
import js from '@eslint/js'
import perfectionist from 'eslint-plugin-perfectionist'
import tseslint from 'typescript-eslint'

export default tseslint.config(
	js.configs.recommended,
	tseslint.configs.strict,
	perfectionist.configs['recommended-natural'],
	{
		rules: {
			'@typescript-eslint/consistent-type-imports': ['error', { fixStyle: 'inline-type-imports' }],
			'@typescript-eslint/no-empty-object-type': 'error',
			eqeqeq: 'error',
		},
	},
)
```

**prettier.config.mjs**:

```js
export default {
	useTabs: true,
	tabWidth: 2,
	singleQuote: true,
	semi: false,
	trailingComma: 'all',
}
```

### Husky + lint-staged

```bash
bun add -d husky lint-staged && bunx husky init
```

`.husky/pre-commit`: `bunx lint-staged`

```json
{
  "lint-staged": {
    "*.{ts,tsx}": ["eslint --fix", "prettier --write"],
    "*.{json,css,md,jsonc,toml}": ["prettier --write"]
  }
}
```

### tsconfig.json (strict)

Required: `strict`, `noUnusedLocals`, `noUnusedParameters`, `noFallthroughCasesInSwitch`, `noUncheckedSideEffectImports`, `verbatimModuleSyntax` -- all `true`.

### Scripts

```json
{
  "check": "tsc --noEmit && eslint . && prettier --check .",
  "fix": "eslint --fix . && prettier --write ."
}
```

### generate-vite-env.ts

Reads `VITE_*` vars from `.env.development`, generates `src/vite-env.d.ts` with typed `ImportMetaEnv`. Run: `bun scripts/generate-vite-env.ts`

### .gitignore

```
node_modules/
dist/
.env
.env.*
!.env.example
*.tsbuildinfo
.wrangler/
```

---

## 2. Encrypted Environment (dotenvx)

### Quick Setup

1. `bun add @dotenvx/dotenvx`
2. Encrypt: `dotenvx encrypt -f .env.development --stdout > .env.development.encrypted` (same for production)
3. Add `postinstall`, `env:encrypt`, `env:local`, `sync-env` scripts to `package.json`
4. Add pre-commit hook to auto-encrypt before lint-staged
5. Create `scripts/generate-env-local.ts` for local Supabase overrides
6. Create `scripts/sync-env.ts` to push secrets to Cloudflare + Supabase

### Key Script Patterns

- **postinstall** uses `;` not `&&` (each file decrypts independently) and ends with `; true` (never fails install)
- **env:encrypt** uses `&&` (fail loudly on error)
- **sync-env** uses `wrangler versions secret bulk` (atomic), NOT individual `secret put` (races)
- **Supabase sync** auto-scans `supabase/functions/**/*.ts` for `Deno.env.get('KEY')` calls

### GitHub Secrets (3 total)

| Secret | Scope |
|---|---|
| `DOTENV_PRIVATE_KEY_DEVELOPMENT` | `development` environment |
| `DOTENV_PRIVATE_KEY_PRODUCTION` | `production` environment |
| `CLOUDFLARE_API_TOKEN` | repo-level |

For full playbook (scripts, file architecture, wrangler cleanup, dashboard cleanup): `references/dotenvx-playbook.md`

---

## 3. CI/CD (GitHub Actions)

### Cloudflare Deploy (`cloudflare-deploy.yml`)

- Triggers on push to main (excluding `supabase/**`) + manual dispatch
- Matrix strategy deploys both environments on push, selected environment on dispatch
- Steps: checkout -> bun install -> `bun sync-env cloudflare` -> build with `--mode ${{ matrix.environment }}` -> `wrangler deploy`
- **Critical**: `--mode` tells Vite which `.env.*` to load. Without it, always loads `.env.production`.

### Supabase Deploy (`supabase-deploy.yml`)

- Triggers on push to main (only `supabase/**` changes) + manual dispatch
- Loads env vars from decrypted `.env.*` into `GITHUB_ENV` (skips `NODE_OPTIONS`, `VITE_*`, `DOTENV_*`)
- Steps: checkout (fetch-depth 0) -> bun install -> load env -> supabase link -> sync secrets -> config push -> db push
- `fetch-depth: 0` required for migration history

### Shared Patterns

- Both use concurrency groups with `cancel-in-progress: false` (never cancel deploys mid-flight)
- Both use the same matrix expression for flexible environment targeting
- Both decrypt env files via `postinstall` during `bun install`

For full workflow YAML templates: `references/github-actions.md`

### Answering GitHub Actions Questions

1. Classify the question (syntax, runners, security, deployments, migration, etc.)
2. Search `docs.github.com/en/actions` as source of truth
3. Open the best page before answering -- use `references/topic-map.md` as a routing aid
4. Answer with docs-grounded guidance and exact links

---

## Gotchas

- **postinstall `;` not `&&`**: CI jobs have environment-scoped keys. `&&` short-circuits if first decrypt fails.
- **Empty files on failed decrypt**: `> file` creates empty file even on error. `; true` handles this.
- **Vite mode**: `vite build` defaults to `mode: production`. Dev deploys MUST pass `--mode development`.
- **`wrangler versions secret bulk`**: Individual `secret put` calls race and silently drop secrets.
- **GITHUB_ENV quoted values**: `NODE_OPTIONS="--max-old-space-size=4096"` triggers GitHub output parameter detection. Skip in env loader.
- **Cloudflare Workers need runtime secrets**: Workers read `env` at request time. Must push actual secrets via `wrangler secret`.
- **Supabase auto-scan limitation**: Only picks up literal `Deno.env.get('KEY')`. Dynamic key access won't be detected.
- **Reusable vs composite actions**: Don't mix these up when answering GitHub Actions questions.
- **OIDC over long-lived credentials**: Prefer OIDC when GitHub docs support it for the target cloud.
