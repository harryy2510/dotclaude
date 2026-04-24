---
name: readme
description: "Use when writing, rewriting, or improving a README. Reads the project, generates a visually appealing README with proper information flow, badges, diagrams, and structure. Works on any project type -- libraries, CLIs, plugins, apps, APIs."
user_invocable: true
---

# README Generator

Read the project. Write a README that sells and documents in equal measure.

## When to Use

- New project needs a README
- Existing README needs improvement
- "Write a README for this project"
- "Improve the README"
- "Make the README better"

## Step 1: Read the Project

Before writing anything, understand the project:

1. `package.json` (or equivalent) -- name, description, scripts, dependencies
2. Source structure -- `ls src/`, key directories
3. Config files -- what tools are used
4. Existing README -- what's there already
5. Git log -- what's the project about based on commit history
6. CLAUDE.md -- conventions and rules
7. Any docs/ directory

From this, determine:
- **What** the project does (one sentence)
- **Who** it's for (developers, end users, AI agents)
- **How** it works (the flow)
- **What makes it different** (the hook)

## Step 2: Structure

Information flow matters more than content volume.

```
1. Hero          ── name, tagline, badges, stats
2. Visual        ── diagram or screenshot (Excalidraw preferred)
3. How It Works  ── the flow, step by step
4. Details       ── features, API, configuration
5. Install       ── prerequisites + install in one block
6. Author        ── name, link
```

**This order is non-negotiable.** Reader should understand what the project does within 10 seconds (hero + diagram), how it works within 30 seconds (flow), and be ready to install within 60 seconds.

## Step 3: Hero Section

```html
<p align="center">
  <h1 align="center">Project Name</h1>
  <p align="center">
    <strong>One sentence that captures the essence.</strong>
  </p>
  <p align="center">
    <code>stat 1</code> &middot; <code>stat 2</code> &middot; <code>stat 3</code>
  </p>
</p>
```

### Tagline rules

- One sentence. Under 10 words.
- Action-oriented. What does it DO, not what it IS.
- No jargon unless the audience is technical.

Good: "Give it a URL. Get back Lighthouse 100."
Good: "Your entire Claude Code setup in one plugin."
Bad: "A comprehensive website cloning and optimization framework."
Bad: "An opinionated collection of development tools and conventions."

### Stats line

3-4 concrete numbers in `<code>` tags separated by `&middot;`

Good: `2 skills` &middot; `7 headless tools` &middot; `pixel-perfect diffs`
Good: `17 skills` &middot; `19 agents` &middot; `6 commands` &middot; `zero bloat`
Bad: `fast` &middot; `reliable` &middot; `easy to use`

### Badges

Technology badges using shields.io `flat-square` style:

```html
<p align="center">
  <a href="URL"><img src="https://img.shields.io/badge/LABEL-COLOR?style=flat-square&logo=LOGO&logoColor=white" alt="ALT"></a>
</p>
```

Only include technologies that are central to the project. 4-6 badges max.

### Score/metric badges (when applicable)

Use `for-the-badge` style for key metrics:

```html
<p align="center">
  <img src="https://img.shields.io/badge/Metric-Value-COLOR?style=for-the-badge" alt="Metric">
</p>
```

## Step 4: Diagram

**Excalidraw preferred.** Hand-drawn aesthetic. Dark background (`#0d1117`).

Generate `.excalidraw` JSON file in `docs/` directory. Export to PNG:

```bash
excalidraw-cli convert docs/diagram.excalidraw --format png --scale 3 --dark -o docs/diagram.png
```

Reference in README:

```html
<p align="center">
  <img src="docs/diagram.png" alt="Flow diagram" />
</p>
```

### Diagram rules

- Show the FLOW, not the architecture
- 4-7 nodes max (more = unreadable)
- Color-code groups (purple for one skill, orange for another)
- Tool names as subtitles under each node
- Dashed borders for logical groupings
- Feedback loops with dashed arrows

If `excalidraw-cli` is not installed: `bun add -g @swiftlysingh/excalidraw-cli`

## Step 5: How It Works

Show the flow. Not the code.

```
You:  "Do the thing"

  1. First step    ── what happens
  2. Second step   ── what happens
  3. Third step    ── what happens
```

- Use `──` (two em dashes) as separator between step and description
- Align the separators vertically
- Start with "You:" showing what the user types
- Each step is one line, under 60 characters

Multiple flows? Give each a `### Subheading`.

## Step 6: Detail Sections

Tables for structured info. Short prose for context.

```markdown
## Section Name

One sentence of context.

| Column | Column |
|---|---|
| data | data |
```

### Rules

- One sentence of context before a table, not a paragraph
- Tables for features, tools, configuration
- Prose only when flow matters (and keep it to 2-3 sentences max)
- No code blocks unless it's an install command or a usage example
- No config file dumps
- No project structure trees (reader can see the repo)
- Edge cases / special features as a single-line list separated by ` -- `

## Step 7: Install

One section. Prerequisites first, then the install.

```bash
# Prerequisites
command1
command2

# Install
install command
```

If the project has a usage example, show it right after install:

```
Then in [tool]:

You: "do the thing"
```

## Anti-patterns

| Don't | Why |
|---|---|
| Two install sections | Confusing, reader doesn't know which to use |
| Project structure trees | Reader can see the repo |
| Cross-reference tables to sibling projects | Maintenance burden, goes stale |
| Code dumps of config files | README shows flow, not implementation |
| Over-explaining what each tool does | One line per tool is enough |
| Real customer/project names | Privacy, goes stale |
| Redundant sections | If it's said once, don't say it again |
| Paragraphs where a table works | Tables are scannable, paragraphs are not |
| "comprehensive", "powerful", "easy" | Show, don't tell |

## Checklist

Before considering README done:

- [ ] Can someone understand what this does in 10 seconds?
- [ ] Is there a visual (diagram or screenshot)?
- [ ] Does the "How It Works" section show the flow in under 30 seconds?
- [ ] Is install in one block with prerequisites first?
- [ ] No redundant sections?
- [ ] No code dumps?
- [ ] No real customer names?
- [ ] Tagline under 10 words?
- [ ] Stats line has concrete numbers?
- [ ] Tables used for structured data?
- [ ] Every section earns its place?
