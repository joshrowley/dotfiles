# Create a unique session log file
ZSH_SESSION_LOG=~/.zsh_sessions/session_$(date +%Y-%m-%d_%H-%M-%S)_$$.log

# Log all input and output
exec > >(tee -a "$ZSH_SESSION_LOG") 2>&1

# Set history file and size
HISTFILE=~/.zsh_history
HISTSIZE=100000               # Number of commands in memory
SAVEHIST=100000               # Number of commands saved to file

# History options
setopt APPEND_HISTORY         # Append to history file instead of overwriting
setopt INC_APPEND_HISTORY     # Add commands to history immediately
setopt SHARE_HISTORY          # Share history across all sessions
setopt HIST_IGNORE_ALL_DUPS   # Ignore duplicated commands
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks
setopt HIST_VERIFY            # Edit command before executing from history

# Enable timestamps
export HISTTIMEFORMAT="%F %T "

eval "$(rbenv init - zsh)"

# Add PostgreSQL to PATH
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# Set PostgreSQL environment variables
export PGDATA="/opt/homebrew/var/postgresql@17"

# Add go-installed binaries to your PATH
export PATH=$PATH:$(go env GOPATH)/bin
# Configures NodeJS to trust your local CA, enabling HTTPS requests to the local API servers.
# For more details, visit https://github.com/FiloSottile/mkcert#using-the-root-with-nodejs
export NODE_EXTRA_CA_CERTS="$(mkcert -CAROOT)/rootCA.pem"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# place this after nvm initialization!
autoload -U add-zsh-hook

load-nvmrc() {
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$(nvm version)" ]; then
      nvm use
    fi
  elif [ -n "$(PWD=$OLDPWD nvm_find_nvmrc)" ] && [ "$(nvm version)" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}

add-zsh-hook chpwd load-nvmrc
load-nvmrc

# pnpm
export PNPM_HOME="/Users/joshrowley/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
