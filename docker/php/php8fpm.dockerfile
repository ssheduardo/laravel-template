FROM php:8-fpm

LABEL maintainer="alexoleksiivelychko@gmail.com"

ENV USER_ID 1000
ENV GROUP_ID 1000
ENV PHP_IDE_CONFIG="serverName=dockerHost"
ENV COMPOSER_HOME=/var/www/docker/cache/composer
ENV npm_config_cache=/var/www/docker/cache/npm

RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    libfreetype6-dev \
    libicu-dev \
    libonig-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libxslt1-dev \
    libxml2-dev \
    zlib1g-dev \
    libbz2-dev \
    libzip-dev

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/
RUN docker-php-ext-configure intl

RUN docker-php-ext-install \
    iconv \
    gd \
    intl \
    mbstring \
    mysqli \
    pdo_mysql \
    xsl \
    zip \
    soap \
    bcmath \
    bz2 \
    opcache \
    exif

RUN pecl install xdebug-3.0.3
RUN docker-php-ext-enable xdebug

RUN pecl install -o -f redis && rm -rf /tmp/pear && docker-php-ext-enable redis

RUN mkdir -p /var/www/docker/cache/

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

RUN usermod -u ${USER_ID} www-data && groupmod -g ${GROUP_ID} www-data

WORKDIR /var/www

USER "${USER_ID}:${GROUP_ID}"

CMD ["php-fpm"]
