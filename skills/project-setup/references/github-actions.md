# GitHub Actions Workflow Templates

Full workflow YAML and CI/CD patterns for Cloudflare Workers + Supabase deploy.

## Cloudflare Deploy Workflow

`.github/workflows/cloudflare-deploy.yml`:

```yaml
name: Deploy Cloudflare Workers

on:
  push:
    branches: [main]
    paths-ignore:
      - 'supabase/**'
      - '*.md'
      - 'docs/**'
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy'
        required: true
        default: 'all'
        type: choice
        options: [all, development, production]

permissions:
  contents: read

jobs:
  deploy:
    runs-on: ubuntu-latest
    concurrency:
      group: cloudflare-deploy-${{ matrix.environment }}
      cancel-in-progress: false
    strategy:
      matrix:
        environment: ${{ (github.event_name == 'push' || inputs.environment == 'all') && fromJSON('["development","production"]') || fromJSON(format('["{0}"]', inputs.environment)) }}
      fail-fast: false
    environment: ${{ matrix.environment }}
    env:
      DOTENV_PRIVATE_KEY_DEVELOPMENT: ${{ secrets.DOTENV_PRIVATE_KEY_DEVELOPMENT }}
      DOTENV_PRIVATE_KEY_PRODUCTION: ${{ secrets.DOTENV_PRIVATE_KEY_PRODUCTION }}
      CLOUDFLARE_API_TOKEN: ${{ secrets.CLOUDFLARE_API_TOKEN }}
      CLOUDFLARE_ACCOUNT_ID: <your-account-id>
    steps:
      - uses: actions/checkout@v6
      - uses: oven-sh/setup-bun@v2
      - run: bun install --frozen-lockfile
      - name: Push secrets to Cloudflare
        run: bun sync-env cloudflare --env ${{ matrix.environment }}
      - name: Build
        run: bun run build -- --mode ${{ matrix.environment }}
        env:
          CLOUDFLARE_ENV: ${{ matrix.environment }}
      - name: Deploy
        run: bunx wrangler deploy --env ${{ matrix.environment }}
```

**Critical:** `--mode ${{ matrix.environment }}` tells Vite which `.env.*` to load. Without it, `vite build` always loads `.env.production`.

## Supabase Deploy Workflow

`.github/workflows/supabase-deploy.yml`:

```yaml
name: Deploy Supabase

on:
  push:
    branches: [main]
    paths:
      - 'supabase/**'
      - '.github/workflows/supabase-deploy.yml'
  workflow_dispatch:
    inputs:
      environment:
        description: 'Environment to deploy'
        required: true
        default: 'all'
        type: choice
        options: [all, development, production]
      deploy_migrations:
        type: boolean
        default: true
      deploy_functions:
        type: choice
        options: [changed, all, none]
        default: changed

permissions:
  contents: write

jobs:
  deploy:
    runs-on: ubuntu-latest
    concurrency:
      group: supabase-deploy-${{ matrix.environment }}
      cancel-in-progress: false
    strategy:
      matrix:
        environment: ${{ (github.event_name == 'push' || inputs.environment == 'all') && fromJSON('["development","production"]') || fromJSON(format('["{0}"]', inputs.environment)) }}
      fail-fast: false
    environment: ${{ matrix.environment }}
    env:
      DOTENV_PRIVATE_KEY_DEVELOPMENT: ${{ secrets.DOTENV_PRIVATE_KEY_DEVELOPMENT }}
      DOTENV_PRIVATE_KEY_PRODUCTION: ${{ secrets.DOTENV_PRIVATE_KEY_PRODUCTION }}
      DEPLOY_MIGRATIONS: ${{ inputs.deploy_migrations == '' && 'true' || inputs.deploy_migrations }}
      DEPLOY_FUNCTIONS: ${{ inputs.deploy_functions || 'changed' }}
    steps:
      - uses: actions/checkout@v6
        with:
          fetch-depth: 0
      - uses: oven-sh/setup-bun@v2
      - run: bun install --frozen-lockfile
      - name: Load env vars
        run: |
          while IFS='=' read -r key value; do
            [[ -z "$key" || "$key" =~ ^#|^/|^DOTENV_|^NODE_OPTIONS|^VITE_ ]] && continue
            value="${value%\"}"
            value="${value#\"}"
            echo "$key=$value" >> "$GITHUB_ENV"
          done < .env.${{ matrix.environment }}
      - uses: supabase/setup-cli@v1
        with:
          version: latest
      - run: supabase link --project-ref ${{ env.SUPABASE_PROJECT_ID }}
      - name: Sync edge function secrets
        run: bun sync-env supabase --env ${{ matrix.environment }}
      - name: Push config
        run: supabase config push --yes
      - name: Deploy migrations
        if: env.DEPLOY_MIGRATIONS == 'true'
        run: supabase db push --include-all --yes
      # Add function detection + deploy steps as needed
```

**Load env vars step:** skips `NODE_OPTIONS` (quoted value breaks GITHUB_ENV), `VITE_*` (not needed by Supabase CLI), `DOTENV_*` (internal).

## Key Workflow Patterns

### Matrix Environment Strategy

Both workflows use the same matrix pattern for flexible environment targeting:

```yaml
matrix:
  environment: ${{ (github.event_name == 'push' || inputs.environment == 'all') && fromJSON('["development","production"]') || fromJSON(format('["{0}"]', inputs.environment)) }}
```

- On push to main: deploys both environments
- On manual dispatch: deploys selected environment(s)

### Concurrency

```yaml
concurrency:
  group: <service>-deploy-${{ matrix.environment }}
  cancel-in-progress: false
```

Never cancel deploys in progress -- they might leave partial state.

## GitHub Actions Documentation Guide

### Answering GitHub Actions Questions

When answering GitHub Actions questions, follow this workflow:

1. **Classify** -- decide which bucket (syntax, runners, security, deployments, migration, etc.)
2. **Search official docs first** -- treat `docs.github.com/en/actions` as source of truth
3. **Open the best page before answering** -- use `references/topic-map.md` to find the right neighborhood
4. **Answer with docs-grounded guidance** -- include exact links, not just the homepage

### Answer Shape

1. Direct answer
2. Relevant docs links
3. Example YAML (only if needed)
4. Explicit inference callout (only if connecting multiple docs pages)

### Search Tips

| Question type | Prefer these docs |
|---|---|
| Concepts | Overview/concept pages first |
| Syntax | Workflow syntax, events, contexts, variables, expressions reference |
| Security | Secure use, Secrets, GITHUB_TOKEN, OIDC, artifact attestations |
| Deployments | Environments and deployment protection docs |
| Migration | Migration hub page, then platform-specific guide |
| Beginner | Tutorials/quickstarts, not raw reference |

### Common Mistakes

- Answering from memory without verifying current docs
- Linking the Actions landing page when a narrower page exists
- Mixing up reusable workflows and composite actions
- Suggesting long-lived cloud credentials when OIDC is documented
- Treating repo-specific CI debugging as a docs question (use `gh-fix-ci` instead)
