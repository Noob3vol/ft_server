#!/bin/sh

cd /tmp
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
tar xvf phpMyAdmin-latest-all-languages.tar.gz
pma_dir=$(tar tf phpMyAdmin-latest-all-languages.tar.gz | head -n1)
mv $pma_dir /var/www/html/phpmyadmin
sed "s/\(.*blowfish.*\)''.*/\1\'$(openssl rand -base64 32 | cut -c 1-32)\';/" /root/srcs/cfg/config.inc.php > /var/www/html/phpmyadmin/config.inc.php
rm phpMyAdmin-latest-all-languages.tar.gz
