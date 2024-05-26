
# Railsアプリケーションの作成

```bash
rails new sample_app --database=postgresql
cd sample_app
```

# 必要なもののインストール

```bash
# PostgreSQLクライアントライブラリのインストール
sudo apt update
sudo apt install ruby-full
sudo apt install libpq-dev

# Bundlerのインストール
sudo apt install ruby-bundler

# Gemsのインストール
bundle config set --local path 'vendor/bundle'
bundle install
```

# Rubyのバージョン調整

```bash
rbenv install 3.1.2
rbenv local 3.1.2
```

```:.bashrc
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
```

# Gemfileの修正

```ruby:Gemfile
ruby "3.1.2"
```

# Gemfile.lockの更新

Rubyのバージョンを更新したら、Gemfile.lockを再生成する必要があります。

```bash
# Bundlerを再インストールします。
gem install bundler

# 古いGemfile.lockを削除
rm Gemfile.lock

# Bundlerを実行して新しいGemfile.lockを生成
bundle install
```

# Railsコントローラーとビューの作成

```bash
# コントローラーの作成
rails generate controller Pages home about
```

# ルートの設定

```ruby:config/routes.rb
Rails.application.routes.draw do
  root 'pages#home'
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'services', to: 'pages#services'
end
```

# ビューの作成

```html:app/views/pages/home.html.erb
<h1>Pages#home</h1>
<p>Find me in app/views/pages/home.html.erb</p>
```

```html:app/views/pages/about.html.erb
<h1>About Page</h1>
<p>This is the about page.</p>
```

# 新しいページの追加

```html:app/views/pages/contact.html.erb
<h1>Contact Page</h1>
<p>This is the contact page.</p>
```

```html:app/views/pages/services.html.erb
<h1>Services Page</h1>
<p>This is the services page.</p>
```

# Dockerfileの作成

```dockerfile
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
```

# docker-compose.ymlの作成

```yml
version: '3.8'
services:
  app: 
    build: .
    volumes:
      - .:/app
    ports:
      - "3000:3000"
    command: bash -c "bundle install && bundle exec rails server -b 0.0.0.0"
    depends_on:
      - db
    environment:
      - TZ=Asia/Tokyo

  db:
    image: postgres
    environment:
      POSTGRES_PASSWORD: password
    volumes:
      - db_data:/var/lib/postgresql/data

volumes:
  db_data:
```

# Dockerエントリポイントスクリプトの作成

```bash
#!/bin/bash
set -e

# 既存のサーバPIDファイルを削除
rm -f /app/tmp/pids/server.pid

# データベースを作成し、マイグレーションを実行
bundle exec rails db:create db:migrate || true

# コンテナのメインプロセスを実行
exec "$@"
```

# Docker Composeの起動

```bash
docker-compose up --build
```

# データベースまだの場合

```yml:config/database.yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: 5
  username: postgres
  password: password
  host: db
```

```bash
# コンテナの中に入る
docker-compose exec app bash
# データベースを作成
bundle exec rails db:create
# データベースの移行
bundle exec rails db:migrate
```

# URL

https://qiita.com/koki_73/items/60b327a586129d157f38#%E3%83%87%E3%83%97%E3%83%AD%E3%82%A4%E6%89%8B%E9%A0%86-%E3%81%9D%E3%81%AE2-%E3%83%87%E3%83%97%E3%83%AD%E3%82%A4%E7%94%A8%E3%81%AE%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92%E7%94%A8%E6%84%8F%E3%81%AA%E3%81%A9

https://guides.rubyonrails.org/configuring.html#actiondispatch-hostauthorization

https://zenn.dev/dragonarrow/articles/1f3c34e31d0acc

https://qiita.com/kodai_0122/items/67c6d390f18698950440