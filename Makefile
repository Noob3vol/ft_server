NAME_CON = test_con
DOCKERFILE = 
SRCS = srcs


all :
	sudo docker build -t test:0.1 .

run : 
	sudo docker run -p 80:80 -p 443:443 -it --name=test_con test:0.1

clean :
	sudo docker rm -f test_con

fclean : clean
	sudo docker rmi -f test:0.1

re : fclean all run
