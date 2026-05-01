# Plan: TechNotes/05_AI Prompt Database

## Context
User wants a prompt database inside their Obsidian vault. Rather than MindFactory, `TechNotes/05_AI/` fits better — prompts are technical artifacts, and the AI category can grow to include model notes, API patterns, and agent workflows.

## Structure to Create

```
TechNotes/05_AI/
  Prompts/
    _index.md          ← MOC listing all prompt files + quick-ref table
    research.md        ← research & synthesis prompts
    writing.md         ← writing, editing, rewriting prompts
    coding.md          ← dev, debugging, code review prompts
    analysis.md        ← analysis, comparison, decision prompts
    system.md          ← system/meta prompts (personas, constraints)
```

## Frontmatter Schema

Follow existing TechNotes conventions (`TemplateTopic.md`):

```yaml
---
tags:
  - domain/ai
  - type/tool
  - source/self
  - status/growing
created: 2026-05-01
---
```

Each prompt entry inside the category files:

```
## [Prompt Name]
**Use when:** ...
**Model:** claude-sonnet-4-6 (or "any")
**Quality:** ⭐⭐⭐⭐
**Last used:** 2026-05-01

[prompt text in a code block]

**Notes:** any caveats or variations
```

## Files to Create

| File | Purpose |
|------|---------|
| `TechNotes/05_AI/Prompts/_index.md` | MOC with frontmatter, table of all prompts, links to category files |
| `TechNotes/05_AI/Prompts/research.md` | Research/synthesis prompts |
| `TechNotes/05_AI/Prompts/writing.md` | Writing/editing prompts |
| `TechNotes/05_AI/Prompts/coding.md` | Dev/debugging prompts |
| `TechNotes/05_AI/Prompts/analysis.md` | Analysis/comparison prompts |
| `TechNotes/05_AI/Prompts/system.md` | System/meta/persona prompts |

## Conventions
- Naming: lowercase with underscores, matching existing TechNotes style
- Category folder prefix: `05_AI` (continuing numeric sequence after `04_Certifications`)
- Wiki-link `_index.md` from within each category file (`[[AI Prompts Index]]`)
- `_index.md` links back to each category file

## Verification
- Open vault in Obsidian and confirm `TechNotes/05_AI/Prompts/` appears in file tree
- Check that `_index.md` renders with working `[[wikilinks]]` to category files
- Confirm frontmatter tags are valid (no Obsidian parse errors)
