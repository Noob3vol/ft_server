FROM debian:buster

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y nginx openssl \
	wget curl \
	php-fpm php-mysql\ 
	php-mbstring php-zip\
	php-xml php-curl php-xmlrpc php-soap\
	mariadb-server vim | grep php > /root/php_version 

COPY srcs/ /root/srcs/

RUN bash /root/srcs/scripts/config_nginx.sh
RUN bash /root/srcs/scripts/config_pma.sh
RUN bash /root/srcs/scripts/config_db.sh
RUN bash /root/srcs/scripts/config_wordpress.sh

RUN rm -rf /root/srcs/scripts
RUN rm -rf /root/srcs/cfg

RUN chown -R www-data:www-data /var/www/html

CMD ["bash", "/root/srcs/start_services.sh"]
