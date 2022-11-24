# base-vue-laravel-project
vueとlaravelのspaのサンプルプロジェクトです。

## ミドルウェア
フロントエンド：vue
バックエンド：laravel
データベース：mysql
リバースプロキシ：nginx

## 主なインストール済みパッケージ
### フロントエンド
- axios
- vue-router
- vuex

### backend
- laravel passport // Oauth認証用のライブラリ
- phpunit // ユニットテスト


## 構成
バックエンド

# セットアップ手順
## Makefileについて
Makefileにコマンドを登録しています。
基本的にはmake ~　とコマンドを叩けばセットアップできるようになっています。

makeコマンドはprojectのルートディレクトリ直下で実行してください。

## コンテナイメージの作成
```
make build
```

## コンテナ起動
```
make start
```

## フロントエンド起動確認
フロントエンドは起動時に、yarn install && yarn serveを実行しているため、コンテナが起動してからサーバが立ち上がるまで数分かかります。
下記コマンドでログを表示し、サーバが立ち上がるのを確認します。

### 起動状況を確認するためにログを表示
```bash
make log_frontend

// 中略
  App running at:
  - Local:   http://localhost:8080/ 
  - Network: http://172.22.0.3:8080/

  Note that the development build is not optimized.
  To create a production build, run yarn build.

Build finished at 15:42:25 by 0.000s

```
### フロントエンド疎通確認
localhost:8080にアクセスし、Vueのトップ画面が表示される

## バックエンドのセットアップ
```
make ini_backend
```

※初回のみ使用するコマンド

### やっていること
cp ./backend/.env.example ./backend/.env; // envの作成
docker-compose exec project-backend  composer install; // パッケージインストール
docker-compose exec project-backend  php artisan key:generate; // laravel アプリケーションキー生成
docker-compose exec project-backend  php artisan migrate; // DB作成
docker-compose exec project-backend  php artisan passport:install; // laravel passportを仕様するため、クライアントIDとシークレットキーを生成しoauth_clients_tableにセット
docker-compose exec project-backend  php artisan db:seed; // データ生成

### バックエンド疎通確認
Web画面
http://localhost:8080/phpinfo.php にアクセスしphpの設定画面が表示される

API
Postmanで下記URLにGETリクエストを叩き、「test success」とレスポンスがあればOK。
http://localhost:8080/api/test 

もしくは、ターミナルでcurlコマンドを叩いてもOK
curl http://localhost:8080/api/test 

## ログイン機能を試す
method:post
api：localhost:8080/oauth/token
body: {
  grant_type: password,
  client_id: X // oauth_clientテーブル確認
  client_secret: 'XXXXXXXXXXXX', // oauth_clientテーブル確認
  username: 'XXXXXX',
  password: 'XXXXXX',
  scope: '*'
}


Xはご自身の環境に応じて入力
Postman等でリクエストを投げ、tokenが取得できればOK。

参考：
Laravel Passport「パスワードグラントのトークン」
https://readouble.com/laravel/9.x/ja/passport.html


# 運用時に使用すると便利なコマンド
## phpのコンテナに入る
```
make sh
```

## DBのmigration実行
```
make migrate
```

## DBのseeder実行
```
make dbseed
```
