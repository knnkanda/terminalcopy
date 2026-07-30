#!/usr/bin/env zsh

if [[ -n "${TERMINALCOPY_LOADED:-}" ]]; then
  return 0
fi
typeset -gx TERMINALCOPY_LOADED=1

typeset -g TERMINALCOPY_MARKER_START="# >>> TerminalCopy >>>"
typeset -g TERMINALCOPY_MARKER_END="# <<< TerminalCopy <<<"
typeset -g TERMINALCOPY_HOME="${HOME:-}"
typeset -g TERMINALCOPY_REDACTED="[REDACTED]"
typeset -g TERMINALCOPY_MACHINE="pk_mini"

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
  return 0
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

terminalcopy__history_clean() {
  local input="${1:-}"
  print -r -- "$input" \
    | sed 's/^[[:space:]]*[0-9][0-9]*[[:space:]]*//' \
    | sed '/^[[:space:]]*$/d' \
    | sed '/^[[:space:]]*#/d' \
    | sed '/^zsh: command not found:/d'
}

terminalcopy__context_block() {
  local command_text="${1:-}"
  local output="${2:-}"
  local cwd
  local timestamp
  local shell_name
  local os_name
  cwd="$(pwd)"
  cwd="${cwd//${TERMINALCOPY_HOME}/~}"
  timestamp="$(date '+%Y-%m-%d %H:%M %Z')"
  shell_name="${ZSH_NAME:-zsh}"
  os_name="macOS"
  printf 'Machine : %s\nFolder  : %s\nTime    : %s\nOS      : %s\nShell   : %s\n\npk_mini %% %s\n\n%s\n' \
    "$TERMINALCOPY_MACHINE" "$cwd" "$timestamp" "$os_name" "$shell_name" "$command_text" "$output"
}

terminalcopy__print_and_copy() {
  local payload="${1:-}"
  print -r -- "$payload"
  terminalcopy__copy "$payload"
}

terminalcopy__capture_command_output() {
  local command_text="${1:-}"
  local tmpfile
  tmpfile="$(mktemp)"
  if eval "$command_text" >"$tmpfile" 2>&1; then
    :
  fi
  cat "$tmpfile"
  rm -f "$tmpfile"
}

terminalcopy__format_command_and_output() {
  local command_text="${1:-}"
  local output="${2:-}"
  local payload
  payload="$(terminalcopy__context_block "$command_text" "$output")"
  payload="$(printf '```terminal\n%s\n```\n' "$payload")"
  terminalcopy__sanitize "$payload"
}

ai() {
  local command_text="${*:-}"
  local output
  local payload
  if [[ -z "$command_text" ]]; then
    payload="$(terminalcopy__capture_command 1)"
  else
    output="$(terminalcopy__capture_command_output "$command_text")"
    payload="$(terminalcopy__format_command_and_output "$command_text" "$output")"
  fi
  terminalcopy__print_and_copy "$payload"
}

a() {
  ai "$@"
}

af() {
  ai "$@"
}

as() {
  local payload
  payload="$(terminalcopy__history_clean "$(terminalcopy__capture_command 3)")"
  terminalcopy__print_and_copy "$payload"
}

as4() { terminalcopy__print_and_copy "$(terminalcopy__history_clean "$(terminalcopy__capture_command 4)")"; }
as5() { terminalcopy__print_and_copy "$(terminalcopy__history_clean "$(terminalcopy__capture_command 5)")"; }
as6() { terminalcopy__print_and_copy "$(terminalcopy__history_clean "$(terminalcopy__capture_command 6)")"; }
as7() { terminalcopy__print_and_copy "$(terminalcopy__history_clean "$(terminalcopy__capture_command 7)")"; }
as8() { terminalcopy__print_and_copy "$(terminalcopy__history_clean "$(terminalcopy__capture_command 8)")"; }
as9() { terminalcopy__print_and_copy "$(terminalcopy__history_clean "$(terminalcopy__capture_command 9)")"; }

ash() {
  local payload
  payload="$(terminalcopy__history_clean "$(terminalcopy__capture_full_history)")"
  terminalcopy__print_and_copy "$payload"
}
