NAME_CON = test_con
NAME = ft_server
VERSION = 1.0
DOCKERFILE = 
SRCS = srcs


all :
	 docker build -t $(NAME):$(VERSION) .

run : 
	 docker run -p 80:80 -p 443:443 -d --name=$(NAME_CON) $(NAME):$(VERSION)

clean :
	 -docker rm -f $(NAME_CON)

fclean : clean
	 -docker rmi -f $(NAME):$(VERSION)

re : fclean all run
