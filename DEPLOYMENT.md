# 🚀 Renderデプロイメント手順

## 前提条件
- GitHubアカウント
- Renderアカウント（無料プランでOK）

## 手順

### 1. GitHubへのプッシュ

```bash
git add .
git commit -m "Add PostgreSQL support for Render deployment"
git push origin main
```

### 2. render.yamlの更新

`render.yaml`ファイルの以下の部分を更新してください：

```yaml
repo: https://github.com/YOUR_USERNAME/YOUR_REPO_NAME
```

を実際のGitHubリポジトリURLに変更：

```yaml
repo: https://github.com/あなたのユーザー名/あなたのリポジトリ名
```

### 3. Renderでのデプロイ

1. [Render Dashboard](https://dashboard.render.com)にログイン
2. 「New +」ボタンをクリック
3. 「Blueprint」を選択
4. GitHubリポジトリを接続
5. リポジトリを選択して「Connect」

### 4. 環境変数の確認

Renderは自動的に以下を設定します：
- `DATABASE_URL`: PostgreSQLの接続文字列（自動設定）
- `JWT_SECRET`: 認証用の秘密鍵（自動生成）
- `NODE_ENV`: production
- `VITE_API_URL`: https://sales-kpi-backend.onrender.com

### 5. デプロイ完了後

#### URLの確認
- バックエンド: `https://sales-kpi-backend.onrender.com`
- フロントエンド: `https://sales-kpi-frontend.onrender.com`

#### 実際のサービス名に合わせて更新

もしRenderが異なるURLを生成した場合：

1. フロントエンドの環境変数を更新
   - Renderダッシュボード → Frontend service → Environment
   - `VITE_API_URL`を実際のバックエンドURLに更新

2. バックエンドのCORS設定を更新（必要な場合）
   - Renderダッシュボード → Backend service → Environment
   - `FRONTEND_URL`を実際のフロントエンドURLに追加

## ローカル開発環境

### SQLiteでの開発（デフォルト）

```bash
# バックエンド起動
cd backend
npm install
npm start

# フロントエンド起動（別ターミナル）
cd frontend
npm install
npm run dev
```

### PostgreSQLでの開発（オプション）

1. PostgreSQLをローカルにインストール
2. `.env`ファイルを作成：

```env
DATABASE_URL=postgresql://user:password@localhost:5432/sales_kpi_dev
JWT_SECRET=your-development-secret-key
```

3. 通常通り起動

## トラブルシューティング

### 新規登録でエラーが出る場合

1. Renderダッシュボードで「Logs」を確認
2. PostgreSQLが正しく接続されているか確認
3. 環境変数が正しく設定されているか確認

### CORSエラーが出る場合

バックエンドの環境変数に`FRONTEND_URL`を追加：
```
FRONTEND_URL=https://your-actual-frontend.onrender.com
```

## データの移行

既存のSQLiteデータをPostgreSQLに移行する必要がある場合は、別途移行スクリプトが必要です。

## セキュリティ注意事項

- `JWT_SECRET`は必ず強力なものを使用
- 本番環境では`.env`ファイルをGitHubにプッシュしない
- PostgreSQLの接続はSSLを使用（Renderは自動設定）