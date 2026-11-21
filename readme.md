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
