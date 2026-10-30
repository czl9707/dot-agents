#!/bin/sh
# Symlink this repo's config into ~/.claude (or $CLAUDE_DIR).
# Existing symlinks pointing elsewhere are replaced; existing real
# files/dirs are moved aside with a .backup.<timestamp> suffix.
set -eu

REPO_DIR=$(cd "$(dirname "$0")" && pwd)
CLAUDE_DIR="${CLAUDE_DIR:-$HOME/.claude}"
AGENTS_DIR="${AGENTS_DIR:-$HOME/.agents}"

git -C "$REPO_DIR" submodule update --init

link() {
    src=$1
    dst=$2
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        return
    fi
    if [ -e "$dst" ]; then
        if [ -L "$dst" ] || [ -f "$dst" ]; then
            rm "$dst"
        else
            mv "$dst" "$dst.backup.$(date +%Y%m%d%H%M%S)"
        fi
    fi
    ln -s "$src" "$dst"
}

link "$REPO_DIR/CLAUDE.md" "$CLAUDE_DIR/CLAUDE.md"
link "$REPO_DIR/rules" "$CLAUDE_DIR/rules"

mkdir -p "$CLAUDE_DIR/skills"
for entry in "$REPO_DIR"/skills/*; do
    link "$entry" "$CLAUDE_DIR/skills/$(basename "$entry")"
done

# Skills are also linked into ~/.agents/skills, the cross-agent location
# used by opencode, gemini and the skills CLI.
mkdir -p "$AGENTS_DIR/skills"
for entry in "$REPO_DIR"/skills/*; do
    link "$entry" "$AGENTS_DIR/skills/$(basename "$entry")"
done

echo "Linked config from $REPO_DIR into $CLAUDE_DIR and $AGENTS_DIR"
