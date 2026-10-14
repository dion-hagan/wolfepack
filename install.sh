#!/usr/bin/env bash
# Installs the wolfepack setup into ~/.claude:
#   CLAUDE.md          -> ~/.claude/CLAUDE.md            (an existing, different one is backed up first)
#   skills/*           -> ~/.claude/skills/*             (an existing, different one is backed up first)
#   config.example.md  -> ~/.claude/wolfepack.config.md  (only if you have none; never overwritten)
#
# Safe to run again: unchanged files are left alone, nothing is deleted, and it never writes
# settings.json or any secret.
#
# Usage:  ./install.sh [--dry-run]
# Set CLAUDE_HOME to install somewhere other than ~/.claude (used for testing).

set -euo pipefail

DRY=0
case "${1:-}" in
  "") ;;
  --dry-run|-n) DRY=1 ;;
  -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
  *) echo "Unknown option: $1 (try --dry-run)" >&2; exit 2 ;;
esac

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEST="${CLAUDE_HOME:-$HOME/.claude}"
STAMP="$(date +%Y%m%d-%H%M%S)"

say() { echo "$*"; }
act() {
  if [ "$DRY" = 1 ]; then
    echo "  [dry-run] $*"
  else
    "$@"
  fi
}

if [ ! -f "$SRC/CLAUDE.md" ] || [ ! -d "$SRC/skills" ]; then
  echo "Run this script from a wolfepack checkout (CLAUDE.md and skills/ not found in $SRC)." >&2
  exit 1
fi

say "wolfepack install"
say "  from: $SRC"
say "  to:   $DEST"
[ "$DRY" = 1 ] && say "  (dry run: nothing will be written)"

act mkdir -p "$DEST/skills"

# 1. CLAUDE.md
if [ -f "$DEST/CLAUDE.md" ]; then
  if cmp -s "$SRC/CLAUDE.md" "$DEST/CLAUDE.md"; then
    say "CLAUDE.md: already up to date"
  else
    say "CLAUDE.md: differs; backing up to CLAUDE.md.bak-$STAMP and replacing"
    act cp "$DEST/CLAUDE.md" "$DEST/CLAUDE.md.bak-$STAMP"
    act cp "$SRC/CLAUDE.md" "$DEST/CLAUDE.md"
  fi
else
  say "CLAUDE.md: installing"
  act cp "$SRC/CLAUDE.md" "$DEST/CLAUDE.md"
fi

# 2. skills
for dir in "$SRC"/skills/*/; do
  dir="${dir%/}"
  name="$(basename "$dir")"
  target="$DEST/skills/$name"
  if [ -d "$target" ]; then
    if diff -r -q "$dir" "$target" >/dev/null 2>&1; then
      say "skill $name: already up to date"
    else
      say "skill $name: differs; moving the old one to skills-backup-$STAMP/$name and replacing"
      act mkdir -p "$DEST/skills-backup-$STAMP"
      act mv "$target" "$DEST/skills-backup-$STAMP/$name"
      act cp -R "$dir" "$target"
    fi
  else
    say "skill $name: installing"
    act cp -R "$dir" "$target"
  fi
done

# 3. config (never overwritten)
if [ -f "$DEST/wolfepack.config.md" ]; then
  say "wolfepack.config.md: exists; left alone"
else
  say "wolfepack.config.md: installing the example; fill it in"
  act cp "$SRC/config.example.md" "$DEST/wolfepack.config.md"
fi

say ""
say "Done. Next steps:"
say "  1. Edit $DEST/wolfepack.config.md and replace every <PLACEHOLDER>."
say "  2. Set the desktop app settings in docs/desktop-app-settings.md."
say "  3. Start a session and paste agents/wolfe.md."
