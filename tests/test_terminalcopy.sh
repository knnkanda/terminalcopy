#!/usr/bin/env zsh
set -euo pipefail

ROOT_DIR="${0:A:h}/.."

test_mask_home() {
  local out
  out="$(HOME="/Users/tester" zsh -c "source '$ROOT_DIR/terminalcopy.zsh'; terminalcopy__sanitize '/Users/tester/projects/demo'")"
  [[ "$out" == "~/projects/demo" ]]
}

test_redact_secret() {
  local out
  out="$(HOME="/Users/tester" zsh -c "source '$ROOT_DIR/terminalcopy.zsh'; terminalcopy__sanitize 'API_KEY=supersecret PASSWORD: topsecret Bearer abc123'")"
  [[ "$out" == *"[REDACTED]"* ]]
  [[ "$out" != *"supersecret"* ]]
  [[ "$out" != *"topsecret"* ]]
}

test_idempotent_install_block() {
  local tempdir
  tempdir="$(mktemp -d)"
  local fakehome="${tempdir}/home"
  mkdir -p "$fakehome"
  print -r -- "export PATH=/usr/bin" > "${fakehome}/.zshrc"
  HOME="$fakehome" zsh "$ROOT_DIR/install.sh" >/dev/null
  HOME="$fakehome" zsh "$ROOT_DIR/install.sh" >/dev/null
  local count
  count="$(grep -c '^# >>> TerminalCopy >>>$' "${fakehome}/.zshrc")"
  [[ "$count" -eq 1 ]]
}

test_mask_home
test_redact_secret
test_idempotent_install_block

print "All tests passed."
