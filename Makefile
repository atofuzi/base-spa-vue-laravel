BACKEND=project-backend 
FRONTEND=project-frontend
DB_NAME=project-db

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

down:
	docker-compose down

sh:
	docker exec -it $(BACKEND) /bin/sh

ini_backend:
	cp ./backend/.env.example ./backend/.env; \
	docker-compose exec $(BACKEND) composer install; \
	docker-compose exec $(BACKEND) php artisan key:generate; \
	docker-compose exec $(BACKEND) php artisan migrate; \
	docker-compose exec $(BACKEND) php artisan passport:install; \
	docker-compose exec $(BACKEND) php artisan db:seed;

migrate:
	docker-compose exec $(BACKEND) php artisan migrate

dbseed:
	docker-compose exec $(BACKEND) php artisan db:seed

log:
	docker logs -f ${BACKEND}

log_frontend:
	docker-compose logs -f ${FRONTEND}

log_db:
	docker-compose logs -f ${DB_NAME}


ps:
	docker-compose ps
