---
name: conventions
description: "Use once per project to install ESLint rules + pre-commit hooks that enforce coding conventions via tooling. After setup, these rules cost 0 tokens — enforced by tools, not AI."
---

# Conventions — One-Time Project Setup

Installs ESLint rules and pre-commit hooks that enforce coding conventions deterministically. Run once per project. After that, tooling enforces the rules — AI never needs to repeat them.

**Prerequisite:** Run `project-setup` skill first (installs ESLint, Prettier, Husky, lint-staged).

---

## Step 1: Install Additional ESLint Plugins

```bash
bun add -d eslint-plugin-unicorn eslint-plugin-react @eslint-react/eslint-plugin
```

## Step 2: Add Convention Rules to eslint.config.ts

Merge these into the existing flat config:

```ts
import react from '@eslint-react/eslint-plugin'
import unicorn from 'eslint-plugin-unicorn'

// Add to tseslint.config(...):
{
	plugins: {
		'@eslint-react': react,
		unicorn,
	},
	rules: {
		// TypeScript conventions
		'@typescript-eslint/consistent-type-definitions': ['error', 'type'],
		'@typescript-eslint/no-explicit-any': 'error',
		'@typescript-eslint/consistent-type-assertions': [
			'error',
			{ assertionStyle: 'never' },
		],

		// Import restrictions
		'no-restricted-imports': [
			'error',
			{
				paths: [
					{ name: 'lodash', message: 'Use es-toolkit instead.' },
					{ name: 'date-fns', message: 'Use dayjs instead.' },
					{ name: 'react', importNames: ['default'], message: 'Use named imports from react.' },
				],
				patterns: [
					{ group: ['lodash/*'], message: 'Use es-toolkit instead.' },
					{ group: ['date-fns/*'], message: 'Use dayjs instead.' },
					{ group: ['@radix-ui/*'], message: 'Use base-ui primitives instead.' },
				],
			},
		],

		// No fetch — use axios
		'no-restricted-globals': ['error', { name: 'fetch', message: 'Use axios instead.' }],

		// No default exports + no inline styles
		'no-restricted-syntax': [
			'error',
			{
				selector: 'ExportDefaultDeclaration',
				message: 'Use named exports. Default exports allowed only in config files.',
			},
			{
				selector: 'JSXAttribute[name.name="style"]',
				message: 'No inline styles. Use Tailwind classes.',
			},
		],

		// Filenames
		'unicorn/filename-case': ['error', { case: 'kebabCase' }],
	},
},

// Config file overrides — allow default exports
{
	files: [
		'*.config.*',
		'**/app/routes/**/*',
		'**/routeTree.gen.ts',
	],
	rules: {
		'no-restricted-syntax': 'off',
	},
},
```

## Step 3: Pre-Commit Convention Hooks

Create `scripts/check-conventions.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

errors=0

# No .js/.jsx files in src/
js_files=$(git diff --cached --name-only --diff-filter=ACR | grep -E '^src/.*\.(js|jsx)$' || true)
if [ -n "$js_files" ]; then
	echo "[ERROR] .js/.jsx files in src/ — use .ts/.tsx only:"
	echo "$js_files"
	errors=1
fi

# No package-lock.json or yarn.lock
for lockfile in package-lock.json yarn.lock; do
	if git diff --cached --name-only | grep -q "^${lockfile}$"; then
		echo "[ERROR] ${lockfile} detected — use bun (bun.lockb)"
		errors=1
	fi
done

# Migrations are immutable — no modifications to existing migration files
modified_migrations=$(git diff --cached --name-only --diff-filter=M | grep -E '^supabase/migrations/' || true)
if [ -n "$modified_migrations" ]; then
	echo "[ERROR] Modified existing migration files — create new migrations instead:"
	echo "$modified_migrations"
	errors=1
fi

# No edits to auto-generated files
for genfile in database.types.ts worker-configuration.d.ts routeTree.gen.ts; do
	if git diff --cached --name-only --diff-filter=M | grep -q "$genfile"; then
		echo "[ERROR] Edited auto-generated file: ${genfile}"
		errors=1
	fi
done

# No new .css files in src/ (except styles.css)
new_css=$(git diff --cached --name-only --diff-filter=A | grep -E '^src/.*\.css$' | grep -v 'styles\.css' || true)
if [ -n "$new_css" ]; then
	echo "[ERROR] New CSS files in src/ — use Tailwind classes instead:"
	echo "$new_css"
	errors=1
fi

exit $errors
```

## Step 4: Wire Into Husky

Update `.husky/pre-commit` to run convention checks before lint-staged:

```bash
#!/usr/bin/env sh

# Encrypt env files if they exist
if [ -f .env.development ] && [ -f .env.production ]; then
  bun env:encrypt
  git add .env.development.encrypted .env.production.encrypted
fi

# Convention checks (file-level)
bash scripts/check-conventions.sh

# Lint + format (code-level)
bunx lint-staged
```

Make the script executable: `chmod +x scripts/check-conventions.sh`

---

## What This Enforces (0 tokens after setup)

| Convention | Enforced By |
|---|---|
| No `any`, no `as` casts | ESLint |
| `type` not `interface` | ESLint |
| Inline type imports | ESLint |
| Sort imports/objects/types | ESLint (perfectionist) |
| Named exports only | ESLint |
| No `React.xxx` namespace | ESLint |
| No lodash, date-fns, radix-ui | ESLint |
| No `fetch()` | ESLint |
| No inline `style` prop | ESLint |
| Kebab-case filenames | ESLint (unicorn) |
| Tabs, single quotes, no semis | Prettier |
| No `.js/.jsx` in src/ | Pre-commit hook |
| No package-lock/yarn.lock | Pre-commit hook |
| Migrations immutable | Pre-commit hook |
| No edits to auto-gen files | Pre-commit hook |
| No CSS files in src/ | Pre-commit hook |

After running this skill, remove these rules from CLAUDE.md — they're now enforced by tools.
