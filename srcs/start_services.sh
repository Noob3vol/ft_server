#!/bin/bash

service nginx start
service mysql start
service php7.3-fpm start

rm -rf /root/srcs/scripts
rm -rf /root/srcs/cfg


/bin/bash
