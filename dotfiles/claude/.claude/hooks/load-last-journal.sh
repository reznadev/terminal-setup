#!/usr/bin/env bash
# SessionStart hook: when opening Claude inside the Symbiose vault,
# inject the most recent cc-journal entry into context so you see where you left off.
# stdout from a SessionStart hook is added to the session context.

set -euo pipefail

vault="$HOME/symbiose"

# Determine cwd: prefer hook JSON on stdin, fall back to $PWD.
input="$(cat 2>/dev/null || true)"
cwd="$(printf '%s' "$input" | jq -r '.cwd // empty' 2>/dev/null || true)"
[ -n "$cwd" ] || cwd="$PWD"

# Only act inside the vault.
case "$cwd" in
  "$vault"*) ;;
  *) exit 0 ;;
esac

jdir="$vault/03_cc-journal/Journal"
[ -d "$jdir" ] || exit 0

last="$(ls -1 "$jdir"/*.md 2>/dev/null | sort | tail -1 || true)"
[ -n "$last" ] || exit 0

echo "# Letzte Claude-Session — $(basename "$last" .md)"
echo
cat "$last"
