FROM php:8.1-fpm-alpine3.16

RUN apk update && apk add \
    freetype-dev \
		libjpeg-turbo-dev \
    libpng-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd \
  pdo_mysql

ENV TZ=Asia/Tokyo \
    COMPOSER_ALLOW_SUPERUSER=1 \
    COMPOSER_HOME=/composer 

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/

EXPOSE 9000