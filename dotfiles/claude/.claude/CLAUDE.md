# Personal preferences

<!--
  This file loads at the start of EVERY session for ALL projects. Keep it lean.
  - Cross-project rules → here
  - Project-specific rules → that project's CLAUDE.md (template at ~/github/terminal-setup/dotfiles/claude/templates/PROJECT_CLAUDE.md)
  - Code style + git conventions → ~/.claude/rules/ (auto-loaded)
  - On-demand workflows → ~/.claude/skills/ (loaded only when invoked/relevant)

  For each line, ask: "would removing this cause Claude to make mistakes?"
  If not, cut it.
-->

## Communication

### Structure
- Lead with the answer. Supporting detail comes after.
- Use headings (`###`) when a response has 2+ distinct parts.
- Use bullets for any list of 3+ items — never inline them in prose.
- Use tables when comparing items across shared attributes.
- One idea per bullet. Break long bullets into sub-bullets.

### Visual rhythm
- Short paragraphs (1–3 sentences). Blank line between them.
- **Bold** the load-bearing terms so the eye can land on them.
- Reference code as `path/file.ts:42` — inline code formatting makes paths jump out.
- Don't bold everything. If most of a sentence is bold, none of it is.

### Tone
- Skip preamble ("Great question!") and trailing summaries that restate the diff.
- No status theater ("I'll now read the file"). The tool calls are the receipt.
- When suggesting an approach, name the main tradeoff in one line.
- Match length to complexity — but never sacrifice structure to save lines.

## Workflow
- Prefer Plan Mode for multi-file or unfamiliar-code changes; skip it for trivial edits (typos, log lines, simple renames).
- Use `gh` CLI for GitHub operations (issues, PRs, releases) rather than the REST API.
- Use git worktrees for feature work — see `~/.claude/rules/coding-standards.md`.

## Tooling
- Prefer `rg` (ripgrep) over `grep` and `fd` over `find` when available.
- Don't install global packages — keep dependencies project-local.
