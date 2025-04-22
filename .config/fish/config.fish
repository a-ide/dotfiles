if status is-interactive
  # Commands to run in interactive sessions can go here

  # Homebrew 
  fish_add_path /opt/homebrew/bin
end

# === XDG Base Directory settings ===
set -x XDG_DATA_HOME "$HOME/.local/share"
set -x XDG_CONFIG_HOME "$HOME/.config"
set -x XDG_STATE_HOME "$HOME/.local/state"
set -x XDG_CACHE_HOME "$HOME/.cache"
set -x XDG_RUNTIME_DIR "/run/user/(id -u)"

# === AWS CLI ===
set -x AWS_SHARED_CREDENTIALS_FILE "$XDG_CONFIG_HOME/aws/credentials"
set -x AWS_CONFIG_FILE "$XDG_CONFIG_HOME/aws/config"

# === Docker ===
set -x DOCKER_CONFIG "$XDG_CONFIG_HOME"/docker 

# === MySQL ===
set -x MYSQL_HISTFILE "$XDG_DATA_HOME"/mysql_history

# === Node REPL History ===
set -x NODE_REPL_HISTORY "$XDG_STATE_HOME"/node_repl_history

# npm XDG configuration
set -x NPM_CONFIG_INIT_MODULE "$XDG_CONFIG_HOME/npm/config/npm-init.js"
set -x NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
set -x NPM_CONFIG_TMP "$XDG_RUNTIME_DIR/npm"

# === PostgreSQL ===
set -x PSQL_HISTORY "$XDG_STATE_HOME/psql_history"

# === Redis ===
set -x REDISCLI_HISTFILE "$XDG_STATE_HOME/redis/rediscli_history"

# bundler XDG configuration
# set -x BUNDLE_USER_CONFIG "$XDG_CONFIG_HOME/bundle"
# set -x BUNDLE_USER_CACHE "$XDG_CACHE_HOME/bundle"
# set -x BUNDLE_USER_PLUGIN "$XDG_DATA_HOME/bundle"


# TODO: 後で alias 設定をする
# alias wget="wget --hsts-file=\${XDG_DATA_HOME:-\$HOME/.local/share}/wget-hsts"

# === Zsh ===
set -x ZDOTDIR "$XDG_CONFIG_HOME"/zsh
