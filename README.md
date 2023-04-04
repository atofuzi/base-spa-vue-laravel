# base-vue-laravel-project
vueとlaravelのspaのサンプルプロジェクトです。

## ミドルウェア
- フロントエンド：vue3（node16系）
- バックエンド：laravel9系
- データベース：mysql8.0
- リバースプロキシ：nginx1.19

## 主なインストール済みパッケージ
### フロントエンド
- axios
- vue-router
- vuex
- Tailwind CSS

### backend
- laravel passport // Oauth認証用のライブラリ
- phpunit // ユニットテスト

# 構成図
![infra](https://user-images.githubusercontent.com/58471852/204072996-a58ef6f6-7b2e-48bb-86c0-d06ab5919bbf.png)

# セットアップ手順
## Makefileについて
Makefileにコマンドを登録しています。  
makeコマンドはprojectのルートディレクトリ直下で実行してください。  

## Docker用の.envをコピー
```
cp .env.example .env
```

## .envの変数を適宜変更
ご自身のプロジェクト名等に合わせて変更ください。  
※変更しなくても、動作は可能です。

### 主な設定項目
アプリ名  
データベース名  
データベースのユーザ名  
データベースのパスワード  
データベースのポート  
プロキシサーバのポート  　


## コンテナ作成・起動・初期設定
下記コマンドを叩くことで、コンテナ作成・コンテナ起動・バックエンド側の設定を一度に行えます。
```
make setup
```
### やっていること  
docker-compose build --no-cache //コンテナ作成  
docker-compose up -d // コンテナ起動
cp ./backend/.env.example ./backend/.env; // envの作成  
docker-compose exec project-backend  composer install; // パッケージインストール  
docker-compose exec project-backend  php artisan key:generate; // laravel アプリケーションキー生成  
docker-compose exec project-backend  php artisan migrate:fresh; // DB作成  
docker-compose exec project-backend  php artisan passport:install; // laravel passportを仕様するため、クライアントIDとシークレットキーを生成しoauth_clients_tableにセット  
docker-compose exec project-backend  php artisan db:seed; // データ生成  

### トラブルシュート
#### docker-compose exec project-backend  php artisan migrate:fresh　でエラーになった場合
ログ確認にてエラー内容を確認ください  
```bash
make log_db
```
下記のエラーログが出力されていた場合
```DBログ
Cannot create redo log files because data files are corrupt or the database was not shut down cleanly after creating the data files.
````
DBのdataの削除をお試しください

```bash
rm -rf docekr/db/dada
```

## フロントエンド起動確認  
フロントエンドは起動時に、yarn install && yarn serveを実行しているため、コンテナが起動してからサーバが立ち上がるまで数分かかります。  
下記コマンドでログを表示し、サーバが立ち上がるのを確認します。  
  
### 起動状況を確認するためにログを表示
```bash
make log_front

// 中略
  App running at:
  - Local:   http://localhost:8080/ 
  - Network: http://172.22.0.3:8080/

  Note that the development build is not optimized.
  To create a production build, run yarn build.

Build finished at 15:42:25 by 0.000s

```
### フロントエンド疎通確認
http://localhost:8088 にアクセスし、Vueのトップ画面が表示される  

  
### バックエンド疎通確認  
Web画面  
http://localhost:8088/phpinfo.php にアクセスしphpの設定画面が表示される  
  
API    
http://localhost:8088/api/test にアクセスし「test success」と表示されればOK  
  
もしくは、ターミナルでcurlコマンドを叩いてもOK  
curl http://localhost:8088/api/test  
  
## ログイン機能を試す
下記のPOSTリクエストをPostman等を使って投げ、tokenが取得できればOK  

method:post  
api：localhost:8088/oauth/token  
body: {  
  grant_type: password,  
  client_id: X // oauth_clientテーブル確認  
  client_secret: 'XXXXXXXXXXXX', // oauth_clientテーブル確認  
  username: 'test0@email.com',  
  password: 'password',  
  scope: '*'  
}  
  
XXXXXXはoauth_clientテーブルをご確認ください
※ユーザ情報はUserSeeder.phpで作成しています。適宜変更ください。


参考：  
Laravel Passport「パスワードグラントのトークン」  
https://readouble.com/laravel/9.x/ja/passport.html  
  
# ライブラリの追加作業
## Backend
backendのコンテナに入る  
```bash
make sh
```

コンテナ内でパッケージをインストールする
```bin/sh
composer install パッケージ名
```
## Frontend
frontendのコンテナに入る
```bash
make sh_front
```

コンテナ内でパッケージをインストールする
```bin/sh
yarn add パッケージ名
```

# 運用時に使用すると便利なコマンド
## コンテナ起動
```
make start
```
  
## コンテナ停止
```
make stop
```
  
# コンテナ再起動
```
make restart
```
  
# コンテナ全削除
```
make reset
```
  
## phpのコンテナに入る
```
make sh
```
  
## DBのmigration実行
```
make migrate
```
  
## DBのmigrationのロールバック実行
```
make migrate_back
```
  
## DBのseeder実行
```
make seed
```
  
## DBのリストア（マイグレーションとシーダーを流し直す）
```
make db_restore
```
## DBのログ
```
make log_db
```
