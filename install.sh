#!/usr/bin/env bash
#
# Install the /user-journey-map slash command into ~/.claude/commands/
# by symlinking it from this skill folder.
#
# Run this *after* cloning the repo into ~/.claude/skills/user-journey-map
# (or wherever your Claude Code skills directory lives).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="${SCRIPT_DIR}/commands/user-journey-map.md"
TARGET_DIR="${HOME}/.claude/commands"
TARGET="${TARGET_DIR}/user-journey-map.md"

if [ ! -f "${SOURCE}" ]; then
  echo "✗ Cannot find ${SOURCE}"
  echo "  Make sure the repo is cloned intact." >&2
  exit 1
fi

mkdir -p "${TARGET_DIR}"

if [ -L "${TARGET}" ] || [ -f "${TARGET}" ]; then
  echo "→ ${TARGET} already exists — replacing"
  rm -f "${TARGET}"
fi

ln -s "${SOURCE}" "${TARGET}"

echo "✓ Installed /user-journey-map slash command"
echo "  symlink: ${TARGET} → ${SOURCE}"
echo ""
echo "Open a new Claude Code session and type /user-journey-map to use it."
