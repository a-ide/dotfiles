#!/bin/bash -eu

readonly ARCH_TYPE="$(arch)"
readonly DOTFILES="$HOME/repositories/dotfiles"

# echo "セットアップを開始します....."

########################################
# Homebrew をインストール
########################################
# # TODO: xcode-toolsのインストール有無をチェックするか後で調べる
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew をインストールします....."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# # Homebrewでアプリインストール前に、fish でパスを設定しないとと思ったけど（dotfiles のインストール）、
# # bash でやってるので bash のやり方でパスを通せば良さそう。

if [ "$ARCH_TYPE" = "arm64" ]; then
  export PATH="/opt/homebrew/bin:$PATH"
else
  echo "arm64 以外です。"
fi

########################################
# Homebrew でパッケージ一覧からパッケージをまとめてインストール
########################################
brew bundle --file="$DOTFILES/Brewfile" --global

########################################
# dotfiles リポジトリをクローン
########################################
if [ ! -d "$DOTFILES" ]; then
  echo "dotfiles リポジトリをインストールします....."
  git clone https://github.com/a-ide/dotfiles.git
else
  echo "dotfilesは存在します。"
fi


mkdir -p "$HOME/.config"

########################################
# シンボリックリンクを作成
########################################
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
  echo "fisher をインストールしています....."
  curl -sL https://git.io/fisher | fish
  fish -c "fisher install jorgebucaran/fisher"
fi

# プラグインとテーマを fish_plugins に基づいてインストール
echo "fisher をアップデートします....."
fish -c "fisher update"
