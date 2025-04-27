readonly DOTFILES="$HOME/repositories/dotfiles"

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
ln -sf "$DOTFILES/.config/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json" || echo "⚠️ VSCode のシンボリックリンク作成に失敗しました。"

mkdir -p "$HOME/.config/fish"
find "$DOTFILES/.config/fish" -type f ! -name '.DS_Store' -print0 | while IFS= read -r -d '' file; do
  rel_path="${file#$DOTFILES/.config/fish/}"
  target="$HOME/.config/fish/$rel_path"
  mkdir -p "$(dirname "$target")"
  ln -sf "$file" "$target" || echo "⚠️ fish のシンボリックリンク作成に失敗しました。"
done
