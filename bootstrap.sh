#!/bin/bash -eu

source "$(dirname "$0")/scripts/config.sh"
echo "🚀 開発環境の準備を始めます..."

########################################
# 関数定義
########################################
function error_exit {
  echo "❌ $1"
  exit 1
}

function wait_for_user {
  read -t 30 -p "$1" || echo "⏳ タイムアウトしました。続行します..."
}

########################################
# SSH 鍵の作成
########################################
if [ ! -f "$SSH_KEY" ]; then
  echo "🔑 SSH 鍵が見つかりません。新しく作成します..."
  ssh-keygen -t ed25519 -f "$SSH_KEY" -N "" || error_exit "SSH 鍵の作成に失敗しました。"
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
  wait_for_user "🔁 登録後に Enter を押してください..."

  touch "$SSH_KEY_INFO_FLAG"
else
  echo "ℹ️ 公開鍵の案内はスキップされました（前回表示済み）。"
fi

########################################
# SSHエージェントに鍵を追加
########################################
if ! ssh-add -l >/dev/null 2>&1; then
  echo "🧠 SSHエージェントを起動し、鍵を追加します..."
  eval "$(ssh-agent -s)" || error_exit "SSHエージェントの起動に失敗しました。"
  ssh-add "$SSH_KEY" || error_exit "SSH鍵の追加に失敗しました。"
else
  echo "✅ SSH鍵はすでにエージェントに追加されています。"
fi

########################################
# Xcode Command Line Tools をインストール
########################################
if ! xcode-select -p >/dev/null 2>&1; then
  echo "🛠️ Xcode Command Line Tools をインストールします..."
  xcode-select --install || error_exit "Xcode Command Line Tools のインストールに失敗しました。"

  wait_for_user "⚠️ インストールが完了したら、Enter を押してください。"

  # 再チェック
  if ! xcode-select -p >/dev/null 2>&1; then
    echo "🛠️ Xcodeのアクティブなパスが設定されていないようです。設定を試みます..."
    sudo xcode-select --switch /Library/Developer/CommandLineTools || error_exit "Xcode Command Line Tools のパス設定に失敗しました。"

    # さらに再チェック
    if ! xcode-select -p >/dev/null 2>&1; then
      error_exit "Xcode Command Line Tools のセットアップに失敗しました。手動で確認してください。"
    fi
  fi
fi

########################################
# dotfiles リポジトリのクローン
########################################
if [ ! -d "$DOTFILES" ];then
  echo "📥 dotfiles リポジトリをクローンします..."
  git clone git@github.com:a-ide/dotfiles.git "$DOTFILES" || error_exit "dotfiles リポジトリのクローンに失敗しました。"
else
  echo "📁 dotfiles はすでに存在します。"
fi

########################################
# インストールスクリプトを実行
########################################
echo "📦 セットアップスクリプトを実行します..."
bash "$DOTFILES/scripts/setup.sh" || error_exit "セットアップスクリプトの実行に失敗しました。"
