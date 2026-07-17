---
name: wrap
description: End-of-session capture for client work. Run at the end of a session under ~/projects/<client>/ — appends what was done, decisions, open items, and the next step to that client's MEMORY.md, refreshes its RESUME POINT, and offers to commit. Trigger when the user says /wrap, "wrap it up", "wrap the session", or "save the session state" in a client folder.
---

# /wrap — client session capture

Capture THIS session's state into the client's MEMORY.md so the next session — on any machine that pulls the repo — starts with full context.

## Scope check first

- Resolve the client from cwd: the first directory under `~/projects/` (e.g. `~/projects/nicos/ncs-sigma-sentinel` → client `nicos`).
- Not under `~/projects/`? Say so in one line and stop. `/wrap` has no other targets — the vault has its own journal protocol.
- `HTB` is learning, not a client: offer a TechNotes page (tag `source/htb`) instead of a MEMORY.md entry.

## Where MEMORY.md lives

- cwd inside a git repo → `<repo root>/MEMORY.md`. Tracked and committed like any other file — that is what makes it travel.
- cwd not in a repo → `~/projects/<client>/MEMORY.md` (machine-local; acceptable).
- File missing → create it from the template below. New clients need zero setup.

## What to write

Append ONE dated session block — from this session's actual content, never invented:

```
## <today> — <one-line summary>
- Done: …
- Decision (+ warum): …
- Open: …
- Next: <the single concrete next step>
```

Then refresh the `RESUME POINT` line at the top (today's date + one sentence: where things stand).

## Rules

- Decisions, state, next steps ONLY — never credentials, tokens, or sensitive findings verbatim. Anyone with repo access can read this file.
- Append-only. Never rewrite or delete earlier session blocks.
- 5–10 lines per session, kurz und bündig — a resume point, not a transcript.
- If inside a repo: offer to commit (`chore: session memory <date>`). Commit on yes; push remains the user's own call.

## Template (first use in a client)

```
---
client: <client>
created: <today>
---

**RESUME POINT (<today>):** <one sentence — where things stand>

# Engagement Memory — <client>
```
