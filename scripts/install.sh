#!/bin/bash -eu

readonly ARCH_TYPE="$(arch)"
readonly DOTFILES="$HOME/repositories/dotfiles"
readonly LOG_FILE="$HOME/setup.log"
INSTALL_SUCCESS=true

# 標準出力とエラーをログに出力
exec > >(tee -a "$LOG_FILE") 2>&1

echo "🔧 セットアップを開始します....."

bash "$DOTFILES/scripts/install_brew.sh"
bash "$DOTFILES/scripts/symlink.sh"
bash "$DOTFILES/scripts/setup_fish.sh"

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
