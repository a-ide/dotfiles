# Git push with upstream
function gpsu
  # 現在のブランチ名を取得
  set branch_name (git branch --show-current)

  if test -z "$branch_name"
    echo "❌ Error: Not on a branch (detached HEAD?)"
    return 1
  end

  # 'origin' リモートが存在するかチェック
  if not git remote get-url origin ^/dev/null
    echo "❌ Error: No remote named 'origin' found."
    return 1
  end

  # 実行内容の通知
  echo "🚀 Pushing branch '$branch_name' to 'origin' with --set-upstream..."

  # push 実行＋結果表示
  if git push -u origin $branch_name
    echo "✅ Push succeeded!"
  else
    echo "❌ Push failed."
    return 1
  end
end
