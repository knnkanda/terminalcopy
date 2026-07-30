# TerminalCopy

TerminalCopy is a macOS/zsh helper for turning terminal output into AI-friendly Markdown.

It captures command output, masks the home directory as `~`, redacts likely secrets, and copies a cleaned version to the clipboard.

## Features

- `ai` for current command output
- `a` as a short alias for `ai`
- `af` for a fuller capture
- `as` for the last 3 history entries
- `as4` through `as9` for the last 4 to 9 history entries
- `ash` for full shell history
- Home directory masking
- Secret redaction for `API_KEY`, `PASSWORD`, `SECRET`, `TOKEN`, and related values
- Safe `.zshrc` installation with backup, start/end markers, and idempotent reinstall support

## Install

One-line install without Homebrew or npm:

```zsh
curl -fsSL https://raw.githubusercontent.com/knnkanda/terminalcopy/main/install.sh | zsh
```

You can also install manually from a clone:

```zsh
git clone https://github.com/knnkanda/terminalcopy.git
cd terminalcopy
./install.sh
```

## Usage

After installation, open a new terminal or source your shell config, then run:

```zsh
ai pwd
a git status
af ls -la
as
as4
as9
ash
```

## Uninstall

```zsh
curl -fsSL https://raw.githubusercontent.com/knnkanda/terminalcopy/main/uninstall.sh | zsh
```

Or, from a local clone:

```zsh
./uninstall.sh
```

## Safety Notes

- TerminalCopy backs up your existing `~/.zshrc` before making changes.
- The installed block is wrapped in clear start/end markers so it can be removed safely.
- Output is sanitized before copying:
  - `~` replaces your home directory path
  - secrets are masked when they look like API keys, passwords, secrets, or tokens
- Review the generated output before sharing it if you are working with sensitive data.

## Details

Detailed article:

https://qiita.com/knnkanda/items/22db36175cdbce44d1ab

## Author

Paul Kanda / KandaNewsNetwork, Inc.
