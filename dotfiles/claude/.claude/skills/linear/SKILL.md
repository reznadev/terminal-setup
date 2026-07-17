---
name: linear
description: Company todo system — all BITPOL/venture execution lives in Linear (private tasks stay in Things 3). Capture ad-hoc todos as issues, push a vault page's checkboxes as a migration, review open issues, mark done with vault sync-back. Trigger when the user says /linear, "add a (company) todo", "put this in Linear", "push this page to Linear", "what's on my plate", "mark X done", or "start X".
---

# /linear — company execution board

**System split (the load-bearing rule):**
- **Linear** = all company execution: BITPOL work, Track A/C actions, Praktikant tasks. Source of truth for todo state.
- **Vault** = strategy and knowledge. New company action items are *born in Linear*; vault pages reference them instead of growing new checkbox lists. Existing checkbox pages migrate via **Push**.
- **Things 3** = private/personal. This skill never touches it; if a capture looks private (health, travel, Steuer-personal), ask in one line before creating.

## Setup check

Load the Linear MCP tools via ToolSearch (`+linear`). If none are found, the server isn't connected — tell the user to run `/mcp` and authenticate `linear` (OAuth), then stop.

## Conventions (discovered 2026-07-15 — treat as fixed, don't re-discover)

- Workspace: **bitpol** · team semantics are OWNERSHIP, not work type (user feedback 2026-07-17): **Delivery (DEL) = the principal's board — the only one the user watches. GTM = juniors/Praktikant work only.** Never put the user's own tasks in GTM.
- Default project: **INTERNAL** (spans both teams; "internal bitpol to-dos")
- Project map: client work lives in per-client Delivery projects (nicos, ITZ-Bund, OLB, TB); Praktikant per-account research → **Client-Research** (GTM); everything internal → INTERNAL
- Labels (workspace-level): `track-a`, `track-c`, `juniors` + pre-existing `Bug`, `Feature`, `Improvement`, `M&A`. No `research` label — the Client-Research project covers that convention
- Priority: Urgent = hard external deadline · High = this week · Medium = default · Low = someday/idea
- States (both teams): Backlog, Todo, In Progress, Done, Duplicate, Canceled. Pushes: "this week" → **Todo** + High; later horizons → **Backlog** + Medium
- Assignee: `#myself` → "me" (team Delivery); `#juniors` → team GTM, leave unassigned + `juniors` label

## Granularity (user feedback 2026-07-17 — hard rule)

**One issue per outcome, never per action line.** The user wants a scannable board: short, precise, summarized issues. Sub-steps go into the issue description as a markdown checklist — not into separate issues. Before creating anything, group related items by outcome/theme; a page push should yield a handful of umbrella issues, not dozens. If a capture batch would create more than ~5 issues, propose the grouping in one line first.

## Modes

### Capture (default) — "add a todo: …", any ad-hoc company task

One line in → one issue out, no ceremony. Short imperative title; description only when the user gave context; infer project/labels/priority from content, else INTERNAL + Medium. Multiple bullets → group related ones into a single issue with a checklist; only genuinely unrelated tasks get their own issue (see Granularity). Echo the created ID(s) back.

### Push — `/linear push <vault page>` (migrate an existing checkbox list)

1. Read the page. Collect unchecked `- [ ]` lines. Skip sections marked PARKED/killed and `>` note/quote lines.
2. Skip lines already carrying a sync marker (`↗ <issue-ID>`); still dedupe by title against open issues in the target project — markers can be lost to edits.
3. **Group the collected lines by outcome/theme before creating anything** — the checkbox lines become a markdown checklist inside one umbrella issue per theme (see Granularity). Map horizon → state/priority per Conventions. An explicit deadline in the text ("before end Q3 2026") → issue due date.
4. Description = 1–3 sentences of surrounding context, vault refs as plain text ("per go-public-strategy §the repurpose factory" — wikilinks don't resolve in Linear), final line `Source: <page> § <section>`.
5. Same action listed in two sections (this-week items often repeat in a 90-day list) → **one** issue at the earlier horizon, mark both lines.
6. After each create, append ` ↗ <issue-ID>` to the vault line (additive, pre-approved). When a page is fully pushed, add one note under its title: *"Execution tracked in Linear (project X) — checkbox state here may lag."*
7. Report counts: created / skipped-marker / skipped-duplicate.

### Review — "what's on my plate", standup, weekly review

List my open issues grouped In Progress → Todo → Backlog; flag overdue and due-this-week at the top. On request, triage: propose priority/due-date/stale-issue fixes, apply on confirmation.

### Done / update — "mark X done", "start X", "move X to …"

Update the issue state. If a vault line carries that issue's `↗` marker, flip it to `- [x]` with the date `(✓ YYYY-MM-DD)`. Canceled issues: annotate the vault line, but never uncheck a box or reword the user's text.

## Rules

- **Ring 1 boundary:** the Praktikant has Linear access — nothing client-confidential, no credentials, no material from `~/projects/*`. Sanitized client references only.
- Parked work (currently Track B) never becomes issues — parked ≠ backlog.
- Vault prose stays canonical for strategy and rationale; Linear holds only the executable slice.
