#!/bin/bash -eu

readonly ARCH_TYPE="$(arch)"
readonly DOTFILES="$HOME/repositories/dotfiles"
INSTALL_SUCCESS=true

########################################
# Homebrew をインストール
########################################
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Homebrew をインストールします....."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
    echo "❌ Homebrew のインストールに失敗しました。"
    INSTALL_SUCCESS=false
    exit 1
  }
fi

# Homebrew (arm64) のパスを zsh に反映させる
if [ "$ARCH_TYPE" = "arm64" ]; then
  echo "🛤️ zsh に Homebrew のパスを追加します..."

  if ! grep -q 'eval "\$\(\/opt\/homebrew\/bin\/brew shellenv\)"' "$HOME/.zprofile" 2>/dev/null; then
    echo >> "$HOME/.zprofile"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
  fi

  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "💻 arm64 以外です。"
fi

########################################
# Homebrew パッケージをインストール
########################################
echo "📦 Brewfile からパッケージをインストールします..."
run "brew bundle --file=\"$DOTFILES/Brewfile\""
