#!/bin/bash -eu

readonly DOTFILES="$HOME/repositories/dotfiles"
readonly SSH_KEY="$HOME/.ssh/id_ed25519"
readonly SSH_KEY_PUB="$SSH_KEY.pub"
readonly SSH_KEY_INFO_FLAG="$HOME/.ssh/.github_key_info_shown"

echo "🚀 開発環境の準備を始めます..."

########################################
# SSH 鍵の作成
########################################
if [ ! -f "$SSH_KEY" ]; then
  echo "🔑 SSH 鍵が見つかりません。新しく作成します..."
  ssh-keygen -t ed25519 -f "$SSH_KEY" -N ""
else
  echo "🔑 SSH 鍵は既に存在します。"
fi

########################################
# GitHub に公開鍵を登録するよう案内
########################################
if [ ! -f "$SSH_KEY_INFO_FLAG" ]; then
  echo "📎 以下の公開鍵を GitHub に登録してください:"
  echo "----------------------------------------------"
  cat "$SSH_KEY_PUB"
  echo "----------------------------------------------"
  echo "👉 https://github.com/settings/keys を開いて、上記の鍵を貼り付けてください。"
  read -p "🔁 登録後に Enter を押してください..."

  touch "$SSH_KEY_INFO_FLAG"
else
  echo "ℹ️ 公開鍵の案内はスキップされました（前回表示済み）。"
fi

########################################
# SSHエージェントに鍵を追加
########################################
if ! ls -al ~/.ssh; then
  echo "🧠 SSHエージェントを起動し、鍵を追加します..."
  eval "$(ssh-agent -s)"
  ssh-add "$SSH_KEY"
else
  echo "✅ SSH鍵はすでにエージェントに追加されています。"
fi

########################################
# Xcode Command Line Tools をインストール
########################################
if ! xcode-select -p >/dev/null 2>&1; then
  echo "🛠️ Xcode Command Line Tools をインストールします..."
  xcode-select --install

  echo "⚠️ インストールが完了したら、Enter を押してください。"
  read

  # 再チェック
  if ! xcode-select -p >/dev/null 2>&1; then
    echo "🛠️ Xcodeのアクティブなパスが設定されていないようです。設定を試みます..."
    sudo xcode-select --switch /Library/Developer/CommandLineTools

    # さらに再チェック
    if ! xcode-select -p >/dev/null 2>&1; then
      echo "❌ Xcode Command Line Tools のセットアップに失敗しました。手動で確認してください。"
      exit 1
    fi
  fi
fi

########################################
# dotfiles リポジトリのクローン
########################################
if [ ! -d "$DOTFILES" ]; then
  echo "📥 dotfiles リポジトリをクローンします..."
  git clone git@github.com:a-ide/dotfiles.git "$DOTFILES"
else
  echo "📁 dotfiles はすでに存在します。"
fi

########################################
# インストールスクリプトを実行
########################################
echo "📦 セットアップスクリプトを実行します..."
bash "$DOTFILES/install.sh"