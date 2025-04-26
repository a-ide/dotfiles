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
ln -sf "$DOTFILES/.config/git/config" "$HOME/.config/git/config" || echo "⚠️ git/config のシンボリックリンク作成に失敗しました。"
ln -sf "$DOTFILES/.config/git/gitignore" "$HOME/.config/git/gitignore" || echo "⚠️ git/gitignore のシンボリックリンク作成に失敗しました。"

mkdir -p "$HOME/Library/Application Support/Code/User"
ln -sf "$DOTFILES/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json" || echo "⚠️ VSCode のシンボリックリンク作成に失敗しました。"

mkdir -p "$HOME/.config/fish"
find "$DOTFILES/.config/fish" -type f ! -name '.DS_Store' -print0 | while IFS= read -r -d '' file; do
  rel_path="${file#$DOTFILES/.config/fish/}"
  target="$HOME/.config/fish/$rel_path"
  mkdir -p "$(dirname "$target")"
  ln -sf "$file" "$target" || echo "⚠️ fish のシンボリックリンク作成に失敗しました。"
done


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
