# Coding Standards

## Code Quality
- Every function does one thing
- Prefer composition over inheritance
- Prefer explicit over implicit — no magic
- Error handling is mandatory: handle at boundaries, propagate typed errors internally
- No `any` in TypeScript — use `unknown` and narrow
- No bare `except` in Python — catch specific exceptions
- Functions over 40 lines need splitting
- Comments explain "why", never "what"
- Dead code gets deleted — git remembers

## Testing
- Every new function gets tests
- Test behavior, not implementation
- Naming: `test_[what]_[condition]_[expected]` or `it('should [behavior] when [condition]')`
- Arrange-Act-Assert pattern
- Mock external dependencies only
- If fixing a bug, write the failing test FIRST

## Git
- Conventional commits: `feat:`, `fix:`, `refactor:`, `docs:`, `test:`, `chore:`
- Branch naming: `feat/description`, `fix/description`
- Never force push to main/master
- Each commit is independently understandable
- Do NOT commit secrets, API keys, or .env files

## Git Worktrees
- When asked to work on a feature, create a worktree: `git worktree add _worktrees/<type>-<desc> -b <type>/<desc>`
- Ensure `_worktrees/` is in .gitignore
- Always verify which worktree you're in before committing
- Clean up with `git worktree remove`, never rm -rf

## Constraints
- Do NOT run destructive commands (rm -rf, DROP TABLE, git push --force)
- Do NOT install global packages — keep dependencies project-local
