FROM debian:buster

ARG DEBIAN_FRONTEND=noninteractive
ARG PHP_VERSION

ARG AUTO_INDEX=on

# Variable for database
ARG DB_NAME=wordpress
ARG DB_USERNAME=ft_server
ARG DB_PASSWORD=ft_pass
ARG DB_HOST=localhost

# Variable for Wordpress (don't change PATH value)
ARG WP_PATH=/var/www/html/wordpress
ARG WP_USER=ft_user
ARG WP_PASS=ft_password
ARG WP_MAIL=invalid@mail.com

RUN apt-get update && apt-get install -y nginx openssl mariadb-server \
#  utility
	wget curl \
# You need php installed to interpret php pages
	php-fpm php-mysql\ 
# Php addon for phpMyAdmin
	php-mbstring php-zip\
	php-xml php-curl php-xmlrpc php-soap

COPY srcs/ /root/srcs/
#------------------------------------------------------------------------------

#  Configuration of nginx
RUN mv /root/srcs/cfg/default /etc/nginx/sites-available/default

RUN echo -e "<?php\nphpinfo();" > /var/www/html/index.php

RUN PHP_VERSION=$(php -v | head -n1 | sed "s/PHP \([0-9]*\.[0-9]*\).*/\1/") &&\
     sed -i "s/PHP_VERSION/php$PHP_VERSION/g" /etc/nginx/sites-available/default

RUN chmod +x /root/srcs/scripts/autoindex.sh &&\
	./root/srcs/scripts/autoindex.sh $AUTO_INDEX

#Generate ssl certificate
RUN openssl req -x509 -nodes -days 36500 -newkey rsa:2048\
	-keyout /etc/ssl/private/default.key -out /etc/ssl/certs/default.crt\
	-subj '/CN=localhost'
#------------------------------------------------------------------------------

#  PHPmyAdmin installation

RUN wget -q https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
RUN tar xf phpMyAdmin-latest-all-languages.tar.gz
RUN mv $(tar tf phpMyAdmin-latest-all-languages.tar.gz | head -n1) /var/www/html/phpmyadmin

RUN sed "s/\(.*blowfish.*\)''.*/\1'$(openssl rand -hex 32 | cut -c 1-32)';/" /root/srcs/cfg/config.inc.php > /var/www/html/phpmyadmin/config.inc.php

RUN rm phpMyAdmin-latest-all-languages.tar.gz
#------------------------------------------------------------------------------

# Database Configuration

## Here we configure root-like user with password access for database
RUN sed -i "s/USER/$DB_USERNAME/; s/PASS/$DB_PASSWORD/; \
	 s/HOST/$DB_HOST/" /root/srcs/scripts/config_db.sql

RUN service mysql start &&\
	mysql < /var/www/html/phpmyadmin/sql/create_tables.sql \
	&& mysql < /root/srcs/scripts/config_db.sql
#------------------------------------------------------------------------------

# Wordpress installation : we use wp-cli to automate site installation
# download
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

RUN wp --allow-root core download --path=${WP_PATH} --locale=fr_FR

RUN service mysql start &&\
	wp --allow-root config create --path=${WP_PATH} --dbname=${DB_NAME} \
	--dbuser=${DB_USERNAME} --dbpass=${DB_PASSWORD}

RUN service mysql start &&\
	wp --allow-root --path=${WP_PATH} db create

RUN service mysql start &&\
	wp --allow-root --path=${WP_PATH} core install \
	--url=localhost/wordpress/ --title=ft_wordpress \
	--admin_user=${WP_USER} --admin_password=${WP_PASS} \
	--admin_email=${WP_MAIL} --skip-email
#------------------------------------------------------------------------------

# Web file should be owned by a user dedicated to avoid security issue
RUN chown -R www-data:www-data /var/www/html

# Cleaning
RUN rm -rf /root/srcs/script/
run rm -rf /root/srcs/cfg/

CMD ["bash", "/root/srcs/start_services.sh"]
