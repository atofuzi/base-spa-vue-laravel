# 変数
PROXY=project-proxy
BACKEND=project-backend 
FRONTEND=project-frontend
DB_NAME=project-db
DB_TESTING_NAME=project-db-testing
NETWORK=project-network

# コンテナ操作全般
build:
	docker-compose build

build_no_cache:
	docekr-compose build --no-cache

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
ini_backend:
	cp ./backend/.env.example ./backend/.env; \
	docker-compose exec $(BACKEND) composer install; \
	docker-compose exec $(BACKEND) php artisan key:generate; \
	docker-compose exec $(BACKEND) php artisan migrate; \
	docker-compose exec $(BACKEND) php artisan passport:install; \
	docker-compose exec $(BACKEND) php artisan db:seed;

sh:
	docker-compose exec $(BACKEND) /bin/sh

migrate:
	docker-compose exec $(BACKEND) php artisan migrate

dbseed:
	docker-compose exec $(BACKEND) php artisan db:seed

log:
	docker-compose logs -f ${BACKEND}

# フロントエンドコンテナ用コマンド
sh_front:
	docker-compose exec $(FRONTEND) /bin/sh

log_front:
	docker-compose logs -f ${FRONTEND}

# リバースプロキシコンテナ用コマンド

log_web:
	docker-compose logs -f ${PROXY}

# DBコンテナ用コマンド
sh_db:
	docker-compose exec $(DB_NAME) /bin/sh

sh_db_test:
	docker-compose exec $(DB_TESTING_NAME) /bin/sh

log_db:
	docker-compose logs -f ${DB_NAME}

log_db_test:
	docker-compose logs -f ${DB_TESTING_NAME}
