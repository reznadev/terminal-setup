#!/usr/bin/env bash
# Telegram push notification for Claude Code hooks.
# Reads creds from ~/.claude/.telegram-creds (not in git):
#   TELEGRAM_TOKEN="..."
#   TELEGRAM_CHAT_ID="..."
# Usage: notify-telegram.sh "message text"
# Keep message text generic — it transits Telegram's servers.

set -euo pipefail

creds="$HOME/.claude/.telegram-creds"
[ -f "$creds" ] || exit 0   # no creds → silently no-op
# shellcheck disable=SC1090
source "$creds"

[ -n "${TELEGRAM_TOKEN:-}" ] && [ -n "${TELEGRAM_CHAT_ID:-}" ] || exit 0

msg="${1:-Claude Code}"

curl -s --max-time 10 \
  "https://api.telegram.org/bot${TELEGRAM_TOKEN}/sendMessage" \
  -d "chat_id=${TELEGRAM_CHAT_ID}" \
  -d "text=${msg}" \
  -o /dev/null || true
