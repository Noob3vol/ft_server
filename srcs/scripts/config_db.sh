#!/bin/sh

user=ft_server
pass=ft_pass
host=localhost
pma_db=phpmyadmin

service mysql start

mysql < /var/www/html/phpmyadmin/sql/create_tables.sql
mysql -e "create user '$user'@'$host' identified by '$pass';"
mysql -e "grant all privileges on *.* to '$user'@'$host';"
mysql -e "flush privileges;"
