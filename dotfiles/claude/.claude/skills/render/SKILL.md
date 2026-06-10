---
name: render
description: Render a finalized vault page to a polished, self-contained HTML deliverable next to its markdown. Markdown stays canonical; HTML is a regenerable render for publish (journald/) and research-report (Domains/) outputs only. Trigger when the user says /render, "render this", "make an HTML version", "take this file" (when pointing at a deliverable), or asks for an HTML deliverable of a page.
---

# Render HTML Deliverable (`/render`)

You produce the **HTML render layer** for the Symbiose Obsidian vault. When invoked,
you take a finalized markdown page and generate a polished, self-contained `.html`
deliverable beside it — implementing the **Render** operation defined in the vault's
root `CLAUDE.md`.

**Vault root**: the Obsidian vault you're working in — typically `$HOME/symbiose`.
Resolve it dynamically (it differs per machine); if the cwd isn't the vault, `cd`
into `$HOME/symbiose`. All vault paths below are relative to that root.

This skill exists because Anthropic's "loop vs deliverable" split (Thariq Shihipar,
May 2026) maps onto the vault: **markdown is the source of truth** (the loop — graph,
wikilinks, search, durability); **HTML is the artifact a human reads**. You only ever
*render* markdown to HTML — never the reverse, never a second copy to hand-maintain.

---

## Hard rules (never break)

- **HTML is derived, markdown is canonical.** Never hand-edit the `.html` as a master.
  If content is wrong, fix the `.md` and regenerate.
- **Scope guard.** Only render finalized, human-facing deliverables:
  - Publish layer: `journald/` (blogposts, articles, newsletters)
  - Research reports / strategy deliverables: `Domains/`, deep-research output, dossiers
  - **Refuse** library notes (`MindFactory/`, `TechNotes/`), drafts, and short notes —
    warn the user and ask for explicit override before rendering one of those.
- **Writing the `.html` is fine when explicitly invoked** (it's a new sibling file, non-destructive).
  **Modifying the source `.md`** (to add the embed block) **requires confirmation first.**
- **Never fabricate.** Render the page's existing content verbatim. Do NOT invent a
  confidence level, date, or source that isn't in the page.
- Self-contained output: inline CSS, **no external dependencies** — must work both as a
  sandboxed-iframe embed in Obsidian and when opened directly as a file.
- NEVER touch `02_Templates/` or `.obsidian/`.
- Cost-aware: HTML is ~4–8× the tokens of markdown. Render on demand, never in a loop.

---

## Workflow

### 1. Resolve the target file

- Use the file the user named or `@mentioned`.
- If none given, use the **most recently discussed/read** page — but **state which file
  you picked** before writing anything.

### 2. Scope check

- Confirm the file is in render scope (see Hard rules). If it's a library note or an
  obvious draft, **stop and ask** — don't render it silently.

### 3. Read source + gather assets

- Read the full `.md`, including frontmatter.
- `Glob` the page's folder for sibling `*.excalidraw.svg` files — these get embedded as figures.

### 4. Render from the shared scaffold

- Read `_html/base.html` (vault root `_html/`) — it is the **single source of styling**.
  Inline its `<style>` block into the output so future scaffold edits propagate to new renders.
- **Header (provenance).** Map frontmatter → the header block:
  - Title: frontmatter `title:`, else the page's H1.
  - Date: `updated:` or `date:`.
  - Source: external `url:`/`source:` if present, else `Internal · <folder>`.
  - Badge: use `confidence:` **if the page has it**; otherwise use the `status/` tag
    (e.g. "Status: Growing"). Never invent a confidence value.
- **Body conversion** (faithful to the markdown):
  - Headings, paragraphs, lists, tables → semantic HTML using the scaffold's classes.
  - Right-align numeric table columns (`class="num"`).
  - **Callouts**: wrap warning/urgent/risk blocks in `.callout.risk` or `.callout.note`
    (e.g. exit-tax warnings, "what could go wrong", purification notes).
  - **Checklists** (`- [ ]` / `- [x]`) → `.checklist` with ☐ / ☑ preserving checked state.
  - **Wikilinks** `[[Page]]` → `<span class="wikilink" title="Vault page: Page">Page</span>`
    (they'd be broken links in a standalone file — render as styled references, not `<a>`).
  - **Diagrams**: embed each sibling SVG as `<figure><img src="<name>.excalidraw.svg">…</figure>`.
- Set the footer's source path to the `.md` filename.

### 5. Write

- Write `<page-name>.html` next to the markdown, same folder.

### 6. Offer the follow-ups (don't auto-do)

- Offer to open it in the browser (`open <file>` on macOS).
- Offer to insert the embed block into the `.md` (requires the user's HTML-embed plugin).
  Only edit the `.md` after the user confirms. Block syntax (Local HTML Embed):
  ````
  ```local-html-embed
  path: ./<page-name>.html
  ```
  ````
  Confirm exact syntax against the plugin the user actually installed.

### 7. Report

- One line: what was rendered, where, how many diagrams embedded, and any faithful-render
  choices worth flagging (e.g. "no confidence field → used status badge", "wikilinks
  rendered as references").

---

## Notes

- Regeneration: if the `.md` later changes materially, re-run `/render` on it — the `.html`
  is build output and should be overwritten, not merged.
- If `_html/base.html` doesn't exist yet, tell the user (the render layer isn't set up) —
  don't improvise a divergent style.
- One scaffold for now; if the user later adds variants (e.g. `report.html` vs `post.html`),
  pick by the page's location/type.
