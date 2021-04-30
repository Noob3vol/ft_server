#!/bin/bash

conf_name=default
conf_path=/etc/nginx/sites-available/

if [ $# -eq 0 ]
then
	if grep "^[[:space:]]*autoindex on" ${conf_path}${conf_name} > /dev/null
	then
		echo "Autoindex is on"
	else
		echo "Autoindex is off"
	fi
fi


if [[ $1 =~ (ON)|(on)|(On)|(oN) ]]
then
	sed -i "s/#\([[:space:]]*autoindex on\)/\1/g" ${conf_path}${conf_name}
else if [[ $1 =~ (OFF)|(off)|(Off)|(OFf)|(OfF) ]]
then
	if grep "^[[:space:]]*autoindex on" ${conf_path}${conf_name} > /dev/null
	then
		sed -i "s/^\([[:space:]]*autoindex on\)/#\1/g" ${conf_path}${conf_name}
	fi
else if [ $# -gt 0 ]
then
		echo "usage is $0 \(on|off\)"
	fi
fi
fi
