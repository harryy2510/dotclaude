# dotenvx Encrypted Environment Playbook

Full reference for dotenvx encryption, env sync, CI integration, and local Supabase overrides.

## Install

```bash
bun add @dotenvx/dotenvx
```

## Encrypt Existing Env Files

```bash
dotenvx encrypt -f .env.development --stdout > .env.development.encrypted
dotenvx encrypt -f .env.production --stdout > .env.production.encrypted
```

Creates `.env.keys` with private decryption keys. **Never commit `.env.keys`.**

## .gitignore

```gitignore
# Environment files
.env*
.dev.vars*
!.env.*.encrypted
```

## Package.json Scripts

```json
{
  "postinstall": "dotenvx decrypt -f .env.development.encrypted --stdout > .env.development 2>/dev/null; dotenvx decrypt -f .env.production.encrypted --stdout > .env.production 2>/dev/null; true",
  "env:encrypt": "dotenvx encrypt -f .env.development --stdout > .env.development.encrypted && dotenvx encrypt -f .env.production --stdout > .env.production.encrypted",
  "env:local": "bun scripts/generate-env-local.ts",
  "dev:server": "bunx supabase start && bun env:local",
  "sync-env": "bun scripts/sync-env.ts",
  "types:cf": "wrangler types --env-file .env.development && oxfmt -w worker-configuration.d.ts"
}
```

Key details:
- **postinstall uses `;` not `&&`** -- each file decrypts independently (CI jobs may only have one key)
- **postinstall ends with `; true`** -- never fails the install (Cloudflare builds have no keys)
- **env:encrypt uses `&&`** -- should fail loudly if encryption fails
- **types:cf uses `--env-file`** -- reads vars from env file, not wrangler.jsonc

## Pre-commit Hook

Add this env encryption step to the repo-local Agent Toolkit pre-commit flow when the project uses encrypted env files:

```bash
if [ -f .env.development ] && [ -f .env.production ]; then
  bun env:encrypt
  git add .env.development.encrypted .env.production.encrypted
fi
```

## Local Supabase Overrides Script

Create `scripts/generate-env-local.ts`:

```ts
import { $ } from 'bun'
import { writeFileSync } from 'node:fs'

const result = await $`bunx supabase status -o env`.quiet().nothrow()
if (result.exitCode !== 0) {
  console.error('Local Supabase is not running. Start it with: bun dev:server')
  process.exit(1)
}

const env = Object.fromEntries(
  result.text().trim().split('\n').map((line) => {
    const [key, ...rest] = line.split('=')
    return [key, rest.join('=').replace(/^"|"$/g, '')]
  }),
)

const content = `# Auto-generated from local Supabase. Regenerate with: bun env:local

VITE_SUPABASE_URL=${env.API_URL}
VITE_SUPABASE_PUBLISHABLE_KEY=${env.PUBLISHABLE_KEY}
VITE_SITE_URL=http://localhost:5173
SUPABASE_DB_URL=${env.DB_URL}
`

writeFileSync('.env.development.local', content)
console.log('Generated .env.development.local from local Supabase')
```

## sync-env.ts -- Push Secrets to Cloudflare + Supabase

Create `scripts/sync-env.ts`. Copy from MTC reference (`~/Desktop/mtc/my-trainer-connect/scripts/sync-env.ts`) and adapt.

### Cloudflare Sync

1. Splits env vars into **vars** (non-sensitive, written to `wrangler.jsonc` ephemerally) and **secrets** (sensitive, pushed via `wrangler versions secret bulk`)
2. `isSecretKey()`: keys containing `SECRET`, `API_KEY`, or `TOKEN` (excluding `VITE_*` and `PUBLISHABLE`)
3. Uses `wrangler versions secret bulk <json-file>` -- single atomic API call, NOT individual `secret put` (races and silently drops secrets)
4. Skip keys: `DOTENV_PUBLIC_KEY_*`, `NODE_OPTIONS`, `SUPABASE_ACCESS_TOKEN`, `SUPABASE_DB_URL`

### Supabase Sync

1. Auto-scans `supabase/functions/**/*.ts` for `Deno.env.get('KEY')` calls -- no hardcoded key list
2. Only syncs keys that edge functions actually use
3. Uses `supabase secrets set KEY=value --project-ref <id>`

### CLI Interface

```bash
bun sync-env                               # All targets, all environments
bun sync-env cloudflare --env development  # CF dev only
bun sync-env supabase --env production     # Supabase prod only
```

## Cloudflare wrangler.jsonc Cleanup

Remove ALL `vars` blocks from `wrangler.jsonc` environment configs. Vars are:
- Locally: read from `.env.*` files by Vite and `wrangler types --env-file`
- In CI: written to `wrangler.jsonc` ephemerally by sync-env before deploy

Keep only infrastructure config (routes, KV bindings, placement, observability).

## GitHub Secrets Setup

Only **3 secrets** needed total:

| Secret | Scope | Source |
|---|---|---|
| `DOTENV_PRIVATE_KEY_DEVELOPMENT` | `development` environment | `.env.keys` |
| `DOTENV_PRIVATE_KEY_PRODUCTION` | `production` environment | `.env.keys` |
| `CLOUDFLARE_API_TOKEN` | repo-level | CF dashboard -> API Tokens -> "Edit Cloudflare Workers" template |

Set via:
```bash
grep DOTENV_PRIVATE_KEY_DEVELOPMENT .env.keys | cut -d= -f2 | gh secret set DOTENV_PRIVATE_KEY_DEVELOPMENT --env development
grep DOTENV_PRIVATE_KEY_PRODUCTION .env.keys | cut -d= -f2 | gh secret set DOTENV_PRIVATE_KEY_PRODUCTION --env production
```

## Cloudflare Dashboard Cleanup

After CI deploy works:
1. Disconnect auto-deploy (Worker -> Settings -> Build -> Disconnect)
2. Delete all Build-tab variables/secrets (no longer needed)
3. Runtime-tab secrets/vars are managed by sync-env going forward

## File Architecture

| File | Purpose | Git? |
|---|---|---|
| `.env.development.encrypted` | Encrypted dev env | Yes |
| `.env.production.encrypted` | Encrypted prod env | Yes |
| `.env.keys` | Private keys | No |
| `.env.development` | Decrypted dev (postinstall) | No |
| `.env.production` | Decrypted prod (postinstall) | No |
| `.env.development.local` | Local Supabase overrides (env:local) | No |
| `scripts/sync-env.ts` | Push secrets to CF + Supabase | Yes |
| `scripts/generate-env-local.ts` | Generate local Supabase env | Yes |
