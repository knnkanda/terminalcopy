#!/usr/bin/env zsh
set -euo pipefail

SCRIPT_DIR="${0:A:h}"
SOURCE_FILE="${SCRIPT_DIR}/terminalcopy.zsh"
TARGET_RC="${HOME}/.zshrc"
BACKUP_FILE="${TARGET_RC}.terminalcopy.backup.$(date +%Y%m%d%H%M%S)"
MARKER_START="# >>> TerminalCopy >>>"
MARKER_END="# <<< TerminalCopy <<<"

if [[ ! -f "$SOURCE_FILE" ]]; then
  print -u2 "terminalcopy.zsh not found next to install.sh"
  exit 1
fi

if [[ -f "$TARGET_RC" ]]; then
  cp "$TARGET_RC" "$BACKUP_FILE"
else
  : > "$TARGET_RC"
  cp "$TARGET_RC" "$BACKUP_FILE"
fi

tmpfile="$(mktemp)"
awk -v start="$MARKER_START" -v end="$MARKER_END" '
  $0 == start { skip=1; next }
  $0 == end { skip=0; next }
  skip != 1 { print }
' "$TARGET_RC" > "$tmpfile"
cat "$tmpfile" > "$TARGET_RC"
rm -f "$tmpfile"

{
  print -r -- ""
  print -r -- "$MARKER_START"
  print -r -- "source \"${SOURCE_FILE}\""
  print -r -- "$MARKER_END"
} >> "$TARGET_RC"

print "Installed TerminalCopy."
print "Backed up your existing zshrc to: $BACKUP_FILE"
print "Open a new terminal or run: source ~/.zshrc"
