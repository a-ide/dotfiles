#!/bin/bash
readonly ARCH_TYPE="$(arch)"
readonly DOTFILES="$HOME/repositories/dotfiles"
readonly SSH_KEY="$HOME/.ssh/id_ed25519"
readonly SSH_KEY_PUB="$SSH_KEY.pub"
readonly SSH_KEY_INFO_FLAG="$HOME/.ssh/.github_key_info_shown"
readonly LOG_FILE="$HOME/setup.log"
