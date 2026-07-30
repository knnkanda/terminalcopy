#!/usr/bin/env zsh
set -euo pipefail

REPO_URL="https://raw.githubusercontent.com/knnkanda/terminalcopy/main/terminalcopy.zsh"
INSTALL_DIR="${HOME}/.terminalcopy"
INSTALLED_SOURCE="${INSTALL_DIR}/terminalcopy.zsh"
TARGET_RC="${HOME}/.zshrc"
BACKUP_FILE="${TARGET_RC}.terminalcopy.backup.$(date +%Y%m%d%H%M%S)"
MARKER_START="# >>> TerminalCopy >>>"
MARKER_END="# <<< TerminalCopy <<<"

mkdir -p "$INSTALL_DIR"

if [[ -f "${0:A:h}/terminalcopy.zsh" ]]; then
  cp "${0:A:h}/terminalcopy.zsh" "$INSTALLED_SOURCE"
else
  curl -fsSL "$REPO_URL" -o "$INSTALLED_SOURCE"
fi

chmod 600 "$INSTALLED_SOURCE"

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
  print -r -- "source \"${INSTALLED_SOURCE}\""
  print -r -- "$MARKER_END"
} >> "$TARGET_RC"

print "TerminalCopy is ready."
print "Your existing ~/.zshrc was backed up to: $BACKUP_FILE"
print "The loaded source file is: $INSTALLED_SOURCE"
print "Open a new terminal or run: source ~/.zshrc"
