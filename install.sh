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
  echo 'export PATH="/opt/homebrew/bin:$PATH"' >> ~/.bash_profile
else
  echo "arm64 以外です。"
fi

########################################
# Homebrew でパッケージ一覧からパッケージをまとめてインストール
########################################
brew bundle --file="$DOTFILES/Brewfile" --global

########################################
# SSH鍵がなければ作成
########################################
# 新環境で git clone するなら
# 1. SSH 鍵の作成
# 2. 公開鍵をGithubに登録
# 3. known_hosts に fingerprint を登録(流れで登録される)

if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
  echo "SSH鍵を作成します..."
  ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519" -N ""
fi

# エージェントにこの鍵がまだ追加されていないなら追加
if ! ssh-add -L 2>/dev/null | grep -q "$(cat "$HOME/.ssh/id_ed25519.pub")"; then
  echo "SSHエージェントを起動し、鍵を追加します..."
  eval "$(ssh-agent -s)"
  ssh-add "$HOME/.ssh/id_ed25519"
else
  echo "SSH鍵はすでにエージェントに追加されています。"
fi

# 公開鍵案内を一度だけ表示（フラグファイルで制御）
SSH_KEY_INFO_FLAG="$HOME/.ssh/.github_key_info_shown"

if [ ! -f "$SSH_KEY_INFO_FLAG" ]; then
  echo "以下の公開鍵を GitHub に登録してください:"
  echo "----------------------------------------------"
  cat "$HOME/.ssh/id_ed25519.pub"
  echo "----------------------------------------------"
  echo "https://github.com/settings/keys を開いて、上記の鍵を貼り付けてください。"
  read -p "登録後に Enter を押してください..."

  touch "$SSH_KEY_INFO_FLAG"
else
  echo "公開鍵の案内はスキップされました（前回表示済み）。"
fi

########################################
# dotfiles リポジトリをクローン
########################################
if [ ! -d "$DOTFILES" ]; then
  echo "dotfiles リポジトリをHTTPSでクローンします....."
  git clone https://github.com/a-ide/dotfiles.git "$DOTFILES"

  echo "SSH接続に切り替えます....."
  git -C "$DOTFILES" remote set-url origin git@github.com:a-ide/dotfiles.git
else
  echo "dotfilesはすでに存在します。"
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
