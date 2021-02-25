#!/bin/bash

PHP_VERSION=$(head --line=1 /root/php_version | sed -e "s/.*php\([0-9]*\.[0-9]\).*/\1/")

rm -f /root/php_version
mv /root/srcs/default /etc/nginx/sites-available/default
sed -i "s/php[0-9]+\.[0-9]+/php$PHP_VERSION/g" /etc/nginx/sites-available/default
#sed -i "s/^[[:space:]]*index/\& index.php/g" /etc/nginx/sites-available/default
echo "listen = 127.0.0.1:9000" >> /etc/php/$PHP_VERSION/fpm/php-fpm.conf

openssl req -x509 -nodes -days 36500 -newkey rsa:2048 -keyout /etc/ssl/private/default.key -out /etc/ssl/certs/default.crt -subj '/CN=localhost'

echo -e "<?php\nphpinfo();" > /var/www/html/index.php
