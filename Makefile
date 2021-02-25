NAME_CON = test_con
NAME = ft_server
VERSION = 1.0
DOCKERFILE = 
SRCS = srcs


all :
	sudo docker build -t $(NAME):$(VERSION) .

run : 
	sudo docker run -p 80:80 -p 443:443 -it --name=$(NAME_CON) $(NAME):$(VERSION)

clean :
	sudo docker rm -f test_con

fclean : clean
	sudo docker rmi -f test:0.1

re : fclean all run
