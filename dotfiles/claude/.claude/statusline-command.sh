#!/usr/bin/env bash
# Claude Code status line layout:
# [Model] 🐧 <purple:cwd> <orange:⎇ worktree | pink:branch> <green/yellow/red:context-bar %> <grey:$cost> <yellow:⚡effort>

input=$(cat)

# --- Extract fields from JSON ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // empty')
git_worktree=$(echo "$input" | jq -r '.workspace.git_worktree // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
total_cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
effort_level=$(echo "$input" | jq -r '.effort.level // empty')

# Shorten home directory to ~
home="$HOME"
cwd_display="${cwd/#$home/~}"

# Git branch — only used when not in a worktree session
git_branch=""
if [ -z "$git_worktree" ]; then
  git_branch=$(echo "$input" | jq -r '.worktree.branch // empty')
  if [ -z "$git_branch" ]; then
    git_branch=$(git -C "$cwd" --no-optional-locks branch --show-current 2>/dev/null || true)
  fi
fi

# --- Colors ---
cyan=$'\033[38;5;087m'
purple=$'\033[38;5;099m'
pink=$'\033[38;5;205m'
orange=$'\033[38;5;214m'
yellow=$'\033[38;5;228m'
grey=$'\033[38;5;242m'
green=$'\033[38;5;082m'
bar_yellow=$'\033[38;5;226m'
red=$'\033[38;5;196m'
reset=$'\033[0m'

# --- Model segment: [Opus] in cyan ---
model_seg=""
if [ -n "$model" ]; then
  # Shorten verbose display names: "Claude 3.5 Sonnet" -> "Sonnet", "Claude Opus 4" -> "Opus 4", etc.
  short_model=$(echo "$model" | sed 's/^Claude[[:space:]]*//' | sed 's/^claude[[:space:]]*//')
  model_seg="${cyan}[${short_model}]${reset} "
fi

# --- Worktree / branch segment ---
branch_seg=""
if [ -n "$git_worktree" ]; then
  branch_seg=" ${orange}⎇ ${git_worktree}${reset}"
elif [ -n "$git_branch" ]; then
  branch_seg=" ${pink}${git_branch}${reset}"
fi

# --- Context usage bar (10 chars) ---
context_seg=""
# used_pct may be a float; convert to integer for comparisons
used_int=$(printf '%.0f' "$used_pct" 2>/dev/null || echo "0")
filled=$(( used_int * 10 / 100 ))
[ "$filled" -gt 10 ] && filled=10
empty=$(( 10 - filled ))

bar=""
for (( i=0; i<filled; i++ )); do bar="${bar}▓"; done
for (( i=0; i<empty; i++ )); do bar="${bar}░"; done

if [ "$used_int" -gt 80 ]; then
  bar_color="$red"
elif [ "$used_int" -ge 50 ]; then
  bar_color="$bar_yellow"
else
  bar_color="$green"
fi
context_seg=" ${bar_color}${bar} ${used_int}%${reset}"

# --- Cost segment ---
cost_seg=""
if [ -n "$total_cost" ] && [ "$total_cost" != "null" ]; then
  cost_formatted=$(printf '%.2f' "$total_cost" 2>/dev/null)
  cost_seg=" ${grey}\$${cost_formatted}${reset}"
fi

# --- Effort segment ---
effort_seg=""
if [ -n "$effort_level" ]; then
  effort_seg=" ${yellow}⚡${effort_level}${reset}"
fi

# --- Assemble ---
printf "${model_seg}🐧 ${purple}%s${reset}%s%s%s%s" \
  "$cwd_display" \
  "$branch_seg" \
  "$context_seg" \
  "$cost_seg" \
  "$effort_seg"
