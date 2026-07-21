---
name: yousum
description: Summarize a YouTube video into the Obsidian vault. Given a YouTube URL, fetch its transcript (into Summaries/transcript/) and write a structured Markdown summary with timestamped deep-links (into Summaries/output/). Also re-summarizes an existing transcript file. Trigger when the user says /yousum, pastes a YouTube URL asking for a summary, or says "summarize this video".
---

# yousum — YouTube → vault summary (`/yousum`)

Two-step pipeline. **Step 1** (a Python script) fetches the transcript; **Step 2**
(you, the Claude agent) reads it and writes the summary. No OpenAI — you are the
analyzer, so Claude's full context handles the whole transcript with no chunking.

**Repo**: `$HOME/github/yousum` (fetch script + venv live here).
**Vault paths** (resolve `$HOME` per machine):
- Transcripts: `$HOME/symbiose/Summaries/transcript/`
- Summaries:   `$HOME/symbiose/Summaries/output/`

---

## Resolve the input

The argument after `/yousum` (or the user's message) is one of:

- **A YouTube URL** → run Step 1 to fetch, then Step 2 to summarize.
- **A transcript filename or partial name** → skip Step 1; summarize that file from
  `Summaries/transcript/`.
- **Nothing** → skip Step 1; summarize the **newest** file in `Summaries/transcript/`
  (`ls -t`). State which file you picked.

## Step 1 — Fetch the transcript (URL input only)

Run the fetch script; it prints the written transcript path on stdout:

```bash
cd "$HOME/github/yousum" && .venv/bin/python main.py "<URL>"
```

- The transcript lands in `Summaries/transcript/` as `YYYY-MM-DD_<Safe_Title>.md`
  with YAML frontmatter (`title`, `channel`, `url`, `video_id`, `fetched`).
- If the script exits with "No transcript available", tell the user the video has no
  captions and stop — there is nothing to summarize.
- Capture the printed path; that is your Step 2 input.

## Step 2 — Summarize (always)

1. Read the transcript file. Parse the frontmatter for `title`, `channel`, `url`.
2. Read the whole transcript. Each line is `[m:ss] text` — the `[m:ss]` markers are
   your timestamp anchors. Convert `m:ss`/`h:mm:ss` to **total seconds** for deep-links
   (`1:23` → 83). **Never invent timestamps** — only cite markers present in the file.
3. Write the summary to `Summaries/output/` using the **same base filename** as the
   transcript (so transcript ↔ summary pair up), in this structure:

```markdown
---
title: "<title>"
channel: "<channel>"
url: <url>
summarized: <today's date, YYYY-MM-DD>
source: yousum
---

# <title>

**Channel:** <channel>
**URL:** <url>

---

## Overview

<3–5 sentences: what the video is about, who it's for, the core takeaway.>

---

## Key Takeaways

- [`m:ss`](<url>&t=<seconds>) **<takeaway title>** — <1–2 sentences on why it matters.>
  <!-- 5–10 items, each anchored to a real timestamp from the transcript. -->

---

## Sections

### [`m:ss`](<url>&t=<seconds>) — <section title>

<2–3 sentence summary of this section.>

- <concrete point>
- <concrete point>

<!-- One block per topic shift; 4–12 sections depending on length. -->
```

4. Report back: one line naming the summary file written, and (if fetched) the
   transcript file. Do **not** paste the full summary into chat unless asked.

## Rules

- **Timestamp links must be real.** Every `&t=<seconds>` comes from a marker in the
  transcript — verify, don't approximate.
- **Faithful, not inventive.** Summarize what's said; never add outside facts or claims
  the transcript doesn't support.
- **Idempotent.** Re-running on the same video/day overwrites both files — that's fine.
- **Language.** Match the transcript's language for the summary body (German transcript
  → German summary), keep the section headers as above.
- Never touch `.obsidian/` or `02_Templates/`.
