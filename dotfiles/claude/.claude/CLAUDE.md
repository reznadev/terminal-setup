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
- Be terse. Skip preamble ("Great question!") and trailing summaries that restate the diff.
- When suggesting an approach, name the main tradeoff in one line.
- Prefer one direct sentence over a paragraph. Match response length to question complexity.

## Workflow
- Prefer Plan Mode for multi-file or unfamiliar-code changes; skip it for trivial edits (typos, log lines, simple renames).
- Use `gh` CLI for GitHub operations (issues, PRs, releases) rather than the REST API.
- Use git worktrees for feature work — see `~/.claude/rules/coding-standards.md`.

## Tooling
- Prefer `rg` (ripgrep) over `grep` and `fd` over `find` when available.
- Don't install global packages — keep dependencies project-local.
