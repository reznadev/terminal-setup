# Coding Standards

<!--
  Global floor — applies wherever code is written. Full engineering
  discipline (TDD, coverage, worktree workflow) is repo-scoped: it applies
  only where that repo's own CLAUDE.md mandates it (e.g. ~/github/bitpol).
  In repos without such rules (client work, scripts, vault tooling): follow
  the repo's existing practice; never scaffold tests/CI/dev-requirements unasked.
-->

## Code Quality (any repo)

- Error handling is mandatory: handle at boundaries, propagate typed errors internally
- No `any` in TypeScript — use `unknown` and narrow
- No bare `except` in Python — catch specific exceptions
- Comments explain "why", never "what"
- Dead code gets deleted — git remembers

## Git

- Conventional commits: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`
- Branch naming: `feat/description`, `fix/description`
- Each commit is independently understandable
- Worktrees only when I explicitly ask or the repo's CLAUDE.md mandates them; clean up with `git worktree remove`, never rm -rf

## Constraints

- Do NOT run destructive commands (rm -rf, DROP TABLE, git push --force)
- Do NOT commit secrets, API keys, or .env files
- Do NOT install global packages — keep dependencies project-local
- Treat client repos (`~/projects/*`) as externally visible: nothing leaves via push, publish, or message without explicit approval
