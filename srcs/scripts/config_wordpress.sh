#!/bin/sh

WORDPRESS_DB=wordpress
USERNAME_DB=ft_server
PASSWORD_DB=ft_pass

#cd /tmp
#wget  -q https://wordpress.org/latest.tar.gz
tar xf latest.tar.gz
#sed -i "s/database_name_here/$WORDPRESS_DB/" wordpress/wp-config-sample.php
#sed -i "s/username_here/$USERNAME_DB/" wordpress/wp-config-sample.php
#sed -i "s/password_here/$PASSWORD_DB/" wordpress/wp-config-sample.php
#head -n47 wordpress/wp-config-sample.php > wordpress/wp-config.php
#wget -q https://api.wordpress.org/secret-key/1.1/salt/ -O - >> wp-config.php
#tail -n+57 wordpress/wp-config-sample.php >> wordpress/wp-config.php
#rm -f wordpress/wp-config-sample.php 

#mv wordpress/ /var/www/html/
#grep -v -e "SALT" -e "KEY" wordpress/wp-config-sample.php > wordpress/wp-config.php
