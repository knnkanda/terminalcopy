#!/usr/bin/env zsh

if [[ -n "${TERMINALCOPY_LOADED:-}" ]]; then
  return 0
fi
typeset -gx TERMINALCOPY_LOADED=1

typeset -g TERMINALCOPY_MARKER_START="# >>> TerminalCopy >>>"
typeset -g TERMINALCOPY_MARKER_END="# <<< TerminalCopy <<<"
typeset -g TERMINALCOPY_HOME="${HOME:-}"
typeset -g TERMINALCOPY_REDACTED="[REDACTED]"

terminalcopy__mask_home() {
  local input="${1:-}"
  if [[ -n "${TERMINALCOPY_HOME}" ]]; then
    input="${input//${TERMINALCOPY_HOME}/~}"
  fi
  print -r -- "$input"
}

terminalcopy__sanitize() {
  local input="${1:-}"
  input="$(terminalcopy__mask_home "$input")"
  input="$(print -r -- "$input" | perl -pe '
    s/((?:API[_-]?KEY|PASSWORD|PASS|SECRET|TOKEN)[A-Za-z0-9_]*\s*[:=]\s*)\S+/$1[REDACTED]/ig;
    s/(Authorization:\s*Bearer\s+)\S+/$1[REDACTED]/ig;
    s/\bBearer\s+\S+/Bearer [REDACTED]/ig;
  ')"
  print -r -- "$input"
}

terminalcopy__copy() {
  local payload="${1:-}"
  if command -v pbcopy >/dev/null 2>&1; then
    print -r -- "$payload" | pbcopy
  fi
}

terminalcopy__history_lines() {
  local count="${1:-3}"
  fc -ln -${count}
}

terminalcopy__capture_command() {
  local count="${1:-3}"
  local output
  output="$(terminalcopy__history_lines "$count" 2>/dev/null)"
  terminalcopy__sanitize "$output"
}

terminalcopy__capture_full_history() {
  local output
  output="$(fc -ln 1 2>/dev/null)"
  terminalcopy__sanitize "$output"
}

terminalcopy__print_and_copy() {
  local payload="${1:-}"
  print -r -- "$payload"
  terminalcopy__copy "$payload"
}

ai() {
  local payload
  payload="$(terminalcopy__capture_command 1)"
  terminalcopy__print_and_copy "$payload"
}

a() {
  ai "$@"
}

af() {
  local payload
  payload="$(terminalcopy__capture_command 1)"
  terminalcopy__print_and_copy "$payload"
}

as() {
  local payload
  payload="$(terminalcopy__capture_command 3)"
  terminalcopy__print_and_copy "$payload"
}

as4() { terminalcopy__print_and_copy "$(terminalcopy__capture_command 4)"; }
as5() { terminalcopy__print_and_copy "$(terminalcopy__capture_command 5)"; }
as6() { terminalcopy__print_and_copy "$(terminalcopy__capture_command 6)"; }
as7() { terminalcopy__print_and_copy "$(terminalcopy__capture_command 7)"; }
as8() { terminalcopy__print_and_copy "$(terminalcopy__capture_command 8)"; }
as9() { terminalcopy__print_and_copy "$(terminalcopy__capture_command 9)"; }

ash() {
  local payload
  payload="$(terminalcopy__capture_full_history)"
  terminalcopy__print_and_copy "$payload"
}
