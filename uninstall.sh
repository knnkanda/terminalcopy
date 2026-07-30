#!/usr/bin/env zsh
set -euo pipefail

TARGET_RC="${HOME}/.zshrc"
INSTALL_DIR="${HOME}/.terminalcopy"
MARKER_START="# >>> TerminalCopy >>>"
MARKER_END="# <<< TerminalCopy <<<"

if [[ ! -f "$TARGET_RC" ]]; then
  print "No ~/.zshrc was found, so there was nothing to remove."
  exit 0
fi

tmpfile="$(mktemp)"
awk -v start="$MARKER_START" -v end="$MARKER_END" '
  $0 == start { skip=1; next }
  $0 == end { skip=0; next }
  skip != 1 { print }
' "$TARGET_RC" > "$tmpfile"
cat "$tmpfile" > "$TARGET_RC"
rm -f "$tmpfile"

if [[ -d "$INSTALL_DIR" ]]; then
  rm -rf "$INSTALL_DIR"
fi

print "TerminalCopy has been removed from ~/.zshrc."
print "The local source folder was removed from: $INSTALL_DIR"
