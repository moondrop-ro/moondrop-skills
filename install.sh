#!/bin/bash
set -e

SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$SKILLS_DIR"

for skill in "$SCRIPT_DIR"/skills/*/; do
  skill_name="$(basename "$skill")"
  mkdir -p "$SKILLS_DIR/$skill_name"
  cp -r "$skill"* "$SKILLS_DIR/$skill_name/"
  echo "  Installed: /$skill_name"
done

echo ""
echo "Done. Skills available in your next Claude Code session."
