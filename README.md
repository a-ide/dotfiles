## 🚀 セットアップ手順

以下のコマンドをコピー＆ペーストして実行してください：

```bash
curl -sL https://raw.githubusercontent.com/a-ide/dotfiles/main/bootstrap.sh | bash
```

このスクリプトは以下を行います：

- SSH 鍵の作成（未作成の場合）
- GitHub への公開鍵登録を案内
- `Xcode Command Line Tools` のインストール
- `dotfiles` を `clone`
- 本体の `setup.sh` を実行
