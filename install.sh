#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR=""

# Parse args
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project)
      PROJECT_DIR="$2"
      shift 2
      ;;
    *)
      echo "Usage: bash install.sh [--project /path/to/project]"
      exit 1
      ;;
  esac
done

# Set target directory
if [ -n "$PROJECT_DIR" ]; then
  SKILLS_DIR="$PROJECT_DIR/.claude/skills"
  echo "Installing to project: $PROJECT_DIR"
else
  SKILLS_DIR="$HOME/.claude/skills"
  echo "Installing globally to: $SKILLS_DIR"
fi

mkdir -p "$SKILLS_DIR"

count=0
for skill in "$SCRIPT_DIR"/skills/*/; do
  skill_name="$(basename "$skill")"
  mkdir -p "$SKILLS_DIR/$skill_name"
  cp -r "$skill"* "$SKILLS_DIR/$skill_name/"
  echo "  Installed: /$skill_name"
  count=$((count + 1))
done

# Write installed version marker
if [ -f "$SCRIPT_DIR/VERSION" ]; then
  VERSION=$(cat "$SCRIPT_DIR/VERSION")
  echo ""
  echo "Version: $VERSION"
fi

echo "Done. $count skill(s) available in your next Claude Code session."
