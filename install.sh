#!/bin/bash -eu

readonly ARCH_TYPE="$(arch)"
readonly DOTFILES="$HOME/repositories/dotfiles"

echo "🔧 セットアップを開始します....."

########################################
# Xcode Command Line Tools をインストール
########################################
if ! xcode-select -p >/dev/null 2>&1; then
  echo "📦 Xcode Command Line Tools をインストールします..."
  xcode-select --install
  echo "⚠️ インストール完了後に再度スクリプトを実行してください。"
  exit 1
fi


########################################
# Homebrew をインストール
########################################
# # TODO: xcode-toolsのインストール有無をチェックするか後で調べる
if ! command -v brew >/dev/null 2>&1; then
  echo "🍺 Homebrew をインストールします....."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Homebrew (arm64) のパスを zsh に反映させる
if [ "$ARCH_TYPE" = "arm64" ]; then
  echo "🛤️ zsh に Homebrew のパスを追加します..."
  if ! grep -q '/opt/homebrew/bin' "$HOME/.zprofile" 2>/dev/null; then
    echo 'export PATH="/opt/homebrew/bin:$PATH"' >> "$HOME/.zprofile"
  fi
  # スクリプト中で即使えるように一時的にも追加
  export PATH="/opt/homebrew/bin:$PATH"
else
  echo "💻 arm64 以外です。"
fi

########################################
# Homebrew でパッケージ一覧からパッケージをまとめてインストール
########################################
echo "📦 Brewfile からパッケージをインストールします..."
brew bundle --file="$DOTFILES/Brewfile"

########################################
# .config ディレクトリの準備
########################################
echo "📁 .config ディレクトリを作成します..."
mkdir -p "$HOME/.config"

########################################
# シンボリックリンクを作成
########################################
echo "🔗 シンボリックリンクを作成します..."

# git settings
mkdir -p "$HOME"/.config/git
ln -sf "$DOTFILES"/.config/git "$HOME"/.config/git

# VSCode settings
mkdir -p "$HOME/Library/Application Support/Code/User"
ln -sf "$DOTFILES"/vscode/settings.json "$HOME"/Library/Application Support/Code/User/settings.json

# fish settings
mkdir -p "$HOME/.config/fish"
ln -sf "$DOTFILES"/.config/fish "$HOME"/.config/fish

########################################
# fisher をインストール（まだなら）
########################################
if ! command -v fisher >/dev/null 2>&1; then
  echo "🐟 fisher をインストールしています....."
  curl -sL https://git.io/fisher | fish
  fish -c "fisher install jorgebucaran/fisher"
fi

########################################
# fisher プラグインを更新
########################################
echo "♻️ fisher をアップデートします....."
fish -c "fisher update"

echo "✅ セットアップ完了！"
