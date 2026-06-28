#!/usr/bin/env bash
# Flag the tmux window this Claude process runs in, so a glance at the
# status bar shows which window is waiting on you RIGHT NOW.
#   mark [icon]  -> prepend "<icon> " to the window name (default ⏳)
#   clear        -> strip whatever mark we added
# The mark is set when Claude is blocked (permission / idle) and cleared the
# moment it resumes (tool finishes, you reply) or the turn/session ends — so a
# lingering mark always means "still waiting".
#
# No-ops cleanly outside tmux. Preserves the window's prior automatic-rename
# state (stashed in @claude_ar_prev) so custom names survive untouched.
set -euo pipefail

[ -n "${TMUX:-}" ] && [ -n "${TMUX_PANE:-}" ] || exit 0

P="$TMUX_PANE"
action="${1:-mark}"

# Current name with our existing mark (if any) stripped off.
base_name() {
  local name old
  name=$(tmux display -p -t "$P" '#W')
  old=$(tmux show-options -wqv -t "$P" @claude_mark)
  if [ -n "$old" ]; then printf '%s' "${name#"$old"}"; else printf '%s' "$name"; fi
}

case "$action" in
  mark)
    icon="${2:-⏳}"
    prefix="${icon} "
    base=$(base_name)
    # Only stash auto-rename state on the FIRST mark (don't clobber it when
    # upgrading ⏳ -> 🔐 on the same window).
    if [ -z "$(tmux show-options -wqv -t "$P" @claude_mark)" ]; then
      tmux set-option -wq -t "$P" @claude_ar_prev \
        "$(tmux display -p -t "$P" '#{?automatic-rename,on,off}')"
      tmux set-window-option -t "$P" automatic-rename off
    fi
    tmux set-option -wq -t "$P" @claude_mark "$prefix"
    tmux rename-window -t "$P" "${prefix}${base}"
    ;;
  clear)
    # Nothing to do if we never marked this window.
    [ -n "$(tmux show-options -wqv -t "$P" @claude_mark)" ] || exit 0
    tmux rename-window -t "$P" "$(base_name)"
    if [ "$(tmux show-options -wqv -t "$P" @claude_ar_prev)" = "on" ]; then
      tmux set-window-option -u -t "$P" automatic-rename   # re-inherit auto-rename
    fi
    tmux set-option -wqu -t "$P" @claude_mark
    tmux set-option -wqu -t "$P" @claude_ar_prev
    ;;
esac
