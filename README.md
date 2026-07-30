# TerminalCopy

[Japanese](#japanese)

TerminalCopy is a macOS/zsh helper that turns terminal output into AI-friendly Markdown.

It is designed for people who want to paste terminal output into ChatGPT, Claude, or a bug report without leaking private paths or secrets.

## What It Does

- Copies terminal output in a cleaned-up form
- Replaces your home directory path with `~`
- Redacts likely secrets such as `API_KEY`, `PASSWORD`, `SECRET`, and `TOKEN`
- Adds simple commands you can type in zsh

## Quick Start

The fastest way to try it is to type this one line into your terminal:

```zsh
curl -fsSL https://raw.githubusercontent.com/knnkanda/terminalcopy/main/install.sh | zsh
```

That will:

- back up your current `~/.zshrc`
- add TerminalCopy with clear start/end markers
- avoid duplicate installs if you run it again
- install the actual source at `~/.terminalcopy/terminalcopy.zsh`

The exact line added to `~/.zshrc` is:

```zsh
source "$HOME/.terminalcopy/terminalcopy.zsh"
```

If you prefer, you can also install from a clone:

```zsh
git clone https://github.com/knnkanda/terminalcopy.git
cd terminalcopy
./install.sh
```

## How To Use

After installation, open a new terminal or reload your shell:

```zsh
source ~/.zshrc
```

Then try:

```zsh
ai pwd
a git status
af ls -la
as
as4
as9
ash
```

## Command Guide

- `ai`: copy the most recent command output
- `a`: short alias for `ai`
- `af`: copy the most recent command output in a fuller form
- `as`: copy the last 3 history entries
- `as4` to `as9`: copy the last 4 to 9 history entries
- `ash`: copy your full shell history

Examples:

```terminal
Machine : pk_mini
Folder  : ~/dev/AI_corp/knn-funda

History (cleaned)

pwd
ls
git status
```

## Safety

TerminalCopy tries to keep your output safe to share.

- Your home directory path is shown as `~`
- Common secret-looking values are redacted
- Your existing `~/.zshrc` is backed up before changes are made
- The backup is saved next to it as `~/.zshrc.terminalcopy.backup.YYYYMMDDHHMMSS`
- For example: `~/.zshrc.terminalcopy.backup.20260730140509`
- The TerminalCopy section in `~/.zshrc` has clear markers for safe removal later
- The loaded source file lives at `~/.terminalcopy/terminalcopy.zsh`, so it is easy to inspect

Important: always review the copied text before sharing it.

## Uninstall

```zsh
curl -fsSL https://raw.githubusercontent.com/knnkanda/terminalcopy/main/uninstall.sh | zsh
```

Or, from a local clone:

```zsh
./uninstall.sh
```

## More Details

https://qiita.com/knnkanda/items/22db36175cdbce44d1ab

## Homebrew

Homebrew support is being prepared. The current plan is to ship TerminalCopy as a tap-based formula so you can install it with Homebrew and then load the shell integration from your `.zshrc`.

## Author

Paul Kanda / KandaNewsNetwork, Inc.

## Japanese

TerminalCopy は、macOS の zsh で使うための補助ツールです。

ターミナルの出力を AI に貼りやすい形に整えながら、`~` への置き換えや秘密情報の伏字化も行います。

### 何ができるか

- 出力を見やすい形に整える
- ホームディレクトリのパスを `~` に置き換える
- `API_KEY`、`PASSWORD`、`SECRET`、`TOKEN` などを伏字にする
- `~/.zshrc` に安全に追加する

### クイックスタート

まずはこの1行を、ターミナルにそのまま打ち込んで試せます。

```zsh
curl -fsSL https://raw.githubusercontent.com/knnkanda/terminalcopy/main/install.sh | zsh
```

それで次のことが行われます。

- いまの `~/.zshrc` をバックアップする
- TerminalCopy の開始・終了マーカーを追加する
- もう一度実行しても重複しないようにする
- 実体のスクリプトを `~/.terminalcopy/terminalcopy.zsh` に置く

`.zshrc` に実際に追加される1行はこれです。

```zsh
source "$HOME/.terminalcopy/terminalcopy.zsh"
```

clone から入れることもできます。

```zsh
git clone https://github.com/knnkanda/terminalcopy.git
cd terminalcopy
./install.sh
```

### 使い方

インストール後に、新しいターミナルを開くか、次を実行します。

```zsh
source ~/.zshrc
```

それから、たとえば次のように使います。

```zsh
ai pwd
a git status
af ls -la
as
as4
as9
ash
```

### コマンドガイド

- `ai`: 直前のコマンドをコピーする
- `a`: `ai` の短い別名
- `af`: 直前のコマンドを少し詳しくコピーする
- `as`: 直近 3 件の履歴をコピーする
- `as4` から `as9`: 直近 4 件から 9 件の履歴をコピーする
- `ash`: シェル履歴全体をコピーする

例:

```terminal
Machine : pk_mini
Folder  : ~/dev/AI_corp/knn-funda

History (cleaned)

pwd
ls
git status
```

### 安全

TerminalCopy は、共有しやすい形に整えるための仕組みを入れています。

- ホームディレクトリのパスは `~` に変わります
- 秘密情報らしい値は伏字になります
- `~/.zshrc` は変更前にバックアップされます
- バックアップは同じ場所に `~/.zshrc.terminalcopy.backup.YYYYMMDDHHMMSS` という名前で保存されます
- たとえば `~/.zshrc.terminalcopy.backup.20260730140509` のようになります
- 追記部分には開始・終了マーカーが付くので、削除しやすいです
- 読み込まれる実体は `~/.terminalcopy/terminalcopy.zsh` に置かれるので確認しやすいです

共有前には、必ずコピーされた内容を見直してください。

### アンインストール

```zsh
curl -fsSL https://raw.githubusercontent.com/knnkanda/terminalcopy/main/uninstall.sh | zsh
```

ローカル clone から外す場合は次でも大丈夫です。

```zsh
./uninstall.sh
```

### 詳細記事

https://qiita.com/knnkanda/items/22db36175cdbce44d1ab
