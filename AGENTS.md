# DotClaude Repository Instructions

## Purpose

This repository contains the DotClaude plugin and the shared agent rules it installs. Keep plugin behavior agent-agnostic where possible while preserving Claude Code plugin compatibility.

## Agent Sync

- `AGENTS.md` is the canonical repository instruction file.
- `.agents/agents.json` is the source of truth for `agents` CLI integration settings.
- Run `agents sync --path .` after changing `.agents/agents.json` when you want local tool config.
- Do not commit generated outputs such as root `CLAUDE.md`, `.codex/`, `.claude/`, `.cursor/`, `.gemini/`, `.windsurf/`, `.opencode/`, or `.agents/generated/`.
- Do not commit `.agents/intel/`; it is local generated repo intelligence.
- Do not add Superpowers docs or planning docs to this public repo.

## Plugin Layout

- `plugins/dotclaude/.claude-plugin/plugin.json` is the Claude Code manifest.
- `plugins/dotclaude/.codex-plugin/plugin.json` is the Codex plugin manifest.
- `plugins/dotclaude/gemini-extension/` is the Gemini CLI extension wrapper. It links to the shared `AGENTS.md` and `skills/` without exposing Claude-only agent definitions to Gemini.
- `plugins/dotclaude/CLAUDE.md` is the Claude Code compatibility rules file for the plugin package.
- `plugins/dotclaude/AGENTS.md` is the shared global rules source for agent-agnostic setup.
- `plugins/dotclaude/skills/` should stay usable as focused skill instructions across compatible agents.
- `plugins/dotclaude/scripts/setup.sh` and `teardown.sh` must preserve user content outside managed fences.

## Development Rules

- Prefer `bun` and `bunx` in Bun projects.
- Use TypeScript for JavaScript-platform source files. Do not add `.js` or `.jsx` source files.
- Use `oxlint --type-aware --type-check`, not `tsc`.
- Use `oxlint`, not ESLint.
- Use `oxfmt`, not Prettier.
- Use Husky for git hooks. Do not introduce `.githooks` or ad hoc hook folders.
- Any commits must use Conventional Commit format.
- Keep scripts POSIX-friendly bash where possible.
- Do not edit files whose names start with `.env`.
- Do not run destructive cleanup commands or `git push` unless the user explicitly asks in the current message.
- Validate JSON manifests after editing them.
