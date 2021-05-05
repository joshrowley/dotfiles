source ~/.bash/environment
source ~/.bash/aliases
source ~/.bash/prompt
source ~/.bash/git_autocomplete
source ~/.bashrc

# added by Anaconda3 5.1.0 installer
export PATH="/anaconda3/bin:$PATH"
export GPG_TTY=$(tty)
export GPG_TTY=$(tty)
export GPG_TTY=$(tty)

[ -f ~/.bashrc ] && source ~/.bashrc

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/joshrowley/google-cloud-sdk/path.bash.inc' ]; then . '/Users/joshrowley/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/joshrowley/google-cloud-sdk/completion.bash.inc' ]; then . '/Users/joshrowley/google-cloud-sdk/completion.bash.inc'; fi
