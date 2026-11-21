source ~/.bash/environment
source ~/.bash/aliases
source ~/.bash/prompt
source ~/.bash/git_autocomplete
source ~/.bash/rex
# Machine-specific aliases and settings, not tracked
[ -f ~/.bash/local ] && source ~/.bash/local
[ -f ~/.bashrc ] && source ~/.bashrc

# History: big, timestamped, shared across tabs and panes instead of the last
# shell to exit overwriting the others.
HISTSIZE=100000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT="%F %T "
shopt -s histappend cmdhist
PROMPT_COMMAND="${PROMPT_COMMAND%;}"
[[ "$PROMPT_COMMAND" != *"history -a"* ]] && PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND;}history -a"

# Google Cloud SDK (Homebrew)
GCLOUD_SDK=/opt/homebrew/share/google-cloud-sdk
[ -f "$GCLOUD_SDK/path.bash.inc" ] && . "$GCLOUD_SDK/path.bash.inc"
[ -f "$GCLOUD_SDK/completion.bash.inc" ] && . "$GCLOUD_SDK/completion.bash.inc"
unset GCLOUD_SDK

# Usage add_alias [name] [command]
# Example: add_alias today date +%Y-%m-%d
# creates the alias today, which executes "date +%Y-%m-%d"
function add_alias ()
{
   local cmd=$1;
   shift;
   local rest="$@";
   echo "alias $cmd=\"$rest\"" >> ~/.bash/aliases;
   source ~/.bash/aliases
}
