#!/usr/bin/env bash
# Symlinks every skill in this repo into local agent skill dirs, so edits here are live.
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"

for DEST in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
  mkdir -p "$DEST"
  for src in "$REPO"/skills/*/; do
    src="${src%/}"
    target="$DEST/$(basename "$src")"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "skipped $target - a real directory exists, remove it to link" >&2
      continue
    fi
    ln -sfn "$src" "$target"
    echo "linked $target"
  done
done
