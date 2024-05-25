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

# Usage add_alias [name] [command]
# Example: add_alias today date +%Y-%m-%d
# creates the alias today, which executes "date +%Y-%m-%d"
# make sure to add a line "source ~/.bash_aliases" to your config
function add_alias ()
{
   local cmd=$1;
   shift;
   local rest="$@";
   echo "alias $cmd=\"$rest\"" >> ~/.bash/aliases;
   source ~/.bash/aliases
}

eval "$(/opt/homebrew/bin/brew shellenv)"
