#!/usr/bin/env bash
set -euo pipefail

target="${1:?missing tmux target (session:window)}"
path="${2:-$PWD}"

# Find git common dir (works in worktrees)
common_dir="$(git -C "$path" rev-parse --path-format=absolute --git-common-dir 2>/dev/null || true)"
[[ -n "$common_dir" ]] || exit 0

# Derive main repo root
# - normal checkout: common_dir = <repo>/.git
# - worktree:        common_dir = <repo>/.git/worktrees/<wt>
repo_root=""
if [[ "$common_dir" == */.git/worktrees/* ]]; then
  repo_root="$(dirname "$(dirname "$(dirname "$common_dir")")")"
else
  repo_root="$(dirname "$common_dir")"
fi

repo="$(basename "$repo_root")"
branch="$(git -C "$path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "?")"

dirty=""
git -C "$path" diff --quiet --ignore-submodules -- 2>/dev/null || dirty="*"

# If you're inside <repo>/.worktrees/<name>/..., prefer <name> as the label
p_abs="$(cd "$path" && pwd -P)"
rt_abs="$(cd "$repo_root" && pwd -P)"
label="$branch"

wt_prefix="$rt_abs/.worktrees/"
if [[ "$p_abs" == "$wt_prefix"* ]]; then
  rest="${p_abs#"$wt_prefix"}"
  wt_name="${rest%%/*}"
  [[ -n "$wt_name" ]] && label="$wt_name"
fi

title="${repo}:${label}${dirty}"

tmux rename-window -t "$target" "$title" >/dev/null 2>&1 || true

