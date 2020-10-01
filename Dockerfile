FROM debian:buster

RUN apt-get update && apt-get install -y nginx \
	php-fpm php-mysql mariadb-server vim

COPY entry_point.sh /root/entry_point.sh

CMD ["bash", "/root/entry_point.sh"]
