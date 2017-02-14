docker-compose.yml
```yml
version: '2'

services:
    web:
        image: jarekw/apache-php7:7.1
        container_name: project-web
        ports:
            - 80:80
            - 443:443
        volumes:
            - .:/var/www/application
    mysql:
        image: mysql:5.6
        container_name: project-mysql
        ports:
            - 3306:3306
        environment:
            MYSQL_ALLOW_EMPTY_PASSWORD: 'yes'
        volumes:
            - ./var/mysql:/var/lib/mysql

```
