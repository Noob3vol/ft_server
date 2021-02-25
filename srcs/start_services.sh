#!/bin/bash

service nginx start
service mysql start
service php7.3-fpm start

tail -f /var/log/access.log
