FROM debian:buster

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y nginx openssl \
	php-fpm php-mysql php-mbstring\
	mariadb-server vim \
	wget | grep php > /root/php_version


COPY srcs/ /root/srcs/

RUN bash /root/srcs/scripts/config_nginx.sh
RUN bash /root/srcs/scripts/config_pma.sh
RUN bash /root/srcs/scripts/config_db.sh
RUN bash /root/srcs/start_services.sh

RUN chown -R www-data:www-data /var/www/html

CMD ["bash", "/root/srcs/start_services.sh"]
