FROM ubuntu:16.04

ENV TERM xterm

RUN apt-get update -y && apt-get install -y software-properties-common language-pack-en-base && \
    LC_ALL=en_US.UTF-8 add-apt-repository -y ppa:ondrej/php && \
    apt-get update -y && apt-get install -y \
    vim \
    mc \
    acl \
    apache2 \
    libapache2-mod-php7.1 \
    python-pycurl \
    php7.1 \
    php7.1-cli \
    php7.1-gd \
    php7.1-curl \
    php7.1-intl \
    php7.1-bcmath \
    php7.1-json \
    php7.1-mbstring \
    php7.1-mysql \
    php7.1-opcache \
    php7.1-readline \
    php7.1-soap \
    php7.1-sqlite3 \
    php7.1-xml \
    php7.1-xmlrpc \
    php7.1-zip \
    php-xdebug \
    python-mysqldb \
    python-selinux && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY application.conf /etc/apache2/sites-available/application.conf
COPY php_config.ini /etc/php/7.1/mods-available/
RUN ln -s /etc/php/7.1/mods-available/php_config.ini /etc/php/7.1/apache2/conf.d/80-php_config.ini && \
    ln -s /etc/php/7.1/mods-available/php_config.ini /etc/php/7.1/cli/conf.d/80-php_config.ini

RUN a2enmod rewrite && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2dissite 000-default && \
    a2dissite default-ssl && \
    a2ensite application && \
    rm -rf /var/www/html && \
    usermod -s /bin/bash www-data

VOLUME /var/www/application
EXPOSE 80

WORKDIR /var/www/application

CMD rm -f /run/apache2/apache2.pid && /usr/sbin/apache2ctl -D FOREGROUND
