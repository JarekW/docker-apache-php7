FROM ubuntu:16.04

ENV TERM xterm

RUN apt-get update -y && apt-get install -y software-properties-common language-pack-en-base && \
    apt-get update -y && apt-get install -y \
    vim \
    mc \
    acl \
    apache2 \
    libapache2-mod-php \
    python-pycurl \
    php \
    php-cli \
    php-gd \
    php-curl \
    php-intl \
    php-mcrypt \
    php-bcmath \
    php-xml \
    php-xml-rpc2 \
    php-readline \
    php-json \
    php-mysql \
    php-sqlite3 \
    php-mbstring \
    php-soap \
    php-zip \
    php-xdebug \
    python-mysqldb \
    python-selinux && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY application.conf /etc/apache2/sites-available/application.conf
COPY php_config.ini /etc/php/7.0/mods-available/
RUN ln -s /etc/php/7.0/mods-available/php_config.ini /etc/php/7.0/apache2/conf.d/80-php_config.ini && \
    ln -s /etc/php/7.0/mods-available/php_config.ini /etc/php/7.0/cli/conf.d/80-php_config.ini

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
