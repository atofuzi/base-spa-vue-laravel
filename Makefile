include .env

# 初期セットアップ
setup:
	make build_no_cache; \
	make start; \
	make ini_backend; \

ini_backend:
	cp ./backend/.env.example ./backend/.env; \
	docker-compose exec $(BACKEND_CONTAINER_NAME) composer install; \
	docker-compose exec $(BACKEND_CONTAINER_NAME) php artisan key:generate; \
	docker-compose exec $(BACKEND_CONTAINER_NAME) php artisan migrate:fresh; \
	docker-compose exec $(BACKEND_CONTAINER_NAME) php artisan passport:install; \
	docker-compose exec $(BACKEND_CONTAINER_NAME) php artisan db:seed;

# コンテナ操作全般
build:
	docker-compose build

build_no_cache:
	docker-compose build --no-cache

start:
	docker-compose up -d

stop:
	docker-compose stop

restart:
	docker-compose stop; \
	docker-compose up -d;

ps:
	docker-compose ps

reset:
	docker-compose down

# バックエンドコンテナ用コマンド

sh:
	docker-compose exec $(BACKEND_CONTAINER_NAME) /bin/sh

migrate:
	docker-compose exec $(BACKEND_CONTAINER_NAME) php artisan migrate

migrate_back:
	docker-compose exec $(BACKEND_CONTAINER_NAME) php artisan migrate:rollback

seed:
	docker-compose exec $(BACKEND_CONTAINER_NAME) php artisan db:seed

db_restore:
	docker-compose exec $(BACKEND_CONTAINER_NAME) php artisan migrate:fresh; \
	docker-compose exec $(BACKEND_CONTAINER_NAME) php artisan db:seed;
	
log:
	docker-compose logs -f ${BACKEND_CONTAINER_NAME}

# フロントエンドコンテナ用コマンド
sh_front:
	docker-compose exec $(FRONTEND_CONTAINER_NAME) /bin/sh

log_front:
	docker-compose logs -f ${FRONTEND_CONTAINER_NAME}

# リバースプロキシコンテナ用コマンド

log_web:
	docker-compose logs -f ${PROXY_CONTAINER_NAME}

# DBコンテナ用コマンド
sh_db:
	docker-compose exec $(DB_CONTAINER_NAME) /bin/sh

sh_db_test:
	docker-compose exec $(DB_TESTING_CONTAINER_NAME) /bin/sh

log_db:
	docker-compose logs -f ${DB_CONTAINER_NAME}

log_db_test:
	docker-compose logs -f ${DB_TESTING_CONTAINER_NAME}
