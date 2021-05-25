# ft_server

This project aim write  a Docker Image to automate the build of a container
running a nginx, wordpress and phpmyadmin service.
you will also need dependency like php and mysql.

## Docker

Docker is kind of a lightweight virtualisation technology used to maximise
availibity and security of application. It got some concept attach to it
but the most important of them are :

- Image building is done with _Dockerfile_ which got his own set of rules
and syntax. It's context is also detached from your system.

- All manipulation on images and container can be done with docker API

- it's os level virtualisation meaning security wise your "hypervisor" system
is still vulnerable to kernel security issue

## debian under docker

Systemd replace the init sytem used by debian-distribtution now. Since Docker
it's own init system to start all the process needed to run the system you don't
have access to it.

No systemctl you got to use service (or directly use binary intended for service
purpose)
https://askubuntu.com/questions/903354/difference-between-systemctl-and-service-commands

## nginx

- redirection
https://twiz.io/blog/nginx-301-redirect/

## MariaDB (MySQL)

MySql is the most famous database system. Since it is non-free we shall use it's
free/open source counterpart MariadDB. It is maintained by the original dev of
Mysql with the aim to be compatible with script using mysql and mysql database.

## phpmyadmin

Phpmyadmin is a collection of web page using php to manage database. Obviously
it require a way to process his html-css and php instruction. Since it's operate
on database you will also need a database (here we use mysql). It is a back-end
tool for those who want to dig deeper.

## wordpress

---

## Utility

You can find some script in the source, most are just here for educationnal
purpose since the Dockerfile is suppose to build images without using script
during installation.

You can add your user to the docker group to use it without sudo
https://www.configserverfirewall.com/ubuntu-linux/add-user-to-docker-group-ubuntu/

Use a dockerignore to filter .git file and non container file (like README)
https://docs.docker.com/engine/reference/builder/#dockerignore-file
