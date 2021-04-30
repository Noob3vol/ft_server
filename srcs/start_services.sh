#!/bin/bash

service nginx start
service mysql start
service php7.3-fpm start

tail -f /var/log/nginx/access.log &
tail -f /var/log/nginx/error.log
