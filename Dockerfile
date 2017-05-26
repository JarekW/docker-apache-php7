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

RUN mkdir /etc/apache2/ssl
RUN openssl req \
    -new \
    -newkey rsa:1024 \
    -days 365 \
    -nodes \
    -x509 \
    -subj "/C=PL/ST=Malopolskie/L=Krakow/O=FSi/OU=IT/CN=localhost" \
    -keyout /etc/apache2/ssl/apache.key \
    -out /etc/apache2/ssl/apache.crt

COPY application.conf /etc/apache2/sites-available/application.conf
COPY php_config.ini /etc/php/7.0/mods-available/
RUN ln -s /etc/php/7.0/mods-available/php_config.ini /etc/php/7.0/apache2/conf.d/80-php_config.ini && \
    ln -s /etc/php/7.0/mods-available/php_config.ini /etc/php/7.0/cli/conf.d/80-php_config.ini

RUN a2enmod rewrite ssl include headers && \
    echo "ServerName localhost" >> /etc/apache2/apache2.conf && \
    a2dissite 000-default && \
    a2dissite default-ssl && \
    a2ensite application && \
    rm -rf /var/www/html && \
    usermod -s /bin/bash www-data && \
    chown www-data:www-data /var/www

#composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php composer-setup.php --install-dir=/usr/local/bin && \
    php -r "unlink('composer-setup.php');" && \
    chown www-data:www-data /usr/local/bin/composer.phar

VOLUME /var/www/application

EXPOSE 80
EXPOSE 443

ENV PHP_IDE_CONFIG "serverName=localhost"

WORKDIR /var/www/application

CMD rm -f /run/apache2/apache2.pid && /usr/sbin/apache2ctl -D FOREGROUND
