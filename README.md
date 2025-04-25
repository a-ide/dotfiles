## 🚀 セットアップ手順

### 1. 最初のセットアップ（SSH 鍵未登録でもOK）

以下のコマンドをコピー＆ペーストして実行してください：

```bash
curl -sL https://raw.githubusercontent.com/a-ide/dotfiles/master/bootstrap.sh | bash
```

このスクリプトは以下を行います：

- SSH 鍵の作成（未作成の場合）
- GitHub への公開鍵登録を案内
- `dotfiles` を clone（HTTPS → SSH に切り替え）
- 本体の `install.sh` を実行

> 💡 `bootstrap.sh` は SSH 鍵の登録と dotfiles セットアップを一括で行う簡易スクリプトです。
> GitHub への鍵登録が済んでいれば、直接 `setup.sh` を使ってもOKです。