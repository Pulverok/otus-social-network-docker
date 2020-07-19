FROM php:7.4-fpm

RUN apt-get update && apt-get install -y \
    build-essential \
    cron \
    ffmpeg \
    git \
    libfreetype6-dev \
    libglib2.0-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libpng-dev \
    libpq-dev \
    libzip-dev \
    nano \
    patchelf \
    procps \
    python \
    rclone \
    software-properties-common \
    unzip \
    zip \
    default-mysql-client \
    default-libmysqlclient-dev

# composer install
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install php extentions
RUN docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install pcntl


# symlink for php74 command
RUN ln -s /usr/local/bin/php /usr/local/bin/php74

# restart php-fpm
RUN kill -USR2 1

WORKDIR /var/www

EXPOSE 9000
