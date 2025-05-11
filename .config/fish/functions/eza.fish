function eza
  if contains -- "--help" $argv
    echo "▶ カスタム eza 関数の使い方"
    echo ""
    echo "  --perm       パーミッション情報を表示（--no-permissions を無効化）"
    echo "  --no-ignore  .gitignore の内容を無視してすべてのファイルを表示"
    echo "  --help       この使い方メッセージを表示"
    echo ""
    echo "🔸 例:"
    echo "  eza -lah                     # デフォルト（パーミッション非表示・gitignore 適用）"
    echo "  eza -lah --perm              # パーミッションを表示"
    echo "  eza -lah --no-ignore         # .gitignore に無視されたファイルも表示"
    echo "  eza -lah --perm --no-ignore  # すべて表示 + パーミッション付き"
    return 0
  end

  set show_perms 0
  set use_gitignore 1
  set args

  for arg in $argv
    switch $arg
      case "--perm"
        set show_perms 1
      case "--no-ignore"
        set use_gitignore 0
      case "*"
        set args $args $arg
    end
  end

  set cmd eza

  if test $show_perms -eq 0
    set args --no-permissions $args
  end

  if test $use_gitignore -eq 1
    set args --git-ignore $args
  end

  command $cmd $args
end
