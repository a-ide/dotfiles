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