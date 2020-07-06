FROM php:7.1-apache

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    software-properties-common \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    libmemcached-dev \
    libmemcached-tools \
    libfreetype6-dev \
    libicu-dev \
    libssl-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libedit-dev \
    libedit2 \
    libpq-dev \
    libxslt1-dev \
    libzip-dev \
    apt-utils \
    gnupg \
    git \
    vim \
    wget \
    curl \
    lynx \
    psmisc \
    unzip \
    tar \
    cron \
    bash-completion \
    && apt-get clean

#Install Dependencies
RUN docker-php-ext-configure \
    gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/; \
    docker-php-ext-install \
    opcache \
    gd \
    bcmath \
    intl \
    mbstring \
    soap \
    xsl \
    zip

RUN chmod 777 -R /var/www \
    && chown -R www-data:www-data /var/www \
    && usermod -u 1000 www-data \
    && chsh -s /bin/bash www-data

RUN a2enmod rewrite
RUN a2enmod headers

RUN ln -sf /dev/stdout /var/log/apache2/access.log \
    && ln -sf /dev/stderr /var/log/apache2/error.log

# Memcached
RUN apt-get update
RUN apt-get install -y pkg-config build-essential libmemcached-dev
RUN git clone https://github.com/php-memcached-dev/php-memcached.git
RUN cd php-memcached && git checkout php7 && phpize && ./configure --disable-memcached-sasl && make && make install
RUN echo 'extension = memcached.so' > /usr/local/etc/php/conf.d/memcached.ini
