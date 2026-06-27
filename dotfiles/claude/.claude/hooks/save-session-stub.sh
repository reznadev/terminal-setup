#!/usr/bin/env bash
# SessionEnd hook: safety-net so a session is never fully lost.
# Appends a minimal, clearly-marked auto-stub (timestamp + transcript path)
# to today's cc-journal entry IF run inside the Symbiose vault.
#
# NOTE: this is a recoverability stub, NOT the rich "what was done" summary.
# The quality journal entry is written by the agent when you signal "done"
# (see vault CLAUDE.md Session Protocol). This hook only guarantees a pointer.
#
# Limits: SessionEnd does NOT fire on a hard terminal kill / window close —
# only on graceful exit (/exit, Ctrl-D, logout).

set -euo pipefail

vault="$HOME/symbiose"

input="$(cat 2>/dev/null || true)"
cwd="$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null || true)"
[ -n "$cwd" ] || cwd="$PWD"

case "$cwd" in
  "$vault"*) ;;
  *) exit 0 ;;
esac

transcript="$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null || true)"
sid="$(printf '%s' "$input" | jq -r '.session_id // empty' 2>/dev/null || true)"

jdir="$vault/03_cc-journal/Journal"
mkdir -p "$jdir"
today="$(date +%Y-%m-%d)"
stamp="$(date '+%Y-%m-%d %H:%M')"
file="$jdir/$today.md"

{
  echo
  echo "<!-- auto-session-stub $stamp"
  echo "     session_id: ${sid:-?}"
  echo "     transcript: ${transcript:-?}"
  echo "     (Recoverability-Pointer — die ausführliche Zusammenfassung schreibt der Agent auf 'done') -->"
} >> "$file"
