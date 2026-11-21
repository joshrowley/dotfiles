# Dotfiles

My dotfiles for configuring a system the way I like it.

## Prerequisites

- `ruby` installed with `rake`

## Installation

1. `git clone <this repo>`
2. `cd dotfiles`
3. `rake`

## Installing VIM

1. `brew install vim`
1. `git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
1. `vim .`
1. `:PluginInstall`
## Claude Code

`claude/` holds Claude Code's user settings and hook scripts. `rake` links each
file into `~/.claude/` individually, because Claude Code keeps its own runtime
files in that folder.

## Local, untracked files

Personal and machine-specific settings stay out of this repo:

- `~/.gitconfig.local`: your `[user]` name, email and signing key. `gitconfig` includes it.
- `~/.bash/local` (`bash/local`, gitignored): work or project aliases and env vars. `bash_profile` sources it if present.

## Rex

`config/rex/init.lua` links to `~/.config/rex/init.lua`. After editing it, run
`rex config check`, then `rex config reload`.

| Key | Does |
| --- | --- |
| `cmd+d` / `shift+cmd+d` | Split right / down |
| `alt+cmd+arrow` | Focus the pane in that direction (add `shift` to move the pane) |
| `shift+cmd+enter` | Zoom the pane |
| `ctrl+cmd+=` | Even out pane sizes |
| `ctrl+cmd+r` | Resize mode: arrows (`shift` for big steps), `enter` or `escape` to leave |
| `shift+cmd+n` | **Dev Layout Here**: new tab in this pane's folder with a main shell, `bin/dev` (if the project has one) and a spare shell |
| `cmd+p` | **Open Project…**: pick a git repo under `~/code` and open it in the dev layout |
| `shift+cmd+c` | **Claude Code Beside Me**: split right and start `claude` in this folder |

`bash/rex` is the shell side. It puts the `rex` CLI on `PATH` in every
terminal, loads its completion, reports the working directory (OSC 7) and
prompt marks (OSC 133), and adds `rex_status STATE MSG` and `rexdone`
(`bin/ci; rexdone`) for marking a pane done or failed in Rex's sidebar.

On a new Mac, after `rake`, run once:

```sh
rex skill setup     # Rex skill + session hook for Claude Code and Codex
rex terminfo setup  # xterm-rex terminfo, and an ssh guard for hosts without it
```
