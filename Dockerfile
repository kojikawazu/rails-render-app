# ベースイメージを指定
FROM ruby:3.1.2

# 作業ディレクトリを設定
WORKDIR /app

# GemfileとGemfile.lockをコンテナにコピー
COPY Gemfile Gemfile.lock ./

# Bundlerを使ってGemをインストール
RUN bundle install

# docker-entrypoint.shをコンテナにコピーし、実行権限を付与
COPY docker-entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/docker-entrypoint.sh

# 起動時に実行するエントリーポイントスクリプトを設定
ENTRYPOINT ["docker-entrypoint.sh"]

# ポートは3000番
EXPOSE 3000

# デフォルトのコマンドを設定（Railsサーバを起動）
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
