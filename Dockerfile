FROM debian:buster

ARG DEBIAN_FRONTEND=noninteractive
ARG AUTO_INDEX=on
ARG PHP_VERSION

#There is a single user
ARG WORDPRESS_DB=wordpress
ARG USERNAME_DB=ft_server
ARG PASSWORD_DB=ft_pass

RUN apt-get update && apt-get install -y nginx openssl \
	wget curl \
	php-fpm php-mysql\ 
	php-mbstring php-zip\
	php-xml php-curl php-xmlrpc php-soap\
	mariadb-server

COPY srcs/ /root/srcs/


#config nginx
RUN mv /root/srcs/cfg/default /etc/nginx/sites-available/default
RUN chmod +x /root/srcs/scripts/autoindex.sh && ./root/srcs/scripts/autoindex.sh $AUTO_INDEX
RUN openssl req -x509 -nodes -days 36500 -newkey rsa:2048\
	-keyout /etc/ssl/private/default.key -out /etc/ssl/certs/default.crt\
	-subj '/CN=localhost'
RUN echo -e "<?php\nphpinfo();" > /var/www/html/index.php

RUN PHP_VERSION=$(php -v | head -n1 | sed "s/PHP \([0-9]*\.[0-9]*\).*/\1/") &&\
     sed -i "s/PHP_VERSION/php$PHP_VERSION/g" /etc/nginx/sites-available/default


#  PHPmyAdmin installation
RUN wget -q https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
RUN tar xf phpMyAdmin-latest-all-languages.tar.gz
RUN mv $(tar tf phpMyAdmin-latest-all-languages.tar.gz | head -n1) /var/www/html/phpmyadmin
RUN sed "s/\(.*blowfish.*\)''.*/\1'$(openssl rand -hex 32 | cut -c 1-32)';/" /root/srcs/cfg/config.inc.php > /var/www/html/phpmyadmin/config.inc.php
RUN rm phpMyAdmin-latest-all-languages.tar.gz


# Wordpress installation
# dowload
RUN wget -q https://wordpress.org/latest.tar.gz
RUN tar xf latest.tar.gz
#RUN bash /root/srcs/scripts/config_wordpress.sh

## configuration
RUN sed -i "s/database_name_here/$WORDPRESS_DB/" wordpress/wp-config-sample.php
RUN sed -i "s/username_here/$USERNAME_DB/" wordpress/wp-config-sample.php
RUN sed -i "s/password_here/$PASSWORD_DB/" wordpress/wp-config-sample.php

RUN head -n47 wordpress/wp-config-sample.php > wordpress/wp-config.php
RUN wget -q https://api.wordpress.org/secret-key/1.1/salt/ -O - >> wp-config.php
RUN tail -n+57 wordpress/wp-config-sample.php >> wordpress/wp-config.php

## Installation
RUN rm -f wordpress/wp-config-sample.php
RUN mv wordpress/ /var/www/html


# Configuration of databases is done with script because we need service
# to be running and it's more pratical to modify key value with variable

RUN bash /root/srcs/scripts/config_db.sh

# Web file should be owned by a user dedicated to avoid security 
RUN chown -R www-data:www-data /var/www/html

# Clean
RUN rm -rf /root/srcs/script/

CMD ["bash", "/root/srcs/start_services.sh"]
