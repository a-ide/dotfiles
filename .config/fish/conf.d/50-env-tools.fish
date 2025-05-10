# AWS
set -x AWS_SHARED_CREDENTIALS_FILE "$XDG_CONFIG_HOME/aws/credentials"
set -x AWS_CONFIG_FILE "$XDG_CONFIG_HOME/aws/config"

# Docker
set -x DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"

# MySQL
set -x MYSQL_HISTFILE "$XDG_DATA_HOME/mysql_history"

# Node.js / npm
set -x NODE_REPL_HISTORY "$XDG_STATE_HOME/node_repl_history"
set -x NPM_CONFIG_INIT_MODULE "$XDG_CONFIG_HOME/npm/config/npm-init.js"
set -x NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
set -x NPM_CONFIG_TMP "$XDG_RUNTIME_DIR/npm"

# PostgreSQL
set -x PSQL_HISTORY "$XDG_STATE_HOME/psql_history"

# Redis
set -x REDISCLI_HISTFILE "$XDG_STATE_HOME/redis/rediscli_history"

# Zsh
set -x ZDOTDIR "$XDG_CONFIG_HOME/zsh"
