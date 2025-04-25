#!/bin/bash -eu

readonly ARCH_TYPE="$(arch)"
readonly DOTFILES="$HOME/repositories/dotfiles"
readonly LOG_FILE="$HOME/setup.log"
INSTALL_SUCCESS=true

# 標準出力とエラーをログに出力
exec > >(tee -a "$LOG_FILE") 2>&1

echo "🔧 セットアップを開始します....."

run() {
  echo "▶️ $1"
  if ! eval "$1"; then
    echo "❌ エラーが発生しました: $1"
    INSTALL_SUCCESS=false
    exit 1
  fi
}

########################################
# Xcode Command Line Tools をインストール
########################################
if ! xcode-select -p >/dev/null 2>&1; then
  echo "� Xcode Command Line Tools をインストールします..."
  xcode-select --install
  echo "⚠️ インストール完了後に再度スクリプトを実行してください。"
  exit 1
fi

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
  if ! grep -q '/opt/homebrew/bin' "$HOME/.zprofile" 2>/dev/null; then
    echo 'export PATH="/opt/homebrew/bin:$PATH"' >> "$HOME/.zprofile"
  fi
  export PATH="/opt/homebrew/bin:$PATH"
else
  echo "💻 arm64 以外です。"
fi

########################################
# Homebrew パッケージをインストール
########################################
echo "📦 Brewfile からパッケージをインストールします..."
run "brew bundle --file=\"$DOTFILES/Brewfile\""

########################################
# .config ディレクトリの準備
########################################
echo "📁 .config ディレクトリを作成します..."
mkdir -p "$HOME/.config"

########################################
# シンボリックリンクを作成
########################################
echo "🔗 シンボリックリンクを作成します..."
mkdir -p "$HOME/.config/git"
ln -sf "$DOTFILES/.config/git" "$HOME/.config/git" || echo "⚠️ Git のシンボリックリンク作成に失敗しました。"

mkdir -p "$HOME/Library/Application Support/Code/User"
ln -sf "$DOTFILES/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json" || echo "⚠️ VSCode のシンボリックリンク作成に失敗しました。"

mkdir -p "$HOME/.config/fish"
ln -sf "$DOTFILES/.config/fish" "$HOME/.config/fish" || echo "⚠️ fish のシンボリックリンク作成に失敗しました。"

########################################
# fisher をインストール
########################################
if ! command -v fisher >/dev/null 2>&1; then
  echo "🐟 fisher をインストールしています....."
  curl -sL https://git.io/fisher | fish || echo "⚠️ fisher インストールに失敗しました。"
  fish -c "fisher install jorgebucaran/fisher" || echo "⚠️ fisher プラグインインストールに失敗しました。"
fi

########################################
# fisher プラグインを更新
########################################
echo "♻️ fisher をアップデートします....."
fish -c "fisher update" || echo "⚠️ fisher アップデートに失敗しました。"

########################################
# 結果の表示
########################################
if [ "$INSTALL_SUCCESS" = true ]; then
  echo "✅ セットアップ完了！"
  echo "🎉 開発環境の準備が完了しました！"
else
  echo "⚠️ セットアップ中にエラーが発生しました。"
  echo "📄 ログファイル: $LOG_FILE を確認してください。"
  exit 1
fi
