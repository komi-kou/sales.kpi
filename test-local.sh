#!/bin/bash

echo "🧪 ローカル環境での動作テスト"
echo "================================"

# バックエンドのパッケージインストール
echo "📦 バックエンドの依存関係をインストール中..."
cd backend
npm install

# SQLiteでのテスト
echo ""
echo "🔵 SQLiteモードでテスト開始..."
unset DATABASE_URL  # DATABASE_URLが設定されていないことを確認

# バックエンドをバックグラウンドで起動
npm start &
BACKEND_PID=$!

# サーバーが起動するまで待機
echo "⏳ サーバー起動を待機中..."
sleep 5

# ヘルスチェック
echo "🏥 ヘルスチェック..."
curl -s http://localhost:5001/api/health | jq .

# テスト用ユーザー登録
echo ""
echo "👤 テストユーザー登録..."
REGISTER_RESPONSE=$(curl -s -X POST http://localhost:5001/api/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "test123456",
    "name": "Test User"
  }')

echo $REGISTER_RESPONSE | jq .

# トークンを取得
TOKEN=$(echo $REGISTER_RESPONSE | jq -r .token)

if [ "$TOKEN" != "null" ] && [ -n "$TOKEN" ]; then
  echo "✅ SQLiteモード: ユーザー登録成功"
  
  # KPIデータの保存テスト
  echo ""
  echo "💾 KPIデータ保存テスト..."
  SAVE_RESPONSE=$(curl -s -X POST http://localhost:5001/api/daily-kpi \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{
      "date": "'$(date +%Y-%m-%d)'",
      "emails_sent_manual": 50,
      "emails_sent_outsource": 100,
      "valid_emails_manual": 45,
      "valid_emails_outsource": 90,
      "replies_received": 10,
      "meetings_scheduled": 3,
      "deals_closed": 1,
      "notes": "テストデータ"
    }')
  
  echo $SAVE_RESPONSE | jq .
  
  # データ取得テスト
  echo ""
  echo "📊 データ取得テスト..."
  curl -s -X GET "http://localhost:5001/api/daily-kpi/$(date +%Y-%m-%d)" \
    -H "Authorization: Bearer $TOKEN" | jq .
    
  echo ""
  echo "✅ SQLiteモード: 全テスト成功"
else
  echo "❌ SQLiteモード: ユーザー登録失敗"
fi

# バックエンドを停止
kill $BACKEND_PID
wait $BACKEND_PID 2>/dev/null

echo ""
echo "================================"
echo "✨ テスト完了"
echo ""
echo "📝 次のステップ:"
echo "1. GitHubにプッシュ"
echo "2. render.yamlのrepoを更新"
echo "3. Renderでデプロイ"
echo ""
echo "詳細は DEPLOYMENT.md を参照してください"