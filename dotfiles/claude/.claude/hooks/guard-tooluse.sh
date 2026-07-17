#!/usr/bin/env bash
# PreToolUse guard — closes the prompt-injection bypass routes that a
# string-level settings.json deny-list structurally cannot catch:
#   • interpreter/shell exfiltration of secrets (python -c, cat ~/.ssh/…)
#   • shell network egress to private/metadata IPs or known exfil sinks
#   • WebFetch to internal addresses or out-of-band collectors (SSRF/exfil)
#   • destructive `find -delete/-exec` that routes around the rm -rf deny
#
# Design choice: NO domain allowlist. This harness (/dossier, /pn,
# deep-research) exists to fetch arbitrary unknown domains, so an intake
# allowlist would be constant manual toil and self-defeating. Instead we
# deny on the *shape of exfiltration* (private IPs, sink hosts, encoded
# query payloads) — near-zero maintenance, keyed on structure not names.
#
# Output contract (Claude Code PreToolUse):
#   print a JSON permissionDecision (deny|ask) to stdout to override, OR
#   exit 0 with no output to defer to the normal permission flow.
# FAILS OPEN on any parse error — never blocks legit work over a hook bug;
# the settings.json deny-list still stands underneath it.

set -uo pipefail

emit() { # $1 = deny|ask   $2 = reason (plain text, no quotes/newlines)
  printf '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"%s","permissionDecisionReason":"%s"}}\n' "$1" "$2"
  exit 0
}

input="$(cat 2>/dev/null || true)"
tool="$(printf '%s' "$input" | jq -r '.tool_name // empty' 2>/dev/null || true)"
[ -n "$tool" ] || exit 0

# Reading any of these from a shell is exfil, never normal dev.
# Private keys are matched by name (privkey/*-key.pem/*.key) so PUBLIC certs
# (cert.pem, fullchain.pem) stay inspectable — a public cert is not a secret.
SECRETS='\.telegram-creds|id_rsa|id_ed25519|id_dsa|\.ssh/|\.aws/|mcp-needs-auth-cache|\.claude/session-env|\.config/gh/hosts|privkey|private[-_]?key|-key\.pem|[a-z0-9]\.key([^a-z0-9]|$)|\.p12|\.pfx|/\.env|credentials\.json'

# Loopback/metadata only — no bare 10./192.168. here so version strings
# like "python-3.10.0" in a URL path can't false-positive.
LOOPBACK='127\.0\.0\.1|(^|[^a-z])localhost|0\.0\.0\.0|169\.254\.169\.254|metadata\.google|metadata\.goog|::1|/dev/(tcp|udp)/'

# Known out-of-band / exfil collectors.
SINKS='webhook\.site|requestbin|pipedream\.net|ngrok\.(io|app|dev|com)|burpcollaborator|oast\.(live|site|pro|fun|online)|interact\.sh|canarytokens|dnslog|beeceptor|mockbin|hookb\.in|smee\.io|pastebin\.com/api'

# Full private-range set — used ONLY against an extracted host (anchored),
# so it cannot collide with version numbers in a path.
PRIVNET='^(127\.|10\.|0\.0\.0\.0|169\.254\.|192\.168\.|172\.(1[6-9]|2[0-9]|3[01])\.)|(^|\.)(internal|local|localhost)$|::1|^\[?::1|metadata\.google'

case "$tool" in
  Bash)
    cmd="$(printf '%s' "$input" | jq -r '.tool_input.command // empty' 2>/dev/null || true)"
    [ -n "$cmd" ] || exit 0
    lc="$(printf '%s' "$cmd" | tr '[:upper:]' '[:lower:]')"

    if printf '%s' "$cmd" | grep -Eiq "$SECRETS"; then
      emit deny "Blocked: command references a secret/credential path. Reading creds from a shell is the injection-exfil route the deny-list cannot see."
    fi

    if printf '%s' "$lc" | grep -Eq '\bfind\b.*-delete' \
       || printf '%s' "$lc" | grep -Eq '\bfind\b.*-exec[[:space:]]+[^;]*\b(rm|unlink|mv|dd|tee|sh|bash|python)\b'; then
      emit deny "Blocked: destructive find -delete/-exec bypasses the rm -rf deny rule."
    fi

    if printf '%s' "$lc" | grep -Eq '\b(curl|wget|nc|ncat|telnet)\b|/dev/(tcp|udp)/'; then
      if printf '%s' "$lc" | grep -Eq "$LOOPBACK|$SINKS"; then
        emit deny "Blocked: shell network call to a private/metadata address or known exfil sink."
      fi
      emit ask "Shell network egress (curl/wget/nc). Research goes through WebFetch — approve only if you consciously meant this shell call."
    fi

    # Interpreter one-liners doing network I/O = the code-exec exfil route.
    if printf '%s' "$lc" | grep -Eq "(python[0-9.]*|node|deno|bun|perl|ruby|php)[^;|]*(-c|-e)[^;]*(urllib|urlopen|requests|httpx|http\.client|socket\.(socket|create_connection|af_inet)|fetch\(|xmlhttprequest|lwp|net::http|net/http|http\.(get|request)|require\(['\"\`]?(http|https|net|dgram|tls|axios))"; then
      emit deny "Blocked: interpreter one-liner performing network I/O — the code-exec exfil route around the deny-list."
    fi
    exit 0
    ;;

  WebFetch)
    url="$(printf '%s' "$input" | jq -r '.tool_input.url // empty' 2>/dev/null || true)"
    [ -n "$url" ] || exit 0
    lc="$(printf '%s' "$url" | tr '[:upper:]' '[:lower:]')"

    # Extract the bare host so private-range checks can't hit path/version text.
    h="${lc#*://}"; h="${h%%[/?#]*}"; h="${h##*@}"; h="${h%%:*}"

    if printf '%s' "$h" | grep -Eq "$PRIVNET"; then
      emit deny "Blocked: WebFetch to a private/loopback/metadata host (SSRF / internal-data egress)."
    fi
    if printf '%s' "$h" | grep -Eq "$SINKS"; then
      emit deny "Blocked: WebFetch to a known out-of-band / exfil collector host."
    fi

    q="${url#*\?}"
    if [ "$q" != "$url" ]; then
      if [ "${#q}" -gt 400 ] || printf '%s' "$q" | grep -Eq '[A-Za-z0-9+/]{200,}={0,2}|(%[0-9a-fA-F]{2}){60,}'; then
        emit ask "WebFetch URL carries a long/encoded query payload — verify it isn't smuggling local data out before approving."
      fi
    fi
    exit 0
    ;;

  *)
    exit 0
    ;;
esac
