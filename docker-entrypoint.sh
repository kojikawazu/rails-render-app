#!/bin/bash
set -e

# 既存のサーバPIDファイルを削除
rm -f /app/tmp/pids/server.pid

# データベースを作成し、マイグレーションを実行
bundle exec rails db:create db:migrate || true

# コンテナのメインプロセスを実行
exec "$@"
