#!/bin/bash
set -e

# 既存のサーバPIDファイルを削除
rm -f /app/tmp/pids/server.pid

# データベースのセットアップ
if [ -z "$SKIP_DB_SETUP" ]; then
  bundle exec rails db:create db:migrate || true
fi

# コンテナのメインプロセスを実行
exec "$@"
